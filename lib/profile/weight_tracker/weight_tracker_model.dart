import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'weight_tracker_widget.dart' show WeightTrackerWidget;
import 'package:flutter/material.dart';

class WeightTrackerModel extends FlutterFlowModel<WeightTrackerWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component (Current Weight).
  late TextTextRightModel textTextRightModel1;
  // Model for TextTextRight component (Goal Weight).
  late TextTextRightModel textTextRightModel2;
  // Model for TextTextRight component (Height).
  late TextTextRightModel textTextRightModel3;
  // Model for TextTextRight component (Weight Units).
  late TextTextRightModel textTextRightModel4;
  // Model for TextTextRight component (Height Units).
  late TextTextRightModel textTextRightModel5;
  // Model for TextSwitch component (BMI).
  late TextSwitchModel textSwitchModel1;
  // Model for TextSwitch component (Weight Logging Reminder toggle).
  late TextSwitchModel textSwitchModel2;
  // Model for TextTextRight component (Reminder Time).
  late TextTextRightModel textTextRightModel6;

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
  }
}
