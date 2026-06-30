import 'dart:async';
import 'dart:io';

import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/app_state.dart';
import '/backend/firestore/step_tracker_service.dart';
import '/backend/schema/structs/index.dart';
import '/backend/services/health_step_service.dart';
import '/backend/utils/date_utils.dart';

const _kBaselineDate = 'pedometer_baseline_date';
const _kBaselineSteps = 'pedometer_baseline_steps';
const _kAccumulated = 'pedometer_accumulated_steps';
const _kLastRaw = 'pedometer_last_raw_steps';

class PedometerService {
  static final PedometerService _instance = PedometerService._internal();
  factory PedometerService() => _instance;
  PedometerService._internal();

  final StepTrackerService _stepTrackerService = StepTrackerService();
  final HealthStepService _healthSteps = HealthStepService.instance;

  StreamSubscription<StepCount>? _stepSub;
  Timer? _healthPollTimer;
  SharedPreferences? _prefs;

  bool _isInitialized = false;
  String? _userId;
  int _todaySteps = 0;

  static const int _syncThrottleSeconds = 30;
  DateTime? _lastSync;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  Future<void> startListening(String userId) async {
    if (!_isInitialized) await initialize();
    _userId = userId;

    await _stepSub?.cancel();
    _healthPollTimer?.cancel();

    if (Platform.isIOS) {
      await _healthSteps.ensureAuthorized(requestIfNeeded: false);
      await refreshTodaySteps(userId);
      _healthPollTimer = Timer.periodic(
        const Duration(seconds: 60),
        (_) => refreshTodaySteps(userId),
      );
    }

    _stepSub = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: false,
    );
  }

  void stopListening() {
    _stepSub?.cancel();
    _stepSub = null;
    _healthPollTimer?.cancel();
    _healthPollTimer = null;
    _userId = null;
  }

  Future<int> getTodaySteps(String userId) async {
    if (Platform.isIOS) {
      final healthSteps = await _healthSteps.getTodayStepCount();
      if (healthSteps != null) {
        _todaySteps = healthSteps;
        _pushStepsToAppState(healthSteps, normalizeToDate(DateTime.now()));
        return healthSteps;
      }
    }
    return _todaySteps;
  }

  Future<void> refreshTodaySteps(String userId) =>
      refreshStepsForDate(userId, DateTime.now());

  Future<void> refreshStepsForDate(String userId, DateTime date) async {
    _userId = userId;
    final day = normalizeToDate(date);

    if (Platform.isIOS) {
      final healthSteps = await _healthSteps.getStepCountForDate(day);
      if (healthSteps != null && healthSteps >= 0) {
        if (isSameCalendarDay(day, DateTime.now())) {
          _todaySteps = healthSteps;
        }
        _pushStepsToAppState(healthSteps, day);
        if (healthSteps > 0) {
          await _syncStepsToFirestore(
            healthSteps,
            date: day,
            force: true,
          );
        }
        return;
      }
    }

    if (isSameCalendarDay(day, DateTime.now())) {
      _pushStepsToAppState(_todaySteps, day);
    }
  }

  void onDayChanged() {
    final uid = _userId;
    if (uid != null && uid.isNotEmpty) {
      refreshTodaySteps(uid);
    }
  }

  Future<void> requestPermission() async {
    if (Platform.isIOS) {
      await _healthSteps.requestPermission();
    }
  }

  void dispose() => stopListening();

  void _onStepCount(StepCount event) {
    if (Platform.isIOS) {
      final uid = _userId;
      if (uid != null && uid.isNotEmpty) {
        refreshTodaySteps(uid);
      }
      return;
    }

    final rawSteps = event.steps;
    final prefs = _prefs;
    if (prefs == null) return;

    final todayStr = _dateStr(DateTime.now());
    final savedDate = prefs.getString(_kBaselineDate);

    int baseline;
    int accumulated;

    if (savedDate != todayStr) {
      baseline = rawSteps;
      accumulated = 0;
      prefs.setString(_kBaselineDate, todayStr);
      prefs.setInt(_kBaselineSteps, baseline);
      prefs.setInt(_kAccumulated, accumulated);
    } else {
      baseline = prefs.getInt(_kBaselineSteps) ?? rawSteps;
      accumulated = prefs.getInt(_kAccumulated) ?? 0;

      if (rawSteps < baseline) {
        final lastRaw = prefs.getInt(_kLastRaw) ?? baseline;
        final preReboot = (lastRaw - baseline).clamp(0, 9999999);
        accumulated += preReboot;
        baseline = rawSteps;
        prefs.setInt(_kBaselineSteps, baseline);
        prefs.setInt(_kAccumulated, accumulated);
      }
    }

    prefs.setInt(_kLastRaw, rawSteps);
    _todaySteps = (rawSteps - baseline + accumulated).clamp(0, 9999999);
    _pushStepsToAppState(_todaySteps, normalizeToDate(DateTime.now()));
    _maybeSyncToFirestore();
  }

  void _onStepCountError(dynamic error) {
    print('🦶 [ERROR] PedometerService step stream error: $error');
  }

  void _pushStepsToAppState(int steps, DateTime date) {
    final day = normalizeToDate(date);
    final goal = FFAppState().trackerSettings.step.goal;
    final progress = goal > 0 ? (steps / goal).clamp(0.0, 1.0) : 0.0;

    FFAppState().updateTrackerStruct((tracker) {
      if (isSameCalendarDay(day, DateTime.now())) {
        tracker.currentDate = day;
      }
      tracker.step.removeWhere((s) => isSameCalendarDay(s.date, day));
      tracker.step.add(TrackerValueStruct(
        date: day,
        value: steps,
        progress: progress,
      ));
    });
  }

  Future<void> _maybeSyncToFirestore() async {
    await _syncStepsToFirestore(
      _todaySteps,
      date: normalizeToDate(DateTime.now()),
      force: false,
    );
  }

  Future<void> _syncStepsToFirestore(
    int steps, {
    required DateTime date,
    required bool force,
  }) async {
    final uid = _userId;
    if (uid == null || uid.isEmpty) return;

    final now = DateTime.now();
    if (!force &&
        _lastSync != null &&
        now.difference(_lastSync!).inSeconds < _syncThrottleSeconds) {
      return;
    }
    _lastSync = now;

    try {
      await _stepTrackerService.upsertPedometerEntry(
        userId: uid,
        date: date,
        steps: steps,
      );
    } catch (e) {
      print('PedometerService: Firestore sync error: $e');
    }
  }

  String _dateStr(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
