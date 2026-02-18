import 'dart:async';

/// Web stub for PedometerService
/// Pedometer functionality is not available on web
class PedometerService {
  static final PedometerService _instance = PedometerService._internal();
  factory PedometerService() => _instance;
  PedometerService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    print('PedometerService (Web Stub): Pedometer not available on web');
  }

  Future<void> startListening(String userId) async {
    print('PedometerService (Web Stub): Cannot start listening on web');
  }

  void stopListening() {
    print('PedometerService (Web Stub): Cannot stop listening on web');
  }

  Future<int> getTodaySteps(String userId) async {
    return 0;
  }

  Future<void> requestPermission() async {
    print('PedometerService (Web Stub): No permissions needed on web');
  }

  void dispose() {
    stopListening();
  }
}

