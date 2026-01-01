import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/profile/components/select_gender/select_gender_widget.dart';
import '/register/components/date_selector/date_selector_widget.dart';
import 'dart:ui';
import 'edit_profile_widget.dart' show EditProfileWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class EditProfileModel extends FlutterFlowModel<EditProfileWidget> {
  ///  Local state fields for this page.

  bool rimender = true;

  bool vibration = false;

  bool stop = true;

  ///  State fields for stateful widgets in this page.

  bool isDataUploading_uploadData0i9 = false;
  FFUploadedFile uploadedLocalFile_uploadData0i9 =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for Email widget.
  FocusNode? emailFocusNode1;
  TextEditingController? emailTextController1;
  String? Function(BuildContext, String?)? emailTextController1Validator;
  // State field(s) for Email widget.
  FocusNode? emailFocusNode2;
  TextEditingController? emailTextController2;
  String? Function(BuildContext, String?)? emailTextController2Validator;
  // State field(s) for Email widget.
  FocusNode? emailFocusNode3;
  TextEditingController? emailTextController3;
  late MaskTextInputFormatter emailMask3;
  String? Function(BuildContext, String?)? emailTextController3Validator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode1?.dispose();
    emailTextController1?.dispose();

    emailFocusNode2?.dispose();
    emailTextController2?.dispose();

    emailFocusNode3?.dispose();
    emailTextController3?.dispose();
  }
}
