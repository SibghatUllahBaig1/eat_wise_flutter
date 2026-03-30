import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'meal_reminder_preferences.dart';

/// Single consistent channel used for all meal reminders.
/// Creating the channel once with [Importance.max] guarantees heads-up
/// banners and sound even when the device is in DND/Doze.
const _kChannelId = 'meal_reminders';
const _kChannelName = 'Meal Reminders';
const _kChannelDesc = 'Daily meal logging reminders';

class MealReminderService {
  static final MealReminderService _instance = MealReminderService._internal();
  factory MealReminderService() => _instance;
  MealReminderService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  // ──────────────────────────────────────────────────────────────────────
  // Initialisation
  // ──────────────────────────────────────────────────────────────────────

  /// Safe to call multiple times — no-op after first successful run.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 1. Timezone — wrap in try/catch so a platform error doesn't kill init.
    try {
      tz.initializeTimeZones();
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
      print('✅ Timezone set to: ${timezoneInfo.identifier}');
    } catch (e) {
      print('⚠️ Timezone init failed ($e) – falling back to UTC');
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.UTC);
    }

    // 2. Plugin initialisation
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _notifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse:
          _onBackgroundNotificationTapped,
    );

    // 3. Pre-create the Android notification channel with MAX importance.
    //    Once a channel is created its importance cannot be lowered by code,
    //    so we set it to max here to guarantee heads-up banners + sound.
    await _ensureChannel();

    _isInitialized = true;
    print('✅ MealReminderService initialised');
  }

  Future<void> _ensureChannel() async {
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _kChannelId,
        _kChannelName,
        description: _kChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────
  // Permissions
  // ──────────────────────────────────────────────────────────────────────

  /// Request notification + exact-alarm permissions.
  /// Must be called AFTER runApp() so an Android Activity exists.
  Future<void> requestPermissions() async {
    final androidImpl = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // POST_NOTIFICATIONS — required on Android 13+
    await androidImpl?.requestNotificationsPermission();

    // SCHEDULE_EXACT_ALARM — for Android 12 (API 31-32) only.
    // On Android 13+ we use USE_EXACT_ALARM which is auto-granted.
    await androidImpl?.requestExactAlarmsPermission();

    // iOS
    final iosImpl = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    await iosImpl?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // ──────────────────────────────────────────────────────────────────────
  // Scheduling
  // ──────────────────────────────────────────────────────────────────────

  /// Schedule (or reschedule) a recurring meal reminder.
  ///
  /// - If [repeatDays] contains all 7 days (or is empty), a daily repeat is
  ///   scheduled using [DateTimeComponents.time].
  /// - Otherwise one notification per selected day is scheduled using
  ///   [DateTimeComponents.dayOfWeekAndTime].
  Future<void> scheduleMealReminder({
    required int id,
    required String mealType,
    required int hour,
    required int minute,
    required bool enableVibration,
    required List<String> repeatDays,
  }) async {
    // Ensure the service is ready before doing anything.
    await initialize();

    try {
      // Cancel any previously scheduled notifications for this id range
      // (up to 7 weekday slots + the base id).
      await _cancelAllSlotsFor(id);

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate =
          tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

      // Push to tomorrow if the time has already passed today.
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      final title = _getMealTitle(mealType);
      final body = _getMealBody(mealType);
      // USE_EXACT_ALARM (Android 13+) is auto-granted; for Android 12 we
      // still try exact and fall back gracefully on exception.
      const scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
      final details = _notificationDetails(enableVibration: enableVibration);

      if (repeatDays.isNotEmpty && repeatDays.length < 7) {
        await _scheduleWeeklyReminder(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          details: details,
          scheduleMode: scheduleMode,
          repeatDays: repeatDays,
        );
      } else {
        // Daily repeat — fires every day at the same local time.
        await _notifications.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          details,
          androidScheduleMode: scheduleMode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }

      final pending = await _notifications.pendingNotificationRequests();
      print('✅ Scheduled $mealType at $hour:$minute | '
          'pending total: ${pending.length}');
    } catch (e) {
      print('❌ scheduleMealReminder error: $e');
    }
  }

  /// Reschedule every reminder that has been saved to [MealReminderPreferences].
  /// Call this on app startup so that OS-cancelled alarms are re-registered.
  Future<void> rescheduleAllReminders() async {
    await initialize();
    for (final mealType in ['breakfast', 'lunch', 'dinner', 'snack']) {
      try {
        final s = await MealReminderPreferences.loadMealReminder(mealType);
        if (s['enabled'] == true) {
          await scheduleMealReminder(
            id: _getMealId(mealType),
            mealType: mealType,
            hour: s['hour'] as int,
            minute: s['minute'] as int,
            enableVibration: s['vibration'] as bool,
            repeatDays: List<String>.from(s['repeatDays'] as List),
          );
          print('🔄 Re-scheduled $mealType reminder');
        }
      } catch (e) {
        print('❌ Error rescheduling $mealType: $e');
      }
    }
  }

  int _getMealId(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 2001;
      case 'lunch':
        return 2002;
      case 'dinner':
        return 2003;
      case 'snack':
        return 2004;
      default:
        return 2000;
    }
  }

  /// Schedule weekly reminder for specific days.
  Future<void> _scheduleWeeklyReminder({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
    required List<String> repeatDays,
    required AndroidScheduleMode scheduleMode,
  }) async {
    const dayMap = {
      'Monday': 1,
      'Tuesday': 2,
      'Wednesday': 3,
      'Thursday': 4,
      'Friday': 5,
      'Saturday': 6,
      'Sunday': 7,
    };

    for (final day in repeatDays) {
      final weekday = dayMap[day];
      if (weekday == null) continue;

      var scheduleDate = scheduledDate;
      final currentWeekday = scheduleDate.weekday;

      var daysUntil = weekday - currentWeekday;
      // Only add 7 when strictly negative — daysUntil==0 means "today, time
      // still in the future" (scheduledDate was already pushed to tomorrow if
      // the time had passed, so 0 here is safe).
      if (daysUntil < 0) daysUntil += 7;

      scheduleDate = scheduleDate.add(Duration(days: daysUntil));

      await _notifications.zonedSchedule(
        id + weekday,
        title,
        body,
        scheduleDate,
        details,
        androidScheduleMode: scheduleMode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  // Cancellation
  // ──────────────────────────────────────────────────────────────────────

  /// Cancel a reminder and all 7 possible weekday-slot variants.
  Future<void> cancelMealReminder(int id) async {
    await _cancelAllSlotsFor(id);
  }

  /// Cancel the base id plus weekday-offset ids (1-7) used by weekly repeats.
  Future<void> _cancelAllSlotsFor(int baseId) async {
    await _notifications.cancel(baseId);
    for (int weekday = 1; weekday <= 7; weekday++) {
      await _notifications.cancel(baseId + weekday);
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  // Notification details
  // ──────────────────────────────────────────────────────────────────────

  /// Build a [NotificationDetails] that uses the pre-created max-importance
  /// channel [_kChannelId] so heads-up banners always appear.
  NotificationDetails _notificationDetails({required bool enableVibration}) {
    final androidDetails = AndroidNotificationDetails(
      _kChannelId,
      _kChannelName,
      channelDescription: _kChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: enableVibration,
      vibrationPattern:
          enableVibration ? Int64List.fromList([0, 500, 250, 500]) : null,
      playSound: true,
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('Notification tapped: ${response.payload}');
  }

  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    print('Background notification tapped: ${response.payload}');
  }

  String _getMealTitle(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return '🌅 Breakfast Time';
      case 'lunch':
        return '🍽️ Lunch Time';
      case 'dinner':
        return '🌙 Dinner Time';
      case 'snack':
        return '🍿 Snack Time';
      default:
        return '🍽️ Meal Time';
    }
  }

  String _getMealBody(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 'Time to log your breakfast! Start your day right 🥗';
      case 'lunch':
        return 'Don\'t forget to log your lunch! 🥙';
      case 'dinner':
        return 'Time to log your dinner! 🍝';
      case 'snack':
        return 'Snack time! Log what you\'re eating 🍎';
      default:
        return 'Time to log your meal!';
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
