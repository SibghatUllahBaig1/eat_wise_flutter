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
    // Intentionally do NOT kick off loadNutritionData() here.
    // The widget's initState / didUpdateWidget already drive reloads; calling
    // it from both places creates overlapping async runs that race on the
    // shared instance fields (burnedCalories, stepCalories) and inflate the
    // "Burned" value on every re-entry.
  }

  @override
  void dispose() {}

  Future<void> loadNutritionData() async {
    if (currentUserUid.isEmpty) return;

    // Re-entrancy guard: if a load is already in flight, skip this call so
    // two concurrent runs cannot both add stepCalories to burnedCalories.
    if (isLoading) return;
    isLoading = true;

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();

      // Get calorie goal from user profile (from onboarding) or tracker settings
      final int localCalorieGoal = FFAppState().userProfile.dailyCalorieGoal > 0
          ? FFAppState().userProfile.dailyCalorieGoal
          : (FFAppState().trackerSettings.calorie.goal > 0
              ? FFAppState().trackerSettings.calorie.goal
              : 2000);

      // Calculate macros goals based on calorie goal (example ratios)
      // 50% carbs, 30% protein, 20% fat
      final int localCarbsGoal = ((localCalorieGoal * 0.5) / 4).round();
      final int localProteinGoal = ((localCalorieGoal * 0.3) / 4).round();
      final int localFatGoal = ((localCalorieGoal * 0.2) / 9).round();

      // Load meals for the selected date
      final meals = await _backend.mealService.getMealsByDate(
        userId: currentUserUid,
        date: selectedDate,
      );

      int localTotalCalories = 0;
      int localTotalCarbs = 0;
      int localTotalProtein = 0;
      int localTotalFat = 0;

      for (final meal in meals) {
        localTotalCalories += (meal['totalCalories'] as int?) ?? 0;
        localTotalCarbs += (meal['totalCarbs'] as int?) ?? 0;
        localTotalProtein += (meal['totalProtein'] as int?) ?? 0;
        localTotalFat += (meal['totalFat'] as int?) ?? 0;
      }

      // Load activities for the selected date to get burned calories
      final activities = await _backend.activityService.getActivitiesByDate(
        userId: currentUserUid,
        date: selectedDate,
      );

      int localActivityBurned = 0;
      for (final activity in activities) {
        localActivityBurned += (activity['caloriesBurned'] as int?) ?? 0;
      }

      // Load step data for the selected date to get step-based calories
      final stepSummary = await _backend.stepTrackerService.getStepSummary(
        userId: currentUserUid,
        date: selectedDate,
      );

      int localStepCalories = 0;
      if (stepSummary != null) {
        final totalSteps = (stepSummary['totalSteps'] as int?) ?? 0;
        localStepCalories = (totalSteps * 0.04).round();
      }

      final int localBurnedCalories = localActivityBurned + localStepCalories;

      // Commit all results atomically at the very end so an interleaved
      // second run (if any ever sneaks past the guard) cannot produce a
      // partially-accumulated value.
      calorieGoal = localCalorieGoal;
      carbsGoal = localCarbsGoal;
      proteinGoal = localProteinGoal;
      fatGoal = localFatGoal;
      totalCalories = localTotalCalories;
      totalCarbs = localTotalCarbs;
      totalProtein = localTotalProtein;
      totalFat = localTotalFat;
      stepCalories = localStepCalories;
      burnedCalories = localBurnedCalories;

      print(
          '📊 Nutrition Summary for ${selectedDate.toString().split(' ')[0]}:');
      print('   Calories: $totalCalories / $calorieGoal');
      print('   Carbs: $totalCarbs / $carbsGoal g');
      print('   Protein: $totalProtein / $proteinGoal g');
      print('   Fat: $totalFat / $fatGoal g');
      print('   Burned from activities: $localActivityBurned kcal');
      print('   Burned from steps: $stepCalories kcal');
      print('   Total burned: $burnedCalories kcal');
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

  // Check if macros are exceeded
  bool get isCarbsExceeded => carbsGoal > 0 && totalCarbs > carbsGoal;
  bool get isProteinExceeded => proteinGoal > 0 && totalProtein > proteinGoal;
  bool get isFatExceeded => fatGoal > 0 && totalFat > fatGoal;

  // Get calories left or excess
  int get caloriesLeft =>
      (calorieGoal - totalCalories + burnedCalories).clamp(0, calorieGoal * 2);

  // Get excess calories (positive value when exceeded)
  int get caloriesExceeded => ((totalCalories - burnedCalories) - calorieGoal)
      .clamp(0, calorieGoal * 2);
}
