#!/bin/bash

# EatWise Admin Panel Deployment Script
# This script builds and deploys the admin panel to Firebase Hosting

set -e

echo "=========================================="
echo "EatWise Admin Panel Deployment"
echo "=========================================="
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI is not installed. Please install it with: npm install -g firebase-tools"
    exit 1
fi

echo "✅ Flutter and Firebase CLI found"
echo ""

# Step 1: Clean previous builds
echo "📦 Cleaning previous builds..."
flutter clean
echo "✅ Clean complete"
echo ""

# Step 2: Get dependencies
echo "📥 Getting dependencies..."
flutter pub get
echo "✅ Dependencies updated"
echo ""

# Step 3: Build admin panel for web
echo "🔨 Building admin panel for web..."
flutter build web --release --target=lib/main_web.dart
echo "✅ Build complete"
echo ""

# Step 4: Deploy to Firebase
echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting
echo "✅ Deployment complete"
echo ""

echo "=========================================="
echo "✅ Admin Panel Successfully Deployed!"
echo "=========================================="
echo ""
echo "Access the admin panel at:"
echo "https://eatwise-6df8a.web.app"
echo ""

