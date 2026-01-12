import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'food_capture_widget.dart' show FoodCaptureWidget, CaptureMode;
import 'package:flutter/material.dart';

class FoodCaptureModel extends FlutterFlowModel<FoodCaptureWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for capture mode
  CaptureMode captureMode = CaptureMode.CAMERA;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // State field(s) for uploaded file
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String? uploadedFileUrl;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

