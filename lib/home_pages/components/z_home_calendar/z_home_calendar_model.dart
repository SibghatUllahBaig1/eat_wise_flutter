import '/backend/schema/structs/index.dart';
import '/backend/utils/date_utils.dart';
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

  DateTime? selectedMonthAndYear;

  bool showMore = false;

  bool isLoadingMonthProgress = false;

  double? size;

  List<DateTime> dates = [];
  void addToDates(DateTime item) => dates.add(item);
  void removeFromDates(DateTime item) => dates.remove(item);
  void removeAtIndexFromDates(int index) => dates.removeAt(index);
  void insertAtIndexInDates(int index, DateTime item) =>
      dates.insert(index, item);
  void updateDatesAtIndex(int index, Function(DateTime) updateFn) =>
      dates[index] = updateFn(dates[index]);

  Map<String, double> nutritionProgressByDate = {};
  Map<String, bool> withinGoalByDate = {};

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  int get _calorieGoal {
    return FFAppState().userProfile.dailyCalorieGoal > 0
        ? FFAppState().userProfile.dailyCalorieGoal
        : (FFAppState().trackerSettings.calorie.goal > 0
            ? FFAppState().trackerSettings.calorie.goal
            : 2000);
  }

  Future<void> loadNutritionProgressForDates(List<DateTime> dates) async {
    if (currentUserUid.isEmpty || dates.isEmpty) return;

    final calorieGoal = _calorieGoal;
    final uniqueDays = <String, DateTime>{};
    for (final date in dates) {
      final day = normalizeToDate(date);
      uniqueDays[_dateKey(day)] = day;
    }

    for (final key in uniqueDays.keys) {
      nutritionProgressByDate[key] = 0.0;
      withinGoalByDate[key] = true;
    }

    final sortedDays = uniqueDays.values.toList()..sort();
    final rangeStart = sortedDays.first;
    final rangeEndDay = sortedDays.last;
    final rangeEnd = DateTime(
      rangeEndDay.year,
      rangeEndDay.month,
      rangeEndDay.day,
      23,
      59,
      59,
    );

    try {
      final meals = await _backend.mealService.getMealsByDateRange(
        userId: currentUserUid,
        startDate: rangeStart,
        endDate: rangeEnd,
      );

      final caloriesByDay = <String, int>{};
      for (final meal in meals) {
        final mealDate = meal['date'];
        if (mealDate is! DateTime) continue;
        final key = _dateKey(normalizeToDate(mealDate));
        if (!uniqueDays.containsKey(key)) continue;
        caloriesByDay[key] = (caloriesByDay[key] ?? 0) +
            ((meal['totalCalories'] as int?) ?? 0);
      }

      for (final entry in caloriesByDay.entries) {
        final totalCalories = entry.value;
        nutritionProgressByDate[entry.key] = calorieGoal > 0
            ? (totalCalories / calorieGoal).clamp(0.0, 1.0)
            : 0.0;
        withinGoalByDate[entry.key] = totalCalories <= calorieGoal;
      }
    } catch (e) {
      for (final key in uniqueDays.keys) {
        nutritionProgressByDate[key] = 0.0;
        withinGoalByDate[key] = true;
      }
    }
  }

  double getProgressForDate(DateTime date) =>
      nutritionProgressByDate[_dateKey(date)] ?? 0.0;

  bool isWithinGoalForDate(DateTime date) =>
      withinGoalByDate[_dateKey(date)] ?? true;

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
      final calorieGoal = _calorieGoal;

      return _backend.mealService
          .streamMealsByDate(
        userId: currentUserUid,
        date: date,
      )
          .map((meals) {
        var totalCalories = 0;
        for (final meal in meals) {
          totalCalories += (meal['totalCalories'] as int?) ?? 0;
        }

        final progress =
            calorieGoal > 0 ? (totalCalories / calorieGoal) : 0.0;
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
