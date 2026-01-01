import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'meals_model.dart';
export 'meals_model.dart';

class MealsWidget extends StatefulWidget {
  const MealsWidget({
    super.key,
    required this.meals,
  });

  final String? meals;

  static String routeName = 'Meals';
  static String routePath = '/meals';

  @override
  State<MealsWidget> createState() => _MealsWidgetState();
}

class _MealsWidgetState extends State<MealsWidget> {
  late MealsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MealsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.pageViewController?.animateToPage(
        functions.indexFromList(
            FFAppState().categories.meals.map((e) => e.title).toList().toList(),
            widget!.meals!),
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
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
            'Meals',
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 12.0),
              child: Builder(
                builder: (context) {
                  final mealsList = FFAppState().categories.meals.toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children:
                          List.generate(mealsList.length, (mealsListIndex) {
                        final mealsListItem = mealsList[mealsListIndex];
                        return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await _model.pageViewController?.animateToPage(
                              mealsListIndex,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          child: Container(
                            height: 44.0,
                            decoration: BoxDecoration(
                              color: mealsListItem.title == _model.selectedMeals
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  12.0, 8.0, 12.0, 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: Image.network(
                                      mealsListItem.image,
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      mealsListItem.title,
                                      'Breakfast',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: mealsListItem.title ==
                                                  _model.selectedMeals
                                              ? FlutterFlowTheme.of(context)
                                                  .info
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.0,
                                        ),
                                  ),
                                ].divide(SizedBox(width: 12.0)),
                              ),
                            ),
                          ),
                        );
                      })
                              .divide(SizedBox(width: 12.0))
                              .addToStart(SizedBox(width: 16.0))
                              .addToEnd(SizedBox(width: 16.0)),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final mealsPageList = FFAppState().categories.meals.toList();

                  return Container(
                    width: double.infinity,
                    height: 500.0,
                    child: PageView.builder(
                      controller: _model.pageViewController ??= PageController(
                          initialPage:
                              max(0, min(0, mealsPageList.length - 1))),
                      onPageChanged: (_) async {
                        _model.pageItem = _model.pageViewCurrentIndex;
                        safeSetState(() {});
                        _model.selectedMeals = mealsPageList
                            .elementAtOrNull(_model.pageItem!)
                            ?.title;
                        safeSetState(() {});
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: mealsPageList.length,
                      itemBuilder: (context, mealsPageListIndex) {
                        final mealsPageListItem =
                            mealsPageList[mealsPageListIndex];
                        return Builder(
                          builder: (context) {
                            final recipesList = FFAppState().recipes.toList();

                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(recipesList.length,
                                        (recipesListIndex) {
                                  final recipesListItem =
                                      recipesList[recipesListIndex];
                                  return wrapWithModel(
                                    model: _model.zRecipeCardModels.getModel(
                                      recipesListIndex.toString(),
                                      recipesListIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ZRecipeCardWidget(
                                      key: Key(
                                        'Keykzr_${recipesListIndex.toString()}',
                                      ),
                                      recipeData: recipesListItem,
                                    ),
                                  );
                                })
                                    .divide(SizedBox(height: 16.0))
                                    .addToStart(SizedBox(height: 12.0))
                                    .addToEnd(SizedBox(height: 24.0)),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
