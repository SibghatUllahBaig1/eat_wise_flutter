import '/app_state.dart';
import '/backend/schema/structs/index.dart';
import '/backend/services/pedometer_service.dart';
import '/backend/utils/date_utils.dart';

/// Ensures tracker dates roll forward and step data refreshes on resume/midnight.
class AppDayService {
  AppDayService._();
  static final AppDayService instance = AppDayService._();

  /// Calendar date selection is session-only — always snap back to today.
  void resetSelectedDateToToday() {
    final today = normalizeToDate(DateTime.now());
    FFAppState().updateTrackerStruct((t) {
      t.currentDate = today;
      t.selectedDate = today;
    });
    FFAppState().update(() {});
  }

  void checkDayRollover({String? userId}) {
    resetSelectedDateToToday();

    if (userId != null && userId.isNotEmpty) {
      PedometerService().refreshTodaySteps(userId);
    }
  }
}
