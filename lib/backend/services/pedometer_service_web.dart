import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Web stub for PedometerService
/// Pedometer functionality is not available on web
class PedometerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    debugPrint('PedometerService (Web Stub): Pedometer not available on web');
  }

  Future<void> startListening(String userId) async {
    debugPrint('PedometerService (Web Stub): Cannot start listening on web');
  }

  void stopListening() {
    debugPrint('PedometerService (Web Stub): Cannot stop listening on web');
  }

  Future<int> getTodaySteps(String userId) async {
    return 0;
  }

  Future<void> refreshTodaySteps(String userId) async {
    debugPrint('PedometerService (Web Stub): refreshTodaySteps not available');
  }

  Future<void> refreshStepsForDate(String userId, DateTime date) async {
    debugPrint('PedometerService (Web Stub): refreshStepsForDate not available');
  }

  Future<void> requestPermission() async {
    debugPrint('PedometerService (Web Stub): No permissions needed on web');
  }

  void dispose() {
    stopListening();
  }
}

