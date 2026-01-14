import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_weight_card/z_weight_card_widget.dart';
import '/tracker/components/z_weight_tracker_edit/z_weight_tracker_edit_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'tracker_weight_widget.dart' show TrackerWeightWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class TrackerWeightModel extends FlutterFlowModel<TrackerWeightWidget> {
  ///  Local state fields for this page.

  int? pageItem = 0;

  bool calendar = false;

  TrackerValueStruct? selectedDay;
  void updateSelectedDayStruct(Function(TrackerValueStruct) updateFn) {
    updateFn(selectedDay ??= TrackerValueStruct());
  }

  bool play = false;

  ///  State fields for stateful widgets in this page.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
