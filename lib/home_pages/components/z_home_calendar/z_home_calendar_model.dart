import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'z_home_calendar_widget.dart' show ZHomeCalendarWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';

class ZHomeCalendarModel extends FlutterFlowModel<ZHomeCalendarWidget> {
  final BackendManager _backend = BackendManager();

  ///  Local state fields for this component.

  DateTime? selectedDate;

  List<DateTime> dates = [];
  void addToDates(DateTime item) => dates.add(item);
  void removeFromDates(DateTime item) => dates.remove(item);
  void removeAtIndexFromDates(int index) => dates.removeAt(index);
  void insertAtIndexInDates(int index, DateTime item) =>
      dates.insert(index, item);
  void updateDatesAtIndex(int index, Function(DateTime) updateFn) =>
      dates[index] = updateFn(dates[index]);

  // Cache for nutrition data by date
  Map<String, Map<String, dynamic>> nutritionDataCache = {};

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Get nutrition data for a specific date (progress and whether within goal)
  Future<Map<String, dynamic>> getNutritionData(DateTime date) async {
    if (currentUserUid.isEmpty) {
      return {'progress': 0.0, 'withinGoal': true};
    }

    final dateKey = '${date.year}-${date.month}-${date.day}';

    // Return cached value if available
    if (nutritionDataCache.containsKey(dateKey)) {
      return nutritionDataCache[dateKey]!;
    }

    try {
      // Get calorie goal from user profile (from onboarding) or tracker settings
      final calorieGoal = FFAppState().userProfile.dailyCalorieGoal > 0
          ? FFAppState().userProfile.dailyCalorieGoal
          : (FFAppState().trackerSettings.calorie.goal > 0
              ? FFAppState().trackerSettings.calorie.goal
              : 2000);

      // Get meals for the date
      final meals = await _backend.mealService.getMealsByDate(
        userId: currentUserUid,
        date: date,
      );

      // Calculate total calories
      int totalCalories = 0;
      for (final meal in meals) {
        totalCalories += (meal['totalCalories'] as int?) ?? 0;
      }

      // Calculate progress (allow > 1.0 for exceeded calories)
      final progress = calorieGoal > 0 ? (totalCalories / calorieGoal) : 0.0;

      // Determine if within goal (calories <= goal)
      final withinGoal = totalCalories <= calorieGoal;

      final result = {
        'progress': progress,
        'withinGoal': withinGoal,
      };

      // Cache the result
      nutritionDataCache[dateKey] = result;

      return result;
    } catch (e) {
      print('Error loading nutrition data for $dateKey: $e');
      return {'progress': 0.0, 'withinGoal': true};
    }
  }

  /// Get nutrition progress for a specific date (for backward compatibility)
  Future<double> getNutritionProgress(DateTime date) async {
    final data = await getNutritionData(date);
    return data['progress'] as double;
  }
}
