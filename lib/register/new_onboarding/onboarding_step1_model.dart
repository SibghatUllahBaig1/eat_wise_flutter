import '/flutter_flow/flutter_flow_util.dart';
import 'onboarding_step1_widget.dart' show OnboardingStep1Widget;
import 'package:flutter/material.dart';

class OnboardingStep1Model extends FlutterFlowModel<OnboardingStep1Widget> {
  // State fields
  FocusNode? nameFocusNode;
  TextEditingController? nameController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameController?.dispose();
  }
}
