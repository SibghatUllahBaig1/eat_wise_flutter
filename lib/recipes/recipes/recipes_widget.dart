import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/recipes/components/z_energy_wrap/z_energy_wrap_widget.dart';
import '/recipes/components/z_filter/z_filter_widget.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import '/recipes/components/z_recipe_card1/z_recipe_card1_widget.dart';
import '/recipes/components/z_search/z_search_widget.dart';
import '/recipes/components/dynamic_categories/dynamic_categories_widget.dart';
import '/recipes/components/dynamic_diets/dynamic_diets_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'recipes_model.dart';
export 'recipes_model.dart';

class RecipesWidget extends StatefulWidget {
  const RecipesWidget({super.key});

  static String routeName = 'Recipes';
  static String routePath = '/recipes';

  @override
  State<RecipesWidget> createState() => _RecipesWidgetState();
}

class _RecipesWidgetState extends State<RecipesWidget>
    with TickerProviderStateMixin {
  late RecipesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecipesModel());

    // Load recipes and update UI when complete
    _loadRecipes();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().NavBar = 3;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'pageViewOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(0.95, 0.95),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });
  }

  /// Load recipes from Firestore and update UI
  Future<void> _loadRecipes() async {
    await _model.loadRecipes();
    if (mounted) {
      setState(() {});
    }
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
          leadingWidth: 120.0,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/images/custom-images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          title: Text(
            'Recipes',
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
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
              child: FlutterFlowIconButton(
                borderRadius: 22.0,
                buttonSize: 44.0,
                fillColor: FlutterFlowTheme.of(context).transparent,
                icon: Icon(
                  FFIcons.ksearch,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: ZSearchWidget(),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
              child: FlutterFlowIconButton(
                borderRadius: 22.0,
                buttonSize: 44.0,
                fillColor: FlutterFlowTheme.of(context).transparent,
                icon: Icon(
                  FFIcons.kfilterLines,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        child: Padding(
                          padding: MediaQuery.viewInsetsOf(context),
                          child: ZFilterWidget(),
                        ),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                },
              ),
            ),
          ],
          centerTitle: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 6.0, 12.0),
              child: Container(
                width: double.infinity,
                height: 44.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await _model.pageViewController?.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: Container(
                            width: 100.0,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: valueOrDefault<Color>(
                                _model.pageItem == 0
                                    ? FlutterFlowTheme.of(context).primary
                                    : FlutterFlowTheme.of(context).transparent,
                                FlutterFlowTheme.of(context).secondary,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Discover',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: _model.pageItem == 0
                                        ? FlutterFlowTheme.of(context).info
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await _model.pageViewController?.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          },
                          child: Container(
                            width: 100.0,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: _model.pageItem == 1
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Favorites',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    color: _model.pageItem == 1
                                        ? FlutterFlowTheme.of(context).info
                                        : FlutterFlowTheme.of(context)
                                            .secondaryText,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ].divide(SizedBox(width: 3.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                height: 500.0,
                child: PageView(
                  controller: _model.pageViewController ??=
                      PageController(initialPage: 0),
                  onPageChanged: (_) async {
                    _model.pageItem = _model.pageViewCurrentIndex;
                    safeSetState(() {});
                  },
                  scrollDirection: Axis.horizontal,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 0.0, 16.0, 0.0),
                            child: Text(
                              'Popular Categories',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: DynamicCategoriesWidget(),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    'New Recipes',
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed(
                                      RecipesByCategoryWidget.routeName,
                                      queryParameters: {
                                        'category': serializeParam(
                                          'New Recipes',
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  text: 'View All',
                                  options: FFButtonOptions(
                                    height: 30.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context)
                                        .transparent,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Builder(
                              builder: (context) {
                                // Show loading indicator while recipes are loading
                                if (_model.isLoadingRecipes) {
                                  return Container(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                // Convert Firestore data to RecipesStruct
                                final articlesList = _model.allRecipes
                                    .take(5)
                                    .map((recipeData) => RecipesStruct(
                                          name: recipeData['name'] as String? ??
                                              '',
                                          description: recipeData['description']
                                                  as String? ??
                                              '',
                                          imageUrl: recipeData['imageUrl']
                                                  as String? ??
                                              '',
                                          calories:
                                              recipeData['calories'] as int? ??
                                                  0,
                                          protein:
                                              (recipeData['protein'] as num?)
                                                      ?.toDouble() ??
                                                  0.0,
                                          carbs: (recipeData['carbs'] as num?)
                                                  ?.toDouble() ??
                                              0.0,
                                          fat: (recipeData['fat'] as num?)
                                                  ?.toDouble() ??
                                              0.0,
                                          time: recipeData['time'] as int? ?? 0,
                                          difficulty: recipeData['difficulty']
                                                  as String? ??
                                              '',
                                          dietCategories: List<String>.from(
                                              recipeData['dietCategories']
                                                      as List? ??
                                                  []),
                                          ingredients: List<String>.from(
                                              recipeData['ingredients']
                                                      as List? ??
                                                  []),
                                          instructions: List<String>.from(
                                              recipeData['instructions']
                                                      as List? ??
                                                  []),
                                          grams: (recipeData['grams'] as num?)
                                                  ?.toDouble() ??
                                              0.0,
                                          cholesterol:
                                              NutrientStruct.maybeFromMap(
                                                  recipeData['cholesterol']),
                                          sodium: NutrientStruct.maybeFromMap(
                                              recipeData['sodium']),
                                          minerals: MineralsStruct.maybeFromMap(
                                              recipeData['minerals']),
                                        ))
                                    .toList();

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: List.generate(articlesList.length,
                                            (articlesListIndex) {
                                      final articlesListItem =
                                          articlesList[articlesListIndex];
                                      return wrapWithModel(
                                        model:
                                            _model.zRecipeCard1Models1.getModel(
                                          articlesListIndex.toString(),
                                          articlesListIndex,
                                        ),
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: ZRecipeCard1Widget(
                                          key: Key(
                                            'Keyyxh_${articlesListIndex.toString()}',
                                          ),
                                          articlesData: articlesListItem,
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 24.0, 16.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Pick Your Diet',
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                FFButtonWidget(
                                  onPressed: () async {
                                    context.pushNamed(
                                      DietsWidget.routeName,
                                      queryParameters: {
                                        'diets': serializeParam(
                                          'Vegetarian',
                                          ParamType.String,
                                        ),
                                      }.withoutNulls,
                                    );
                                  },
                                  text: 'View All',
                                  options: FFButtonOptions(
                                    height: 30.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        12.0, 0.0, 12.0, 0.0),
                                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context)
                                        .transparent,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: DynamicDietsWidget(),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 24.0, 16.0, 0.0),
                            child: Text(
                              'Energy Value',
                              style: FlutterFlowTheme.of(context)
                                  .titleLarge
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 0.0),
                            child: wrapWithModel(
                              model: _model.zEnergyWrapModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ZEnergyWrapWidget(),
                            ),
                          ),
                        ]
                            .addToStart(SizedBox(height: 12.0))
                            .addToEnd(SizedBox(height: 24.0)),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        // Show only recipes that are in favorites
                        final favoritesRecipesList =
                            FFAppState().favoritesRecipes.toList();

                        if (favoritesRecipesList.isNotEmpty) {
                          return ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              0,
                              12.0,
                              0,
                              24.0,
                            ),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: favoritesRecipesList.length,
                            separatorBuilder: (_, __) => SizedBox(height: 16.0),
                            itemBuilder: (context, favoritesRecipesListIndex) {
                              final favoritesRecipesListItem =
                                  favoritesRecipesList[
                                      favoritesRecipesListIndex];
                              return wrapWithModel(
                                model: _model.zRecipeCardModels.getModel(
                                  favoritesRecipesListIndex.toString(),
                                  favoritesRecipesListIndex,
                                ),
                                updateCallback: () => safeSetState(() {}),
                                child: ZRecipeCardWidget(
                                  key: Key(
                                    'Keymqo_${favoritesRecipesListIndex.toString()}',
                                  ),
                                  recipeData: favoritesRecipesListItem,
                                ),
                              );
                            },
                          );
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      'assets/images/emptyFavorites.png',
                                      width: 250.0,
                                      height: 220.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Text(
                                      'No saved recipes',
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional(0.0, -1.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 12.0, 16.0, 0.0),
                                    child: Text(
                                      'Start exploring and add your favorites!',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ),
                                ),
                              ]
                                  .addToStart(SizedBox(height: 12.0))
                                  .addToEnd(SizedBox(height: 24.0)),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ).animateOnPageLoad(
                  animationsMap['pageViewOnPageLoadAnimation']!),
            ),
            wrapWithModel(
              model: _model.zNawBarModel,
              updateCallback: () => safeSetState(() {}),
              child: ZNawBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
