import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import 'dart:ui';
import 'recipes_by_category_widget.dart' show RecipesByCategoryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecipesByCategoryModel extends FlutterFlowModel<RecipesByCategoryWidget> {
  ///  State fields for stateful widgets in this page.

  // Models for zRecipeCard dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCardModel> zRecipeCardModels;

  @override
  void initState(BuildContext context) {
    zRecipeCardModels = FlutterFlowDynamicModels(() => ZRecipeCardModel());
  }

  @override
  void dispose() {
    zRecipeCardModels.dispose();
  }
}
