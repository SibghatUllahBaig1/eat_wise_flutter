import 'package:eat_wise/app_state.dart';
import 'package:eat_wise/backend/schema/structs/index.dart';
import 'package:eat_wise/backend/services/weight_sync_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FFAppState.reset();
    await FFAppState().initializePersistedState();
    FFAppState().updateUserProfileStruct((p) => p..weightKg = 80);
    FFAppState().updateTrackerSettingsStruct((s) {
      s.updateWeight((w) => w..currentWeight = 75);
    });
  });

  test('resolveCurrentWeightKg prefers latest tracker entry', () {
    FFAppState().updateTrackerStruct((t) {
      t.weight.addAll([
        TrackerValueStruct(
          date: DateTime(2026, 5, 20),
          value: 78,
          unit: 'kg',
        ),
        TrackerValueStruct(
          date: DateTime(2026, 5, 24),
          value: 82,
          unit: 'kg',
        ),
      ]);
    });

    expect(WeightSyncHelper.resolveCurrentWeightKg(), 82);
  });

  test('resolveCurrentWeightKg falls back to profile then settings', () {
    expect(WeightSyncHelper.resolveCurrentWeightKg(), 80);

    FFAppState().updateUserProfileStruct((p) => p..weightKg = 0);
    expect(WeightSyncHelper.resolveCurrentWeightKg(), 75);
  });

  test('recordWeight syncs profile and settings', () async {
    await WeightSyncHelper.recordWeight(
      userId: '',
      weightKg: 90,
      date: DateTime(2026, 5, 25),
      persistFirestore: false,
      persistProfile: false,
    );

    expect(WeightSyncHelper.resolveCurrentWeightKg(), 90);
    expect(FFAppState().userProfile.weightKg, 90);
    expect(FFAppState().trackerSettings.weight.currentWeight, 90);
    expect(
      WeightSyncHelper.weightKgForDate(DateTime(2026, 5, 25)),
      90,
    );
  });

  test('propagateCanonicalCurrentWeight aligns stores from tracker', () {
    FFAppState().updateTrackerStruct((t) {
      t.weight.add(
        TrackerValueStruct(
          date: DateTime(2026, 5, 25),
          value: 88,
          unit: 'kg',
        ),
      );
    });
    FFAppState().updateUserProfileStruct((p) => p..weightKg = 70);
    FFAppState().updateTrackerSettingsStruct((s) {
      s.updateWeight((w) => w..currentWeight = 70);
    });

    WeightSyncHelper.propagateCanonicalCurrentWeight();

    expect(FFAppState().userProfile.weightKg, 88);
    expect(FFAppState().trackerSettings.weight.currentWeight, 88);
  });
}
