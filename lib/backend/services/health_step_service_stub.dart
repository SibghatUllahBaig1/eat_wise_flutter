/// Stub — HealthKit is iOS-only.
class HealthStepService {
  static final HealthStepService instance = HealthStepService._();
  HealthStepService._();

  Stream<void> get stepCountChanges => const Stream.empty();

  Future<bool> ensureAuthorized({bool requestIfNeeded = true}) async => false;

  Future<bool> requestPermission() async => false;

  Future<int?> getTodayStepCount() async => null;

  Future<int?> getStepCountForDate(DateTime date) async => null;
}
