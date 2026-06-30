import '/app_state.dart';
import '/backend/firestore/weight_tracker_service.dart';
import '/backend/schema/structs/index.dart';
import '/backend/services/weight_sync_helper.dart';

/// Keeps onboarding/profile data in sync with tracker settings and weight history.
class ProfileSyncHelper {
  ProfileSyncHelper._();

  static int deriveGoalWeightKg(String goal, double currentWeightKg) {
    final current = currentWeightKg.round();
    final goalLower = goal.toLowerCase();
    if (goalLower.contains('lose')) {
      return (currentWeightKg - 5).round().clamp(30, current);
    }
    if (goalLower.contains('gain')) {
      return (currentWeightKg + 5).round();
    }
    return current;
  }

  /// Apply [profile] to local tracker settings and weight list.
  static void applyProfileToTrackerState(UserProfileStruct profile) {
    if (profile.weightKg <= 0 || profile.heightCm <= 0) return;

    final goalWeight = deriveGoalWeightKg(profile.goal, profile.weightKg);
    final heightInt = profile.heightCm.round();
    final currentInt = profile.weightKg.round();
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    FFAppState().updateTrackerSettingsStruct((settings) {
      settings.updateWeight((w) {
        w.height = heightInt;
        w.currentWeight = currentInt;
        w.goalWeight = goalWeight;
      });
      if (profile.dailyCalorieGoal > 0) {
        settings.updateCalorie((c) {
          c.goal = profile.dailyCalorieGoal;
        });
      }
    });

    WeightSyncHelper.upsertLocalWeightEntry(
      date: normalizedToday,
      weightKg: profile.weightKg,
    );
    WeightSyncHelper.propagateCanonicalCurrentWeight();
  }

  /// Persist profile-derived weight to Firestore for today.
  static Future<void> seedWeightTrackerFromProfile({
    required String userId,
    required UserProfileStruct profile,
  }) async {
    if (userId.isEmpty || profile.weightKg <= 0) return;

    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final goalWeight = deriveGoalWeightKg(profile.goal, profile.weightKg);

    await WeightTrackerService().addOrUpdateWeight(
      userId: userId,
      date: normalizedToday,
      weight: profile.weightKg,
      startWeight: profile.weightKg,
      goalWeight: goalWeight.toDouble(),
    );
  }

  /// Load profile from struct into FFAppState and propagate to trackers.
  static void hydrateFromProfile(UserProfileStruct profile) {
    FFAppState().userProfile = profile;
    if (profile.onboardingCompleted) {
      applyProfileToTrackerState(profile);
    }
  }
}
