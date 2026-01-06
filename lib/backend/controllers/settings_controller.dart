import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend_manager.dart';
import '/app_state.dart';

/// Controller for managing user settings
class SettingsController extends ChangeNotifier {
  final BackendManager _backend = BackendManager();
  
  // Settings data
  Map<String, dynamic>? _settings;
  
  // Loading state
  bool _isLoading = false;
  bool _isSaving = false;
  
  // Error state
  String? _error;
  
  // Getters
  Map<String, dynamic>? get settings => _settings;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  /// Load user settings from Firestore
  Future<void> loadSettings() async {
    if (currentUserId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _settings = await _backend.userService.getUserSettings(currentUserId!);
      
      // Update app state
      if (_settings != null) {
        final appState = FFAppState();
        
        appState.darkMode = _settings!['darkMode'] ?? 'Light';
        
        if (_settings!['notifications'] != null) {
          final notifications = _settings!['notifications'] as Map<String, dynamic>;
          appState.updateNotificationStruct((notif) {
            notif.mealtime = notifications['mealtime'] ?? false;
            notif.water = notifications['water'] ?? false;
            notif.checkYourProgress = notifications['checkYourProgress'] ?? false;
          });
        }
      }
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load settings: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Update dark mode setting
  Future<bool> updateDarkMode(String mode) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.userService.updateUserSettings(
        userId: currentUserId!,
        darkMode: mode,
      );
      
      // Update app state
      FFAppState().darkMode = mode;
      
      // Reload settings
      await loadSettings();
      
      return true;
    } catch (e) {
      _error = 'Failed to update dark mode: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Update notification settings
  Future<bool> updateNotifications(Map<String, dynamic> notifications) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.userService.updateUserSettings(
        userId: currentUserId!,
        notifications: notifications,
      );
      
      // Update app state
      final appState = FFAppState();
      appState.updateNotificationStruct((notif) {
        notif.mealtime = notifications['mealtime'] ?? false;
        notif.water = notifications['water'] ?? false;
        notif.checkYourProgress = notifications['checkYourProgress'] ?? false;
      });
      
      // Reload settings
      await loadSettings();
      
      return true;
    } catch (e) {
      _error = 'Failed to update notifications: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Update language setting
  Future<bool> updateLanguage(Map<String, dynamic> language) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.userService.updateUserSettings(
        userId: currentUserId!,
        language: language,
      );
      
      // Update app state
      final appState = FFAppState();
      appState.updateSelectedLangStruct((lang) {
        lang.language = language['language'] ?? 'English';
        lang.langCode = language['langCode'] ?? 'en';
        lang.flag = language['flag'] ?? '';
      });
      
      // Reload settings
      await loadSettings();
      
      return true;
    } catch (e) {
      _error = 'Failed to update language: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Sync app state settings to Firestore
  Future<bool> syncToFirestore() async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.syncService.syncUserSettings(userId: currentUserId!);
      return true;
    } catch (e) {
      _error = 'Failed to sync settings: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

