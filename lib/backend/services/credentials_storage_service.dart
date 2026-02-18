import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing and retrieving user credentials
/// Uses flutter_secure_storage for sensitive data (password)
/// and shared_preferences for non-sensitive data (email, remember me flag)
class CredentialsStorageService {
  static const String _keyRememberMe = 'remember_me';
  static const String _keyEmail = 'saved_email';
  static const String _keyPassword = 'saved_password';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  /// Save credentials securely
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyRememberMe, true);
      await prefs.setString(_keyEmail, email);
      
      // Store password securely
      await _secureStorage.write(key: _keyPassword, value: password);
    } catch (e) {
      print('Error saving credentials: $e');
    }
  }

  /// Get saved email
  Future<String?> getSavedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
      if (!rememberMe) return null;
      
      return prefs.getString(_keyEmail);
    } catch (e) {
      print('Error getting saved email: $e');
      return null;
    }
  }

  /// Get saved password
  Future<String?> getSavedPassword() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_keyRememberMe) ?? false;
      if (!rememberMe) return null;
      
      return await _secureStorage.read(key: _keyPassword);
    } catch (e) {
      print('Error getting saved password: $e');
      return null;
    }
  }

  /// Check if remember me is enabled
  Future<bool> isRememberMeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyRememberMe) ?? false;
    } catch (e) {
      print('Error checking remember me: $e');
      return false;
    }
  }

  /// Clear saved credentials
  Future<void> clearCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyRememberMe);
      await prefs.remove(_keyEmail);
      await _secureStorage.delete(key: _keyPassword);
    } catch (e) {
      print('Error clearing credentials: $e');
    }
  }

  /// Disable remember me (but keep credentials for current session)
  Future<void> disableRememberMe() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyRememberMe, false);
    } catch (e) {
      print('Error disabling remember me: $e');
    }
  }
}

