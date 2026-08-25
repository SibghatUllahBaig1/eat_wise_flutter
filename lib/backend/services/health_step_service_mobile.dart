import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:health/health.dart';

import '/backend/utils/date_utils.dart';

/// Reads step counts from Apple Health on iOS.
class HealthStepService {
  static final HealthStepService instance = HealthStepService._();
  HealthStepService._();

  static const EventChannel _stepEventsChannel =
      EventChannel('eat_wise/health_steps_events');

  final Health _health = Health();
  bool _configured = false;
  bool _authorizationRequested = false;
  Stream<void>? _stepCountChangesCache;

  /// Fires when HealthKit reports new step samples (HKObserverQuery).
  Stream<void> get stepCountChanges {
    if (!Platform.isIOS) return const Stream.empty();
    _stepCountChangesCache ??= _stepEventsChannel
        .receiveBroadcastStream()
        .map((_) => null)
        .cast<void>();
    return _stepCountChangesCache!;
  }

  static const _stepTypes = [HealthDataType.STEPS];
  static const _readPermissions = [HealthDataAccess.READ];

  /// Configure HealthKit and request read access once per app session.
  Future<bool> ensureAuthorized({bool requestIfNeeded = true}) async {
    if (!Platform.isIOS) return false;
    try {
      await _ensureConfigured();
      if (_authorizationRequested) {
        return true;
      }
      if (!requestIfNeeded) {
        return false;
      }

      final granted = await _health.requestAuthorization(
        _stepTypes,
        permissions: _readPermissions,
      );
      _authorizationRequested = true;
      debugPrint(
        'HealthStepService: authorization requested, granted=$granted',
      );
      return granted;
    } catch (e) {
      debugPrint('HealthStepService: authorization error: $e');
      return false;
    }
  }

  Future<bool> requestPermission() => ensureAuthorized(requestIfNeeded: true);

  Future<int?> getTodayStepCount() =>
      getStepCountForDate(DateTime.now());

  Future<int?> getStepCountForDate(DateTime date) async {
    if (!Platform.isIOS) return null;
    try {
      await _ensureConfigured();
      if (!_authorizationRequested) {
        await ensureAuthorized(requestIfNeeded: true);
      }

      final day = normalizeToDate(date);
      final now = DateTime.now();
      final today = normalizeToDate(now);
      final start = startOfDay(day);
      // Full calendar days use an exclusive end at the next midnight so
      // HealthKit includes the entire day in the local timezone.
      final end = isSameCalendarDay(day, today)
          ? now
          : start.add(const Duration(days: 1));

      var steps = await _health.getTotalStepsInInterval(start, end);

      // The interval API can return 0 for past days even when samples exist.
      final isPastDay = day.isBefore(today);
      if (steps == null || (isPastDay && steps == 0)) {
        final fromSamples = await _sumStepsFromSamples(start, end);
        if (fromSamples != null) {
          steps = fromSamples;
        }
      }

      debugPrint(
        'HealthStepService: ${start.toIso8601String().split('T').first} '
        'steps=$steps',
      );
      return steps;
    } catch (e) {
      debugPrint('HealthStepService: read error: $e');
      return null;
    }
  }

  Future<int?> _sumStepsFromSamples(DateTime start, DateTime end) async {
    try {
      final points = await _health.getHealthDataFromTypes(
        types: _stepTypes,
        startTime: start,
        endTime: end,
      );

      if (points.isEmpty) return 0;

      var total = 0;
      for (final point in points) {
        if (point.type != HealthDataType.STEPS) continue;
        final value = point.value;
        if (value is NumericHealthValue) {
          total += value.numericValue.round();
        }
      }
      return total;
    } catch (e) {
      debugPrint('HealthStepService: sample fallback error: $e');
      return null;
    }
  }

  Future<void> _ensureConfigured() async {
    if (_configured) return;
    await _health.configure();
    _configured = true;
  }
}
