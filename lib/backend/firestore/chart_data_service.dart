import 'package:flutter/foundation.dart';
import '/backend/schema/structs/index.dart';
import 'firestore_service.dart';
import 'meal_service.dart';
import 'water_tracker_service.dart';
import 'step_tracker_service.dart';
import 'weight_tracker_service.dart';

/// Service for loading and transforming chart data
class ChartDataService {
  final MealService _mealService = MealService();
  final WaterTrackerService _waterService = WaterTrackerService();
  final StepTrackerService _stepService = StepTrackerService();
  final WeightTrackerService _weightService = WeightTrackerService();

  /// Load chart data for a specific period
  /// [periodType] 0 = Daily (last 14 days), 1 = Weekly (last 14 weeks), 2 = Monthly (last 12 months)
  Future<ChartStruct> loadChartData({
    required String userId,
    required DateTime selectedDate,
    required int periodType,
  }) async {
    try {
      debugPrint('Loading chart data for period type: $periodType');

      switch (periodType) {
        case 0: // Daily - last 14 days
          return await _loadDailyChartData(userId, selectedDate);
        case 1: // Weekly - last 14 weeks
          return await _loadWeeklyChartData(userId, selectedDate);
        case 2: // Monthly - last 12 months
          return await _loadMonthlyChartData(userId, selectedDate);
        default:
          return await _loadDailyChartData(userId, selectedDate);
      }
    } catch (e) {
      debugPrint('Error loading chart data: $e');
      return ChartStruct();
    }
  }

  /// Load daily chart data (last 14 days)
  Future<ChartStruct> _loadDailyChartData(
      String userId, DateTime selectedDate) async {
    final endDate = selectedDate;
    final startDate = endDate.subtract(const Duration(days: 13));

    debugPrint('Loading daily data from $startDate to $endDate');

    // Fetch all data in parallel, including last weight before start date
    final results = await Future.wait([
      _mealService.getMealHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _waterService.getWaterIntakeHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _stepService.getStepHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _weightService.getWeightHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _weightService.getLastWeightBefore(userId: userId, beforeDate: startDate),
    ]);

    final meals = results[0] as List<Map<String, dynamic>>;
    final waterData = results[1] as List<Map<String, dynamic>>;
    final stepData = results[2] as List<Map<String, dynamic>>;
    final weightData = results[3] as List<Map<String, dynamic>>;
    final lastWeightBefore = results[4] as Map<String, dynamic>?;

    debugPrint(
        'Fetched ${meals.length} meals, ${waterData.length} water entries, ${stepData.length} step entries, ${weightData.length} weight entries');

    // Create maps for quick lookup by date
    final caloriesByDate = <String, int>{};
    final waterByDate = <String, int>{};
    final stepsByDate = <String, int>{};
    final weightByDate = <String, double>{};

    // Aggregate calories by date
    for (var meal in meals) {
      final date = meal['date'] as DateTime;
      final dateKey = _formatDateKey(date);
      caloriesByDate[dateKey] = (caloriesByDate[dateKey] ?? 0) +
          ((meal['totalCalories'] as int?) ?? 0);
    }

    // Aggregate water by date
    for (var water in waterData) {
      final date = water['date'] as DateTime;
      final dateKey = _formatDateKey(date);
      // Support both 'totalIntake' (new system) and 'intake' (old system)
      final intake =
          (water['totalIntake'] as int?) ?? (water['intake'] as int?) ?? 0;
      waterByDate[dateKey] = (waterByDate[dateKey] ?? 0) + intake;
      debugPrint(
          'Water on $dateKey: $intake ml (total: ${waterByDate[dateKey]})');
    }

    // Aggregate steps by date
    for (var step in stepData) {
      final date = step['date'] as DateTime;
      final dateKey = _formatDateKey(date);
      // Support both 'totalSteps' (new system) and 'steps' (old system)
      final steps =
          (step['totalSteps'] as int?) ?? (step['steps'] as int?) ?? 0;
      stepsByDate[dateKey] = (stepsByDate[dateKey] ?? 0) + steps;
      debugPrint('Steps on $dateKey: $steps (total: ${stepsByDate[dateKey]})');
    }

    // Get weight by date (use latest entry for each day)
    for (var weight in weightData) {
      final date = weight['date'] as DateTime;
      final dateKey = _formatDateKey(date);
      weightByDate[dateKey] = (weight['weight'] as num?)?.toDouble() ?? 0.0;
    }

    // Build chart data for last 14 days
    final List<int> xValues = [];
    final List<int> calorieYValues = [];
    final List<int> waterYValues = [];
    final List<int> stepYValues = [];
    final List<int> weightYValues = [];

    // Initialize with last weight before the period, if available
    double? lastWeight = lastWeightBefore != null
        ? (lastWeightBefore['weight'] as num?)?.toDouble()
        : null;

    for (int i = 13; i >= 0; i--) {
      final date = endDate.subtract(Duration(days: i));
      final dateKey = _formatDateKey(date);

      xValues.add(date.day);
      calorieYValues.add(caloriesByDate[dateKey] ?? 0);
      waterYValues.add(waterByDate[dateKey] ?? 0);
      stepYValues.add(stepsByDate[dateKey] ?? 0);

      // For weight, use the value for this date if available, otherwise carry forward last weight
      if (weightByDate.containsKey(dateKey) && weightByDate[dateKey]! > 0) {
        lastWeight = weightByDate[dateKey];
      }
      weightYValues.add((lastWeight ?? 0.0).round());
    }

    debugPrint('Daily chart data loaded: ${xValues.length} days');
    debugPrint('Calories: $calorieYValues');
    debugPrint('Water: $waterYValues');
    debugPrint('Steps: $stepYValues');
    debugPrint('Weight: $weightYValues');

    return ChartStruct(
      calorie: ChartValuesStruct(xValues: xValues, yValues: calorieYValues),
      water: ChartValuesStruct(xValues: xValues, yValues: waterYValues),
      step: ChartValuesStruct(xValues: xValues, yValues: stepYValues),
      weight: ChartValuesStruct(xValues: xValues, yValues: weightYValues),
    );
  }

  /// Load weekly chart data (last 14 weeks)
  Future<ChartStruct> _loadWeeklyChartData(
      String userId, DateTime selectedDate) async {
    final endDate = selectedDate;
    final startDate =
        endDate.subtract(const Duration(days: 13 * 7)); // 13 weeks back

    debugPrint('Loading weekly data from $startDate to $endDate');

    // Fetch all data in parallel, including last weight before start date
    final results = await Future.wait([
      _mealService.getMealHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _waterService.getWaterIntakeHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _stepService.getStepHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _weightService.getWeightHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _weightService.getLastWeightBefore(userId: userId, beforeDate: startDate),
    ]);

    final meals = results[0] as List<Map<String, dynamic>>;
    final waterData = results[1] as List<Map<String, dynamic>>;
    final stepData = results[2] as List<Map<String, dynamic>>;
    final weightData = results[3] as List<Map<String, dynamic>>;
    final lastWeightBefore = results[4] as Map<String, dynamic>?;

    // Create maps for quick lookup by week
    final caloriesByWeek = <int, int>{};
    final waterByWeek = <int, int>{};
    final stepsByWeek = <int, int>{};
    final weightByWeek = <int, double>{};
    final weightDateByWeek =
        <int, DateTime>{}; // Track date of weight entry to get the latest

    // Helper function to get week number from date
    int getWeekNumber(DateTime date) {
      final diff = endDate.difference(date).inDays;
      return diff ~/ 7;
    }

    // Aggregate calories by week
    for (var meal in meals) {
      final date = meal['date'] as DateTime;
      final weekNum = getWeekNumber(date);
      if (weekNum >= 0 && weekNum < 14) {
        caloriesByWeek[weekNum] = (caloriesByWeek[weekNum] ?? 0) +
            ((meal['totalCalories'] as int?) ?? 0);
      }
    }

    // Aggregate water by week
    for (var water in waterData) {
      final date = water['date'] as DateTime;
      final weekNum = getWeekNumber(date);
      if (weekNum >= 0 && weekNum < 14) {
        // Support both 'totalIntake' (new system) and 'intake' (old system)
        final intake =
            (water['totalIntake'] as int?) ?? (water['intake'] as int?) ?? 0;
        waterByWeek[weekNum] = (waterByWeek[weekNum] ?? 0) + intake;
      }
    }

    // Aggregate steps by week
    for (var step in stepData) {
      final date = step['date'] as DateTime;
      final weekNum = getWeekNumber(date);
      if (weekNum >= 0 && weekNum < 14) {
        // Support both 'totalSteps' (new system) and 'steps' (old system)
        final steps =
            (step['totalSteps'] as int?) ?? (step['steps'] as int?) ?? 0;
        stepsByWeek[weekNum] = (stepsByWeek[weekNum] ?? 0) + steps;
      }
    }

    // Track latest weight entry per week
    for (var weight in weightData) {
      final date = weight['date'] as DateTime;
      final weekNum = getWeekNumber(date);
      if (weekNum >= 0 && weekNum < 14) {
        // Only update if this is a later date in the week or first entry
        if (!weightDateByWeek.containsKey(weekNum) ||
            date.isAfter(weightDateByWeek[weekNum]!)) {
          weightByWeek[weekNum] = (weight['weight'] as num?)?.toDouble() ?? 0.0;
          weightDateByWeek[weekNum] = date;
        }
      }
    }

    // Build chart data for last 14 weeks
    final List<int> xValues = [];
    final List<int> calorieYValues = [];
    final List<int> waterYValues = [];
    final List<int> stepYValues = [];
    final List<int> weightYValues = [];

    // Initialize with last weight before the period, if available
    double? lastWeight = lastWeightBefore != null
        ? (lastWeightBefore['weight'] as num?)?.toDouble()
        : null;

    for (int i = 13; i >= 0; i--) {
      xValues.add(14 - i); // Week number 1-14
      calorieYValues.add(caloriesByWeek[i] ?? 0);
      waterYValues.add(waterByWeek[i] ?? 0);
      stepYValues.add(stepsByWeek[i] ?? 0);

      // Use latest weight for the week, or carry forward last weight
      if (weightByWeek.containsKey(i) && weightByWeek[i]! > 0) {
        lastWeight = weightByWeek[i];
      }
      weightYValues.add((lastWeight ?? 0.0).round());
    }

    debugPrint('Weekly chart data loaded: ${xValues.length} weeks');

    return ChartStruct(
      calorie: ChartValuesStruct(xValues: xValues, yValues: calorieYValues),
      water: ChartValuesStruct(xValues: xValues, yValues: waterYValues),
      step: ChartValuesStruct(xValues: xValues, yValues: stepYValues),
      weight: ChartValuesStruct(xValues: xValues, yValues: weightYValues),
    );
  }

  /// Load monthly chart data (last 12 months)
  Future<ChartStruct> _loadMonthlyChartData(
      String userId, DateTime selectedDate) async {
    final endDate = DateTime(selectedDate.year, selectedDate.month + 1,
        0); // Last day of current month
    final startDate = DateTime(selectedDate.year - 1, selectedDate.month,
        1); // First day 12 months ago

    debugPrint('Loading monthly data from $startDate to $endDate');

    // Fetch all data in parallel, including last weight before start date
    final results = await Future.wait([
      _mealService.getMealHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _waterService.getWaterIntakeHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _stepService.getStepHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _weightService.getWeightHistory(
          userId: userId, startDate: startDate, endDate: endDate),
      _weightService.getLastWeightBefore(userId: userId, beforeDate: startDate),
    ]);

    final meals = results[0] as List<Map<String, dynamic>>;
    final waterData = results[1] as List<Map<String, dynamic>>;
    final stepData = results[2] as List<Map<String, dynamic>>;
    final weightData = results[3] as List<Map<String, dynamic>>;
    final lastWeightBefore = results[4] as Map<String, dynamic>?;

    // Create maps for quick lookup by month
    final caloriesByMonth = <String, int>{};
    final waterByMonth = <String, int>{};
    final stepsByMonth = <String, int>{};
    final weightByMonth = <String, double>{};
    final weightDateByMonth =
        <String, DateTime>{}; // Track date of weight entry to get the latest

    // Helper function to get month key
    String getMonthKey(DateTime date) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}';
    }

    // Aggregate calories by month
    for (var meal in meals) {
      final date = meal['date'] as DateTime;
      final monthKey = getMonthKey(date);
      caloriesByMonth[monthKey] = (caloriesByMonth[monthKey] ?? 0) +
          ((meal['totalCalories'] as int?) ?? 0);
    }

    // Aggregate water by month
    for (var water in waterData) {
      final date = water['date'] as DateTime;
      final monthKey = getMonthKey(date);
      // Support both 'totalIntake' (new system) and 'intake' (old system)
      final intake =
          (water['totalIntake'] as int?) ?? (water['intake'] as int?) ?? 0;
      waterByMonth[monthKey] = (waterByMonth[monthKey] ?? 0) + intake;
    }

    // Aggregate steps by month
    for (var step in stepData) {
      final date = step['date'] as DateTime;
      final monthKey = getMonthKey(date);
      // Support both 'totalSteps' (new system) and 'steps' (old system)
      final steps =
          (step['totalSteps'] as int?) ?? (step['steps'] as int?) ?? 0;
      stepsByMonth[monthKey] = (stepsByMonth[monthKey] ?? 0) + steps;
    }

    // Track latest weight entry per month
    for (var weight in weightData) {
      final date = weight['date'] as DateTime;
      final monthKey = getMonthKey(date);
      // Only update if this is a later date in the month or first entry
      if (!weightDateByMonth.containsKey(monthKey) ||
          date.isAfter(weightDateByMonth[monthKey]!)) {
        weightByMonth[monthKey] = (weight['weight'] as num?)?.toDouble() ?? 0.0;
        weightDateByMonth[monthKey] = date;
      }
    }

    // Build chart data for last 12 months
    final List<int> xValues = [];
    final List<int> calorieYValues = [];
    final List<int> waterYValues = [];
    final List<int> stepYValues = [];
    final List<int> weightYValues = [];

    // Initialize with last weight before the period, if available
    double? lastWeight = lastWeightBefore != null
        ? (lastWeightBefore['weight'] as num?)?.toDouble()
        : null;

    for (int i = 11; i >= 0; i--) {
      final monthDate = DateTime(selectedDate.year, selectedDate.month - i, 1);
      final monthKey = getMonthKey(monthDate);

      xValues.add(monthDate.month); // Month number 1-12
      calorieYValues.add(caloriesByMonth[monthKey] ?? 0);
      waterYValues.add(waterByMonth[monthKey] ?? 0);
      stepYValues.add(stepsByMonth[monthKey] ?? 0);

      // Use latest weight for the month, or carry forward last weight
      if (weightByMonth.containsKey(monthKey) && weightByMonth[monthKey]! > 0) {
        lastWeight = weightByMonth[monthKey];
      }
      weightYValues.add((lastWeight ?? 0.0).round());
    }

    debugPrint('Monthly chart data loaded: ${xValues.length} months');

    return ChartStruct(
      calorie: ChartValuesStruct(xValues: xValues, yValues: calorieYValues),
      water: ChartValuesStruct(xValues: xValues, yValues: waterYValues),
      step: ChartValuesStruct(xValues: xValues, yValues: stepYValues),
      weight: ChartValuesStruct(xValues: xValues, yValues: weightYValues),
    );
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
