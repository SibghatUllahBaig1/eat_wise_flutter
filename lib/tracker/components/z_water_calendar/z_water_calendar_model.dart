import '/app_state.dart';
import '/backend/firestore/water_tracker_service.dart';
import '/backend/services/water_sync_helper.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'z_water_calendar_widget.dart' show ZWaterCalendarWidget;
import 'package:flutter/material.dart';

class ZWaterCalendarModel extends FlutterFlowModel<ZWaterCalendarWidget> {
  ///  Local state fields for this component.

  DateTime? selectedMonthAndYear;

  bool showMore = false;

  double? size;

  /// Water progress data for visible dates (date string -> progress 0.0-1.0)
  Map<String, double> waterProgressByDate = {};

  final WaterTrackerService _waterTrackerService = WaterTrackerService();

  /// Load water progress for a list of dates
  Future<void> loadWaterProgressForDates(List<DateTime> dates) async {
    if (!loggedIn) return;

    for (final date in dates) {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      try {
        final data = await _waterTrackerService.getWaterIntake(
          userId: currentUserUid,
          date: date,
        );

        if (data != null) {
          final intake = data['totalIntake'] as int? ??
              data['intake'] as int? ??
              0;
          final progress = WaterSyncHelper.calculateWaterProgress(
            intake,
            FFAppState().trackerSettings.water.goal,
          );
          waterProgressByDate[dateKey] = progress.clamp(0.0, 1.0);
        } else {
          waterProgressByDate[dateKey] = 0.0;
        }
      } catch (e) {
        waterProgressByDate[dateKey] = 0.0;
      }
    }
  }

  /// Get progress for a specific date
  double getProgressForDate(DateTime date) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return waterProgressByDate[dateKey] ?? 0.0;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
