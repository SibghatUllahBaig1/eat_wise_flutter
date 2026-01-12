import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing API keys stored in Firestore
/// 
/// API keys are stored in a secure collection and should only be accessible
/// by authenticated users or admin functions
class ApiKeysService extends FirestoreService {
  /// Collection reference for API keys
  CollectionReference get apiKeysCollection =>
      firestore.collection('api_keys');

  /// Get OpenAI API key from Firestore
  Future<String?> getOpenAiApiKey() async {
    try {
      final doc = await apiKeysCollection.doc('openai').get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>?;
      return data?['apiKey'] as String?;
    } catch (e) {
      throw Exception('Failed to get OpenAI API key: ${handleFirestoreError(e)}');
    }
  }

  /// Get USDA API key from Firestore
  Future<String?> getUsdaApiKey() async {
    try {
      final doc = await apiKeysCollection.doc('usda').get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>?;
      return data?['apiKey'] as String?;
    } catch (e) {
      throw Exception('Failed to get USDA API key: ${handleFirestoreError(e)}');
    }
  }

  /// Get all API keys at once
  Future<Map<String, String>> getAllApiKeys() async {
    try {
      final openAiKey = await getOpenAiApiKey();
      final usdaKey = await getUsdaApiKey();
      
      return {
        'openai': openAiKey ?? '',
        'usda': usdaKey ?? '',
      };
    } catch (e) {
      throw Exception('Failed to get API keys: ${handleFirestoreError(e)}');
    }
  }

  /// Store OpenAI API key (admin only - should be called from Cloud Functions or admin SDK)
  Future<void> setOpenAiApiKey(String apiKey) async {
    try {
      await apiKeysCollection.doc('openai').set({
        'apiKey': apiKey,
        'service': 'OpenAI',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to set OpenAI API key: ${handleFirestoreError(e)}');
    }
  }

  /// Store USDA API key (admin only - should be called from Cloud Functions or admin SDK)
  Future<void> setUsdaApiKey(String apiKey) async {
    try {
      await apiKeysCollection.doc('usda').set({
        'apiKey': apiKey,
        'service': 'USDA FoodData Central',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to set USDA API key: ${handleFirestoreError(e)}');
    }
  }

  /// Initialize API keys in Firestore (call this once during setup)
  /// This should be called from a secure environment (Cloud Functions or admin SDK)
  Future<void> initializeApiKeys({
    required String openAiKey,
    required String usdaKey,
  }) async {
    try {
      await setOpenAiApiKey(openAiKey);
      await setUsdaApiKey(usdaKey);
    } catch (e) {
      throw Exception('Failed to initialize API keys: ${handleFirestoreError(e)}');
    }
  }
}

