import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'openai_service.dart';
import 'usda_food_matcher.dart';
import 'usda_search_option.dart';

/// Service for interacting with USDA FoodData Central API
/// Fetches detailed nutrition information for foods
class USDAService {
  /// Search for a food in the USDA database
  /// Returns a list of matching foods with their FDC IDs
  static const defaultSearchPageSize = 5;

  static Future<List<Map<String, dynamic>>> searchFood(
    String foodName, {
    List<String>? dataTypes,
    int pageSize = defaultSearchPageSize,
  }) async {
    if (!ApiConfig.isUsdaConfigured) {
      throw Exception('USDA API key not configured');
    }

    try {
      if (dataTypes != null && dataTypes.isNotEmpty) {
        return await _searchFoodPost(
          foodName,
          dataTypes,
          pageSize: pageSize,
        );
      }
      return await _searchFoodGet(foodName, pageSize: pageSize);
    } catch (e) {
      if (dataTypes != null && dataTypes.isNotEmpty) {
        print('⚠️ Filtered USDA search failed ($e). Retrying without dataType filter...');
        try {
          return await _searchFoodGet(foodName, pageSize: pageSize);
        } catch (fallbackError) {
          throw Exception('Failed to search food: $fallbackError');
        }
      }
      throw Exception('Failed to search food: $e');
    }
  }

  /// Maps raw USDA search hits to typed options for the text picker UI.
  static List<UsdaSearchOption> mapSearchResults(
    List<Map<String, dynamic>> raw,
  ) {
    return raw.map(UsdaSearchOption.fromMap).toList();
  }

  /// Searches USDA and splits results into reference vs general buckets.
  static Future<UsdaPickerSearchBuckets> searchFoodForPicker(
    String query, {
    int pageSize = 25,
  }) async {
    final searchQuery = UsdaFoodMatcher.buildSearchQuery(
      foodName: query,
      userInput: query,
    );

    var reference = <Map<String, dynamic>>[];
    try {
      reference = await searchFood(
        searchQuery,
        dataTypes: UsdaFoodMatcher.preferredSearchDataTypes,
        pageSize: 15,
      );
    } catch (e) {
      print('⚠️ Preferred-type picker search failed: $e');
    }

    final generalRaw = await searchFood(searchQuery, pageSize: pageSize);
    final referenceIds = reference.map((r) => r['fdcId'] as int).toSet();
    final general = generalRaw
        .where((item) => !referenceIds.contains(item['fdcId'] as int))
        .toList();

    reference = UsdaFoodMatcher.filterRelevantResults(query, reference);
    final filteredGeneral = UsdaFoodMatcher.filterRelevantResults(query, general);

    return UsdaPickerSearchBuckets(
      reference: reference,
      general: filteredGeneral,
    );
  }

  static List<UsdaSearchOption> _candidatesToOptions(List<UsdaCandidate> ranked) {
    return ranked
        .map(
          (candidate) => UsdaSearchOption(
            fdcId: candidate.fdcId,
            description: candidate.description,
            dataType: candidate.dataType,
            brandName: candidate.brandName,
          ),
        )
        .toList();
  }

  static List<UsdaSearchOption> _moveSelectedFirst(
    List<UsdaSearchOption> options,
    int selectedFdcId,
  ) {
    if (options.isEmpty) return options;
    final index = options.indexWhere((o) => o.fdcId == selectedFdcId);
    if (index <= 0) return options;
    final selected = options.removeAt(index);
    return [selected, ...options];
  }

  static List<UsdaCandidate> _relevantRanked(
    String foodName,
    List<UsdaCandidate> ranked,
  ) {
    final relevant = ranked
        .where(
          (c) => UsdaFoodMatcher.isRelevantPrimaryFood(
            foodName,
            c.description,
          ),
        )
        .toList();
    return relevant.isNotEmpty ? relevant : ranked;
  }

  /// Picks the best USDA candidate using rules + OpenAI disambiguation.
  static Future<int> pickBestCandidate({
    required String foodName,
    required List<UsdaCandidate> rankedReference,
    required List<UsdaCandidate> rankedGeneral,
    String? userInput,
    double? estimatedGrams,
  }) async {
    final filteredReference = _relevantRanked(foodName, rankedReference);
    final filteredGeneral = _relevantRanked(foodName, rankedGeneral);
    final ranked =
        filteredReference.isNotEmpty ? filteredReference : filteredGeneral;
    if (ranked.isEmpty) {
      throw Exception('No USDA candidates to pick from');
    }
    if (ranked.length == 1) {
      return ranked.first.fdcId;
    }

    final top = ranked.first;
    final useClearWinner = UsdaFoodMatcher.isClearWinner(ranked) &&
        UsdaFoodMatcher.isRelevantPrimaryFood(foodName, top.description);

    if (useClearWinner) {
      print('✅ Clear rule-based winner for picker: ${top.description}');
      return top.fdcId;
    }

    print('🤖 Asking OpenAI to pick best USDA match for picker...');
    return OpenAIService.pickUsdaCandidate(
      foodName: foodName,
      searchKeyword: foodName,
      userInput: userInput,
      estimatedGrams: estimatedGrams,
      candidates: ranked.take(5).toList(),
      preferReference: filteredReference.isNotEmpty,
    );
  }

  /// Search, rank, AI-pick, and order options for the text food picker.
  static Future<UsdaTextPickerResult> prepareTextPickerResults({
    required String query,
    int pageSize = 25,
    double? estimatedGrams,
  }) async {
    final buckets = await searchFoodForPicker(query, pageSize: pageSize);

    final rankedReference = UsdaFoodMatcher.rankCandidates(
      foodName: query,
      searchResults: buckets.reference,
      userInput: query,
    );
    final rankedGeneral = UsdaFoodMatcher.rankCandidates(
      foodName: query,
      searchResults: buckets.general,
      userInput: query,
    );

    if (rankedReference.isEmpty && rankedGeneral.isEmpty) {
      return const UsdaTextPickerResult();
    }

    final selectedFdcId = await pickBestCandidate(
      foodName: query,
      rankedReference: rankedReference,
      rankedGeneral: rankedGeneral,
      userInput: query,
      estimatedGrams: estimatedGrams,
    );

    var referenceOptions = _moveSelectedFirst(
      _candidatesToOptions(rankedReference),
      selectedFdcId,
    );
    var generalOptions = _moveSelectedFirst(
      _candidatesToOptions(rankedGeneral),
      selectedFdcId,
    );

    final selectedInReference =
        referenceOptions.any((o) => o.fdcId == selectedFdcId);
    if (selectedInReference) {
      generalOptions = _candidatesToOptions(rankedGeneral);
    } else {
      referenceOptions = _candidatesToOptions(rankedReference);
    }

    return UsdaTextPickerResult(
      referenceOptions: referenceOptions,
      generalOptions: generalOptions,
      selectedFdcId: selectedFdcId,
    );
  }

  static Future<List<Map<String, dynamic>>> _searchFoodGet(
    String foodName, {
    int pageSize = defaultSearchPageSize,
  }) async {
    final uri = Uri.parse('${ApiConfig.usdaBaseUrl}/foods/search').replace(
      queryParameters: {
        'query': foodName,
        'pageSize': pageSize.toString(),
        'api_key': ApiConfig.usdaApiKey,
      },
    );

    final response =
        await http.get(uri).timeout(ApiConfig.apiTimeout);
    return _parseSearchResponse(response);
  }

  /// POST avoids malformed GET query strings for dataType values like "Survey (FNDDS)".
  static Future<List<Map<String, dynamic>>> _searchFoodPost(
    String foodName,
    List<String> dataTypes, {
    int pageSize = defaultSearchPageSize,
  }) async {
    final uri = Uri.parse('${ApiConfig.usdaBaseUrl}/foods/search').replace(
      queryParameters: {'api_key': ApiConfig.usdaApiKey},
    );

    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'query': foodName,
            'pageSize': pageSize,
            'dataType': dataTypes,
          }),
        )
        .timeout(ApiConfig.apiTimeout);

    return _parseSearchResponse(response);
  }

  static List<Map<String, dynamic>> _parseSearchResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception(
          'USDA API error: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body);
    final foods = data['foods'] as List<dynamic>? ?? [];

    return foods
        .map((food) => {
              'fdcId': food['fdcId'],
              'description': food['description'],
              'dataType': food['dataType'],
              'brandName': food['brandName'],
            })
        .toList();
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

  /// Exposed for unit tests.
  @visibleForTesting
  static Map<String, dynamic> parseNutritionDataForTest(
      Map<String, dynamic> usdaData) {
    return _parseNutritionData(usdaData);
  }

  /// Parse USDA nutrition data into our app's format (normalized per 100g).
  static Map<String, dynamic> _parseNutritionData(
      Map<String, dynamic> usdaData) {
    final nutrients = usdaData['foodNutrients'];
    final labelNutrients = usdaData['labelNutrients'] as Map<String, dynamic>?;

    double getNutrientValue(
      List<String> nutrientNumbers,
      List<int> nutrientIds,
      String nutrientName, {
      String? labelKey,
    }) {
      if (nutrients is List) {
        for (final nutrient in nutrients) {
          if (nutrient is! Map) continue;
          final map = nutrient.cast<String, dynamic>();

          final number = map['nutrient']?['number']?.toString() ??
              map['nutrientNumber']?.toString();
          if (number != null && nutrientNumbers.contains(number)) {
            final amount = _readNutrientAmount(map);
            if (amount > 0) {
              print('   ✓ Found $nutrientName ($number): $amount');
              return amount;
            }
          }

          final id = map['nutrientId'] as int?;
          if (id != null && nutrientIds.contains(id)) {
            final amount = _readNutrientAmount(map);
            if (amount > 0) {
              print('   ✓ Found $nutrientName (id $id): $amount');
              return amount;
            }
          }
        }
      }

      if (labelKey != null && labelNutrients != null) {
        final fromLabel = _readLabelNutrient(labelNutrients, labelKey);
        if (fromLabel > 0) {
          final per100g = _scaleLabelToPer100g(fromLabel, usdaData);
          print('   ✓ Found $nutrientName from labelNutrients: $per100g/100g');
          return per100g;
        }
      }

      print('   ✗ NOT FOUND: $nutrientName (${nutrientNumbers.join(", ")})');
      return 0.0;
    }

    print('🔍 Parsing nutrients from USDA data...');
    final calories = getNutrientValue(
      ['208', '957', '958'],
      [1008, 2047, 2048],
      'Calories',
      labelKey: 'calories',
    );
    final protein = getNutrientValue(['203'], [1003], 'Protein', labelKey: 'protein');
    final carbs = getNutrientValue(['205'], [1005], 'Carbohydrate',
        labelKey: 'carbohydrates');
    final fat = getNutrientValue(['204'], [1004], 'Fat', labelKey: 'fat');
    final fiber = getNutrientValue(['291'], [1079], 'Fiber', labelKey: 'fiber');
    final sugar = getNutrientValue(['269'], [2000], 'Sugar', labelKey: 'sugars');
    final saturatedFat = getNutrientValue(['606'], [1258], 'Saturated Fat',
        labelKey: 'saturatedFat');
    final cholesterol =
        getNutrientValue(['601'], [1253], 'Cholesterol', labelKey: 'cholesterol');
    final sodium = getNutrientValue(['307'], [1093], 'Sodium', labelKey: 'sodium');
    final calcium = getNutrientValue(['301'], [1087], 'Calcium', labelKey: 'calcium');
    final iron = getNutrientValue(['303'], [1089], 'Iron', labelKey: 'iron');
    final potassium =
        getNutrientValue(['306'], [1092], 'Potassium', labelKey: 'potassium');
    final magnesium =
        getNutrientValue(['304'], [1090], 'Magnesium', labelKey: 'magnesium');
    final phosphorus =
        getNutrientValue(['305'], [1091], 'Phosphorus', labelKey: 'phosphorus');
    final zinc = getNutrientValue(['309'], [1095], 'Zinc', labelKey: 'zinc');
    final copper = getNutrientValue(['312'], [1098], 'Copper', labelKey: 'copper');
    final selenium =
        getNutrientValue(['317'], [1103], 'Selenium', labelKey: 'selenium');

    return {
      'description': usdaData['description'],
      'servingSize': 100.0,
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

  static double _readNutrientAmount(Map<String, dynamic> nutrient) {
    final amount = nutrient['amount'] ?? nutrient['value'];
    if (amount is num) return amount.toDouble();
    return 0.0;
  }

  static double _readLabelNutrient(
    Map<String, dynamic> labelNutrients,
    String key,
  ) {
    final entry = labelNutrients[key];
    if (entry is Map) {
      final value = entry['value'];
      if (value is num) return value.toDouble();
    }
    return 0.0;
  }

  static double _scaleLabelToPer100g(
    double perServing,
    Map<String, dynamic> usdaData,
  ) {
    final servingSize = (usdaData['servingSize'] as num?)?.toDouble();
    final unit = (usdaData['servingSizeUnit'] as String?)?.toLowerCase() ?? 'g';
    if (servingSize == null || servingSize <= 0) return perServing;
    if (unit == 'g' || unit == 'ml') {
      return perServing / servingSize * 100.0;
    }
    return perServing;
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
        preferredDataTypes: UsdaFoodMatcher.preferredSearchDataTypes,
        allowCandidateFallback: true,
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

      if (!UsdaFoodMatcher.hasValidNutrition(result)) {
        print('⚠️ Selected USDA entry has no usable nutrition. '
            'Retrying with Foundation/SR Legacy search...');
        final stapleQuery = UsdaFoodMatcher.buildSearchQuery(
          foodName: foodName,
          description: description,
          userInput: userInput,
        );
        result = await _resolveWithQuery(
          foodName: foodName,
          searchQuery: stapleQuery,
          description: description,
          userInput: userInput,
          estimatedGrams: estimatedGrams,
          preferredDataTypes: UsdaFoodMatcher.preferredSearchDataTypes,
          allowCandidateFallback: true,
        );
        result['searchQueryUsed'] = stapleQuery;
      }

      if (!UsdaFoodMatcher.hasValidNutrition(result)) {
        throw Exception(
          'No nutrition data found for: $foodName. Try a more specific description.',
        );
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
    List<String>? preferredDataTypes,
    bool allowCandidateFallback = false,
  }) async {
    print('🔍 Searching USDA database...');
    var searchResults = preferredDataTypes != null
        ? await searchFood(searchQuery, dataTypes: preferredDataTypes)
        : await searchFood(searchQuery);

    if (searchResults.isEmpty && preferredDataTypes != null) {
      print('📊 No Foundation/SR Legacy hits — searching all data types...');
      searchResults = await searchFood(searchQuery);
    }

    print('📊 Found ${searchResults.length} results');

    if (searchResults.isEmpty) {
      throw Exception('No food found matching: $foodName');
    }

    for (var i = 0; i < searchResults.length && i < 3; i++) {
      print(
          '   ${i + 1}. ${searchResults[i]['description']} (${searchResults[i]['dataType']}, FDC ID: ${searchResults[i]['fdcId']})');
    }

    final ranked = UsdaFoodMatcher.rankCandidates(
      foodName: foodName,
      searchResults: searchResults,
      description: description,
      userInput: userInput,
    );

    final candidatesToTry = <UsdaCandidate>[];
    if (UsdaFoodMatcher.isClearWinner(ranked)) {
      candidatesToTry.add(ranked.first);
      if (allowCandidateFallback) {
        for (final candidate in ranked.skip(1)) {
          candidatesToTry.add(candidate);
        }
      }
    } else {
      print('🤖 Ambiguous match — asking OpenAI to disambiguate...');
      final fdcId = await OpenAIService.pickUsdaCandidate(
        foodName: foodName,
        searchKeyword: userInput ?? foodName,
        description: description,
        userInput: userInput,
        estimatedGrams: estimatedGrams,
        candidates: ranked.take(5).toList(),
      );
      final aiSelected = ranked.firstWhere(
        (c) => c.fdcId == fdcId,
        orElse: () => ranked.first,
      );
      candidatesToTry.add(aiSelected);
      if (allowCandidateFallback) {
        for (final candidate in ranked) {
          if (candidate.fdcId != aiSelected.fdcId) {
            candidatesToTry.add(candidate);
          }
        }
      }
    }

    if (allowCandidateFallback && candidatesToTry.length == 1) {
      candidatesToTry.addAll(ranked.skip(1));
    }

    for (final selected in candidatesToTry) {
      print('📥 Fetching detailed nutrition data for fdcId ${selected.fdcId}...');
      final nutritionData = await getFoodDetails(selected.fdcId);

      print('📊 USDA Nutrition Data Retrieved:');
      print('   Calories: ${nutritionData['calories']} kcal');
      print('   Protein: ${nutritionData['protein']}g');
      print('   Carbs: ${nutritionData['carbs']}g');
      print('   Fat: ${nutritionData['fat']}g');

      final result = {
        ...nutritionData,
        'fdcId': selected.fdcId,
        'usdaDescription': selected.description,
        'usdaDataType': selected.dataType,
        'searchQueryUsed': searchQuery,
      };

      if (UsdaFoodMatcher.hasValidNutrition(result)) {
        print('✅ Selected match: ${selected.description}');
        return result;
      }

      print('⚠️ ${selected.description} has no usable nutrition, trying next...');
    }

    final fallback = candidatesToTry.isNotEmpty ? candidatesToTry.first : ranked.first;
    final nutritionData = await getFoodDetails(fallback.fdcId);
    return {
      ...nutritionData,
      'fdcId': fallback.fdcId,
      'usdaDescription': fallback.description,
      'usdaDataType': fallback.dataType,
      'searchQueryUsed': searchQuery,
    };
  }

  /// Get nutrition data for a food by name (legacy wrapper).
  static Future<Map<String, dynamic>> getNutritionByName(
      String foodName) async {
    return resolveNutrition(foodName: foodName);
  }
}
