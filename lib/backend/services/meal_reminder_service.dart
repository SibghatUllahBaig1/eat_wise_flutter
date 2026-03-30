import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'meal_reminder_preferences.dart';

/// FCM-based meal reminder service.
///
/// Scheduling is done server-side (Cloud Functions).
/// This service is responsible for syncing the user's reminder preferences
/// and IANA timezone to Firestore so the backend can send FCM notifications
/// at the correct local time.
class MealReminderService {
  static final MealReminderService _instance = MealReminderService._internal();
  factory MealReminderService() => _instance;
  MealReminderService._internal();

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _userId => _auth.currentUser?.uid;

  // ──────────────────────────────────────────────────────────────────────
  // Firestore sync
  // ──────────────────────────────────────────────────────────────────────

  /// Sync a single meal reminder's preferences to Firestore and persist them
  /// locally via [MealReminderPreferences] for offline access.
  ///
  /// The Cloud Function reads this document to decide when and whether to
  /// send an FCM push notification for the given [mealType].
  Future<void> syncMealReminder({
    required String mealType,
    required bool enabled,
    required int hour,
    required int minute,
    required List<String> repeatDays,
  }) async {
    // 1. Persist locally so settings survive offline/no-user scenarios.
    await MealReminderPreferences.saveMealReminder(
      mealType: mealType,
      enabled: enabled,
      hour: hour,
      minute: minute,
      repeatDays: repeatDays,
    );

    // 2. Sync to Firestore when authenticated.
    final uid = _userId;
    if (uid == null) return;

    String timezone = 'UTC';
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      timezone = tzInfo.identifier;
    } catch (_) {}

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('meal_reminders')
          .set(
        {
          'timezone': timezone,
          mealType.toLowerCase(): {
            'enabled': enabled,
            'hour': hour,
            'minute': minute,
            'repeatDays': repeatDays,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      // Non-fatal — local prefs are the offline fallback.
      debugPrint('⚠️ MealReminderService: Firestore sync failed ($e)');
    }
  }

  // ──────────────────────────────────────────────────────────────────────
  // Tracker reminder sync (Water / Step / Weight)
  // ──────────────────────────────────────────────────────────────────────

  /// Syncs a tracker reminder to Firestore under
  /// `users/{uid}/settings/tracker_reminders`.
  ///
  /// [trackerType] — 1: water, 2: step, 3: weight
  /// Time is stored in 12-hour format (hour string, minute string, ampm string)
  /// so the Cloud Function can convert it to the user's local 24-hour time.
  Future<void> syncTrackerReminder({
    required int trackerType, // 1=water, 2=step, 3=weight
    required bool enabled,
    required String hour,
    required String minute,
    required String ampm,
    required List<String> repeatDays,
  }) async {
    final uid = _userId;
    if (uid == null) return;

    const keys = {1: 'water', 2: 'step', 3: 'weight'};
    final trackerKey = keys[trackerType];
    if (trackerKey == null) return;

    String timezone = 'UTC';
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      timezone = tzInfo.identifier;
    } catch (_) {}

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('tracker_reminders')
          .set(
        {
          'timezone': timezone,
          trackerKey: {
            'enabled': enabled,
            'hour': hour,
            'minute': minute,
            'ampm': ampm,
            'repeatDays': repeatDays,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('⚠️ MealReminderService: Tracker Firestore sync failed ($e)');
    }
  }
}
