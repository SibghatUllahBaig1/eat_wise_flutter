import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../backend_manager.dart';
import '/app_state.dart';

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

  // Getters
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  bool get isAuthenticated => _auth.currentUser != null;
  bool get isLoading => _isLoading;
  String? get error => _error;

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

      // Update app state
      FFAppState().authenticated = true;

      // Check if user profile exists
      final profile = await _backend.userService.getUserProfile(user.uid);

      if (profile == null) {
        // New user - initialize profile
        await _backend.initializeUserData(
          userId: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
        );

        // Sync app state to Firestore
        await _backend.syncService.syncUserProfile(userId: user.uid);
        await _backend.syncService.syncUserSettings(userId: user.uid);
      } else {
        // Existing user - load data from Firestore
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
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      _isLoading = false;
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Sign in error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      _isLoading = false;
      _error = 'An unexpected error occurred';
      notifyListeners();
      debugPrint('Sign in error: $e');
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

      _isLoading = false;
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Google sign in error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      _isLoading = false;
      _error = 'Google sign in failed';
      notifyListeners();
      debugPrint('Google sign in error: $e');
      return null;
    }
  }

  /// Sign in with Apple
  Future<User?> signInWithApple() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      UserCredential credential;

      if (kIsWeb) {
        // Web flow
        final provider = OAuthProvider("apple.com")
          ..addScope('email')
          ..addScope('name');
        credential = await _auth.signInWithPopup(provider);
      } else {
        // Mobile flow
        final rawNonce = _generateNonce();
        final nonce = _sha256ofString(rawNonce);

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        final oauthCredential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
          accessToken: appleCredential.authorizationCode,
        );

        credential = await _auth.signInWithCredential(oauthCredential);

        // Update display name if available
        final displayName = [
          appleCredential.givenName,
          appleCredential.familyName
        ].where((name) => name != null).join(' ');

        if (displayName.isNotEmpty && credential.user != null) {
          await credential.user!.updateDisplayName(displayName);
          await credential.user!.reload();
        }
      }

      _isLoading = false;
      notifyListeners();
      return credential.user;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _error = _getErrorMessage(e);
      notifyListeners();
      debugPrint('Apple sign in error: ${e.code} - ${e.message}');
      return null;
    } on SignInWithAppleAuthorizationException catch (e) {
      _isLoading = false;
      if (e.code == AuthorizationErrorCode.canceled) {
        _error = 'Apple sign in was cancelled';
      } else {
        _error = 'Apple sign in failed: ${e.message}';
      }
      notifyListeners();
      debugPrint('Apple sign in error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      _isLoading = false;
      _error = 'Apple sign in failed';
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

  // Helper methods

  /// Generate a cryptographically secure random nonce
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of input in hex notation
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

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
