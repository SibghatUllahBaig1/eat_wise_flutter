import '/flutter_flow/flutter_flow_util.dart';
import 'onboarding_step3_widget.dart' show OnboardingStep3Widget;
import 'package:flutter/material.dart';

class OnboardingStep3Model extends FlutterFlowModel<OnboardingStep3Widget> {
  // State fields
  FocusNode? heightFocusNode;
  TextEditingController? heightController;
  
  FocusNode? weightFocusNode;
  TextEditingController? weightController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    heightFocusNode?.dispose();
    heightController?.dispose();
    
    weightFocusNode?.dispose();
    weightController?.dispose();
  }
}

