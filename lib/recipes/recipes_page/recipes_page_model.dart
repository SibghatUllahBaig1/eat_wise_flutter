import '/backend/schema/structs/index.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_recipe_app_bar/z_recipe_app_bar_widget.dart';
import '/recipes/components/z_recipe_content/z_recipe_content_widget.dart';
import '/recipes/components/z_recipe_headar/z_recipe_headar_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'recipes_page_widget.dart' show RecipesPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RecipesPageModel extends FlutterFlowModel<RecipesPageWidget> {
  ///  Local state fields for this page.

  bool termPolicy = false;

  bool checkBox = false;

  int? pageItem = 0;

  bool isAddingToMealLog = false;

  @override
  void initState(BuildContext context) {}

  /// Add recipe to today's meal log
  Future<bool> addRecipeToMealLog(String recipeId) async {
    if (currentUserUid.isEmpty) return false;

    isAddingToMealLog = true;
    try {
      final backend = BackendManager();
      await backend.recipeService.addRecipeToMealLog(
        userId: currentUserUid,
        recipeId: recipeId,
      );
      return true;
    } catch (e) {
      debugPrint('Error adding recipe to meal log: $e');
      return false;
    } finally {
      isAddingToMealLog = false;
    }
  }

  @override
  void dispose() {}
}
