import '/backend/firestore/calorie_goal_history_service.dart';
import '/backend/schema/structs/index.dart';
import '/backend/services/calorie_goal_history_helper.dart';
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
import '/backend/services/weight_sync_helper.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:rxdart/rxdart.dart';

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

  List<CalorieGoalHistoryEntry>? _goalHistory;
  int? _cachedProfileCalorieGoal;

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  int get _currentCalorieGoalFallback =>
      CalorieGoalHistoryHelper.resolveCurrentCalorieGoal();

  int _calorieGoalForDate(DateTime date) {
    return CalorieGoalHistoryHelper.goalForDate(
      history: _goalHistory ?? const [],
      date: date,
      fallback: _currentCalorieGoalFallback,
    );
  }

  Future<void> _ensureGoalHistoryLoaded({bool forceReload = false}) async {
    final currentFallback = _currentCalorieGoalFallback;
    if (!forceReload &&
        _goalHistory != null &&
        _cachedProfileCalorieGoal == currentFallback) {
      return;
    }
    if (currentUserUid.isEmpty) {
      _goalHistory = const [];
      _cachedProfileCalorieGoal = currentFallback;
      return;
    }
    _goalHistory = await CalorieGoalHistoryHelper.fetchHistory(currentUserUid);
    _cachedProfileCalorieGoal = currentFallback;
  }

  void invalidateGoalHistoryCache() {
    _goalHistory = null;
    _cachedProfileCalorieGoal = null;
  }

  int _stepCaloriesFromSummary(Map<String, dynamic>? stepSummary) {
    if (stepSummary == null) return 0;
    final totalSteps = (stepSummary['totalSteps'] as int?) ?? 0;
    final weightKg = WeightSyncHelper.resolveCurrentWeightKg();
    final kcalPerStep = weightKg > 0 ? 0.04 * (weightKg / 70.0) : 0.04;
    return (totalSteps * kcalPerStep).round();
  }

  int _activityCaloriesFromList(List<Map<String, dynamic>> activities) {
    var total = 0;
    for (final activity in activities) {
      total += (activity['caloriesBurned'] as int?) ?? 0;
    }
    return total;
  }

  bool _isWithinCalorieGoal({
    required int totalCalories,
    required int burnedCalories,
    required int calorieGoal,
  }) {
    return (totalCalories - burnedCalories) <= calorieGoal;
  }

  double _calorieProgress({
    required int totalCalories,
    required int calorieGoal,
  }) {
    return calorieGoal > 0 ? (totalCalories / calorieGoal).clamp(0.0, 1.0) : 0.0;
  }


  Future<void> loadNutritionProgressForDates(List<DateTime> dates) async {
    if (currentUserUid.isEmpty || dates.isEmpty) return;

    await _ensureGoalHistoryLoaded(forceReload: true);

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
      final mealsFuture = _backend.mealService.getMealsByDateRange(
        userId: currentUserUid,
        startDate: rangeStart,
        endDate: rangeEnd,
      );
      final activitiesFuture = _backend.activityService.getActivitiesByDateRange(
        userId: currentUserUid,
        startDate: rangeStart,
        endDate: rangeEnd,
      );
      final stepsFuture = _backend.stepTrackerService.getStepHistory(
        userId: currentUserUid,
        startDate: rangeStart,
        endDate: rangeEnd,
      );

      final results = await Future.wait([
        mealsFuture,
        activitiesFuture,
        stepsFuture,
      ]);
      final meals = results[0] as List<Map<String, dynamic>>;
      final activities = results[1] as List<Map<String, dynamic>>;
      final stepSummaries = results[2] as List<Map<String, dynamic>>;

      final caloriesByDay = <String, int>{};
      for (final meal in meals) {
        final mealDate = meal['date'];
        if (mealDate is! DateTime) continue;
        final key = _dateKey(normalizeToDate(mealDate));
        if (!uniqueDays.containsKey(key)) continue;
        caloriesByDay[key] = (caloriesByDay[key] ?? 0) +
            ((meal['totalCalories'] as int?) ?? 0);
      }

      final burnedByDay = <String, int>{};
      for (final activity in activities) {
        final activityDate = activity['date'];
        if (activityDate is! DateTime) continue;
        final key = _dateKey(normalizeToDate(activityDate));
        if (!uniqueDays.containsKey(key)) continue;
        burnedByDay[key] = (burnedByDay[key] ?? 0) +
            ((activity['caloriesBurned'] as int?) ?? 0);
      }
      for (final stepSummary in stepSummaries) {
        final stepDate = stepSummary['date'];
        if (stepDate is! DateTime) continue;
        final key = _dateKey(normalizeToDate(stepDate));
        if (!uniqueDays.containsKey(key)) continue;
        burnedByDay[key] =
            (burnedByDay[key] ?? 0) + _stepCaloriesFromSummary(stepSummary);
      }

      for (final entry in caloriesByDay.entries) {
        final day = uniqueDays[entry.key]!;
        final calorieGoal = _calorieGoalForDate(day);
        final totalCalories = entry.value;
        final burnedCalories = burnedByDay[entry.key] ?? 0;
        nutritionProgressByDate[entry.key] = _calorieProgress(
          totalCalories: totalCalories,
          calorieGoal: calorieGoal,
        );
        withinGoalByDate[entry.key] = _isWithinCalorieGoal(
          totalCalories: totalCalories,
          burnedCalories: burnedCalories,
          calorieGoal: calorieGoal,
        );
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
      return Stream.fromFuture(_ensureGoalHistoryLoaded()).asyncExpand((_) {
        final calorieGoal = _calorieGoalForDate(date);

        final mealsStream = _backend.mealService.streamMealsByDate(
          userId: currentUserUid,
          date: date,
        );
        final stepsStream = _backend.stepTrackerService.streamStepSummary(
          userId: currentUserUid,
          date: date,
        );

        return Rx.combineLatest2(
          mealsStream,
          stepsStream,
          (List<Map<String, dynamic>> meals, Map<String, dynamic>? stepSummary) =>
              (meals, stepSummary),
        ).asyncMap((data) async {
          final meals = data.$1;
          final stepSummary = data.$2;
          var totalCalories = 0;
          for (final meal in meals) {
            totalCalories += (meal['totalCalories'] as int?) ?? 0;
          }

          final activityBurned = _activityCaloriesFromList(
            await _backend.activityService.getActivitiesByDate(
              userId: currentUserUid,
              date: date,
            ),
          );
          final burnedCalories =
              activityBurned + _stepCaloriesFromSummary(stepSummary);

          return {
            'progress': _calorieProgress(
              totalCalories: totalCalories,
              calorieGoal: calorieGoal,
            ),
            'withinGoal': _isWithinCalorieGoal(
              totalCalories: totalCalories,
              burnedCalories: burnedCalories,
              calorieGoal: calorieGoal,
            ),
          };
        }).handleError((e) {
          print(
              'Error streaming nutrition data for ${date.toString().split(' ')[0]}: $e');
          return {'progress': 0.0, 'withinGoal': true};
        });
      });
    } catch (e) {
      print('Error setting up nutrition stream: $e');
      return Stream.value({'progress': 0.0, 'withinGoal': true});
    }
  }
}
