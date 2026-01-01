import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_add_food_card/z_add_food_card_widget.dart';
import '/home_pages/components/z_creat_food/z_creat_food_widget.dart';
import '/home_pages/components/z_food_type/z_food_type_widget.dart';
import '/home_pages/components/z_quick_log_activity/z_quick_log_activity_widget.dart';
import '/home_pages/components/z_select_scan_type/z_select_scan_type_widget.dart';
import 'dart:ui';
import 'z_foods_widget.dart' show ZFoodsWidget;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZFoodsModel extends FlutterFlowModel<ZFoodsWidget> {
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
  // Models for zAddFoodCard dynamic component.
  late FlutterFlowDynamicModels<ZAddFoodCardModel> zAddFoodCardModels1;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Models for zAddFoodCard dynamic component.
  late FlutterFlowDynamicModels<ZAddFoodCardModel> zAddFoodCardModels2;
  // Models for zAddFoodCard dynamic component.
  late FlutterFlowDynamicModels<ZAddFoodCardModel> zAddFoodCardModels3;
  // Models for zAddFoodCard dynamic component.
  late FlutterFlowDynamicModels<ZAddFoodCardModel> zAddFoodCardModels4;

  @override
  void initState(BuildContext context) {
    zAddFoodCardModels1 = FlutterFlowDynamicModels(() => ZAddFoodCardModel());
    zAddFoodCardModels2 = FlutterFlowDynamicModels(() => ZAddFoodCardModel());
    zAddFoodCardModels3 = FlutterFlowDynamicModels(() => ZAddFoodCardModel());
    zAddFoodCardModels4 = FlutterFlowDynamicModels(() => ZAddFoodCardModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    zAddFoodCardModels1.dispose();
    zAddFoodCardModels2.dispose();
    zAddFoodCardModels3.dispose();
    zAddFoodCardModels4.dispose();
  }
}
