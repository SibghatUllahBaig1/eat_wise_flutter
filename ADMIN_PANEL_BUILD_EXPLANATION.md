# Admin Panel Build Configuration - Explanation

## The Problem

When you run `flutter build web --release` without specifying a target, Flutter builds the **default app** (the mobile app) instead of the admin panel. This is why Firebase Hosting was serving the mobile app instead of the admin panel.

## Why This Happens

Flutter projects can have multiple entry points:
- **Mobile App**: `lib/main.dart` (default)
- **Web App**: `lib/main_web.dart` (for web-specific configuration)
- **Admin Panel**: `lib/admin/main_admin.dart` (separate admin app)

When you don't specify `--target`, Flutter uses `lib/main.dart` by default.

## The Solution

### Build Command
```bash
flutter build web --release --target=lib/main_web.dart
```

The `--target=lib/main_web.dart` flag tells Flutter to:
1. Use `lib/main_web.dart` as the entry point
2. `lib/main_web.dart` imports and runs the admin app
3. Build the admin panel instead of the mobile app

### Why firebase.json Can't Specify the Target

Firebase Hosting's `firebase.json` only controls:
- Where to find the built files (`public: "build/web"`)
- How to serve them (rewrites, headers, caching)
- It does NOT control the Flutter build process

The Flutter build target must be specified in the **build command**, not in `firebase.json`.

## File Structure

```
lib/
├── main.dart                 # Mobile app entry point (default)
├── main_web.dart            # Web entry point (imports admin app)
├── admin/
│   ├── main_admin.dart      # Admin app entry point
│   ├── auth/
│   ├── dashboard/
│   └── pages/
└── ... (other mobile app files)
```

## Deployment Flow

```
flutter build web --release --target=lib/main_web.dart
    ↓
Reads lib/main_web.dart
    ↓
lib/main_web.dart imports admin/main_admin.dart
    ↓
Builds admin app
    ↓
Output: build/web/ (admin panel)
    ↓
firebase deploy --only hosting
    ↓
Uploads build/web/ to Firebase Hosting
    ↓
Admin panel is now live at https://eatwise-6df8a.web.app
```

## Automated Solution

Use the provided deployment scripts:
- **macOS/Linux**: `scripts/deploy_admin.sh`
- **Windows**: `scripts/deploy_admin.bat`

These scripts automatically use the correct build target.

## Key Takeaway

✅ **Always use**: `flutter build web --release --target=lib/main_web.dart`

❌ **Never use**: `flutter build web --release` (without target)

