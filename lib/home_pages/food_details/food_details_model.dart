import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_food_details_app_bar/z_food_details_app_bar_widget.dart';
import '/home_pages/components/z_food_details_content/z_food_details_content_widget.dart';
import '/home_pages/components/z_food_details_headar/z_food_details_headar_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'food_details_widget.dart' show FoodDetailsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/backend/backend_manager.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

class FoodDetailsModel extends FlutterFlowModel<FoodDetailsWidget> {
  ///  Local state fields for this page.

  int? quantity = 1;

  final BackendManager _backend = BackendManager();

  // Reference to the content widget model to access updated nutrition data
  ZFoodDetailsContentModel? contentModel;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Save meal to Firestore
  Future<void> saveMeal(
      BuildContext context, FoodNutritionStruct? nutritionData) async {
    // Use the updated nutrition data from the content model if available
    final dataToSave = contentModel?.calculatedNutrition ?? nutritionData;

    if (dataToSave == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No nutrition data available')),
        );
      }
      return;
    }

    if (currentUserUid.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please log in to save meals')),
        );
      }
      return;
    }

    try {
      // Get the selected date from FFAppState
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();

      // Convert nutrition data to food map format with all nutritional data
      final foodMap = {
        'title': dataToSave.foodName,
        'kcal': dataToSave.calories.round(),
        'gram': dataToSave.grams.round(),
        'carbs': dataToSave.macros.carbs.grams.round(),
        'protein': dataToSave.macros.protein.grams.round(),
        'fat': dataToSave.macros.fat.grams.round(),
        // Image URL (if available from photo search)
        if (dataToSave.imageUrl.isNotEmpty) 'imageUrl': dataToSave.imageUrl,
        // Additional nutritional data
        'cholesterol': {
          'mg': dataToSave.cholesterol.mg,
          'percentage': dataToSave.cholesterol.percentage,
        },
        'sodium': {
          'mg': dataToSave.sodium.mg,
          'percentage': dataToSave.sodium.percentage,
        },
        'minerals': {
          'calcium': {
            'mg': dataToSave.minerals.calcium.mg,
            'percentage': dataToSave.minerals.calcium.percentage,
          },
          'iron': {
            'mg': dataToSave.minerals.iron.mg,
            'percentage': dataToSave.minerals.iron.percentage,
          },
          'potassium': {
            'mg': dataToSave.minerals.potassium.mg,
            'percentage': dataToSave.minerals.potassium.percentage,
          },
          'magnesium': {
            'mg': dataToSave.minerals.magnesium.mg,
            'percentage': dataToSave.minerals.magnesium.percentage,
          },
          'phosphorus': {
            'mg': dataToSave.minerals.phosphorus.mg,
            'percentage': dataToSave.minerals.phosphorus.percentage,
          },
          'zinc': {
            'mg': dataToSave.minerals.zinc.mg,
            'percentage': dataToSave.minerals.zinc.percentage,
          },
          'copper': {
            'mg': dataToSave.minerals.copper.mg,
            'percentage': dataToSave.minerals.copper.percentage,
          },
          'selenium': {
            'mg': dataToSave.minerals.selenium.mg,
            'percentage': dataToSave.minerals.selenium.percentage,
          },
        },
      };

      // Check if this is an update (has mealId) or a new meal
      final isUpdate = dataToSave.mealId.isNotEmpty;

      if (isUpdate) {
        print('🔄 Updating existing meal...');
        print('   Meal ID: ${dataToSave.mealId}');
        print('   User ID: $currentUserUid');
        print('   Food: ${dataToSave.foodName}');
        print('   Calories: ${dataToSave.calories}');

        // For now, when updating from history, we'll replace the meal with just this food
        // In the future, we might want to fetch the existing meal and update only the specific food item
        await _backend.mealService.updateMeal(
          userId: currentUserUid,
          mealId: dataToSave.mealId,
          foods: [foodMap],
        );

        print('✅ Meal updated successfully');
      } else {
        print('💾 Saving new meal to Firestore...');
        print('   User ID: $currentUserUid');
        print('   Date: $selectedDate');
        print('   Food: ${dataToSave.foodName}');
        print('   Calories: ${dataToSave.calories}');

        // Save new meal to Firestore using MealService
        final mealId = await _backend.mealService.addMeal(
          userId: currentUserUid,
          date: selectedDate,
          type: 'snack', // Default to snack, can be customized later
          foods: [foodMap],
          totalCalories: dataToSave.calories.round(),
          totalCarbs: dataToSave.macros.carbs.grams.round(),
          totalProtein: dataToSave.macros.protein.grams.round(),
          totalFat: dataToSave.macros.fat.grams.round(),
        );

        print('✅ Meal saved successfully with ID: $mealId');
      }

      if (!context.mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isUpdate
              ? '✅ Food updated successfully!'
              : '✅ Food saved successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to home page
      await Future.delayed(const Duration(milliseconds: 500));
      if (!context.mounted) return;

      context.goNamed('HomePage');
    } catch (e) {
      print('❌ Error saving meal: $e');
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save food: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
