import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_foods/z_foods_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'z_nutrition_widget.dart' show ZNutritionWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/schema/structs/index.dart';

class ZNutritionModel extends FlutterFlowModel<ZNutritionWidget> {
  final BackendManager _backend = BackendManager();

  List<Map<String, dynamic>> meals = [];
  bool isLoading = false;

  @override
  void initState(BuildContext context) {
    loadMeals();
  }

  @override
  void dispose() {}

  Future<void> loadMeals() async {
    if (currentUserUid.isEmpty) return;

    isLoading = true;

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();
      meals = await _backend.mealService.getMealsByDate(
        userId: currentUserUid,
        date: selectedDate,
      );
      print(
          '📊 Loaded ${meals.length} meals for ${selectedDate.toString().split(' ')[0]}');
    } catch (e) {
      print('❌ Error loading meals: $e');
      meals = [];
    } finally {
      isLoading = false;
    }
  }

  /// Convert food map from Firebase to FoodNutritionStruct
  FoodNutritionStruct convertFoodToNutritionStruct(Map<String, dynamic> food) {
    final grams = (food['gram'] as num?)?.toDouble() ?? 100.0;
    final calories = (food['kcal'] as num?)?.toDouble() ?? 0.0;
    final carbs = (food['carbs'] as num?)?.toDouble() ?? 0.0;
    final protein = (food['protein'] as num?)?.toDouble() ?? 0.0;
    final fat = (food['fat'] as num?)?.toDouble() ?? 0.0;

    // Calculate percentages for macros
    final totalMacroCalories = (carbs * 4) + (protein * 4) + (fat * 9);
    final carbsPercentage =
        totalMacroCalories > 0 ? (carbs * 4 / totalMacroCalories) * 100 : 0.0;
    final proteinPercentage =
        totalMacroCalories > 0 ? (protein * 4 / totalMacroCalories) * 100 : 0.0;
    final fatPercentage =
        totalMacroCalories > 0 ? (fat * 9 / totalMacroCalories) * 100 : 0.0;

    // Extract cholesterol data
    final cholesterolData = food['cholesterol'] as Map<String, dynamic>?;
    final cholesterol = NutrientStruct(
      mg: (cholesterolData?['mg'] as num?)?.toDouble() ?? 0.0,
      percentage: (cholesterolData?['percentage'] as num?)?.toDouble() ?? 0.0,
    );

    // Extract sodium data
    final sodiumData = food['sodium'] as Map<String, dynamic>?;
    final sodium = NutrientStruct(
      mg: (sodiumData?['mg'] as num?)?.toDouble() ?? 0.0,
      percentage: (sodiumData?['percentage'] as num?)?.toDouble() ?? 0.0,
    );

    // Extract minerals data
    final mineralsData = food['minerals'] as Map<String, dynamic>?;
    final minerals = MineralsStruct(
      calcium: NutrientStruct(
        mg: ((mineralsData?['calcium'] as Map<String, dynamic>?)?['mg'] as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['calcium']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
      iron: NutrientStruct(
        mg: ((mineralsData?['iron'] as Map<String, dynamic>?)?['mg'] as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['iron']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
      potassium: NutrientStruct(
        mg: ((mineralsData?['potassium'] as Map<String, dynamic>?)?['mg']
                    as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['potassium']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
      magnesium: NutrientStruct(
        mg: ((mineralsData?['magnesium'] as Map<String, dynamic>?)?['mg']
                    as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['magnesium']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
      phosphorus: NutrientStruct(
        mg: ((mineralsData?['phosphorus'] as Map<String, dynamic>?)?['mg']
                    as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['phosphorus']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
      zinc: NutrientStruct(
        mg: ((mineralsData?['zinc'] as Map<String, dynamic>?)?['mg'] as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['zinc']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
      copper: NutrientStruct(
        mg: ((mineralsData?['copper'] as Map<String, dynamic>?)?['mg'] as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['copper']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
      selenium: NutrientStruct(
        mg: ((mineralsData?['selenium'] as Map<String, dynamic>?)?['mg']
                    as num?)
                ?.toDouble() ??
            0.0,
        percentage: ((mineralsData?['selenium']
                    as Map<String, dynamic>?)?['percentage'] as num?)
                ?.toDouble() ??
            0.0,
      ),
    );

    return FoodNutritionStruct(
      foodName: food['title']?.toString() ?? 'Unknown Food',
      grams: grams,
      calories: calories,
      macros: MacrosStruct(
        carbs: MacroDetailStruct(
          grams: carbs,
          percentage: carbsPercentage,
        ),
        protein: MacroDetailStruct(
          grams: protein,
          percentage: proteinPercentage,
        ),
        fat: MacroDetailStruct(
          grams: fat,
          percentage: fatPercentage,
        ),
      ),
      cholesterol: cholesterol,
      sodium: sodium,
      minerals: minerals,
      imageUrl: food['imageUrl']?.toString() ?? '',
      timestamp: DateTime.now(),
      usdaDescription: food['usdaDescription']?.toString(),
      usdaDataType: food['usdaDataType']?.toString(),
    );
  }
}
