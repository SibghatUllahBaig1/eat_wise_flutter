import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'usda_food_matcher.dart';

/// Service for interacting with OpenAI API
/// Supports both Vision API (for images) and GPT API (for text)
class OpenAIService {
  /// Analyze food from an image using OpenAI Vision API
  ///
  /// Returns a JSON object with food identification and estimated nutrition
  /// Example return:
  /// {
  ///   "foodName": "Grilled Chicken Breast",
  ///   "description": "A grilled chicken breast with visible grill marks",
  ///   "estimatedGrams": 150,
  ///   "confidence": 0.85
  /// }
  static Future<Map<String, dynamic>> analyzeFoodImage(String imagePath) async {
    print('\n🔑 OpenAI Vision API - Starting...');

    if (!ApiConfig.isOpenAiConfigured) {
      print('❌ OpenAI API key not configured!');
      throw Exception('OpenAI API key not configured');
    }

    print(
        '✅ API Key configured: ${ApiConfig.openAiApiKey.substring(0, 20)}...');

    try {
      // Read image file and convert to base64
      print('📸 Reading image file: $imagePath');
      final imageFile = File(imagePath);
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      print('✅ Image encoded to base64 (${imageBytes.length} bytes)');

      // Determine image MIME type
      String mimeType = 'image/jpeg';
      if (imagePath.toLowerCase().endsWith('.png')) {
        mimeType = 'image/png';
      } else if (imagePath.toLowerCase().endsWith('.webp')) {
        mimeType = 'image/webp';
      }
      print('📝 MIME type: $mimeType');

      // Prepare the request
      final requestBody = {
        'model': ApiConfig.openAiVisionModel,
        'messages': [
          {
            'role': 'system',
            'content':
                'You are a nutrition expert. Analyze food images and identify the food items with estimated portion sizes in grams. Return ONLY valid JSON with no markdown formatting.',
          },
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text':
                    'Identify the food in this image and estimate the portion size in grams. Return a JSON object with: foodName (string), description (string), estimatedGrams (number), confidence (number 0-1). Return ONLY the JSON object, no markdown or code blocks.',
              },
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:$mimeType;base64,$base64Image',
                },
              },
            ],
          },
        ],
        'max_tokens': 500,
        'temperature': 0.3,
      };

      print('📤 Sending request to OpenAI Vision API...');
      print('   URL: ${ApiConfig.openAiBaseUrl}/chat/completions');
      print('   Model: ${ApiConfig.openAiVisionModel}');

      final response = await http
          .post(
            Uri.parse('${ApiConfig.openAiBaseUrl}/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${ApiConfig.openAiApiKey}',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(ApiConfig.apiTimeout);

      print('📥 Response received: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Success! Parsing response...');
        final data = jsonDecode(response.body);
        print('📊 Full API Response:');
        print(jsonEncode(data));

        final content = data['choices'][0]['message']['content'] as String;
        print('📝 AI Response Content:');
        print(content);

        // Parse the JSON response from the content
        // Remove any markdown code blocks if present
        String cleanContent = content.trim();
        if (cleanContent.startsWith('```json')) {
          cleanContent = cleanContent.substring(7);
        }
        if (cleanContent.startsWith('```')) {
          cleanContent = cleanContent.substring(3);
        }
        if (cleanContent.endsWith('```')) {
          cleanContent = cleanContent.substring(0, cleanContent.length - 3);
        }
        cleanContent = cleanContent.trim();

        print('🧹 Cleaned content:');
        print(cleanContent);

        final result = jsonDecode(cleanContent) as Map<String, dynamic>;
        print('✅ Parsed result:');
        print(jsonEncode(result));

        return result;
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception(
            'OpenAI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Exception in analyzeFoodImage: $e');
      throw Exception('Failed to analyze food image: $e');
    }
  }

  /// Analyze food from a text description using OpenAI GPT API
  ///
  /// Returns a JSON object with food identification and estimated nutrition
  /// Example return:
  /// {
  ///   "foodName": "Grilled Chicken Breast",
  ///   "description": "Grilled chicken breast, skinless",
  ///   "estimatedGrams": 150,
  ///   "confidence": 0.9
  /// }
  static Future<Map<String, dynamic>> analyzeFoodText(
    String foodDescription, {
    double? explicitGrams,
  }) async {
    if (!ApiConfig.isOpenAiConfigured) {
      throw Exception('OpenAI API key not configured');
    }

    final gramsHint = explicitGrams != null
        ? ' The user explicitly stated a portion of ${explicitGrams.round()}g — use that exact value for estimatedGrams unless it is clearly wrong for the food described.'
        : '';

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.openAiBaseUrl}/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${ApiConfig.openAiApiKey}',
            },
            body: jsonEncode({
              'model': ApiConfig.openAiTextModel,
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'You are a nutrition expert. Analyze food descriptions and identify the food items with estimated portion sizes in grams. If the user states an explicit weight (e.g. "50g banana"), honor that portion. Return ONLY valid JSON with no markdown formatting.',
                },
                {
                  'role': 'user',
                  'content':
                      'Identify the food from this description: "$foodDescription".$gramsHint Return a JSON object with: foodName (string), description (string), estimatedGrams (number), confidence (number 0-1). Return ONLY the JSON object, no markdown or code blocks.',
                },
              ],
              'max_tokens': 300,
              'temperature': 0.3,
            }),
          )
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return _parseJsonContent(content);
      } else {
        throw Exception(
            'OpenAI API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to analyze food text: $e');
    }
  }

  /// Picks the best USDA candidate when rule-based ranking is ambiguous.
  static Future<int> pickUsdaCandidate({
    required String foodName,
    String? description,
    String? userInput,
    double? estimatedGrams,
    required List<UsdaCandidate> candidates,
  }) async {
    if (candidates.isEmpty) {
      throw Exception('No USDA candidates to pick from');
    }

    if (!ApiConfig.isOpenAiConfigured) {
      return candidates.first.fdcId;
    }

    final payload = {
      'foodName': foodName,
      'description': description,
      'userInput': userInput,
      'estimatedGrams': estimatedGrams,
      'candidates': candidates.map((c) => c.toMap()).toList(),
    };

    try {
      final response = await http
          .post(
            Uri.parse('${ApiConfig.openAiBaseUrl}/chat/completions'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${ApiConfig.openAiApiKey}',
            },
            body: jsonEncode({
              'model': ApiConfig.openAiTextModel,
              'messages': [
                {
                  'role': 'system',
                  'content':
                      'You are a nutrition database expert. Pick the USDA FoodData Central entry that best matches what the user actually ate. Prefer raw/fresh whole foods unless the user clearly ate a branded or prepared item. Return ONLY valid JSON.',
                },
                {
                  'role': 'user',
                  'content':
                      'Pick the best USDA match from the candidates below. Return JSON: {"selectedFdcId": number, "reason": string}. You must pick one of the provided fdcId values.\n\n${jsonEncode(payload)}',
                },
              ],
              'max_tokens': 200,
              'temperature': 0.1,
            }),
          )
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        final parsed = _parseJsonContent(content);
        final selectedId = parsed['selectedFdcId'];
        if (selectedId is num) {
          final fdcId = selectedId.toInt();
          final valid = candidates.any((c) => c.fdcId == fdcId);
          if (valid) {
            print('✅ OpenAI picked USDA fdcId: $fdcId (${parsed['reason']})');
            return fdcId;
          }
        }
      }
    } catch (e) {
      print('⚠️ OpenAI USDA disambiguation failed, using top rule match: $e');
    }

    return candidates.first.fdcId;
  }

  static Map<String, dynamic> _parseJsonContent(String content) {
    String cleanContent = content.trim();
    if (cleanContent.startsWith('```json')) {
      cleanContent = cleanContent.substring(7);
    }
    if (cleanContent.startsWith('```')) {
      cleanContent = cleanContent.substring(3);
    }
    if (cleanContent.endsWith('```')) {
      cleanContent = cleanContent.substring(0, cleanContent.length - 3);
    }
    cleanContent = cleanContent.trim();
    return jsonDecode(cleanContent) as Map<String, dynamic>;
  }
}
