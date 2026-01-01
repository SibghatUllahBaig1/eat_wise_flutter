import '/buttons/icon_text_right/icon_text_right_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/profile/components/log_out/log_out_widget.dart';
import '/profile/components/rate_us/rate_us_widget.dart';
import '/profile/components/upgrade_plan/upgrade_plan_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  ///  Local state fields for this page.

  bool termPolicy = false;

  bool checkBox = false;

  int? pageItem = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel1;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel2;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel3;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel4;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel5;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel6;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel7;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel8;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel9;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel10;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel11;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel12;
  // Model for IconTextRight component.
  late IconTextRightModel iconTextRightModel13;
  // Model for zNawBar component.
  late ZNawBarModel zNawBarModel;

  @override
  void initState(BuildContext context) {
    iconTextRightModel1 = createModel(context, () => IconTextRightModel());
    iconTextRightModel2 = createModel(context, () => IconTextRightModel());
    iconTextRightModel3 = createModel(context, () => IconTextRightModel());
    iconTextRightModel4 = createModel(context, () => IconTextRightModel());
    iconTextRightModel5 = createModel(context, () => IconTextRightModel());
    iconTextRightModel6 = createModel(context, () => IconTextRightModel());
    iconTextRightModel7 = createModel(context, () => IconTextRightModel());
    iconTextRightModel8 = createModel(context, () => IconTextRightModel());
    iconTextRightModel9 = createModel(context, () => IconTextRightModel());
    iconTextRightModel10 = createModel(context, () => IconTextRightModel());
    iconTextRightModel11 = createModel(context, () => IconTextRightModel());
    iconTextRightModel12 = createModel(context, () => IconTextRightModel());
    iconTextRightModel13 = createModel(context, () => IconTextRightModel());
    zNawBarModel = createModel(context, () => ZNawBarModel());
  }

  @override
  void dispose() {
    iconTextRightModel1.dispose();
    iconTextRightModel2.dispose();
    iconTextRightModel3.dispose();
    iconTextRightModel4.dispose();
    iconTextRightModel5.dispose();
    iconTextRightModel6.dispose();
    iconTextRightModel7.dispose();
    iconTextRightModel8.dispose();
    iconTextRightModel9.dispose();
    iconTextRightModel10.dispose();
    iconTextRightModel11.dispose();
    iconTextRightModel12.dispose();
    iconTextRightModel13.dispose();
    zNawBarModel.dispose();
  }
}
