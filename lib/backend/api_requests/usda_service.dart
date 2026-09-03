import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'openai_service.dart';
import 'usda_food_matcher.dart';

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

  /// Resolve nutrition for a food using hybrid rule + AI matching.
  static Future<Map<String, dynamic>> resolveNutrition({
    required String foodName,
    String? description,
    String? userInput,
    double? estimatedGrams,
  }) async {
    try {
      print('\n🥗 USDA Service - Resolving nutrition for: $foodName');

      var searchQuery = UsdaFoodMatcher.buildSearchQuery(
        foodName: foodName,
        description: description,
        userInput: userInput,
      );
      print('🔍 USDA search query: $searchQuery');

      var result = await _resolveWithQuery(
        foodName: foodName,
        searchQuery: searchQuery,
        description: description,
        userInput: userInput,
        estimatedGrams: estimatedGrams,
      );

      final caloriesPer100g = (result['calories'] as num?)?.toDouble() ?? 0;
      final sanityPassed = UsdaFoodMatcher.passesCalorieSanity(
        foodName: foodName,
        caloriesPer100g: caloriesPer100g,
        description: description,
        userInput: userInput,
      );

      if (!sanityPassed && !searchQuery.toLowerCase().contains(' raw')) {
        print('⚠️ Calorie sanity check failed ($caloriesPer100g kcal/100g). '
            'Retrying with raw suffix...');
        searchQuery = '${foodName.trim()} raw';
        result = await _resolveWithQuery(
          foodName: foodName,
          searchQuery: searchQuery,
          description: description,
          userInput: userInput,
          estimatedGrams: estimatedGrams,
        );
        result['searchQueryUsed'] = searchQuery;
      }

      return result;
    } catch (e) {
      print('❌ Error in resolveNutrition: $e');
      throw Exception('Failed to resolve nutrition: $e');
    }
  }

  static Future<Map<String, dynamic>> _resolveWithQuery({
    required String foodName,
    required String searchQuery,
    String? description,
    String? userInput,
    double? estimatedGrams,
  }) async {
    print('🔍 Searching USDA database...');
    final searchResults = await searchFood(searchQuery);
    print('📊 Found ${searchResults.length} results');

    if (searchResults.isEmpty) {
      throw Exception('No food found matching: $foodName');
    }

    for (var i = 0; i < searchResults.length && i < 3; i++) {
      print(
          '   ${i + 1}. ${searchResults[i]['description']} (FDC ID: ${searchResults[i]['fdcId']})');
    }

    final ranked = UsdaFoodMatcher.rankCandidates(
      foodName: foodName,
      searchResults: searchResults,
      description: description,
      userInput: userInput,
    );

    int fdcId;
    UsdaCandidate selected;

    if (UsdaFoodMatcher.isClearWinner(ranked)) {
      selected = ranked.first;
      fdcId = selected.fdcId;
      print('✅ Clear rule-based winner: ${selected.description}');
    } else {
      print('🤖 Ambiguous match — asking OpenAI to disambiguate...');
      fdcId = await OpenAIService.pickUsdaCandidate(
        foodName: foodName,
        description: description,
        userInput: userInput,
        estimatedGrams: estimatedGrams,
        candidates: ranked,
      );
      selected = ranked.firstWhere(
        (c) => c.fdcId == fdcId,
        orElse: () => ranked.first,
      );
      print('✅ Selected match: ${selected.description}');
    }

    print('📥 Fetching detailed nutrition data for fdcId $fdcId...');
    final nutritionData = await getFoodDetails(fdcId);

    print('📊 USDA Nutrition Data Retrieved:');
    print('   Calories: ${nutritionData['calories']} kcal');
    print('   Protein: ${nutritionData['protein']}g');
    print('   Carbs: ${nutritionData['carbs']}g');
    print('   Fat: ${nutritionData['fat']}g');

    return {
      ...nutritionData,
      'fdcId': fdcId,
      'usdaDescription': selected.description,
      'usdaDataType': selected.dataType,
      'searchQueryUsed': searchQuery,
    };
  }

  /// Get nutrition data for a food by name (legacy wrapper).
  static Future<Map<String, dynamic>> getNutritionByName(
      String foodName) async {
    return resolveNutrition(foodName: foodName);
  }
}
