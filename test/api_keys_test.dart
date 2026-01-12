import 'package:flutter_test/flutter_test.dart';
import 'package:eat_wise/backend/api_requests/api_config.dart';
import 'package:eat_wise/backend/firestore/api_keys_service.dart';

/// Test suite for API keys functionality
/// 
/// Note: These tests require Firebase to be initialized and
/// API keys to be present in Firestore.
void main() {
  group('ApiConfig Tests', () {
    test('API keys should have getters', () {
      // Test that getters exist and return strings
      expect(ApiConfig.openAiApiKey, isA<String>());
      expect(ApiConfig.usdaApiKey, isA<String>());
    });

    test('API configuration validation should work', () {
      // Test validation methods exist
      expect(ApiConfig.isOpenAiConfigured, isA<bool>());
      expect(ApiConfig.isUsdaConfigured, isA<bool>());
    });

    test('Manual key setting should work', () {
      // Test manual setters
      const testKey = 'test-key-123';
      
      ApiConfig.setOpenAiApiKey(testKey);
      expect(ApiConfig.openAiApiKey, equals(testKey));
      expect(ApiConfig.isOpenAiConfigured, isTrue);
      
      ApiConfig.setUsdaApiKey(testKey);
      expect(ApiConfig.usdaApiKey, equals(testKey));
      expect(ApiConfig.isUsdaConfigured, isTrue);
    });

    test('Empty keys should not be configured', () {
      ApiConfig.setOpenAiApiKey('');
      expect(ApiConfig.isOpenAiConfigured, isFalse);
      
      ApiConfig.setUsdaApiKey('');
      expect(ApiConfig.isUsdaConfigured, isFalse);
    });
  });

  group('ApiKeysService Tests', () {
    test('Service should be instantiable', () {
      final service = ApiKeysService();
      expect(service, isNotNull);
    });

    // Note: The following tests require Firebase to be initialized
    // and will only work in integration tests, not unit tests
    
    // test('Should load OpenAI key from Firestore', () async {
    //   final service = ApiKeysService();
    //   final key = await service.getOpenAiApiKey();
    //   expect(key, isNotEmpty);
    // });

    // test('Should load USDA key from Firestore', () async {
    //   final service = ApiKeysService();
    //   final key = await service.getUsdaApiKey();
    //   expect(key, isA<String>());
    // });

    // test('Should load all keys from Firestore', () async {
    //   final service = ApiKeysService();
    //   final keys = await service.getAllApiKeys();
    //   expect(keys, isA<Map<String, String>>());
    //   expect(keys.containsKey('openai'), isTrue);
    //   expect(keys.containsKey('usda'), isTrue);
    // });
  });
}

