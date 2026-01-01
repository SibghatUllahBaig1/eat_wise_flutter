import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/register/components/date_selector/date_selector_widget.dart';
import '/register/components/gender_info/gender_info_widget.dart';
import '/register/components/review/review_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'onboarding_widget.dart' show OnboardingWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class OnboardingModel extends FlutterFlowModel<OnboardingWidget> {
  ///  Local state fields for this page.

  GoalsStruct? goal;
  void updateGoalStruct(Function(GoalsStruct) updateFn) {
    updateFn(goal ??= GoalsStruct());
  }

  int? heightUnit = 0;

  String? weighsUnit = 'Kg';

  int? progressBar = 1;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for Weighs1 widget.
  FocusNode? weighs1FocusNode;
  TextEditingController? weighs1TextController;
  String? Function(BuildContext, String?)? weighs1TextControllerValidator;
  // State field(s) for Weighs2 widget.
  FocusNode? weighs2FocusNode;
  TextEditingController? weighs2TextController;
  String? Function(BuildContext, String?)? weighs2TextControllerValidator;
  // State field(s) for NewWeighs1 widget.
  FocusNode? newWeighs1FocusNode;
  TextEditingController? newWeighs1TextController;
  String? Function(BuildContext, String?)? newWeighs1TextControllerValidator;
  // State field(s) for NewWeighs2 widget.
  FocusNode? newWeighs2FocusNode;
  TextEditingController? newWeighs2TextController;
  String? Function(BuildContext, String?)? newWeighs2TextControllerValidator;
  // Models for Review dynamic component.
  late FlutterFlowDynamicModels<ReviewModel> reviewModels;

  @override
  void initState(BuildContext context) {
    reviewModels = FlutterFlowDynamicModels(() => ReviewModel());
  }

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    weighs1FocusNode?.dispose();
    weighs1TextController?.dispose();

    weighs2FocusNode?.dispose();
    weighs2TextController?.dispose();

    newWeighs1FocusNode?.dispose();
    newWeighs1TextController?.dispose();

    newWeighs2FocusNode?.dispose();
    newWeighs2TextController?.dispose();

    reviewModels.dispose();
  }
}
