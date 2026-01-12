import '/backend/schema/structs/index.dart';
import '/backend/firestore/step_tracker_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'z_step_calendar_widget.dart' show ZStepCalendarWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ZStepCalendarModel extends FlutterFlowModel<ZStepCalendarWidget> {
  ///  Local state fields for this component.

  DateTime? selectedMonthAndYear;

  bool showMore = false;

  double? size;

  /// Step progress data for visible dates (date string -> progress 0.0-1.0)
  Map<String, double> stepProgressByDate = {};

  final StepTrackerService _stepTrackerService = StepTrackerService();

  /// Load step progress for a list of dates
  Future<void> loadStepProgressForDates(List<DateTime> dates) async {
    if (!loggedIn) return;

    for (final date in dates) {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      try {
        final data = await _stepTrackerService.getStepSummary(
          userId: currentUserUid,
          date: date,
        );

        if (data != null) {
          final progress = (data['progress'] as num?)?.toDouble() ?? 0.0;
          stepProgressByDate[dateKey] = progress.clamp(0.0, 1.0);
        } else {
          stepProgressByDate[dateKey] = 0.0;
        }
      } catch (e) {
        stepProgressByDate[dateKey] = 0.0;
      }
    }
  }

  /// Get progress for a specific date
  double getProgressForDate(DateTime date) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return stepProgressByDate[dateKey] ?? 0.0;
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
