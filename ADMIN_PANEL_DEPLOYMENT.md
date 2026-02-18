# EatWise Admin Panel - Deployment Guide

## Overview

The EatWise Admin Panel is a web-based administrative interface built with Flutter Web and hosted on Firebase Hosting. It allows administrators to manage users, recipes, API keys, and legal content.

## Admin Panel Features

1. **Dashboard** - Overview statistics (total users, recipes, subscriptions, meals)
2. **API Management** - Manage API keys for OpenAI, USDA, and RevenueCat
3. **Customer Management** - View, edit, suspend, block, and delete users
4. **Recipe Management** - Add, edit, and delete recipes with diet categories
5. **Content Management** - Edit legal pages (Terms, Privacy, About, Contact)

## Prerequisites

- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- Firebase project configured (eatwise-6df8a)
- Admin user account with `isAdmin: true` in Firestore

## Building the Admin Panel

### 1. Build for Web

```bash
flutter build web --release
```

This will create a production build in the `build/web` directory.

### 2. Deploy to Firebase Hosting

```bash
# Login to Firebase (if not already logged in)
firebase login

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

The admin panel will be deployed to: `https://eatwise-6df8a.web.app`

## Creating the First Admin User

Since the admin panel requires authentication with `isAdmin: true`, you need to create the first admin user manually:

### Method 1: Using Firebase Console

1. Go to Firebase Console: https://console.firebase.google.com/project/eatwise-6df8a
2. Navigate to **Firestore Database**
3. Find or create a user document in the `users` collection
4. Add a field: `isAdmin` (boolean) = `true`

### Method 2: Using Firestore Rules (Temporary)

1. Temporarily modify Firestore security rules to allow write access
2. Create a user account through the mobile app
3. Use a script or Firebase Console to set `isAdmin: true`
4. Restore the original security rules

### Example User Document Structure

```
users/{userId}
  - email: "admin@eatwise.com"
  - displayName: "Admin User"
  - isAdmin: true
  - createdAt: <timestamp>
```

## Firestore Security Rules

Update your Firestore security rules to protect admin operations:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is admin
    function isAdmin() {
      return request.auth != null && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // API Keys - Admin only
    match /api_keys/{document} {
      allow read, write: if isAdmin();
    }
    
    // Recipes - Admin can write, users can read
    match /recipes/{recipeId} {
      allow read: if request.auth != null;
      allow write: if isAdmin();
    }
    
    // Legal content - Admin can write, anyone can read
    match /legal/{documentId} {
      allow read: if true;
      allow write: if isAdmin();
    }
    
    // Users collection - Admin can read/write all, users can only access their own
    match /users/{userId} {
      allow read: if request.auth.uid == userId || isAdmin();
      allow write: if request.auth.uid == userId;
      allow delete: if isAdmin();
      
      // User subcollections
      match /{subcollection}/{document=**} {
        allow read, write: if request.auth.uid == userId;
        allow delete: if isAdmin();
      }
    }
  }
}
```

## Admin Panel Access

1. Navigate to: `https://eatwise-6df8a.web.app`
2. Login with an admin account (email/password)
3. The system will check if the user has `isAdmin: true`
4. If not admin, access will be denied

## Development Mode

To run the admin panel locally for development:

```bash
# Run in web mode
flutter run -d chrome --web-port=5000

# Or use the admin entry point directly
flutter run -d chrome --target=lib/admin/main_admin.dart
```

## File Structure

```
lib/admin/
├── main_admin.dart                    # Admin app entry point
├── auth/
│   ├── admin_auth_gate.dart          # Authentication gate
│   └── admin_login_page.dart         # Login page
├── dashboard/
│   └── admin_dashboard.dart          # Main dashboard layout
└── pages/
    ├── dashboard_home_page.dart      # Dashboard overview
    ├── api_management_page.dart      # API key management
    ├── customer_management_page.dart # User management
    ├── recipe_management_page.dart   # Recipe CRUD
    └── content_management_page.dart  # Legal content CMS
```

## Troubleshooting

### Issue: "Access Denied" after login

**Solution**: Verify that the user document in Firestore has `isAdmin: true`

### Issue: Build fails

**Solution**: Run `flutter clean && flutter pub get` then rebuild

### Issue: Firebase deploy fails

**Solution**: 
- Check that you're logged in: `firebase login`
- Verify project: `firebase use eatwise-6df8a`
- Check firebase.json configuration

### Issue: API keys not loading

**Solution**: Ensure the `api_keys` collection exists in Firestore with documents:
- `openai` (with field: `apiKey`)
- `usda` (with field: `apiKey`)
- `revenuecat` (with fields: `iosApiKey`, `androidApiKey`)

## Maintenance

### Updating Legal Content

1. Login to admin panel
2. Navigate to Content Management
3. Click Edit on the document you want to update
4. Modify the content (supports markdown)
5. Click Save

### Managing Recipes

1. Navigate to Recipe Management
2. Use the search and filter to find recipes
3. Click Add Recipe to create new recipes
4. Click Edit on a recipe card to modify
5. Click Delete to remove recipes

### Managing Users

1. Navigate to Customer Management
2. Use search to find specific users
3. Click Edit to modify user details or suspend/block accounts
4. Click Delete to permanently remove a user (requires confirmation)

## Security Best Practices

1. **Never share admin credentials**
2. **Limit admin access** - Only grant `isAdmin: true` to trusted users
3. **Monitor admin actions** - Consider adding audit logging
4. **Use strong passwords** - Enforce password requirements
5. **Regular backups** - Backup Firestore data regularly
6. **Update security rules** - Review and update Firestore rules as needed

## Support

For issues or questions, contact the development team.

