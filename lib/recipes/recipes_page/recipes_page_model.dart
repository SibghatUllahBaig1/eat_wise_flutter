import '/backend/schema/structs/index.dart';
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
