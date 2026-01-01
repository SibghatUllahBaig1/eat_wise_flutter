import '/backend/schema/structs/index.dart';
import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/z_current_weight/z_current_weight_widget.dart';
import '/profile/components/z_goal_weight/z_goal_weight_widget.dart';
import '/profile/components/z_height/z_height_widget.dart';
import '/profile/components/z_height_unit/z_height_unit_widget.dart';
import '/profile/components/z_reminder_time/z_reminder_time_widget.dart';
import '/profile/components/z_repeat/z_repeat_widget.dart';
import '/profile/components/z_ringtone/z_ringtone_widget.dart';
import '/profile/components/z_weight_unit/z_weight_unit_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'weight_tracker_widget.dart' show WeightTrackerWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WeightTrackerModel extends FlutterFlowModel<WeightTrackerWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel1;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel2;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel3;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel4;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel5;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel1;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel2;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel6;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel7;
  // State field(s) for Slider widget.
  double? sliderValue;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel3;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel4;

  @override
  void initState(BuildContext context) {
    textTextRightModel1 = createModel(context, () => TextTextRightModel());
    textTextRightModel2 = createModel(context, () => TextTextRightModel());
    textTextRightModel3 = createModel(context, () => TextTextRightModel());
    textTextRightModel4 = createModel(context, () => TextTextRightModel());
    textTextRightModel5 = createModel(context, () => TextTextRightModel());
    textSwitchModel1 = createModel(context, () => TextSwitchModel());
    textSwitchModel2 = createModel(context, () => TextSwitchModel());
    textTextRightModel6 = createModel(context, () => TextTextRightModel());
    textTextRightModel7 = createModel(context, () => TextTextRightModel());
    textSwitchModel3 = createModel(context, () => TextSwitchModel());
    textSwitchModel4 = createModel(context, () => TextSwitchModel());
  }

  @override
  void dispose() {
    textTextRightModel1.dispose();
    textTextRightModel2.dispose();
    textTextRightModel3.dispose();
    textTextRightModel4.dispose();
    textTextRightModel5.dispose();
    textSwitchModel1.dispose();
    textSwitchModel2.dispose();
    textTextRightModel6.dispose();
    textTextRightModel7.dispose();
    textSwitchModel3.dispose();
    textSwitchModel4.dispose();
  }
}
