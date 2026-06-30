import '/app_state.dart';
import '/backend/firestore/water_tracker_service.dart';
import '/backend/schema/structs/index.dart';

/// Keeps FFAppState water totals in sync with Firestore after drink changes.
class WaterSyncHelper {
  WaterSyncHelper._();

  static DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static int waterIntakeMlForDate(DateTime date) {
    final normalized = normalizeDate(date);
    for (final entry in FFAppState().tracker.water) {
      if (isSameDay(entry.date, normalized)) {
        return entry.value;
      }
    }
    return 0;
  }

  static double waterProgressForDate(DateTime date) {
    final normalized = normalizeDate(date);
    for (final entry in FFAppState().tracker.water) {
      if (isSameDay(entry.date, normalized)) {
        return entry.progress;
      }
    }
    return 0.0;
  }

  static void upsertLocalWaterEntry({
    required DateTime date,
    required int intakeMl,
    required double progress,
  }) {
    final normalizedDate = normalizeDate(date);

    FFAppState().updateTrackerStruct((tracker) {
      tracker.water.removeWhere((w) => isSameDay(w.date, normalizedDate));
      tracker.water.add(
        TrackerValueStruct(
          date: normalizedDate,
          value: intakeMl,
          progress: progress,
        ),
      );
    });
  }

  /// Pull the latest daily total from Firestore into FFAppState.
  static Future<void> syncWaterForDate({
    required String userId,
    required DateTime date,
  }) async {
    if (userId.isEmpty) return;

    final normalizedDate = normalizeDate(date);
    final data = await WaterTrackerService().getWaterIntake(
      userId: userId,
      date: normalizedDate,
    );

    final intake = data?['totalIntake'] as int? ?? data?['intake'] as int? ?? 0;
    final progress = (data?['progress'] as num?)?.toDouble() ?? 0.0;

    upsertLocalWaterEntry(
      date: normalizedDate,
      intakeMl: intake,
      progress: progress,
    );
    FFAppState().update(() {});
  }
}
