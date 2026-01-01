import '/backend/schema/structs/index.dart';
import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/title_description/title_description_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/dayoftheweek/dayoftheweek_widget.dart';
import 'dart:ui';
import 'notifications_settings_widget.dart' show NotificationsSettingsWidget;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationsSettingsModel
    extends FlutterFlowModel<NotificationsSettingsWidget> {
  ///  Local state fields for this page.

  bool mealtime = false;

  ///  State fields for stateful widgets in this page.

  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel1;
  // Model for TitleDescription component.
  late TitleDescriptionModel titleDescriptionModel1;
  DateTime? datePicked1;
  // Model for TitleDescription component.
  late TitleDescriptionModel titleDescriptionModel2;
  DateTime? datePicked2;
  // Model for TitleDescription component.
  late TitleDescriptionModel titleDescriptionModel3;
  DateTime? datePicked3;
  // Model for TitleDescription component.
  late TitleDescriptionModel titleDescriptionModel4;
  DateTime? datePicked4;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel2;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel3;
  // Model for TitleDescription component.
  late TitleDescriptionModel titleDescriptionModel5;
  DateTime? datePicked5;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel4;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel5;
  // Model for TextSwitch component.
  late TextSwitchModel textSwitchModel6;

  @override
  void initState(BuildContext context) {
    textSwitchModel1 = createModel(context, () => TextSwitchModel());
    titleDescriptionModel1 =
        createModel(context, () => TitleDescriptionModel());
    titleDescriptionModel2 =
        createModel(context, () => TitleDescriptionModel());
    titleDescriptionModel3 =
        createModel(context, () => TitleDescriptionModel());
    titleDescriptionModel4 =
        createModel(context, () => TitleDescriptionModel());
    textSwitchModel2 = createModel(context, () => TextSwitchModel());
    textSwitchModel3 = createModel(context, () => TextSwitchModel());
    titleDescriptionModel5 =
        createModel(context, () => TitleDescriptionModel());
    textSwitchModel4 = createModel(context, () => TextSwitchModel());
    textSwitchModel5 = createModel(context, () => TextSwitchModel());
    textSwitchModel6 = createModel(context, () => TextSwitchModel());
  }

  @override
  void dispose() {
    textSwitchModel1.dispose();
    titleDescriptionModel1.dispose();
    titleDescriptionModel2.dispose();
    titleDescriptionModel3.dispose();
    titleDescriptionModel4.dispose();
    textSwitchModel2.dispose();
    textSwitchModel3.dispose();
    titleDescriptionModel5.dispose();
    textSwitchModel4.dispose();
    textSwitchModel5.dispose();
    textSwitchModel6.dispose();
  }
}
