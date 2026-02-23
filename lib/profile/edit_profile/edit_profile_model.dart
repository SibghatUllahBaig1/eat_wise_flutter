import '/flutter_flow/flutter_flow_util.dart';
import 'edit_profile_widget.dart' show EditProfileWidget;
import 'package:flutter/material.dart';

class EditProfileModel extends FlutterFlowModel<EditProfileWidget> {
  ///  Local state fields for this page.

  bool rimender = true;

  bool vibration = false;

  bool stop = true;

  bool isLoading = false;

  String? selectedProfileImagePath;
  String? currentPhotoUrl;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Full Name widget.
  FocusNode? fullNameFocusNode;
  TextEditingController? fullNameTextController;
  String? Function(BuildContext, String?)? fullNameTextControllerValidator;

  // State field(s) for Email widget (read-only).
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  // State field(s) for Age widget.
  FocusNode? ageFocusNode;
  TextEditingController? ageTextController;
  String? Function(BuildContext, String?)? ageTextControllerValidator;

  // State field(s) for Gender selection.
  String? selectedGender;

  // State field(s) for Height widget.
  FocusNode? heightFocusNode;
  TextEditingController? heightTextController;
  String? Function(BuildContext, String?)? heightTextControllerValidator;

  // State field(s) for Weight widget.
  FocusNode? weightFocusNode;
  TextEditingController? weightTextController;
  String? Function(BuildContext, String?)? weightTextControllerValidator;

  // State field(s) for Goal selection.
  String? selectedGoal;

  // State field(s) for Activity Level selection.
  String? selectedActivityLevel;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    fullNameFocusNode?.dispose();
    fullNameTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    ageFocusNode?.dispose();
    ageTextController?.dispose();

    heightFocusNode?.dispose();
    heightTextController?.dispose();

    weightFocusNode?.dispose();
    weightTextController?.dispose();
  }
}
