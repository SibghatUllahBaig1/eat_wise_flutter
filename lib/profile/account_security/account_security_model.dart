import '/backend/schema/structs/index.dart';
import '/buttons/text_switch/text_switch_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'account_security_widget.dart' show AccountSecurityWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AccountSecurityModel extends FlutterFlowModel<AccountSecurityWidget> {
  ///  Local state fields for this page.

  bool mealtime = false;

  ///  State fields for stateful widgets in this page.

  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel1;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel2;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel3;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel4;

  @override
  void initState(BuildContext context) {
    textSwitchModel1 = createModel(context, () => TextSwitchModel());
    textSwitchModel2 = createModel(context, () => TextSwitchModel());
    textSwitchModel3 = createModel(context, () => TextSwitchModel());
    textSwitchModel4 = createModel(context, () => TextSwitchModel());
  }

  @override
  void dispose() {
    textSwitchModel1.dispose();
    textSwitchModel2.dispose();
    textSwitchModel3.dispose();
    textSwitchModel4.dispose();
  }
}
