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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Stream nutrition data for a specific date (real-time updates)
  Stream<Map<String, dynamic>> streamNutritionData(DateTime date) {
    if (currentUserUid.isEmpty) {
      return Stream.value({'progress': 0.0, 'withinGoal': true});
    }

    try {
      // Get calorie goal from user profile (from onboarding) or tracker settings
      final calorieGoal = FFAppState().userProfile.dailyCalorieGoal > 0
          ? FFAppState().userProfile.dailyCalorieGoal
          : (FFAppState().trackerSettings.calorie.goal > 0
              ? FFAppState().trackerSettings.calorie.goal
              : 2000);

      // Stream meals for the date and transform to nutrition data
      return _backend.mealService
          .streamMealsByDate(
        userId: currentUserUid,
        date: date,
      )
          .map((meals) {
        // Calculate total calories from all meals
        int totalCalories = 0;
        for (final meal in meals) {
          totalCalories += (meal['totalCalories'] as int?) ?? 0;
        }

        // Calculate progress (allow > 1.0 for exceeded calories)
        final progress = calorieGoal > 0 ? (totalCalories / calorieGoal) : 0.0;

        // Determine if within goal (calories <= goal)
        final withinGoal = totalCalories <= calorieGoal;

        return {
          'progress': progress,
          'withinGoal': withinGoal,
        };
      }).handleError((e) {
        print(
            'Error streaming nutrition data for ${date.toString().split(' ')[0]}: $e');
        return {'progress': 0.0, 'withinGoal': true};
      });
    } catch (e) {
      print('Error setting up nutrition stream: $e');
      return Stream.value({'progress': 0.0, 'withinGoal': true});
    }
  }
}
