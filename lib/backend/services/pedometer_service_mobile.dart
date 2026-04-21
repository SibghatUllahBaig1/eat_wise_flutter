import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/backend/firestore/step_tracker_service.dart';

/// Keys used in SharedPreferences for persisting pedometer state.
const _kBaselineDate = 'pedometer_baseline_date';
const _kBaselineSteps = 'pedometer_baseline_steps';
const _kAccumulated = 'pedometer_accumulated_steps';
const _kLastRaw = 'pedometer_last_raw_steps';

/// Real mobile implementation of the pedometer service.
///
/// The hardware step sensor provides a cumulative count since last boot.
/// This class converts that into "today's steps" by:
///   1. Saving a baseline (raw count at start of each new day).
///   2. Detecting reboots (raw < last-known → sensor reset to 0) and
///      carrying accumulated steps forward.
///   3. Throttling Firestore writes (at most once per [_syncThrottleSeconds]).
class PedometerService {
  static final PedometerService _instance = PedometerService._internal();
  factory PedometerService() => _instance;
  PedometerService._internal();

  final StepTrackerService _stepTrackerService = StepTrackerService();

  StreamSubscription<StepCount>? _stepSub;
  SharedPreferences? _prefs;

  bool _isInitialized = false;
  String? _userId;

  /// Steps counted today, kept in-memory for fast access.
  int _todaySteps = 0;

  /// Throttle: only write to Firestore every N seconds.
  static const int _syncThrottleSeconds = 30;
  DateTime? _lastSync;

  // ─────────────────────────────────────────────────────────────────────
  // Public API
  // ─────────────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_isInitialized) return;
    _prefs = await SharedPreferences.getInstance();
    _isInitialized = true;
  }

  Future<void> startListening(String userId) async {
    if (!_isInitialized) await initialize();
    _userId = userId;

    // Cancel any existing subscription before creating a new one.
    await _stepSub?.cancel();

    print('🦶 PedometerService: starting step stream for user $userId');

    _stepSub = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: _onStepCountError,
      cancelOnError: false,
    );
  }

  void stopListening() {
    _stepSub?.cancel();
    _stepSub = null;
    _userId = null;
  }

  /// Returns the cached in-memory today-step count.
  Future<int> getTodaySteps(String userId) async {
    return _todaySteps;
  }

  /// No-op on mobile; permission is handled by [PermissionService].
  Future<void> requestPermission() async {}

  void dispose() => stopListening();

  // ─────────────────────────────────────────────────────────────────────
  // Internal helpers
  // ─────────────────────────────────────────────────────────────────────

  void _onStepCount(StepCount event) {
    final rawSteps = event.steps;
    final prefs = _prefs;
    if (prefs == null) return;

    final todayStr = _dateStr(DateTime.now());
    final savedDate = prefs.getString(_kBaselineDate);

    int baseline;
    int accumulated;

    if (savedDate != todayStr) {
      // ── New calendar day: reset baseline ──────────────────────────────
      baseline = rawSteps;
      accumulated = 0;
      prefs.setString(_kBaselineDate, todayStr);
      prefs.setInt(_kBaselineSteps, baseline);
      prefs.setInt(_kAccumulated, accumulated);
      print('🦶 [NEW DAY] date=$todayStr | baseline set to $rawSteps');
    } else {
      baseline = prefs.getInt(_kBaselineSteps) ?? rawSteps;
      accumulated = prefs.getInt(_kAccumulated) ?? 0;

      if (rawSteps < baseline) {
        // ── Phone rebooted: sensor restarted from 0 (or near 0) ─────────
        final lastRaw = prefs.getInt(_kLastRaw) ?? baseline;
        final preReboot = (lastRaw - baseline).clamp(0, 9999999);
        accumulated += preReboot;
        baseline = rawSteps;
        prefs.setInt(_kBaselineSteps, baseline);
        prefs.setInt(_kAccumulated, accumulated);
        print(
            '🦶 [REBOOT] rawSteps=$rawSteps < baseline → pre-reboot=$preReboot | new accumulated=$accumulated');
      }
    }

    prefs.setInt(_kLastRaw, rawSteps);

    _todaySteps = (rawSteps - baseline + accumulated).clamp(0, 9999999);

    print(
      '🦶 [STEP EVENT] raw=$rawSteps | baseline=$baseline | accumulated=$accumulated | todaySteps=$_todaySteps | time=${event.timeStamp}',
    );

    _maybeSyncToFirestore();
  }

  void _onStepCountError(dynamic error) {
    // Sensor unavailable on this device or permission denied.
    print('🦶 [ERROR] PedometerService step stream error: $error');
  }

  Future<void> _maybeSyncToFirestore() async {
    final uid = _userId;
    if (uid == null || uid.isEmpty) return;

    final now = DateTime.now();
    if (_lastSync != null &&
        now.difference(_lastSync!).inSeconds < _syncThrottleSeconds) {
      return; // throttled
    }
    _lastSync = now;

    try {
      await _stepTrackerService.upsertPedometerEntry(
        userId: uid,
        date: now,
        steps: _todaySteps,
      );
    } catch (e) {
      print('PedometerService: Firestore sync error: $e');
    }
  }

  String _dateStr(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
}
