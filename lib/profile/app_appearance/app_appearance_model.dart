import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'app_appearance_widget.dart' show AppAppearanceWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppAppearanceModel extends FlutterFlowModel<AppAppearanceWidget> {
  ///  Local state fields for this page.

  bool mealtime = false;

  ///  State fields for stateful widgets in this page.

  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel1;
  // Model for TextTextRight component.
  late TextTextRightModel textTextRightModel2;

  @override
  void initState(BuildContext context) {
    textTextRightModel1 = createModel(context, () => TextTextRightModel());
    textTextRightModel2 = createModel(context, () => TextTextRightModel());
  }

  @override
  void dispose() {
    textTextRightModel1.dispose();
    textTextRightModel2.dispose();
  }
}
