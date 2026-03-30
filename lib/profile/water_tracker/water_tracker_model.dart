import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'water_tracker_widget.dart' show WaterTrackerWidget;
import 'package:flutter/material.dart';

class WaterTrackerModel extends FlutterFlowModel<WaterTrackerWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component (Water Intake Goal).
  late TextTextRightModel textTextRightModel1;
  // Model for TextTextRight component (cup units - unused but kept for slot).
  late TextTextRightModel textTextRightModel2;
  // Model for TextSwitch component (Drink Reminder toggle).
  late TextSwitchModel textSwitchModel1;
  // Model for TextTextRight component (Reminder Time).
  late TextTextRightModel textTextRightModel3;

  @override
  void initState(BuildContext context) {
    textTextRightModel1 = createModel(context, () => TextTextRightModel());
    textTextRightModel2 = createModel(context, () => TextTextRightModel());
    textSwitchModel1 = createModel(context, () => TextSwitchModel());
    textTextRightModel3 = createModel(context, () => TextTextRightModel());
  }

  @override
  void dispose() {
    textTextRightModel1.dispose();
    textTextRightModel2.dispose();
    textSwitchModel1.dispose();
    textTextRightModel3.dispose();
  }
}
