import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_activity_templates_content/z_activity_templates_content_widget.dart';
import '/home_pages/components/z_creat_activity/z_creat_activity_widget.dart';
import 'dart:ui';
import 'z_activity_templates_widget.dart' show ZActivityTemplatesWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZActivityTemplatesModel
    extends FlutterFlowModel<ZActivityTemplatesWidget> {
  ///  Local state fields for this component.

  int? filter = 0;

  int? quantity = 0;

  FoodStruct? selectedFood;
  void updateSelectedFoodStruct(Function(FoodStruct) updateFn) {
    updateFn(selectedFood ??= FoodStruct());
  }

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for zActivityTemplatesContent component.
  late ZActivityTemplatesContentModel zActivityTemplatesContentModel1;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for zActivityTemplatesContent component.
  late ZActivityTemplatesContentModel zActivityTemplatesContentModel3;
  // Model for zActivityTemplatesContent component.
  late ZActivityTemplatesContentModel zActivityTemplatesContentModel4;

  @override
  void initState(BuildContext context) {
    zActivityTemplatesContentModel1 =
        createModel(context, () => ZActivityTemplatesContentModel());
    zActivityTemplatesContentModel3 =
        createModel(context, () => ZActivityTemplatesContentModel());
    zActivityTemplatesContentModel4 =
        createModel(context, () => ZActivityTemplatesContentModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    zActivityTemplatesContentModel1.dispose();
    zActivityTemplatesContentModel3.dispose();
    zActivityTemplatesContentModel4.dispose();
  }
}
