import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import '/backend/firestore/api_keys_service.dart';

/// API Configuration for external services
///
/// API keys are stored in Firestore (managed via admin panel).
/// Call `loadApiKeys()` after the user is authenticated.

class ApiConfig {
  static String _openAiApiKey = '';
  static String _usdaApiKey = '';
  static String _revenueCatIosApiKey = '';
  static String _revenueCatAndroidApiKey = '';

  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String openAiVisionModel = 'gpt-4o';
  static const String openAiTextModel = 'gpt-4o-mini';
  static const String usdaBaseUrl = 'https://api.nal.usda.gov/fdc/v1';

  static const Duration apiTimeout = Duration(seconds: 30);

  static String get openAiApiKey => _openAiApiKey;
  static String get usdaApiKey => _usdaApiKey;
  static String get revenueCatIosApiKey => _revenueCatIosApiKey;
  static String get revenueCatAndroidApiKey => _revenueCatAndroidApiKey;

  static String get revenueCatApiKey {
    if (kIsWeb) return '';
    return Platform.isIOS ? _revenueCatIosApiKey : _revenueCatAndroidApiKey;
  }

  static bool get isOpenAiConfigured => _openAiApiKey.isNotEmpty;
  static bool get isUsdaConfigured => _usdaApiKey.isNotEmpty;
  static bool get isRevenueCatConfigured => revenueCatApiKey.isNotEmpty;

  /// Load API keys from Firestore (admin panel).
  static Future<void> loadApiKeys() async {
    try {
      final apiKeysService = ApiKeysService();
      final keys = await apiKeysService.getAllApiKeys();

      _openAiApiKey = keys['openai'] ?? '';
      _usdaApiKey = keys['usda'] ?? '';
      _revenueCatIosApiKey = keys['revenuecat_ios'] ?? '';
      _revenueCatAndroidApiKey = keys['revenuecat_android'] ?? '';

      if (!isOpenAiConfigured) {
        debugPrint('Warning: OpenAI API key not configured in Firestore');
      }
      if (!isUsdaConfigured) {
        debugPrint('Warning: USDA API key not configured in Firestore');
      }
      if (!isRevenueCatConfigured && !kIsWeb) {
        debugPrint('Warning: RevenueCat API key not configured in Firestore');
      }
    } catch (e) {
      debugPrint('Error loading API keys from Firestore: $e');
    }
  }

  @visibleForTesting
  static void setOpenAiApiKey(String key) {
    _openAiApiKey = key;
  }

  @visibleForTesting
  static void setUsdaApiKey(String key) {
    _usdaApiKey = key;
  }

  @visibleForTesting
  static void setRevenueCatIosApiKey(String key) {
    _revenueCatIosApiKey = key;
  }

  @visibleForTesting
  static void setRevenueCatAndroidApiKey(String key) {
    _revenueCatAndroidApiKey = key;
  }
}
