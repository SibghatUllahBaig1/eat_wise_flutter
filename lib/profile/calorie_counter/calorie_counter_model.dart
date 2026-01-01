import '/backend/schema/structs/index.dart';
import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/z_calorie_intake_goal/z_calorie_intake_goal_widget.dart';
import '/profile/components/z_calorie_unit/z_calorie_unit_widget.dart';
import '/profile/components/z_reminder_time/z_reminder_time_widget.dart';
import '/profile/components/z_repeat/z_repeat_widget.dart';
import '/profile/components/z_ringtone/z_ringtone_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'calorie_counter_widget.dart' show CalorieCounterWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CalorieCounterModel extends FlutterFlowModel<CalorieCounterWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel1;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel2;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel1;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel3;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel4;
  // State field(s) for Slider widget.
  double? sliderValue;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel2;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel3;

  @override
  void initState(BuildContext context) {
    textTextRightModel1 = createModel(context, () => TextTextRightModel());
    textTextRightModel2 = createModel(context, () => TextTextRightModel());
    textSwitchModel1 = createModel(context, () => TextSwitchModel());
    textTextRightModel3 = createModel(context, () => TextTextRightModel());
    textTextRightModel4 = createModel(context, () => TextTextRightModel());
    textSwitchModel2 = createModel(context, () => TextSwitchModel());
    textSwitchModel3 = createModel(context, () => TextSwitchModel());
  }

  @override
  void dispose() {
    textTextRightModel1.dispose();
    textTextRightModel2.dispose();
    textSwitchModel1.dispose();
    textTextRightModel3.dispose();
    textTextRightModel4.dispose();
    textSwitchModel2.dispose();
    textSwitchModel3.dispose();
  }
}
