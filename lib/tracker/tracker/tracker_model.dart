import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/tracker/components/z_b_m_i_tracker/z_b_m_i_tracker_widget.dart';
import '/tracker/components/z_calendar/z_calendar_widget.dart';
import '/tracker/components/z_step_tracker/z_step_tracker_widget.dart';
import '/tracker/components/z_water_tracker/z_water_tracker_widget.dart';
import '/tracker/components/z_weight_tracker/z_weight_tracker_widget.dart';
import '/backend/firestore/sync_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'dart:math';
import 'dart:ui';
import 'tracker_widget.dart' show TrackerWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrackerModel extends FlutterFlowModel<TrackerWidget> {
  ///  Local state fields for this page.

  bool isDataLoaded = false;

  ///  State fields for stateful widgets in this page.

  // Model for zWaterTracker component.
  late ZWaterTrackerModel zWaterTrackerModel;
  // Model for zStepTracker component.
  late ZStepTrackerModel zStepTrackerModel;
  // Model for zWeightTracker component.
  late ZWeightTrackerModel zWeightTrackerModel;
  // Model for zBMITracker component.
  late ZBMITrackerModel zBMITrackerModel;
  // Model for zNawBar component.
  late ZNawBarModel zNawBarModel;

  @override
  void initState(BuildContext context) {
    zWaterTrackerModel = createModel(context, () => ZWaterTrackerModel());
    zStepTrackerModel = createModel(context, () => ZStepTrackerModel());
    zWeightTrackerModel = createModel(context, () => ZWeightTrackerModel());
    zBMITrackerModel = createModel(context, () => ZBMITrackerModel());
    zNawBarModel = createModel(context, () => ZNawBarModel());
  }

  @override
  void dispose() {
    zWaterTrackerModel.dispose();
    zStepTrackerModel.dispose();
    zWeightTrackerModel.dispose();
    zBMITrackerModel.dispose();
    zNawBarModel.dispose();
  }

  /// Load tracker data from Firestore
  Future<void> loadTrackerData(BuildContext context) async {
    if (currentUserUid.isEmpty) return;

    try {
      final appState = FFAppState();
      final syncService = SyncService();

      // Use currentDate (today) for main tracker screen
      // The main tracker screen always shows today's data
      final dateToLoad = appState.tracker.currentDate ?? DateTime.now();

      debugPrint('Loading tracker data for date: $dateToLoad');

      await syncService.loadTrackerData(
        userId: currentUserUid,
        date: dateToLoad,
      );
      isDataLoaded = true;

      debugPrint('Tracker data loaded successfully');
    } catch (e) {
      debugPrint('Error loading tracker data: $e');
    }
  }
}
