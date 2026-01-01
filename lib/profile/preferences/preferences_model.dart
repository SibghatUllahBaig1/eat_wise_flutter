import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'preferences_widget.dart' show PreferencesWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PreferencesModel extends FlutterFlowModel<PreferencesWidget> {
  ///  Local state fields for this page.

  bool rimender = true;

  bool vibration = false;

  bool stop = true;

  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel1;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel2;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel3;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel4;

  @override
  void initState(BuildContext context) {
    textTextRightModel1 = createModel(context, () => TextTextRightModel());
    textTextRightModel2 = createModel(context, () => TextTextRightModel());
    textTextRightModel3 = createModel(context, () => TextTextRightModel());
    textTextRightModel4 = createModel(context, () => TextTextRightModel());
  }

  @override
  void dispose() {
    textTextRightModel1.dispose();
    textTextRightModel2.dispose();
    textTextRightModel3.dispose();
    textTextRightModel4.dispose();
  }
}
