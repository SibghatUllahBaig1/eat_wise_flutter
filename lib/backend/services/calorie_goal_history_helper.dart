import '/app_state.dart';
import '/backend/backend_manager.dart';
import '/backend/firestore/calorie_goal_history_service.dart';

/// Shared entry points for recording calorie goal history.
class CalorieGoalHistoryHelper {
  CalorieGoalHistoryHelper._();

  static final _service = BackendManager().calorieGoalHistoryService;

  static int resolveCurrentCalorieGoal() {
    return FFAppState().userProfile.dailyCalorieGoal > 0
        ? FFAppState().userProfile.dailyCalorieGoal
        : (FFAppState().trackerSettings.calorie.goal > 0
            ? FFAppState().trackerSettings.calorie.goal
            : 2000);
  }

  static Future<void> recordGoalChange({
    required String userId,
    required int previousGoal,
    required int newGoal,
    String? goalType,
    DateTime? effectiveFrom,
  }) async {
    if (userId.isEmpty) return;
    await _service.recordGoalChange(
      userId: userId,
      previousGoal: previousGoal,
      newGoal: newGoal,
      goalType: goalType,
      effectiveFrom: effectiveFrom,
    );
  }

  static Future<void> seedInitialGoal({
    required String userId,
    required int dailyCalorieGoal,
    String? goalType,
    DateTime? effectiveFrom,
  }) async {
    if (userId.isEmpty) return;
    await _service.seedInitialGoal(
      userId: userId,
      dailyCalorieGoal: dailyCalorieGoal,
      goalType: goalType,
      effectiveFrom: effectiveFrom,
    );
  }

  static Future<List<CalorieGoalHistoryEntry>> fetchHistory(String userId) {
    if (userId.isEmpty) {
      return Future.value(const []);
    }
    return _service.fetchHistory(userId);
  }

  static int goalForDate({
    required List<CalorieGoalHistoryEntry> history,
    required DateTime date,
    int? fallback,
  }) {
    return CalorieGoalHistoryService.resolveGoalForDate(
      history,
      date,
      fallback ?? resolveCurrentCalorieGoal(),
    );
  }
}
