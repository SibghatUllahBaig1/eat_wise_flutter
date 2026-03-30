import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'calorie_counter_widget.dart' show CalorieCounterWidget;
import 'package:flutter/material.dart';

class CalorieCounterModel extends FlutterFlowModel<CalorieCounterWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel1;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel2;

  // Backend manager for loading nutrition data
  final BackendManager _backend = BackendManager();

  @override
  void initState(BuildContext context) {
    textTextRightModel1 = createModel(context, () => TextTextRightModel());
    textTextRightModel2 = createModel(context, () => TextTextRightModel());
  }

  @override
  void dispose() {
    textTextRightModel1.dispose();
    textTextRightModel2.dispose();
  }

  /// Load calorie data for the selected date
  Future<Map<String, dynamic>> loadCalorieData() async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return {
          'caloriesLeft': 0,
          'caloriesExceeded': 0,
          'isExceeded': false,
        };
      }

      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();

      // Get calorie goal from user profile (from onboarding) or tracker settings
      final calorieGoal = FFAppState().userProfile.dailyCalorieGoal > 0
          ? FFAppState().userProfile.dailyCalorieGoal
          : (FFAppState().trackerSettings.calorie.goal > 0
              ? FFAppState().trackerSettings.calorie.goal
              : 2000);

      // Load meals for the selected date
      final meals = await _backend.mealService.getMealsByDate(
        userId: userId,
        date: selectedDate,
      );

      // Calculate total calories from meals
      int totalCalories = 0;
      for (final meal in meals) {
        totalCalories += (meal['totalCalories'] as int?) ?? 0;
      }

      // Load activities for the selected date to get burned calories
      final activities = await _backend.activityService.getActivitiesByDate(
        userId: userId,
        date: selectedDate,
      );

      // Calculate total burned calories from activities
      int burnedCalories = 0;
      for (final activity in activities) {
        burnedCalories += (activity['caloriesBurned'] as int?) ?? 0;
      }

      // Load step data for the selected date to get step-based calories
      final stepSummary = await _backend.stepTrackerService.getStepSummary(
        userId: userId,
        date: selectedDate,
      );

      // Calculate calories burned from steps (steps × 0.04)
      int stepCalories = 0;
      if (stepSummary != null) {
        final totalSteps = (stepSummary['totalSteps'] as int?) ?? 0;
        stepCalories = (totalSteps * 0.04).round();
      }

      // Add step calories to total burned calories
      burnedCalories += stepCalories;

      // Calculate calories left or exceeded
      final caloriesLeft = (calorieGoal - totalCalories + burnedCalories)
          .clamp(0, calorieGoal * 2);
      final caloriesExceeded = ((totalCalories - burnedCalories) - calorieGoal)
          .clamp(0, calorieGoal * 2);
      final isExceeded = (totalCalories - burnedCalories) > calorieGoal;

      return {
        'caloriesLeft': caloriesLeft,
        'caloriesExceeded': caloriesExceeded,
        'isExceeded': isExceeded,
      };
    } catch (e) {
      print('❌ Error loading calorie data: $e');
      return {
        'caloriesLeft': 0,
        'caloriesExceeded': 0,
        'isExceeded': false,
      };
    }
  }
}
