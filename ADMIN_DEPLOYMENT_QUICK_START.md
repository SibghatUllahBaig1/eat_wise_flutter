# Admin Panel Deployment - Quick Start Guide

## ⚠️ Important: Build Target

The admin panel is a **separate Flutter Web app** located in `lib/admin/`. When deploying to Firebase Hosting, you **MUST** build with the correct target:

```bash
flutter build web --release --target=lib/main_web.dart
```

## Automated Deployment (Recommended)

### macOS/Linux:
```bash
chmod +x scripts/deploy_admin.sh
./scripts/deploy_admin.sh
```

### Windows:
```bash
scripts\deploy_admin.bat
```

The script will:
1. ✅ Clean previous builds
2. ✅ Get dependencies
3. ✅ Build admin panel for web
4. ✅ Deploy to Firebase Hosting

## Manual Deployment

If you prefer to deploy manually:

```bash
# 1. Clean
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Build admin panel (IMPORTANT: use --target=lib/main_web.dart)
flutter build web --release --target=lib/main_web.dart

# 4. Deploy to Firebase
firebase deploy --only hosting
```

## Verify Deployment

After deployment, access the admin panel at:
- **URL**: https://eatwise-6df8a.web.app
- **Login**: Use admin account credentials
- **Check**: Verify `isAdmin: true` in Firestore for your user

## Troubleshooting

### Issue: Mobile app opens instead of admin panel
**Solution**: Make sure you built with `--target=lib/main_web.dart`

### Issue: Build fails
**Solution**: Run `flutter clean && flutter pub get` first

### Issue: Firebase deploy fails
**Solution**: 
- Login: `firebase login`
- Verify project: `firebase use eatwise-6df8a`
- Check internet connection

## Key Files

- **Admin Entry Point**: `lib/admin/main_admin.dart`
- **Web Entry Point**: `lib/main_web.dart`
- **Admin Dashboard**: `lib/admin/dashboard/admin_dashboard.dart`
- **Firebase Config**: `firebase.json`

## Admin Panel Features

- 📊 Dashboard with statistics
- 🔑 API key management
- 👥 Customer management
- 🍽️ Recipe management
- 📄 Legal content management

