import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_recipe_app_bar/z_recipe_app_bar_widget.dart';
import '/recipes/components/z_recipe_content/z_recipe_content_widget.dart';
import '/recipes/components/z_recipe_headar/z_recipe_headar_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'recipes_page_model.dart';
export 'recipes_page_model.dart';

class RecipesPageWidget extends StatefulWidget {
  const RecipesPageWidget({
    super.key,
    required this.recipeData,
  });

  final RecipesStruct? recipeData;

  static String routeName = 'RecipesPage';
  static String routePath = '/recipesPage';

  @override
  State<RecipesPageWidget> createState() => _RecipesPageWidgetState();
}

class _RecipesPageWidgetState extends State<RecipesPageWidget> {
  late RecipesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipesPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            actions: [],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: custom_widgets.AppBarWidget(
                  width: double.infinity,
                  height: double.infinity,
                  backgroundColorSliverAppBar:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  expandedHeightAppBAr: 240.0,
                  shareborderRadius: 24.0,
                  homepage: () => ZRecipeContentWidget(
                    recipeData: widget!.recipeData!,
                  ),
                  pageSimpleAppBar: () => ZRecipeAppBarWidget(
                    recipeData: widget!.recipeData!,
                  ),
                  pageSliverAppBar: () => ZRecipeHeadarWidget(
                    recipeData: widget!.recipeData!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
