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

  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel1;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel2;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel3;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel4;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel5;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel6;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel7;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel8;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel9;

  @override
  void initState(BuildContext context) {
    zWeightCardModel1 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel2 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel3 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel4 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel5 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel6 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel7 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel8 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel9 = createModel(context, () => ZWeightCardModel());
  }

  @override
  void dispose() {
    zWeightCardModel1.dispose();
    zWeightCardModel2.dispose();
    zWeightCardModel3.dispose();
    zWeightCardModel4.dispose();
    zWeightCardModel5.dispose();
    zWeightCardModel6.dispose();
    zWeightCardModel7.dispose();
    zWeightCardModel8.dispose();
    zWeightCardModel9.dispose();
  }
}
