import '/backend/firestore/api_keys_service.dart';

/// API Configuration for external services
///
/// API keys are now stored securely in Firestore.
/// Call `loadApiKeys()` before using any API services.

class ApiConfig {
  // Runtime API keys (loaded from Firestore)
  static String _openAiApiKey = '';
  static String _usdaApiKey = '';

  // API Base URLs and Models
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String openAiVisionModel = 'gpt-4o'; // gpt-4o supports vision
  static const String openAiTextModel = 'gpt-4o-mini'; // Faster for text-only
  static const String usdaBaseUrl = 'https://api.nal.usda.gov/fdc/v1';

  // API Request Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);

  // Getters for API keys
  static String get openAiApiKey => _openAiApiKey;
  static String get usdaApiKey => _usdaApiKey;

  // Validation
  static bool get isOpenAiConfigured => _openAiApiKey.isNotEmpty;
  static bool get isUsdaConfigured => _usdaApiKey.isNotEmpty;

  /// Load API keys from Firestore
  /// This should be called during app initialization
  static Future<void> loadApiKeys() async {
    try {
      final apiKeysService = ApiKeysService();
      final keys = await apiKeysService.getAllApiKeys();

      _openAiApiKey = keys['openai'] ?? '';
      _usdaApiKey = keys['usda'] ?? '';

      // ignore: avoid_print
      if (!isOpenAiConfigured) {
        print('Warning: OpenAI API key not configured in Firestore');
      }
      // ignore: avoid_print
      if (!isUsdaConfigured) {
        print('Warning: USDA API key not configured in Firestore');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error loading API keys from Firestore: $e');
      // Keys remain empty, services will throw appropriate errors
    }
  }

  /// Manually set API keys (for testing or fallback)
  static void setOpenAiApiKey(String key) {
    _openAiApiKey = key;
  }

  static void setUsdaApiKey(String key) {
    _usdaApiKey = key;
  }
}
