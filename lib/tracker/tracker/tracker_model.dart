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
import 'dart:math';
import 'dart:ui';
import 'tracker_widget.dart' show TrackerWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrackerModel extends FlutterFlowModel<TrackerWidget> {
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
}
