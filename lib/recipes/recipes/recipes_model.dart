import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/recipes/components/z_diets/z_diets_widget.dart';
import '/recipes/components/z_energy_wrap/z_energy_wrap_widget.dart';
import '/recipes/components/z_filter/z_filter_widget.dart';
import '/recipes/components/z_popular_categories/z_popular_categories_widget.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import '/recipes/components/z_recipe_card1/z_recipe_card1_widget.dart';
import '/recipes/components/z_recipe_card2/z_recipe_card2_widget.dart';
import '/recipes/components/z_search/z_search_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'recipes_widget.dart' show RecipesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecipesModel extends FlutterFlowModel<RecipesWidget> {
  ///  Local state fields for this page.

  bool termPolicy = false;

  bool checkBox = false;

  int? pageItem = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for zPopularCategories component.
  late ZPopularCategoriesModel zPopularCategoriesModel;
  // Models for zRecipeCard1 dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCard1Model> zRecipeCard1Models1;
  // Model for zDiets component.
  late ZDietsModel zDietsModel;
  // Models for zRecipeCard2 dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCard2Model> zRecipeCard2Models;
  // Model for zEnergyWrap component.
  late ZEnergyWrapModel zEnergyWrapModel;
  // Models for zRecipeCard1 dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCard1Model> zRecipeCard1Models2;
  // Models for zRecipeCard dynamic component.
  late FlutterFlowDynamicModels<ZRecipeCardModel> zRecipeCardModels;
  // Model for zNawBar component.
  late ZNawBarModel zNawBarModel;

  @override
  void initState(BuildContext context) {
    zPopularCategoriesModel =
        createModel(context, () => ZPopularCategoriesModel());
    zRecipeCard1Models1 = FlutterFlowDynamicModels(() => ZRecipeCard1Model());
    zDietsModel = createModel(context, () => ZDietsModel());
    zRecipeCard2Models = FlutterFlowDynamicModels(() => ZRecipeCard2Model());
    zEnergyWrapModel = createModel(context, () => ZEnergyWrapModel());
    zRecipeCard1Models2 = FlutterFlowDynamicModels(() => ZRecipeCard1Model());
    zRecipeCardModels = FlutterFlowDynamicModels(() => ZRecipeCardModel());
    zNawBarModel = createModel(context, () => ZNawBarModel());
  }

  @override
  void dispose() {
    zPopularCategoriesModel.dispose();
    zRecipeCard1Models1.dispose();
    zDietsModel.dispose();
    zRecipeCard2Models.dispose();
    zEnergyWrapModel.dispose();
    zRecipeCard1Models2.dispose();
    zRecipeCardModels.dispose();
    zNawBarModel.dispose();
  }
}
