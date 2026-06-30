import '/app_state.dart';
import '/backend/backend_manager.dart';
import '/backend/firestore/weight_tracker_service.dart';
import '/backend/schema/structs/index.dart';

/// Keeps weight consistent across profile, tracker settings, daily log, and Firestore.
class WeightSyncHelper {
  WeightSyncHelper._();

  static DateTime normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Latest logged weight from tracker history (by date), or 0 if none.
  static double latestLoggedWeightKg() {
    final weightList = FFAppState().tracker.weight;
    if (weightList.isEmpty) return 0;

    final latest = weightList.reduce(
      (a, b) {
        final aDate = normalizeDate(a.date ?? DateTime(1970));
        final bDate = normalizeDate(b.date ?? DateTime(1970));
        return aDate.isAfter(bDate) ? a : b;
      },
    );
    return latest.value.toDouble();
  }

  /// Single resolved current weight (kg) for display and formulas.
  static double resolveCurrentWeightKg() {
    final fromTracker = latestLoggedWeightKg();
    if (fromTracker > 0) return fromTracker;

    final profileKg = FFAppState().userProfile.weightKg;
    if (profileKg > 0) return profileKg;

    final settingsKg =
        FFAppState().trackerSettings.weight.currentWeight.toDouble();
    if (settingsKg > 0) return settingsKg;

    return 0;
  }

  /// Weight logged for [date], or null if none.
  static double? weightKgForDate(DateTime date) {
    final normalized = normalizeDate(date);
    for (final entry in FFAppState().tracker.weight) {
      if (isSameDay(entry.date, normalized) && entry.value > 0) {
        return entry.value.toDouble();
      }
    }
    return null;
  }

  /// Upsert one day in local tracker history only.
  static void upsertLocalWeightEntry({
    required DateTime date,
    required double weightKg,
    double? progress,
  }) {
    final normalizedDate = normalizeDate(date);
    final weightInt = weightKg.round();

    FFAppState().updateTrackerStruct((tracker) {
      tracker.weight.removeWhere(
        (w) => isSameDay(w.date, normalizedDate),
      );
      tracker.weight.add(
        TrackerValueStruct(
          date: normalizedDate,
          value: weightInt,
          unit: 'kg',
          progress: progress ?? 0.0,
        ),
      );
    });
  }

  /// Align profile and tracker settings with the latest known weight.
  static void propagateCanonicalCurrentWeight() {
    final canonical = resolveCurrentWeightKg();
    if (canonical <= 0) return;

    final weightInt = canonical.round();
    FFAppState().updateUserProfileStruct(
      (profile) => profile..weightKg = canonical,
    );
    FFAppState().updateTrackerSettingsStruct(
      (settings) => settings.updateWeight(
        (w) => w..currentWeight = weightInt,
      ),
    );
  }

  /// Record weight for [date] and sync every store that shows "current weight".
  static Future<void> recordWeight({
    required String userId,
    required double weightKg,
    required DateTime date,
    bool persistFirestore = true,
    bool persistProfile = true,
  }) async {
    if (weightKg <= 0) return;

    final normalizedDate = normalizeDate(date);
    final goalWeight =
        FFAppState().trackerSettings.weight.goalWeight.toDouble();
    final startWeight = _oldestLoggedWeightKg();

    double? progress;
    if (startWeight != null &&
        goalWeight > 0 &&
        startWeight != goalWeight) {
      progress = ((weightKg - startWeight) / (goalWeight - startWeight))
          .clamp(0.0, 1.0);
    }

    upsertLocalWeightEntry(
      date: normalizedDate,
      weightKg: weightKg,
      progress: progress,
    );
    // Profile and settings always reflect the most recent logged date.
    propagateCanonicalCurrentWeight();

    if (!persistFirestore || userId.isEmpty) return;

    await WeightTrackerService().addOrUpdateWeight(
      userId: userId,
      date: normalizedDate,
      weight: weightKg,
      startWeight: startWeight,
      goalWeight: goalWeight > 0 ? goalWeight : null,
    );

    if (persistProfile) {
      await BackendManager().userService.saveUserProfileData(
        userId: userId,
        profile: FFAppState().userProfile,
      );
    }
  }

  static double? _oldestLoggedWeightKg() {
    final weightList = FFAppState().tracker.weight;
    if (weightList.isEmpty) return null;

    final oldest = weightList.reduce(
      (a, b) => (a.date?.isBefore(b.date ?? DateTime.now()) ?? false) ? a : b,
    );
    final value = oldest.value.toDouble();
    return value > 0 ? value : null;
  }
}
