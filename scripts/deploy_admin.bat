@echo off
REM EatWise Admin Panel Deployment Script (Windows)
REM This script builds and deploys the admin panel to Firebase Hosting

setlocal enabledelayedexpansion

echo.
echo ==========================================
echo EatWise Admin Panel Deployment
echo ==========================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter is not installed. Please install Flutter first.
    exit /b 1
)

REM Check if Firebase CLI is installed
firebase --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Firebase CLI is not installed. Please install it with: npm install -g firebase-tools
    exit /b 1
)

echo ✅ Flutter and Firebase CLI found
echo.

REM Step 1: Clean previous builds
echo 📦 Cleaning previous builds...
call flutter clean
echo ✅ Clean complete
echo.

REM Step 2: Get dependencies
echo 📥 Getting dependencies...
call flutter pub get
echo ✅ Dependencies updated
echo.

REM Step 3: Build admin panel for web
echo 🔨 Building admin panel for web...
call flutter build web --release --target=lib/main_web.dart
if errorlevel 1 (
    echo ❌ Build failed
    exit /b 1
)
echo ✅ Build complete
echo.

REM Step 4: Deploy to Firebase
echo 🚀 Deploying to Firebase Hosting...
call firebase deploy --only hosting
if errorlevel 1 (
    echo ❌ Deployment failed
    exit /b 1
)
echo ✅ Deployment complete
echo.

echo ==========================================
echo ✅ Admin Panel Successfully Deployed!
echo ==========================================
echo.
echo Access the admin panel at:
echo https://eatwise-6df8a.web.app
echo.

