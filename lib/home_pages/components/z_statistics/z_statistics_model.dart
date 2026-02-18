import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'z_statistics_widget.dart' show ZStatisticsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';

class ZStatisticsModel extends FlutterFlowModel<ZStatisticsWidget> {
  final BackendManager _backend = BackendManager();

  // Nutrition data
  int totalCalories = 0;
  int totalCarbs = 0;
  int totalProtein = 0;
  int totalFat = 0;

  // Goals (from FFAppState)
  int calorieGoal = 2000;
  int carbsGoal = 250;
  int proteinGoal = 150;
  int fatGoal = 65;

  // Burned calories (placeholder - can be integrated with activity tracking)
  int burnedCalories = 0;
  int stepCalories = 0;

  bool isLoading = false;

  @override
  void initState(BuildContext context) {
    loadNutritionData();
  }

  @override
  void dispose() {}

  Future<void> loadNutritionData() async {
    if (currentUserUid.isEmpty) return;

    isLoading = true;

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();

      // Get calorie goal from user profile (from onboarding) or tracker settings
      calorieGoal = FFAppState().userProfile.dailyCalorieGoal > 0
          ? FFAppState().userProfile.dailyCalorieGoal
          : (FFAppState().trackerSettings.calorie.goal > 0
              ? FFAppState().trackerSettings.calorie.goal
              : 2000);

      // Calculate macros goals based on calorie goal (example ratios)
      // 50% carbs, 30% protein, 20% fat
      carbsGoal = ((calorieGoal * 0.5) / 4).round(); // 4 cal per gram
      proteinGoal = ((calorieGoal * 0.3) / 4).round(); // 4 cal per gram
      fatGoal = ((calorieGoal * 0.2) / 9).round(); // 9 cal per gram

      // Load meals for the selected date
      final meals = await _backend.mealService.getMealsByDate(
        userId: currentUserUid,
        date: selectedDate,
      );

      // Calculate totals
      totalCalories = 0;
      totalCarbs = 0;
      totalProtein = 0;
      totalFat = 0;

      for (final meal in meals) {
        totalCalories += (meal['totalCalories'] as int?) ?? 0;
        totalCarbs += (meal['totalCarbs'] as int?) ?? 0;
        totalProtein += (meal['totalProtein'] as int?) ?? 0;
        totalFat += (meal['totalFat'] as int?) ?? 0;
      }

      // Load activities for the selected date to get burned calories
      final activities = await _backend.activityService.getActivitiesByDate(
        userId: currentUserUid,
        date: selectedDate,
      );

      // Calculate total burned calories from activities
      burnedCalories = 0;
      for (final activity in activities) {
        burnedCalories += (activity['caloriesBurned'] as int?) ?? 0;
      }

      // Load step data for the selected date to get step-based calories
      final stepSummary = await _backend.stepTrackerService.getStepSummary(
        userId: currentUserUid,
        date: selectedDate,
      );

      // Calculate calories burned from steps (steps × 0.04)
      stepCalories = 0;
      if (stepSummary != null) {
        final totalSteps = (stepSummary['totalSteps'] as int?) ?? 0;
        stepCalories = (totalSteps * 0.04).round();
      }

      // Add step calories to total burned calories
      burnedCalories += stepCalories;

      print(
          '📊 Nutrition Summary for ${selectedDate.toString().split(' ')[0]}:');
      print('   Calories: $totalCalories / $calorieGoal');
      print('   Carbs: $totalCarbs / $carbsGoal g');
      print('   Protein: $totalProtein / $proteinGoal g');
      print('   Fat: $totalFat / $fatGoal g');
      print('   Burned from activities: ${burnedCalories - stepCalories} cal');
      print('   Burned from steps: $stepCalories cal');
      print('   Total burned: $burnedCalories cal');
    } catch (e) {
      print('❌ Error loading nutrition data: $e');
    } finally {
      isLoading = false;
    }
  }

  // Helper methods for progress calculations
  double get calorieProgress =>
      calorieGoal > 0 ? (totalCalories / calorieGoal) : 0.0;
  double get carbsProgress =>
      carbsGoal > 0 ? (totalCarbs / carbsGoal).clamp(0.0, 1.0) : 0.0;
  double get proteinProgress =>
      proteinGoal > 0 ? (totalProtein / proteinGoal).clamp(0.0, 1.0) : 0.0;
  double get fatProgress =>
      fatGoal > 0 ? (totalFat / fatGoal).clamp(0.0, 1.0) : 0.0;

  // Check if calories are exceeded
  bool get isCaloriesExceeded => (totalCalories - burnedCalories) > calorieGoal;

  // Get calories left or excess
  int get caloriesLeft =>
      (calorieGoal - totalCalories + burnedCalories).clamp(0, calorieGoal * 2);

  // Get excess calories (positive value when exceeded)
  int get caloriesExceeded => ((totalCalories - burnedCalories) - calorieGoal)
      .clamp(0, calorieGoal * 2);
}
