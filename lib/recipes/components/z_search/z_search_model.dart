import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_categories_wrap/z_categories_wrap_widget.dart';
import '/recipes/components/z_filter/z_filter_widget.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'z_search_widget.dart' show ZSearchWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZSearchModel extends FlutterFlowModel<ZSearchWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Models for zRecipeCard dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCardModel> zRecipeCardModels1;
  // Models for zRecipeCard dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCardModel> zRecipeCardModels2;
  // Model for zCategoriesWrap component.
  late ZCategoriesWrapModel zCategoriesWrapModel;
  // Models for zRecipeCard dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCardModel> zRecipeCardModels3;

  @override
  void initState(BuildContext context) {
    zRecipeCardModels1 = FlutterFlowDynamicModels(() => ZRecipeCardModel());
    zRecipeCardModels2 = FlutterFlowDynamicModels(() => ZRecipeCardModel());
    zCategoriesWrapModel = createModel(context, () => ZCategoriesWrapModel());
    zRecipeCardModels3 = FlutterFlowDynamicModels(() => ZRecipeCardModel());
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    zRecipeCardModels1.dispose();
    zRecipeCardModels2.dispose();
    zCategoriesWrapModel.dispose();
    zRecipeCardModels3.dispose();
  }
}
