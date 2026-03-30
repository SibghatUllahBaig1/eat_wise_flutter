import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/firebase_auth/firebase_user_provider.dart';
import 'auth/firebase_auth/auth_util.dart';

import 'backend/firebase/firebase_config.dart';
import 'backend/api_requests/api_config.dart';
import 'backend/services/pedometer_service.dart';
import 'backend/services/legal_content_service.dart';
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
  await Firebase.initializeApp();
  // Background messages are delivered by the OS when the app is terminated.
  // No action needed here; the OS shows the notification automatically.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  await initFirebase();

  // ── FCM setup ──────────────────────────────────────────────────────────────
  // Register the background handler (must be done before any other FCM calls).
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Create the high-importance Android notification channel.
  // Without this, notifications sent to 'eatwise_notifications' are silently
  // dropped on Android 8+ because the channel doesn't exist.
  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_eatwiseChannel);

  // Initialize flutter_local_notifications so foreground FCM messages can be
  // shown as heads-up notifications.
  await _flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

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
      ),
    );
  });
  // ──────────────────────────────────────────────────────────────────────────

  // Try to load API keys from Firestore (may fail if user not authenticated yet)
  // Keys will be reloaded after authentication in AuthHandler
  print('🔑 Attempting to load API keys before authentication...');
  await ApiConfig.loadApiKeys();
  print(
      '🔑 Initial API key load: OpenAI=${ApiConfig.isOpenAiConfigured}, USDA=${ApiConfig.isUsdaConfigured}');

  // Initialize default legal content in Firestore
  await LegalContentService().initializeDefaultContent();

  await FlutterFlowTheme.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

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

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
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

    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = eatWiseFirebaseUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
        if (user.loggedIn) {
          // Initialize pedometer service when user logs in
          PedometerService().initialize();
          // Sync FCM token to Firestore so Cloud Functions can send notifications
          final uid = user.uid;
          if (uid != null) _syncFcmToken(uid);
        }
      });

    // Refresh FCM token in Firestore whenever it rotates
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      final uid = currentUserUid;
      if (uid.isNotEmpty) _storeFcmToken(uid, newToken);
    });
    jwtTokenStream.listen((_) {});
    Future.delayed(
      Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
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
    );
  }
}
