import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '/backend/schema/structs/index.dart';
import 'openai_service.dart';
import 'usda_service.dart';

/// Main service for analyzing food and getting complete nutrition data
/// Orchestrates OpenAI (for food identification) and USDA (for nutrition data)
class FoodAnalysisService {
  /// Analyze food from an image
  ///
  /// Steps:
  /// 1. Upload image to Firebase Storage
  /// 2. Use OpenAI Vision to identify the food
  /// 3. Fetch nutrition data from USDA
  /// 4. Calculate nutrition based on estimated grams
  /// 5. Return FoodNutritionStruct
  static Future<FoodNutritionStruct> analyzeFromImage(String imagePath) async {
    try {
      print('\n🔍 ===== FOOD ANALYSIS FROM IMAGE =====');
      print('📸 Image path: $imagePath');

      // Step 1: Upload image to Firebase Storage
      print('\n📤 Step 1: Uploading image to Firebase Storage...');
      final imageUrl = await _uploadImage(imagePath);
      print('✅ Image uploaded: $imageUrl');

      // Step 2: Use OpenAI Vision to identify the food
      print('\n🤖 Step 2: Analyzing image with OpenAI Vision...');
      final aiResult = await OpenAIService.analyzeFoodImage(imagePath);
      print('📊 OpenAI Result:');
      print('   - Food Name: ${aiResult['foodName']}');
      print('   - Estimated Grams: ${aiResult['estimatedGrams']}');
      print('   - Confidence: ${aiResult['confidence']}');

      final foodName = aiResult['foodName'] as String;
      final estimatedGrams = (aiResult['estimatedGrams'] as num).toDouble();
      final confidence = (aiResult['confidence'] as num).toDouble();

      // Step 3: Fetch nutrition data from USDA (per 100g)
      print('\n🥗 Step 3: Fetching nutrition data from USDA...');
      print('   Searching for: $foodName');
      final usdaData = await USDAService.getNutritionByName(foodName);
      print('📊 USDA Data (per 100g):');
      print('   - Calories: ${usdaData['calories']}');
      print('   - Carbs: ${usdaData['carbs']}g');
      print('   - Protein: ${usdaData['protein']}g');
      print('   - Fat: ${usdaData['fat']}g');
      print('   - Cholesterol: ${usdaData['cholesterol']}mg');
      print('   - Sodium: ${usdaData['sodium']}mg');

      // Step 4: Calculate nutrition based on estimated grams
      print('\n🧮 Step 4: Calculating nutrition for ${estimatedGrams}g...');
      final nutritionData = _calculateNutrition(usdaData, estimatedGrams);
      print('📊 Calculated Nutrition:');
      print('   - Calories: ${nutritionData['calories']}');
      print(
          '   - Carbs: ${(nutritionData['macros'] as MacrosStruct).carbs.grams}g (${(nutritionData['macros'] as MacrosStruct).carbs.percentage}%)');
      print(
          '   - Protein: ${(nutritionData['macros'] as MacrosStruct).protein.grams}g (${(nutritionData['macros'] as MacrosStruct).protein.percentage}%)');
      print(
          '   - Fat: ${(nutritionData['macros'] as MacrosStruct).fat.grams}g (${(nutritionData['macros'] as MacrosStruct).fat.percentage}%)');

      // Step 5: Create and return FoodNutritionStruct
      print('\n✅ Step 5: Creating FoodNutritionStruct...');
      final result = FoodNutritionStruct(
        foodName: foodName,
        grams: estimatedGrams,
        calories: nutritionData['calories'],
        macros: nutritionData['macros'],
        cholesterol: nutritionData['cholesterol'],
        sodium: nutritionData['sodium'],
        minerals: nutritionData['minerals'],
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
        confidence: confidence,
      );

      print('🎉 Analysis complete!');
      print('===== END FOOD ANALYSIS =====\n');

      return result;
    } catch (e) {
      print('❌ ERROR in analyzeFromImage: $e');
      print('Stack trace: ${StackTrace.current}');
      throw Exception('Failed to analyze food from image: $e');
    }
  }

  /// Analyze food from a text description
  ///
  /// Steps:
  /// 1. Use OpenAI GPT to identify the food
  /// 2. Fetch nutrition data from USDA
  /// 3. Calculate nutrition based on estimated grams
  /// 4. Return FoodNutritionStruct
  static Future<FoodNutritionStruct> analyzeFromText(
      String foodDescription) async {
    try {
      print('\n🔍 ===== FOOD ANALYSIS FROM TEXT =====');
      print('📝 Description: $foodDescription');

      // Step 1: Use OpenAI GPT to identify the food
      print('\n🤖 Step 1: Analyzing text with OpenAI GPT...');
      final aiResult = await OpenAIService.analyzeFoodText(foodDescription);
      print('📊 OpenAI Result:');
      print('   - Food Name: ${aiResult['foodName']}');
      print('   - Estimated Grams: ${aiResult['estimatedGrams']}');
      print('   - Confidence: ${aiResult['confidence']}');

      final foodName = aiResult['foodName'] as String;
      final estimatedGrams = (aiResult['estimatedGrams'] as num).toDouble();
      final confidence = (aiResult['confidence'] as num).toDouble();

      // Step 2: Fetch nutrition data from USDA (per 100g)
      print('\n🥗 Step 2: Fetching nutrition data from USDA...');
      print('   Searching for: $foodName');
      final usdaData = await USDAService.getNutritionByName(foodName);
      print('📊 USDA Data (per 100g):');
      print('   - Calories: ${usdaData['calories']}');
      print('   - Carbs: ${usdaData['carbs']}g');
      print('   - Protein: ${usdaData['protein']}g');
      print('   - Fat: ${usdaData['fat']}g');

      // Step 3: Calculate nutrition based on estimated grams
      print('\n🧮 Step 3: Calculating nutrition for ${estimatedGrams}g...');
      final nutritionData = _calculateNutrition(usdaData, estimatedGrams);
      print('📊 Calculated Nutrition:');
      print('   - Calories: ${nutritionData['calories']}');
      print(
          '   - Carbs: ${(nutritionData['macros'] as MacrosStruct).carbs.grams}g');
      print(
          '   - Protein: ${(nutritionData['macros'] as MacrosStruct).protein.grams}g');
      print(
          '   - Fat: ${(nutritionData['macros'] as MacrosStruct).fat.grams}g');

      // Step 4: Create and return FoodNutritionStruct
      print('\n✅ Step 4: Creating FoodNutritionStruct...');
      final result = FoodNutritionStruct(
        foodName: foodName,
        grams: estimatedGrams,
        calories: nutritionData['calories'],
        macros: nutritionData['macros'],
        cholesterol: nutritionData['cholesterol'],
        sodium: nutritionData['sodium'],
        minerals: nutritionData['minerals'],
        imageUrl: '',
        timestamp: DateTime.now(),
        confidence: confidence,
      );

      print('🎉 Analysis complete!');
      print('===== END FOOD ANALYSIS =====\n');

      return result;
    } catch (e) {
      print('❌ ERROR in analyzeFromText: $e');
      print('Stack trace: ${StackTrace.current}');
      throw Exception('Failed to analyze food from text: $e');
    }
  }

  /// Upload image to Firebase Storage and return the download URL
  static Future<String> _uploadImage(String imagePath) async {
    try {
      final file = File(imagePath);
      final fileName =
          'food_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      await ref.putFile(file);
      final downloadUrl = await ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// Calculate nutrition values based on grams
  /// USDA data is per 100g, so we scale it to the actual portion size
  static Map<String, dynamic> _calculateNutrition(
    Map<String, dynamic> usdaData,
    double grams,
  ) {
    final scale = grams / 100.0; // USDA data is per 100g

    // Calculate macros
    final carbsGrams = (usdaData['carbs'] as double) * scale;
    final proteinGrams = (usdaData['protein'] as double) * scale;
    final fatGrams = (usdaData['fat'] as double) * scale;
    final calories = (usdaData['calories'] as double) * scale;

    // Calculate total calories from macros for percentage calculation
    final totalCalories =
        (carbsGrams * 4) + (proteinGrams * 4) + (fatGrams * 9);

    return {
      'calories': calories,
      'macros': MacrosStruct(
        carbs: MacroDetailStruct(
          grams: carbsGrams,
          percentage:
              totalCalories > 0 ? (carbsGrams * 4 / totalCalories * 100) : 0,
        ),
        protein: MacroDetailStruct(
          grams: proteinGrams,
          percentage:
              totalCalories > 0 ? (proteinGrams * 4 / totalCalories * 100) : 0,
        ),
        fat: MacroDetailStruct(
          grams: fatGrams,
          percentage:
              totalCalories > 0 ? (fatGrams * 9 / totalCalories * 100) : 0,
        ),
      ),
      'cholesterol': NutrientStruct(
        mg: (usdaData['cholesterol'] as double) * scale,
        percentage: 0, // TODO: Calculate based on daily value (300mg)
      ),
      'sodium': NutrientStruct(
        mg: (usdaData['sodium'] as double) * scale,
        percentage: 0, // TODO: Calculate based on daily value (2300mg)
      ),
      'minerals': MineralsStruct(
        calcium: NutrientStruct(
          mg: (usdaData['calcium'] as double) * scale,
          percentage: 0, // TODO: Calculate based on daily value
        ),
        iron: NutrientStruct(
          mg: (usdaData['iron'] as double) * scale,
          percentage: 0,
        ),
        potassium: NutrientStruct(
          mg: (usdaData['potassium'] as double) * scale,
          percentage: 0,
        ),
        magnesium: NutrientStruct(
          mg: (usdaData['magnesium'] as double) * scale,
          percentage: 0,
        ),
        phosphorus: NutrientStruct(
          mg: (usdaData['phosphorus'] as double) * scale,
          percentage: 0,
        ),
        zinc: NutrientStruct(
          mg: (usdaData['zinc'] as double) * scale,
          percentage: 0,
        ),
        copper: NutrientStruct(
          mg: (usdaData['copper'] as double) * scale,
          percentage: 0,
        ),
        selenium: NutrientStruct(
          mg: (usdaData['selenium'] as double) * scale,
          percentage: 0,
        ),
      ),
    };
  }
}
