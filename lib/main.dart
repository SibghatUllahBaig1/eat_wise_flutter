import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/firebase_options.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'backend/api_requests/api_config.dart';
import 'backend/services/app_day_service.dart';
import 'backend/services/pedometer_service.dart';
import 'backend/services/legal_content_service.dart';
import 'backend/backend_manager.dart';
import 'backend/services/revenuecat_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// The single notification channel used for all EatWise FCM messages.
const AndroidNotificationChannel _eatwiseChannel = AndroidNotificationChannel(
  'eatwise_notifications', // must match default_notification_channel_id in manifest
  'EatWise Notifications',
  description: 'Reminders, tips, and updates from EatWise.',
  importance: Importance.high,
);

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Background message handler — must be a top-level function.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Background messages are delivered by the OS when the app is terminated.
  // No action needed here; the OS shows the notification automatically.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  if (kIsWeb) {
    usePathUrlStrategy();
  }

  await initFirebase();

  // Prime auth before runApp so GoRouter does not sit on a blank white
  // loading overlay waiting for the first authStateChanges event.
  AppStateNotifier.instance.update(
    EatWiseFirebaseUser.fromFirebaseUser(FirebaseAuth.instance.currentUser),
  );

  // ── FCM setup ──────────────────────────────────────────────────────────────
  // Register the background handler (must be done before any other FCM calls).
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Create the high-importance Android notification channel.
  // Without this, notifications sent to 'eatwise_notifications' are silently
  // dropped on Android 8+ because the channel doesn't exist.
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_eatwiseChannel);
  }

  // Initialize flutter_local_notifications so foreground FCM messages can be
  // shown as heads-up notifications. iOS requires DarwinInitializationSettings.
  if (!kIsWeb) {
    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          // Permissions are requested via Firebase Messaging below.
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  // Request permission on iOS / Android 13+ (Android < 13 is auto-granted).
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // Show FCM messages as local notifications while the app is in the foreground.
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _eatwiseChannel.id,
          _eatwiseChannel.name,
          channelDescription: _eatwiseChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  });
  // ──────────────────────────────────────────────────────────────────────────

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  // Non-blocking startup work — must not delay the first frame on release builds.
  unawaited(_runDeferredStartup());

  // Clear old hardcoded tracker data to ensure fresh start
  final today = DateTime.now();
  final normalizedToday = DateTime(today.year, today.month, today.day);
  appState.updateTrackerStruct((e) => e
    ..step = []
    ..water = []
    ..weight = []
    ..currentDate = normalizedToday
    ..selectedDate = normalizedToday);

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: MyApp(),
  ));
}

/// Firestore / subscription setup that should not block showing the UI.
Future<void> _runDeferredStartup() async {
  try {
    await ApiConfig.loadApiKeys();
  } catch (e) {
    // ignore: avoid_print
    print('ApiConfig.loadApiKeys failed: $e');
  }
  try {
    await LegalContentService().initializeDefaultContent();
  } catch (e) {
    // ignore: avoid_print
    print('LegalContentService.initializeDefaultContent failed: $e');
  }
  try {
    await RevenueCatService().initialize();
  } catch (e) {
    // ignore: avoid_print
    print('RevenueCatService.initialize failed: $e');
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  String getRoute([RouteMatch? routeMatch]) {
    final RouteMatch lastMatch =
        routeMatch ?? _router.routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : _router.routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }

  List<String> getRouteStack() =>
      _router.routerDelegate.currentConfiguration.matches
          .map((e) => getRoute(e))
          .toList();
  late Stream<BaseAuthUser> userStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = eatWiseFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
        if (user.loggedIn) {
          // Start real hardware step counting for this user.
          final uid = user.uid;
          if (uid != null) {
            PedometerService().startListening(uid);
            // Sync FCM token to Firestore so Cloud Functions can send notifications
            _syncFcmToken(uid);
            // Identify the user to RevenueCat so purchases follow them.
            RevenueCatService().setUserId(uid);
            // Grant the one-time 7-day premium trial for eligible testers.
            BackendManager().subscriptionService.ensureFreeTrialIfEligible(uid);
          }
        } else {
          // User logged out — stop the step counter and detach RevenueCat user.
          PedometerService().stopListening();
          RevenueCatService().logOut();
        }
      });

    // Refresh FCM token in Firestore whenever it rotates
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      final uid = currentUserUid;
      if (uid.isNotEmpty) _storeFcmToken(uid, newToken);
    });
    jwtTokenStream.listen((_) {});
    // Dismiss splash quickly; auth is already primed in main().
    Future.delayed(
      const Duration(milliseconds: 300),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
    // Safety net — never leave the user on a blank loading screen.
    Future.delayed(
      const Duration(seconds: 4),
      () {
        if (_appStateNotifier.showSplashImage) {
          _appStateNotifier.stopShowingSplashImage();
        }
        if (_appStateNotifier.user == null) {
          _appStateNotifier.update(
            EatWiseFirebaseUser.fromFirebaseUser(
              FirebaseAuth.instance.currentUser,
            ),
          );
        }
      },
    );
  }

  /// Retrieve the current FCM token and persist it to Firestore.
  Future<void> _syncFcmToken(String uid) async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _storeFcmToken(uid, token);
    } catch (e) {
      print('⚠️ FCM token sync failed: $e');
    }
  }

  /// Write (or overwrite) the FCM token to `users/{uid}` in Firestore.
  Future<void> _storeFcmToken(String uid, String token) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {'fcmToken': token, 'fcmTokenUpdatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    } catch (e) {
      print('⚠️ FCM token store failed: $e');
    }
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final uid = currentUserUid;
      AppDayService.instance.checkDayRollover(
        userId: uid.isEmpty ? null : uid,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'EatWise',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
      // Keep layout stable when the user enables larger system text sizes.
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child!,
        );
      },
    );
  }
}
