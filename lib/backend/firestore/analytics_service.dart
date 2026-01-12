import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';
import 'meal_service.dart';
import 'water_tracker_service.dart';
import 'weight_tracker_service.dart';
import 'step_tracker_service.dart';

/// Service for aggregating and analyzing user data
class AnalyticsService extends FirestoreService {
  final MealService _mealService = MealService();
  final WaterTrackerService _waterService = WaterTrackerService();
  final WeightTrackerService _weightService = WeightTrackerService();
  final StepTrackerService _stepService = StepTrackerService();

  /// Get comprehensive dashboard data for a specific date
  Future<Map<String, dynamic>> getDashboardData({
    required String userId,
    required DateTime date,
  }) async {
    try {
      // Fetch all data in parallel
      final results = await Future.wait<dynamic>([
        _mealService.getMealsByDate(userId: userId, date: date),
        _mealService.getDailyNutritionSummary(userId: userId, date: date),
        _waterService.getWaterIntake(userId: userId, date: date),
        _stepService.getStepSummary(userId: userId, date: date),
        _weightService.getLatestWeight(userId: userId),
      ]);

      return {
        'meals': results[0],
        'nutrition': results[1],
        'water': results[2],
        'steps': results[3],
        'latestWeight': results[4],
        'activeGoal': null, // Goals sync removed - GoalsService was deleted
        'date': date,
      };
    } catch (e) {
      throw Exception('Failed to get dashboard data: $e');
    }
  }

  /// Get weekly nutrition summary
  Future<Map<String, dynamic>> getWeeklySummary({
    required String userId,
    required DateTime startDate,
  }) async {
    try {
      final endDate = startDate.add(Duration(days: 7));

      final meals = await _mealService.getMealHistory(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );

      // Aggregate by day
      final dailyData = <String, Map<String, dynamic>>{};

      for (var meal in meals) {
        final dateKey = _formatDateKey(meal['date'] as DateTime);

        if (!dailyData.containsKey(dateKey)) {
          dailyData[dateKey] = {
            'date': meal['date'],
            'calories': 0.0,
            'carbs': 0.0,
            'protein': 0.0,
            'fat': 0.0,
            'mealCount': 0,
          };
        }

        dailyData[dateKey]!['calories'] += (meal['totalCalories'] ?? 0.0);
        dailyData[dateKey]!['carbs'] += (meal['totalCarbs'] ?? 0.0);
        dailyData[dateKey]!['protein'] += (meal['totalProtein'] ?? 0.0);
        dailyData[dateKey]!['fat'] += (meal['totalFat'] ?? 0.0);
        dailyData[dateKey]!['mealCount'] += 1;
      }

      // Calculate averages
      final days = dailyData.values.toList();
      final avgCalories = days.isEmpty
          ? 0.0
          : days.map((d) => d['calories'] as double).reduce((a, b) => a + b) /
              days.length;
      final avgCarbs = days.isEmpty
          ? 0.0
          : days.map((d) => d['carbs'] as double).reduce((a, b) => a + b) /
              days.length;
      final avgProtein = days.isEmpty
          ? 0.0
          : days.map((d) => d['protein'] as double).reduce((a, b) => a + b) /
              days.length;
      final avgFat = days.isEmpty
          ? 0.0
          : days.map((d) => d['fat'] as double).reduce((a, b) => a + b) /
              days.length;

      return {
        'dailyData': days,
        'averages': {
          'calories': avgCalories,
          'carbs': avgCarbs,
          'protein': avgProtein,
          'fat': avgFat,
        },
        'startDate': startDate,
        'endDate': endDate,
      };
    } catch (e) {
      throw Exception('Failed to get weekly summary: $e');
    }
  }

  /// Get monthly nutrition chart data
  Future<List<Map<String, dynamic>>> getMonthlyNutritionChart({
    required String userId,
    required DateTime month,
  }) async {
    try {
      final startDate = DateTime(month.year, month.month, 1);
      final endDate = DateTime(month.year, month.month + 1, 0);

      final meals = await _mealService.getMealHistory(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );

      // Aggregate by day
      final dailyData = <String, Map<String, dynamic>>{};

      for (var meal in meals) {
        final date = meal['date'] as DateTime;
        final dateKey = _formatDateKey(date);

        if (!dailyData.containsKey(dateKey)) {
          dailyData[dateKey] = {
            'day': date.day.toString(),
            'carbs': 0.0,
            'protein': 0.0,
            'fat': 0.0,
          };
        }

        dailyData[dateKey]!['carbs'] += (meal['totalCarbs'] ?? 0.0);
        dailyData[dateKey]!['protein'] += (meal['totalProtein'] ?? 0.0);
        dailyData[dateKey]!['fat'] += (meal['totalFat'] ?? 0.0);
      }

      return dailyData.values.toList()
        ..sort((a, b) => int.parse(a['day']).compareTo(int.parse(b['day'])));
    } catch (e) {
      throw Exception('Failed to get monthly nutrition chart: $e');
    }
  }

  /// Get weight progress chart data
  Future<List<Map<String, dynamic>>> getWeightProgressChart({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final weightHistory = await _weightService.getWeightHistory(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );

      return weightHistory.map((entry) {
        return {
          'date': entry['date'],
          'weight': entry['weight'],
          'unit': entry['unit'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get weight progress chart: $e');
    }
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
