import '/flutter_flow/flutter_flow_util.dart';
import 'onboarding_step2_widget.dart' show OnboardingStep2Widget;
import 'package:flutter/material.dart';

class OnboardingStep2Model extends FlutterFlowModel<OnboardingStep2Widget> {
  // State fields
  FocusNode? ageFocusNode;
  TextEditingController? ageController;
  
  String selectedGender = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    ageFocusNode?.dispose();
    ageController?.dispose();
  }
}

