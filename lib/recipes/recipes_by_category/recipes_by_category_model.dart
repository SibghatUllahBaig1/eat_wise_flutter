import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import '/backend/services/recipe_cache_service.dart';
import 'recipes_by_category_widget.dart' show RecipesByCategoryWidget;
import 'package:flutter/material.dart';

class RecipesByCategoryModel extends FlutterFlowModel<RecipesByCategoryWidget> {
  ///  Local state fields for this page.

  List<Map<String, dynamic>> allRecipes = [];
  bool isLoadingRecipes = false;

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

  /// Load recipes from shared cache.
  Future<void> loadRecipes() async {
    isLoadingRecipes = true;

    try {
      allRecipes = await RecipeCacheService.instance.getRecipes();
    } catch (e) {
      debugPrint('Error loading recipes: $e');
      allRecipes = [];
    } finally {
      isLoadingRecipes = false;
    }
  }
}
