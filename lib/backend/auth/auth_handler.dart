import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '/auth/firebase_auth/apple_auth.dart';
import '../backend_manager.dart';
import '/app_state.dart';
import '/backend/api_requests/api_config.dart';

/// Handler for authentication events and user data synchronization
class AuthHandler extends ChangeNotifier {
  static final AuthHandler _instance = AuthHandler._internal();

  factory AuthHandler() {
    return _instance;
  }

  AuthHandler._internal() {
    _initAuthListener();
  }

  final BackendManager _backend = BackendManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

  // Loading states
  bool _isLoading = false;
  String? _error;
  bool _isNewUser = false;

  // Getters
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  bool get isAuthenticated => _auth.currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// True if the last sign-in created a brand-new account.
  bool get isNewUser => _isNewUser;

  // User info getters
  String get currentUserEmail => currentUser?.email ?? '';
  String get currentUserDisplayName => currentUser?.displayName ?? '';
  String get currentUserPhotoUrl => currentUser?.photoURL ?? '';
  bool get isEmailVerified => currentUser?.emailVerified ?? false;

  /// Initialize authentication state listener
  void _initAuthListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _onUserSignedIn(user);
      } else {
        _onUserSignedOut();
      }
    });
  }

  /// Handle user sign in
  Future<void> _onUserSignedIn(User user) async {
    try {
      debugPrint('User signed in: ${user.uid}');

      // Every eligible new install gets a 7-day premium trial for testing.
      await _backend.subscriptionService.ensureFreeTrialIfEligible(user.uid);

      // Update app state
      FFAppState().authenticated = true;

      // Load API keys from Firestore now that user is authenticated
      debugPrint('Loading API keys after authentication...');
      await ApiConfig.loadApiKeys();
      debugPrint(
          'API keys loaded: OpenAI=${ApiConfig.isOpenAiConfigured}, USDA=${ApiConfig.isUsdaConfigured}');

      // Check if user profile exists
      final profile = await _backend.userService.getUserProfile(user.uid);

      if (profile == null) {
        // New user - initialize profile shell only; onboarding writes real data.
        await _backend.initializeUserData(
          userId: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
        );
      } else {
        // Existing user - load data from Firestore (includes profile/data subcollection).
        await _backend.syncService.fullSync(userId: user.uid);
      }
    } catch (e) {
      debugPrint('Error handling user sign in: $e');
    }
  }

  /// Handle user sign out
  void _onUserSignedOut() {
    debugPrint('User signed out');
    FFAppState().authenticated = false;
  }

  /// Sign in with email and password
  Future<User?> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('AuthHandler: Attempting sign in with email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      debugPrint(
          'AuthHandler: Sign in successful! User: ${credential.user?.uid}');
      debugPrint(
          'AuthHandler: Current user after sign in: ${_auth.currentUser?.uid}');

      _isLoading = false;
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('AuthHandler: Sign in error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      _isLoading = false;
      _error = 'An unexpected error occurred';
      notifyListeners();
      debugPrint('AuthHandler: Sign in error: $e');
      return null;
    }
  }

  /// Sign up with email and password
  Future<User?> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Update display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }

      _isLoading = false;
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Sign up error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      _isLoading = false;
      _error = 'An unexpected error occurred';
      notifyListeners();
      debugPrint('Sign up error: $e');
      return null;
    }
  }

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential credential;

      if (kIsWeb) {
        // Web flow
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        credential = await _auth.signInWithPopup(googleProvider);
      } else {
        // Mobile flow
        // Sign out first to ensure account picker shows
        await _googleSignIn.signOut().catchError((_) => null);

        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          _isLoading = false;
          _error = 'Google sign in was cancelled';
          notifyListeners();
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final OAuthCredential googleCredential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        credential = await _auth.signInWithCredential(googleCredential);
      }

      _isNewUser = credential.additionalUserInfo?.isNewUser ?? false;
      _isLoading = false;
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _isNewUser = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Google sign in error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      _isLoading = false;
      _isNewUser = false;
      final msg = e.toString();
      if (msg.contains('ApiException: 10') ||
          msg.contains('DEVELOPER_ERROR') ||
          msg.contains('sign_in_failed')) {
        _error =
            'Google sign in is not configured for this device. Please contact support.';
      } else if (msg.contains('network') || msg.contains('Network')) {
        _error = 'Network error. Please check your internet connection.';
      } else {
        _error = 'Google sign in failed. Please try again.';
      }
      notifyListeners();
      debugPrint('Google sign in error: $e');
      return null;
    }
  }

  /// Sign in with Apple
  Future<User?> signInWithApple() async {
    _isLoading = true;
    _error = null;
    _isNewUser = false;
    notifyListeners();

    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        final isAvailable = await SignInWithApple.isAvailable();
        if (!isAvailable) {
          _isLoading = false;
          _error =
              'Apple Sign-In is not available on this device. Sign into iCloud in Settings and try again.';
          notifyListeners();
          return null;
        }
      }

      final credential = await appleSignIn();
      _isNewUser = credential.additionalUserInfo?.isNewUser ?? false;

      _isLoading = false;
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _isNewUser = false;
      if (e.code == 'invalid-credential' &&
          (e.message?.contains('apple.com') ?? false)) {
        _error =
            'Apple Sign-In could not be verified. Rebuild and reinstall the app, then confirm Sign in with Apple is enabled in Firebase Console with your Apple Team ID, Key ID, and private key.';
      } else {
        _error = _getErrorMessage(e);
      }
      notifyListeners();
      debugPrint('Apple sign in error: ${e.code} - ${e.message}');
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      _isLoading = false;
      _isNewUser = false;
      if (e.code == AuthorizationErrorCode.canceled) {
        _error = 'Apple sign in was cancelled';
      } else if (e.code == AuthorizationErrorCode.unknown) {
        _error =
            'Apple sign in could not start. Reinstall the app from a build with Sign in with Apple enabled, ensure you are signed into iCloud, then try again.';
      } else if (e.code == AuthorizationErrorCode.notHandled) {
        _error = 'Apple sign in is not configured for this app build.';
      } else {
        _error = 'Apple sign in failed: ${e.message}';
      }
      notifyListeners();
      debugPrint('Apple sign in error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      _isLoading = false;
      _isNewUser = false;
      _error = 'Apple sign in failed. Please try again.';
      notifyListeners();
      debugPrint('Apple sign in error: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Sign out from Google if signed in
      if (!kIsWeb) {
        await _googleSignIn.signOut().catchError((_) => null);
      }

      await _auth.signOut();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Sign out failed';
      notifyListeners();
      debugPrint('Sign out error: $e');
      rethrow;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to send password reset email';
      notifyListeners();
      debugPrint('Password reset error: $e');
      return false;
    }
  }

  /// Send email verification
  Future<bool> sendEmailVerification() async {
    try {
      await currentUser?.sendEmailVerification();
      return true;
    } catch (e) {
      _error = 'Failed to send verification email';
      notifyListeners();
      debugPrint('Email verification error: $e');
      return false;
    }
  }

  /// Reload current user
  Future<void> reloadUser() async {
    try {
      await currentUser?.reload();
      notifyListeners();
    } catch (e) {
      debugPrint('Reload user error: $e');
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        _error = 'No user signed in';
        notifyListeners();
        return false;
      }

      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }

      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      await user.reload();

      // Sync to Firestore
      await _backend.syncService.syncUserProfile(userId: user.uid);

      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Failed to update profile';
      notifyListeners();
      debugPrint('Update profile error: $e');
      return false;
    }
  }

  /// Update user password
  Future<bool> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
      return true;
    } on FirebaseAuthException catch (e) {
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Update password error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      _error = 'Failed to update password';
      notifyListeners();
      debugPrint('Update password error: $e');
      return false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) {
        _isLoading = false;
        _error = 'No user signed in';
        notifyListeners();
        return false;
      }

      // Delete user data from Firestore
      // Note: This should be done via Cloud Function for security
      // For now, just delete the auth account

      await user.delete();

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Delete account error: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to delete account';
      notifyListeners();
      debugPrint('Delete account error: $e');
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Link Google account to the current user.
  Future<bool> linkWithGoogle() async {
    final user = _auth.currentUser;
    if (user == null) {
      _error = 'No user signed in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        _error = 'Google sign in was cancelled';
        notifyListeners();
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await user.linkWithCredential(credential);
      await user.reload();
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getLinkErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to link Google account';
      notifyListeners();
      return false;
    }
  }

  /// Link Apple account to the current user.
  Future<bool> linkWithApple() async {
    final user = _auth.currentUser;
    if (user == null) {
      _error = 'No user signed in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS) {
        await user.linkWithProvider(_appleLinkProvider());
      } else {
        final credential = await getAppleCredential();
        await user.linkWithCredential(credential);
      }

      await user.reload();
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getLinkErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to link Apple account';
      notifyListeners();
      return false;
    }
  }

  /// Link email/password credentials to the current user.
  Future<bool> linkWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      _error = 'No user signed in';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final credential = EmailAuthProvider.credential(
        email: email.trim(),
        password: password,
      );
      await user.linkWithCredential(credential);
      await user.reload();
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getLinkErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to link email account';
      notifyListeners();
      return false;
    }
  }

  /// Unlink a provider from the current user.
  Future<bool> unlinkProvider(String providerId) async {
    final user = _auth.currentUser;
    if (user == null) {
      _error = 'No user signed in';
      notifyListeners();
      return false;
    }

    if (user.providerData.length <= 1) {
      _error = 'Cannot unlink your only sign-in method';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await user.unlink(providerId);
      await user.reload();
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getLinkErrorMessage(e);
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _error = 'Failed to unlink account';
      notifyListeners();
      return false;
    }
  }

  AppleAuthProvider _appleLinkProvider() {
    final provider = AppleAuthProvider();
    provider.addScope('email');
    provider.addScope('name');
    return provider;
  }

  String _getLinkErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'provider-already-linked':
        return 'This account is already linked';
      case 'credential-already-in-use':
        return 'This credential is already used by another account';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action';
      default:
        return _getErrorMessage(e);
    }
  }

  // Helper methods

  /// Get user-friendly error message from FirebaseAuthException
  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid email or password';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method';
      case 'requires-recent-login':
        return 'Please sign in again to complete this action';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      default:
        return e.message ?? 'An error occurred';
    }
  }
}
