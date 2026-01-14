# Quick Start: Implementing Reminders in EatWise

## 🚀 Quick Setup (5 Steps)

### 1. Add Dependencies
```bash
flutter pub add flutter_local_notifications timezone flutter_timezone
```

### 2. Android Configuration

**File: `android/app/build.gradle`**
```gradle
android {
    compileSdk 35
    defaultConfig {
        multiDexEnabled true
    }
    compileOptions {
        coreLibraryDesugaringEnabled true
        sourceCompatibility JavaVersion.VERSION_11
        targetCompatibility JavaVersion.VERSION_11
    }
}

dependencies {
    coreLibraryDesugaring 'com.android.tools:desugar_jdk_libs:2.1.4'
}
```

**File: `android/app/src/main/AndroidManifest.xml`**
```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

<application>
    <receiver android:exported="false" 
              android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
    <receiver android:exported="false" 
              android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
        <intent-filter>
            <action android:name="android.intent.action.BOOT_COMPLETED"/>
        </intent-filter>
    </receiver>
</application>
```

### 3. iOS Configuration

**File: `ios/Runner/AppDelegate.swift`**
```swift
import flutter_local_notifications

override func application(
  _ application: UIApplication,
  didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
  if #available(iOS 10.0, *) {
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
  }
  
  FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)
  }
  
  GeneratedPluginRegistrant.register(with: self)
  return super.application(application, didFinishLaunchingWithOptions: launchOptions)
}
```

### 4. Add Custom Sounds (Optional)

**Android:** Place in `android/app/src/main/res/raw/asteroid.mp3`
**iOS:** Add to Xcode project as `asteroid.aiff` (must be .aiff, .wav, or .caf)

### 5. Initialize in Main

**File: `lib/main.dart`**
```dart
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initialize();
  runApp(MyApp());
}
```

## 📋 Usage Examples

### Schedule Daily Water Reminder
```dart
await NotificationService().scheduleDailyReminder(
  id: 1001,
  title: 'Water Reminder',
  body: 'Time to drink water! 💧',
  hour: 9,
  minute: 0,
  channelId: 'water_reminder',
  channelName: 'Water Reminders',
  soundFile: 'asteroid',
  enableVibration: true,
);
```

### Cancel Reminder
```dart
await NotificationService().cancelNotification(1001);
```

### Check Pending Notifications
```dart
final pending = await NotificationService().getPendingNotifications();
print('Pending: ${pending.length}');
```

## 🎯 Notification IDs

```dart
class NotificationIds {
  static const int waterTracker = 1001;
  static const int calorieCounter = 1002;
  static const int stepCounter = 1003;
  static const int weightTracker = 1004;
}
```

## ✅ Testing Checklist

- [ ] Run `flutter pub get`
- [ ] Test notification when app is open
- [ ] Test notification when app is in background
- [ ] Test notification when app is closed
- [ ] Test notification after device reboot (Android)
- [ ] Test custom sound
- [ ] Test vibration on/off
- [ ] Test permission requests (Android 13+, iOS)
- [ ] Test "Stop When 100%" feature

## 🐛 Common Issues

**Notifications not showing?**
- Check permissions are granted
- On Android 13+, request `POST_NOTIFICATIONS` permission
- Request exact alarm permission on Android

**Sound not playing?**
- Android: File must be in `res/raw/` without extension in code
- iOS: File must be .aiff/.wav/.caf and ≤ 30 seconds

**Notifications stop after reboot?**
- Add `RECEIVE_BOOT_COMPLETED` permission
- Add boot receiver in AndroidManifest.xml

## 📚 Full Documentation

See `REMINDER_IMPLEMENTATION_GUIDE.md` for complete implementation details.

## 🎉 You're Done!

Your reminder system is now ready to use. The implementation:
- ✅ Works when app is closed
- ✅ Persists across reboots
- ✅ Supports custom sounds
- ✅ Supports vibration
- ✅ Battery efficient
- ✅ Follows platform best practices

