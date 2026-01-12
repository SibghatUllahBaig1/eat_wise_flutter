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

  // Cache for nutrition progress by date
  Map<String, double> nutritionProgressCache = {};

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Get nutrition progress for a specific date
  Future<double> getNutritionProgress(DateTime date) async {
    if (currentUserUid.isEmpty) return 0.0;

    final dateKey = '${date.year}-${date.month}-${date.day}';

    // Return cached value if available
    if (nutritionProgressCache.containsKey(dateKey)) {
      return nutritionProgressCache[dateKey]!;
    }

    try {
      // Get calorie goal
      final calorieGoal = FFAppState().trackerSettings.calorie.goal > 0
          ? FFAppState().trackerSettings.calorie.goal
          : 2000;

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

      // Calculate progress
      final progress =
          calorieGoal > 0 ? (totalCalories / calorieGoal).clamp(0.0, 1.0) : 0.0;

      // Cache the result
      nutritionProgressCache[dateKey] = progress;

      return progress;
    } catch (e) {
      print('Error loading nutrition progress for $dateKey: $e');
      return 0.0;
    }
  }
}
