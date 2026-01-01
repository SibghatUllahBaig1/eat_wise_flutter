import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/home_pages/components/z_manual_entry/z_manual_entry_widget.dart';
import 'dart:ui';
import 'z_select_scan_type_widget.dart' show ZSelectScanTypeWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZSelectScanTypeModel extends FlutterFlowModel<ZSelectScanTypeWidget> {
  ///  State fields for stateful widgets in this component.

  bool isDataUploading_uploadDataHjw = false;
  FFUploadedFile uploadedLocalFile_uploadDataHjw =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  bool isDataUploading_uploadDataCvf = false;
  FFUploadedFile uploadedLocalFile_uploadDataCvf =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
