import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'creat_plan_widget.dart' show CreatPlanWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class CreatPlanModel extends FlutterFlowModel<CreatPlanWidget> {
  ///  Local state fields for this page.

  bool analyze = false;

  bool calculate = false;

  bool predict = false;

  bool add = false;

  int? percent = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
