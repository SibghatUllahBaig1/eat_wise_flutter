import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/profile/components/support_message/support_message_widget.dart';
import '/profile/components/user_message/user_message_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'support_widget.dart' show SupportWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SupportModel extends FlutterFlowModel<SupportWidget> {
  ///  Local state fields for this page.

  bool mealtime = false;

  ///  State fields for stateful widgets in this page.

  // Models for UserMessage dynamic component.
  late FlutterFlowDynamicModels<UserMessageModel> userMessageModels;
  // Models for SupportMessage dynamic component.
  late FlutterFlowDynamicModels<SupportMessageModel> supportMessageModels;
  bool isDataUploading_uploadDataX2f = false;
  FFUploadedFile uploadedLocalFile_uploadDataX2f =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {
    userMessageModels = FlutterFlowDynamicModels(() => UserMessageModel());
    supportMessageModels =
        FlutterFlowDynamicModels(() => SupportMessageModel());
  }

  @override
  void dispose() {
    userMessageModels.dispose();
    supportMessageModels.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
