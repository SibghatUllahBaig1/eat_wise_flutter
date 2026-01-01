import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'recipes_by_category_model.dart';
export 'recipes_by_category_model.dart';

class RecipesByCategoryWidget extends StatefulWidget {
  const RecipesByCategoryWidget({
    super.key,
    required this.category,
  });

  final String? category;

  static String routeName = 'RecipesByCategory';
  static String routePath = '/recipesByCategory';

  @override
  State<RecipesByCategoryWidget> createState() =>
      _RecipesByCategoryWidgetState();
}

class _RecipesByCategoryWidgetState extends State<RecipesByCategoryWidget> {
  late RecipesByCategoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipesByCategoryModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 22.0,
              borderWidth: 1.0,
              buttonSize: 44.0,
              icon: Icon(
                FFIcons.karrowLeft,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ),
          title: Text(
            valueOrDefault<String>(
              widget!.category,
              'null',
            ),
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Builder(
          builder: (context) {
            final articlesList = FFAppState().recipes.toList();

            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children:
                    List.generate(articlesList.length, (articlesListIndex) {
                  final articlesListItem = articlesList[articlesListIndex];
                  return wrapWithModel(
                    model: _model.zRecipeCardModels.getModel(
                      articlesListIndex.toString(),
                      articlesListIndex,
                    ),
                    updateCallback: () => safeSetState(() {}),
                    child: ZRecipeCardWidget(
                      key: Key(
                        'Key1nc_${articlesListIndex.toString()}',
                      ),
                      recipeData: articlesListItem,
                    ),
                  );
                })
                        .divide(SizedBox(height: 12.0))
                        .addToStart(SizedBox(height: 16.0))
                        .addToEnd(SizedBox(height: 24.0)),
              ),
            );
          },
        ),
      ),
    );
  }
}
