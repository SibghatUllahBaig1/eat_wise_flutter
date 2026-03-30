import 'package:cloud_firestore/cloud_firestore.dart';
import '../../backend/schema/structs/index.dart';

/// Utility to prepopulate recipe nutrition data from hardcoded data
/// Updates all recipes with complete nutrition information including minerals
class PrepopulateRecipesUSDA {
  static final _firestore = FirebaseFirestore.instance;

  /// Hardcoded nutrition data for all recipes
  static final Map<String, Map<String, dynamic>> _recipeData = {
    "Classic Caesar Salad": {
      "totalGrams": 100,
      "cookingTime": 15,
      "calories": 308,
      "protein": {"value": 10, "unit": "g"},
      "carbs": {"value": 10, "unit": "g"},
      "fat": {"value": 25, "unit": "g"},
      "fiber": {"value": 3, "unit": "g"},
      "sugar": {"value": 2, "unit": "g"},
      "saturatedFat": {"value": 6, "unit": "g"},
      "cholesterol": {"value": 35, "unit": "mg"},
      "sodium": {"value": 480, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 120, "unit": "mg"},
        "iron": {"value": 1.8, "unit": "mg"},
        "potassium": {"value": 280, "unit": "mg"},
        "magnesium": {"value": 20, "unit": "mg"},
        "phosphorus": {"value": 90, "unit": "mg"},
        "zinc": {"value": 1.2, "unit": "mg"},
        "copper": {"value": 0.1, "unit": "mg"},
        "selenium": {"value": 8, "unit": "µg"}
      }
    },
    "Watermelon Smoothie with Basil & Mint": {
      "totalGrams": 100,
      "cookingTime": 5,
      "calories": 30,
      "protein": {"value": 0.6, "unit": "g"},
      "carbs": {"value": 8, "unit": "g"},
      "fat": {"value": 0.2, "unit": "g"},
      "fiber": {"value": 0.5, "unit": "g"},
      "sugar": {"value": 7, "unit": "g"},
      "saturatedFat": {"value": 0, "unit": "g"},
      "cholesterol": {"value": 0, "unit": "mg"},
      "sodium": {"value": 5, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 10, "unit": "mg"},
        "iron": {"value": 0.2, "unit": "mg"},
        "potassium": {"value": 110, "unit": "mg"},
        "magnesium": {"value": 8, "unit": "mg"},
        "phosphorus": {"value": 10, "unit": "mg"},
        "zinc": {"value": 0.1, "unit": "mg"},
        "copper": {"value": 0.02, "unit": "mg"},
        "selenium": {"value": 0.3, "unit": "µg"}
      }
    },
    "Classic Beef Burger": {
      "totalGrams": 100,
      "cookingTime": 20,
      "calories": 250,
      "protein": {"value": 10, "unit": "g"},
      "carbs": {"value": 23, "unit": "g"},
      "fat": {"value": 16, "unit": "g"},
      "fiber": {"value": 1.5, "unit": "g"},
      "sugar": {"value": 4, "unit": "g"},
      "saturatedFat": {"value": 6, "unit": "g"},
      "cholesterol": {"value": 45, "unit": "mg"},
      "sodium": {"value": 600, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 50, "unit": "mg"},
        "iron": {"value": 2.5, "unit": "mg"},
        "potassium": {"value": 300, "unit": "mg"},
        "magnesium": {"value": 25, "unit": "mg"},
        "phosphorus": {"value": 110, "unit": "mg"},
        "zinc": {"value": 2.2, "unit": "mg"},
        "copper": {"value": 0.08, "unit": "mg"},
        "selenium": {"value": 15, "unit": "µg"}
      }
    },
    "Vegetarian Butternut Squash Soup": {
      "totalGrams": 100,
      "cookingTime": 30,
      "calories": 90,
      "protein": {"value": 1.5, "unit": "g"},
      "carbs": {"value": 12, "unit": "g"},
      "fat": {"value": 4, "unit": "g"},
      "fiber": {"value": 2.5, "unit": "g"},
      "sugar": {"value": 4, "unit": "g"},
      "saturatedFat": {"value": 1, "unit": "g"},
      "cholesterol": {"value": 0, "unit": "mg"},
      "sodium": {"value": 200, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 40, "unit": "mg"},
        "iron": {"value": 0.8, "unit": "mg"},
        "potassium": {"value": 250, "unit": "mg"},
        "magnesium": {"value": 15, "unit": "mg"},
        "phosphorus": {"value": 40, "unit": "mg"},
        "zinc": {"value": 0.4, "unit": "mg"},
        "copper": {"value": 0.05, "unit": "mg"},
        "selenium": {"value": 1, "unit": "µg"}
      }
    },
    "Sweet Potato Chips": {
      "totalGrams": 100,
      "cookingTime": 25,
      "calories": 301,
      "protein": {"value": 3, "unit": "g"},
      "carbs": {"value": 35, "unit": "g"},
      "fat": {"value": 15, "unit": "g"},
      "fiber": {"value": 4, "unit": "g"},
      "sugar": {"value": 7, "unit": "g"},
      "saturatedFat": {"value": 3, "unit": "g"},
      "cholesterol": {"value": 0, "unit": "mg"},
      "sodium": {"value": 200, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 30, "unit": "mg"},
        "iron": {"value": 1, "unit": "mg"},
        "potassium": {"value": 400, "unit": "mg"},
        "magnesium": {"value": 25, "unit": "mg"},
        "phosphorus": {"value": 60, "unit": "mg"},
        "zinc": {"value": 0.6, "unit": "mg"},
        "copper": {"value": 0.1, "unit": "mg"},
        "selenium": {"value": 1, "unit": "µg"}
      }
    },
    "Surimi Salad": {
      "totalGrams": 100,
      "cookingTime": 10,
      "calories": 310,
      "protein": {"value": 9, "unit": "g"},
      "carbs": {"value": 15, "unit": "g"},
      "fat": {"value": 22, "unit": "g"},
      "fiber": {"value": 1, "unit": "g"},
      "sugar": {"value": 3, "unit": "g"},
      "saturatedFat": {"value": 4, "unit": "g"},
      "cholesterol": {"value": 25, "unit": "mg"},
      "sodium": {"value": 700, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 40, "unit": "mg"},
        "iron": {"value": 0.7, "unit": "mg"},
        "potassium": {"value": 200, "unit": "mg"},
        "magnesium": {"value": 15, "unit": "mg"},
        "phosphorus": {"value": 70, "unit": "mg"},
        "zinc": {"value": 0.8, "unit": "mg"},
        "copper": {"value": 0.05, "unit": "mg"},
        "selenium": {"value": 12, "unit": "µg"}
      }
    },
    "Buttermilk Mango Shake": {
      "totalGrams": 100,
      "cookingTime": 5,
      "calories": 99,
      "protein": {"value": 2, "unit": "g"},
      "carbs": {"value": 18, "unit": "g"},
      "fat": {"value": 2, "unit": "g"},
      "fiber": {"value": 1.5, "unit": "g"},
      "sugar": {"value": 16, "unit": "g"},
      "saturatedFat": {"value": 1, "unit": "g"},
      "cholesterol": {"value": 8, "unit": "mg"},
      "sodium": {"value": 40, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 80, "unit": "mg"},
        "iron": {"value": 0.3, "unit": "mg"},
        "potassium": {"value": 200, "unit": "mg"},
        "magnesium": {"value": 15, "unit": "mg"},
        "phosphorus": {"value": 60, "unit": "mg"},
        "zinc": {"value": 0.4, "unit": "mg"},
        "copper": {"value": 0.05, "unit": "mg"},
        "selenium": {"value": 2, "unit": "µg"}
      }
    },
    "Semolina Casserole": {
      "totalGrams": 100,
      "cookingTime": 35,
      "calories": 352,
      "protein": {"value": 8, "unit": "g"},
      "carbs": {"value": 50, "unit": "g"},
      "fat": {"value": 12, "unit": "g"},
      "fiber": {"value": 2, "unit": "g"},
      "sugar": {"value": 15, "unit": "g"},
      "saturatedFat": {"value": 5, "unit": "g"},
      "cholesterol": {"value": 30, "unit": "mg"},
      "sodium": {"value": 150, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 100, "unit": "mg"},
        "iron": {"value": 1.5, "unit": "mg"},
        "potassium": {"value": 180, "unit": "mg"},
        "magnesium": {"value": 30, "unit": "mg"},
        "phosphorus": {"value": 120, "unit": "mg"},
        "zinc": {"value": 1, "unit": "mg"},
        "copper": {"value": 0.1, "unit": "mg"},
        "selenium": {"value": 10, "unit": "µg"}
      }
    },
    "Neapolitan-Style Margherita Pizza": {
      "totalGrams": 100,
      "cookingTime": 20,
      "calories": 280,
      "protein": {"value": 11, "unit": "g"},
      "carbs": {"value": 33, "unit": "g"},
      "fat": {"value": 10, "unit": "g"},
      "fiber": {"value": 2, "unit": "g"},
      "sugar": {"value": 4, "unit": "g"},
      "saturatedFat": {"value": 4, "unit": "g"},
      "cholesterol": {"value": 20, "unit": "mg"},
      "sodium": {"value": 500, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 150, "unit": "mg"},
        "iron": {"value": 2, "unit": "mg"},
        "potassium": {"value": 200, "unit": "mg"},
        "magnesium": {"value": 20, "unit": "mg"},
        "phosphorus": {"value": 130, "unit": "mg"},
        "zinc": {"value": 1.2, "unit": "mg"},
        "copper": {"value": 0.1, "unit": "mg"},
        "selenium": {"value": 14, "unit": "µg"}
      }
    },
    "Marinated Zucchini with Hazelnuts and Ricotta": {
      "totalGrams": 100,
      "cookingTime": 15,
      "calories": 180,
      "protein": {"value": 6, "unit": "g"},
      "carbs": {"value": 8, "unit": "g"},
      "fat": {"value": 14, "unit": "g"},
      "fiber": {"value": 2, "unit": "g"},
      "sugar": {"value": 3, "unit": "g"},
      "saturatedFat": {"value": 3, "unit": "g"},
      "cholesterol": {"value": 15, "unit": "mg"},
      "sodium": {"value": 120, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 120, "unit": "mg"},
        "iron": {"value": 1.2, "unit": "mg"},
        "potassium": {"value": 220, "unit": "mg"},
        "magnesium": {"value": 30, "unit": "mg"},
        "phosphorus": {"value": 100, "unit": "mg"},
        "zinc": {"value": 0.9, "unit": "mg"},
        "copper": {"value": 0.2, "unit": "mg"},
        "selenium": {"value": 3, "unit": "µg"}
      }
    },
    "Lasagne Soup": {
      "totalGrams": 100,
      "cookingTime": 40,
      "calories": 120,
      "protein": {"value": 7, "unit": "g"},
      "carbs": {"value": 10, "unit": "g"},
      "fat": {"value": 6, "unit": "g"},
      "fiber": {"value": 1.5, "unit": "g"},
      "sugar": {"value": 3, "unit": "g"},
      "saturatedFat": {"value": 2.5, "unit": "g"},
      "cholesterol": {"value": 20, "unit": "mg"},
      "sodium": {"value": 400, "unit": "mg"},
      "minerals": {
        "calcium": {"value": 90, "unit": "mg"},
        "iron": {"value": 1.5, "unit": "mg"},
        "potassium": {"value": 250, "unit": "mg"},
        "magnesium": {"value": 20, "unit": "mg"},
        "phosphorus": {"value": 110, "unit": "mg"},
        "zinc": {"value": 1.2, "unit": "mg"},
        "copper": {"value": 0.08, "unit": "mg"},
        "selenium": {"value": 10, "unit": "µg"}
      }
    },
  };

  /// Prepopulate all recipes with hardcoded nutrition data
  /// Returns a summary with success/error counts
  static Future<Map<String, dynamic>> prepopulateAllRecipes() async {
    int successCount = 0;
    int errorCount = 0;
    final errors = <String>[];

    try {
      // Get all recipes from Firestore
      final recipesSnapshot = await _firestore.collection('recipes').get();
      final recipes = recipesSnapshot.docs;

      print('📊 Found ${recipes.length} recipes to prepopulate');

      for (final recipeDoc in recipes) {
        final recipeData = recipeDoc.data();
        final recipeName = recipeData['name'] ?? '';

        if (recipeName.isEmpty) {
          errorCount++;
          errors.add('Recipe ${recipeDoc.id}: No name found');
          continue;
        }

        try {
          print('\n🥗 Processing: $recipeName');

          // Get nutrition data from hardcoded map
          final nutritionData = _recipeData[recipeName];

          if (nutritionData == null) {
            errorCount++;
            errors.add('$recipeName: No nutrition data available');
            continue;
          }

          // Build minerals struct
          final mineralsData =
              nutritionData['minerals'] as Map<String, dynamic>;
          final minerals = MineralsStruct(
            calcium: NutrientStruct(
              mg: (mineralsData['calcium']?['value'] ?? 0).toDouble(),
            ),
            iron: NutrientStruct(
              mg: (mineralsData['iron']?['value'] ?? 0).toDouble(),
            ),
            potassium: NutrientStruct(
              mg: (mineralsData['potassium']?['value'] ?? 0).toDouble(),
            ),
            magnesium: NutrientStruct(
              mg: (mineralsData['magnesium']?['value'] ?? 0).toDouble(),
            ),
            phosphorus: NutrientStruct(
              mg: (mineralsData['phosphorus']?['value'] ?? 0).toDouble(),
            ),
            zinc: NutrientStruct(
              mg: (mineralsData['zinc']?['value'] ?? 0).toDouble(),
            ),
            copper: NutrientStruct(
              mg: (mineralsData['copper']?['value'] ?? 0).toDouble(),
            ),
            selenium: NutrientStruct(
              mg: (mineralsData['selenium']?['value'] ?? 0).toDouble(),
            ),
          );

          // Build cholesterol and sodium structs
          final cholesterolStruct = NutrientStruct(
            mg: (nutritionData['cholesterol']?['value'] ?? 0).toDouble(),
          );
          final sodiumStruct = NutrientStruct(
            mg: (nutritionData['sodium']?['value'] ?? 0).toDouble(),
          );

          // Update recipe document
          await _firestore.collection('recipes').doc(recipeDoc.id).update({
            'calories': nutritionData['calories'] ?? 0,
            'protein': (nutritionData['protein']?['value'] ?? 0).toDouble(),
            'carbs': (nutritionData['carbs']?['value'] ?? 0).toDouble(),
            'fat': (nutritionData['fat']?['value'] ?? 0).toDouble(),
            'fiber': (nutritionData['fiber']?['value'] ?? 0).toDouble(),
            'sugar': (nutritionData['sugar']?['value'] ?? 0).toDouble(),
            'saturatedFat':
                (nutritionData['saturatedFat']?['value'] ?? 0).toDouble(),
            'cholesterol': cholesterolStruct.toMap(),
            'sodium': sodiumStruct.toMap(),
            'minerals': minerals.toMap(),
            'grams': nutritionData['totalGrams'] ?? 0,
            'time': nutritionData['cookingTime'] ?? 0,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          successCount++;
          print('✅ Updated: $recipeName');
        } catch (e) {
          errorCount++;
          final errorMsg = 'Recipe "$recipeName": $e';
          errors.add(errorMsg);
          print('❌ Error: $errorMsg');
        }
      }
    } catch (e) {
      print('❌ Fatal error: $e');
      errorCount++;
      errors.add('Fatal error: $e');
    }

    return {
      'success': successCount,
      'errors': errorCount,
      'total': successCount + errorCount,
      'errorDetails': errors,
    };
  }
}
