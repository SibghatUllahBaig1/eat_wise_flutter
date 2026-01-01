import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_activity_log_content/z_activity_log_content_widget.dart';
import '/home_pages/components/z_creat_activity/z_creat_activity_widget.dart';
import '/home_pages/components/z_quick_log_activity/z_quick_log_activity_widget.dart';
import 'dart:ui';
import 'z_activity_log_widget.dart' show ZActivityLogWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZActivityLogModel extends FlutterFlowModel<ZActivityLogWidget> {
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
  // Model for zActivityLogContent component.
  late ZActivityLogContentModel zActivityLogContentModel1;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for zActivityLogContent component.
  late ZActivityLogContentModel zActivityLogContentModel2;
  // Model for zActivityLogContent component.
  late ZActivityLogContentModel zActivityLogContentModel3;
  // Model for zActivityLogContent component.
  late ZActivityLogContentModel zActivityLogContentModel4;

  @override
  void initState(BuildContext context) {
    zActivityLogContentModel1 =
        createModel(context, () => ZActivityLogContentModel());
    zActivityLogContentModel2 =
        createModel(context, () => ZActivityLogContentModel());
    zActivityLogContentModel3 =
        createModel(context, () => ZActivityLogContentModel());
    zActivityLogContentModel4 =
        createModel(context, () => ZActivityLogContentModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    zActivityLogContentModel1.dispose();
    zActivityLogContentModel2.dispose();
    zActivityLogContentModel3.dispose();
    zActivityLogContentModel4.dispose();
  }
}
