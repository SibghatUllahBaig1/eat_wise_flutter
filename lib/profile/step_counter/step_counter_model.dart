import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'step_counter_widget.dart' show StepCounterWidget;
import 'package:flutter/material.dart';

class StepCounterModel extends FlutterFlowModel<StepCounterWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component (Step Goal).
  late TextTextRightModel textTextRightModel1;
  // Model for TextSwitch component (Walking Reminder toggle).
  late TextSwitchModel textSwitchModel1;
  // Model for TextTextRight component (Reminder Time).
  late TextTextRightModel textTextRightModel2;

  @override
  void initState(BuildContext context) {
    textTextRightModel1 = createModel(context, () => TextTextRightModel());
    textSwitchModel1 = createModel(context, () => TextSwitchModel());
    textTextRightModel2 = createModel(context, () => TextTextRightModel());
  }

  @override
  void dispose() {
    textTextRightModel1.dispose();
    textSwitchModel1.dispose();
    textTextRightModel2.dispose();
  }
}
