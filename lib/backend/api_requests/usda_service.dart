import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

/// Service for interacting with USDA FoodData Central API
/// Fetches detailed nutrition information for foods
class USDAService {
  /// Search for a food in the USDA database
  /// Returns a list of matching foods with their FDC IDs
  static Future<List<Map<String, dynamic>>> searchFood(String foodName) async {
    if (!ApiConfig.isUsdaConfigured) {
      throw Exception('USDA API key not configured');
    }

    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.usdaBaseUrl}/foods/search?query=${Uri.encodeComponent(foodName)}&pageSize=5&api_key=${ApiConfig.usdaApiKey}',
            ),
          )
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foods = data['foods'] as List<dynamic>;

        return foods
            .map((food) => {
                  'fdcId': food['fdcId'],
                  'description': food['description'],
                  'dataType': food['dataType'],
                  'brandName': food['brandName'],
                })
            .toList();
      } else {
        throw Exception(
            'USDA API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to search food: $e');
    }
  }

  /// Get detailed nutrition information for a specific food by FDC ID
  /// Returns comprehensive nutrition data including macros, minerals, vitamins, etc.
  static Future<Map<String, dynamic>> getFoodDetails(int fdcId) async {
    if (!ApiConfig.isUsdaConfigured) {
      throw Exception('USDA API key not configured');
    }

    try {
      final response = await http
          .get(
            Uri.parse(
              '${ApiConfig.usdaBaseUrl}/food/$fdcId?api_key=${ApiConfig.usdaApiKey}',
            ),
          )
          .timeout(ApiConfig.apiTimeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _parseNutritionData(data);
      } else {
        throw Exception(
            'USDA API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to get food details: $e');
    }
  }

  /// Parse USDA nutrition data into our app's format
  static Map<String, dynamic> _parseNutritionData(
      Map<String, dynamic> usdaData) {
    final nutrients = usdaData['foodNutrients'] as List<dynamic>;

    // Helper function to find nutrient value by name or nutrient number
    double getNutrientValue(List<String> nutrientNumbers, String nutrientName) {
      for (var nutrient in nutrients) {
        final number = nutrient['nutrient']?['number']?.toString();
        if (number != null && nutrientNumbers.contains(number)) {
          final amount = (nutrient['amount'] ?? 0.0).toDouble();
          print('   ✓ Found $nutrientName ($number): $amount');
          return amount;
        }
      }
      print('   ✗ NOT FOUND: $nutrientName (${nutrientNumbers.join(", ")})');
      return 0.0;
    }

    // Extract nutrition values (per 100g from USDA)
    print('🔍 Parsing nutrients from USDA data...');
    final calories = getNutrientValue(['208'], 'Calories'); // Energy (kcal)
    final protein = getNutrientValue(['203'], 'Protein'); // Protein
    final carbs = getNutrientValue(['205'], 'Carbohydrate'); // Carbohydrate
    final fat = getNutrientValue(['204'], 'Fat'); // Total lipid (fat)
    final fiber = getNutrientValue(['291'], 'Fiber'); // Fiber
    final sugar = getNutrientValue(['269'], 'Sugar'); // Sugars, total
    final saturatedFat = getNutrientValue(
        ['606'], 'Saturated Fat'); // Fatty acids, total saturated
    final cholesterol = getNutrientValue(['601'], 'Cholesterol'); // Cholesterol
    final sodium = getNutrientValue(['307'], 'Sodium'); // Sodium
    final calcium = getNutrientValue(['301'], 'Calcium'); // Calcium
    final iron = getNutrientValue(['303'], 'Iron'); // Iron
    final potassium = getNutrientValue(['306'], 'Potassium'); // Potassium
    final magnesium = getNutrientValue(['304'], 'Magnesium'); // Magnesium
    final phosphorus = getNutrientValue(['305'], 'Phosphorus'); // Phosphorus
    final zinc = getNutrientValue(['309'], 'Zinc'); // Zinc
    final copper = getNutrientValue(['312'], 'Copper'); // Copper
    final selenium = getNutrientValue(['317'], 'Selenium'); // Selenium

    return {
      'description': usdaData['description'],
      'servingSize': 100.0, // USDA data is per 100g
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'saturatedFat': saturatedFat,
      'cholesterol': cholesterol,
      'sodium': sodium,
      'calcium': calcium,
      'iron': iron,
      'potassium': potassium,
      'magnesium': magnesium,
      'phosphorus': phosphorus,
      'zinc': zinc,
      'copper': copper,
      'selenium': selenium,
    };
  }

  /// Get nutrition data for a food by name
  /// Searches for the food and returns nutrition data for the best match
  static Future<Map<String, dynamic>> getNutritionByName(
      String foodName) async {
    try {
      print('\n🥗 USDA Service - Getting nutrition for: $foodName');

      // Search for the food
      print('🔍 Searching USDA database...');
      final searchResults = await searchFood(foodName);
      print('📊 Found ${searchResults.length} results');

      if (searchResults.isEmpty) {
        print('❌ No food found matching: $foodName');
        throw Exception('No food found matching: $foodName');
      }

      // Log search results
      for (var i = 0; i < searchResults.length && i < 3; i++) {
        print(
            '   ${i + 1}. ${searchResults[i]['description']} (FDC ID: ${searchResults[i]['fdcId']})');
      }

      // Get details for the first (best) match
      final fdcId = searchResults[0]['fdcId'] as int;
      print('✅ Using best match: ${searchResults[0]['description']}');
      print('📥 Fetching detailed nutrition data...');

      final nutritionData = await getFoodDetails(fdcId);

      print('📊 USDA Nutrition Data Retrieved:');
      print('   Calories: ${nutritionData['calories']} kcal');
      print('   Protein: ${nutritionData['protein']}g');
      print('   Carbs: ${nutritionData['carbs']}g');
      print('   Fat: ${nutritionData['fat']}g');
      print('   Fiber: ${nutritionData['fiber']}g');
      print('   Sugar: ${nutritionData['sugar']}g');
      print('   Cholesterol: ${nutritionData['cholesterol']}mg');
      print('   Sodium: ${nutritionData['sodium']}mg');
      print('   Calcium: ${nutritionData['calcium']}mg');
      print('   Iron: ${nutritionData['iron']}mg');

      return nutritionData;
    } catch (e) {
      print('❌ Error in getNutritionByName: $e');
      throw Exception('Failed to get nutrition by name: $e');
    }
  }
}
