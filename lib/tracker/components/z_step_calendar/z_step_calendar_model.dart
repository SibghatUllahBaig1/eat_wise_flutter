import '/backend/schema/structs/index.dart';
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
