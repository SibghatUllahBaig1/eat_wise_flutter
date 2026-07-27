import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_recipe_content_model.dart';
export 'z_recipe_content_model.dart';

class ZRecipeContentWidget extends StatefulWidget {
  const ZRecipeContentWidget({
    super.key,
    required this.recipeData,
  });

  final RecipesStruct? recipeData;

  @override
  State<ZRecipeContentWidget> createState() => _ZRecipeContentWidgetState();
}

class _ZRecipeContentWidgetState extends State<ZRecipeContentWidget> {
  late ZRecipeContentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZRecipeContentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((widget.recipeData?.name ?? '').isNotEmpty)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Text(
                  widget.recipeData!.name,
                  style: FlutterFlowTheme.of(context).titleLarge.override(
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
                        fontStyle:
                            FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        lineHeight: 1.5,
                      ),
                ),
              ),
            if (_buildQuickInfoCards(context).isNotEmpty)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Row(
                  children: _buildQuickInfoCards(context)
                      .divide(const SizedBox(width: 16.0)),
                ),
              ),
            if ((widget.recipeData?.description ?? '').trim().isNotEmpty)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  widget.recipeData!.description,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.5,
                      ),
                ),
              ),
            if ((widget.recipeData?.ingredients ?? []).isNotEmpty) ...[
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  'Ingredients',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .titleMedium
                            .fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.recipeData!.ingredients
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '• ',
                                style: FlutterFlowTheme.of(context).bodyMedium,
                              ),
                              Expanded(
                                child: Text(
                                  item,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .fontWeight,
                                          fontStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        lineHeight: 1.5,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
            if ((widget.recipeData?.dietCategories ?? []).isNotEmpty)
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Builder(
                  builder: (context) {
                    final tagsList =
                        widget.recipeData!.dietCategories.toList();

                    return Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    runAlignment: WrapAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    clipBehavior: Clip.none,
                    children: List.generate(tagsList.length, (tagsListIndex) {
                      final tagsListItem = tagsList[tagsListIndex];
                      return InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(
                            RecipesByCategoryWidget.routeName,
                            queryParameters: {
                              'category': serializeParam(
                                tagsListItem,
                                ParamType.String,
                              ),
                            }.withoutNulls,
                          );
                        },
                        child: Container(
                          height: 36.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 1.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    tagsListItem,
                                    'null',
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.normal,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ]
                                  .addToStart(SizedBox(width: 16.0))
                                  .addToEnd(SizedBox(width: 16.0)),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
            if ((widget.recipeData?.instructions ?? []).isNotEmpty) ...[
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  'Instructions',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .titleMedium
                            .fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: Text(
                  widget.recipeData!.instructions.join('\n'),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.5,
                      ),
                ),
              ),
            ],
            ..._buildNutritionSections(context),
            // "Use for Calories" button
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
              child: FFButtonWidget(
                onPressed: () {
                  _navigateToFoodDetails(context);
                },
                text: 'Use for Calories',
                icon: const Icon(
                  Icons.local_fire_department_rounded,
                  size: 20.0,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: Colors.white,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w600,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ].addToStart(SizedBox(height: 16.0)).addToEnd(SizedBox(height: 24.0)),
        ),
      ),
    );
  }

  bool _hasNutrientValue(NutrientStruct nutrient) => nutrient.mg > 0;

  bool _hasMacroValue(double value) => value > 0;

  List<Widget> _buildQuickInfoCards(BuildContext context) {
    final recipe = widget.recipeData;
    if (recipe == null) return [];

    final cards = <Widget>[];

    if (recipe.calories > 0) {
      cards.add(_quickInfoCard(
        context,
        icon: Icons.local_fire_department,
        label: recipe.calories.toString(),
      ));
    }
    if (recipe.time > 0) {
      cards.add(_quickInfoCard(
        context,
        icon: FFIcons.kclockw1,
        label: '${recipe.time} mins',
      ));
    }
    if (recipe.difficulty.trim().isNotEmpty) {
      cards.add(_quickInfoCard(
        context,
        icon: FFIcons.kchefHatOn,
        label: recipe.difficulty,
      ));
    }
    if (recipe.grams > 0) {
      cards.add(_quickInfoCard(
        context,
        icon: Icons.monitor_weight_outlined,
        label: '${recipe.grams.toStringAsFixed(0)} g',
      ));
    }

    return cards.map((card) => Expanded(child: card)).toList();
  }

  Widget _quickInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: FlutterFlowTheme.of(context).primaryText, size: 24.0),
          Text(
            label,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyLarge.fontWeight,
                    fontStyle: FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                  ),
                  color: FlutterFlowTheme.of(context).primaryText,
                  letterSpacing: 0.0,
                  lineHeight: 1.0,
                ),
          ),
        ]
            .divide(const SizedBox(height: 16.0))
            .addToStart(const SizedBox(height: 16.0))
            .addToEnd(const SizedBox(height: 16.0)),
      ),
    );
  }

  List<Widget> _buildNutritionSections(BuildContext context) {
    final recipe = widget.recipeData;
    if (recipe == null) return [];

    final percentages = _macroPercentages(recipe);
    final hasMacros = _hasMacroValue(recipe.protein) ||
        _hasMacroValue(recipe.carbs) ||
        _hasMacroValue(recipe.fat);
    final hasCholesterol = _hasNutrientValue(recipe.cholesterol);
    final mineralRows = _allMineralRows(recipe);

    final showMacroCard =
        recipe.calories > 0 || hasMacros || hasCholesterol;
    if (!showMacroCard && mineralRows.isEmpty) return [];

    final sections = <Widget>[
      Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
        child: Text(
          'Nutrition Information',
          style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).titleMedium.fontStyle,
                ),
                letterSpacing: 0.0,
              ),
        ),
      ),
    ];

    if (showMacroCard) {
      sections.add(
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
          child: _greyCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (recipe.calories > 0 || hasMacros)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (recipe.calories > 0 && hasMacros)
                        SizedBox(
                          width: 110.0,
                          height: 110.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 132.0,
                                height: 132.0,
                                child: FlutterFlowPieChart(
                                  data: FFPieChartData(
                                    values: [
                                      if (_hasMacroValue(recipe.carbs))
                                        percentages.carbs,
                                      if (_hasMacroValue(recipe.protein))
                                        percentages.protein,
                                      if (_hasMacroValue(recipe.fat))
                                        percentages.fat,
                                    ],
                                    colors: _pieChartColors(context, recipe),
                                    radius: const [8.0],
                                    borderColor: [
                                      FlutterFlowTheme.of(context).primaryText,
                                    ],
                                  ),
                                  donutHoleRadius: 44.0,
                                  donutHoleColor:
                                      FlutterFlowTheme.of(context).transparent,
                                  sectionLabelStyle:
                                      FlutterFlowTheme.of(context).titleMedium,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    recipe.calories.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                                    context)
                                                .titleLarge
                                                .fontWeight,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  Text(
                                    'kcal',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FlutterFlowTheme.of(
                                                    context)
                                                .bodyMedium
                                                .fontWeight,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      if (recipe.calories > 0 && hasMacros)
                        const SizedBox(width: 8.0),
                      if (hasMacros)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              recipe.calories > 0 ? 16.0 : 0.0,
                              0.0,
                              0.0,
                              0.0,
                            ),
                            child: Column(
                              children: [
                                if (_hasMacroValue(recipe.carbs))
                                  _macroRow(
                                    context,
                                    label: 'Carbs',
                                    dotColor: FlutterFlowTheme.of(context)
                                        .weightColor,
                                    value:
                                        '${recipe.carbs.toStringAsFixed(1)}g (${percentages.carbs.toStringAsFixed(0)}%)',
                                  ),
                                if (_hasMacroValue(recipe.protein))
                                  _macroRow(
                                    context,
                                    label: 'Protein',
                                    dotColor:
                                        FlutterFlowTheme.of(context).stepColor,
                                    value:
                                        '${recipe.protein.toStringAsFixed(1)}g (${percentages.protein.toStringAsFixed(0)}%)',
                                  ),
                                if (_hasMacroValue(recipe.fat))
                                  _macroRow(
                                    context,
                                    label: 'Fat',
                                    dotColor:
                                        FlutterFlowTheme.of(context).waterColor,
                                    value:
                                        '${recipe.fat.toStringAsFixed(1)}g (${percentages.fat.toStringAsFixed(0)}%)',
                                  ),
                              ].divide(const SizedBox(height: 8.0)),
                            ),
                          ),
                        ),
                      if (!hasMacros && recipe.calories > 0)
                        Expanded(
                          child: Text(
                            '${recipe.calories} kcal',
                            style: FlutterFlowTheme.of(context).titleLarge,
                          ),
                        ),
                    ],
                  ),
                if (hasCholesterol)
                  Padding(
                    padding: EdgeInsets.only(
                      top: (recipe.calories > 0 || hasMacros) ? 16.0 : 0.0,
                    ),
                    child: _nutrientRow(
                      context,
                      'Cholesterol',
                      recipe.cholesterol,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    if (mineralRows.isNotEmpty) {
      sections.addAll([
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
          child: Text(
            'Minerals',
            style: FlutterFlowTheme.of(context).titleSmall.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  lineHeight: 1.0,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
          child: _greyCard(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: mineralRows
                  .map(
                    (entry) => _nutrientRow(context, entry.key, entry.value),
                  )
                  .toList()
                  .divide(const SizedBox(height: 16.0)),
            ),
          ),
        ),
      ]);
    }

    return sections;
  }

  Widget _greyCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  List<Color> _pieChartColors(BuildContext context, RecipesStruct recipe) {
    const chartColors = [
      Color(0xFF1997F5),
      Color(0xFFF84135),
      Color(0xFFFF921D),
    ];
    final colors = <Color>[];
    if (_hasMacroValue(recipe.carbs)) colors.add(chartColors[0]);
    if (_hasMacroValue(recipe.protein)) colors.add(chartColors[1]);
    if (_hasMacroValue(recipe.fat)) colors.add(chartColors[2]);
    return colors;
  }

  ({double protein, double carbs, double fat}) _macroPercentages(
    RecipesStruct recipe,
  ) {
    final calories = recipe.calories.toDouble();
    if (calories <= 0) {
      return (protein: 0, carbs: 0, fat: 0);
    }
    return (
      protein: ((recipe.protein * 4) / calories) * 100,
      carbs: ((recipe.carbs * 4) / calories) * 100,
      fat: ((recipe.fat * 9) / calories) * 100,
    );
  }

  List<MapEntry<String, NutrientStruct>> _allMineralRows(RecipesStruct recipe) {
    final rows = <MapEntry<String, NutrientStruct>>[];
    if (_hasNutrientValue(recipe.sodium)) {
      rows.add(MapEntry('Sodium', recipe.sodium));
    }
    rows.addAll(_mineralsWithData(recipe.minerals));
    return rows;
  }

  Widget _macroRow(
    BuildContext context, {
    required String label,
    required Color dotColor,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
            child: Text(
              label,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
        ),
        Text(
          value,
          style: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                ),
                fontSize: 14.0,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

  Widget _nutrientRow(
    BuildContext context,
    String label,
    NutrientStruct nutrient,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
        ),
        Text(
          '${nutrient.mg.toStringAsFixed(1)} mg (${nutrient.percentage.toStringAsFixed(0)}%)',
          style: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.inter(
                  fontWeight:
                      FlutterFlowTheme.of(context).titleSmall.fontWeight,
                ),
                fontSize: 14.0,
                letterSpacing: 0.0,
              ),
        ),
      ],
    );
  }

  List<MapEntry<String, NutrientStruct>> _mineralsWithData(
    MineralsStruct minerals,
  ) {
    return [
      MapEntry('Calcium', minerals.calcium),
      MapEntry('Iron', minerals.iron),
      MapEntry('Potassium', minerals.potassium),
      MapEntry('Magnesium', minerals.magnesium),
      MapEntry('Phosphorus', minerals.phosphorus),
      MapEntry('Zinc', minerals.zinc),
      MapEntry('Copper', minerals.copper),
      MapEntry('Selenium', minerals.selenium),
    ].where((entry) => _hasNutrientValue(entry.value)).toList();
  }

  /// Converts RecipesStruct to FoodNutritionStruct and navigates to FoodDetails
  void _navigateToFoodDetails(BuildContext context) {
    final recipe = widget.recipeData;
    if (recipe == null) return;

    // Extract macro grams from recipe
    final proteinGrams = recipe.protein;
    final carbsGrams = recipe.carbs;
    final fatGrams = recipe.fat;
    final calories = recipe.calories.toDouble();

    // Calculate macro percentages based on calorie contribution
    // Protein: 4 kcal/g, Carbs: 4 kcal/g, Fat: 9 kcal/g
    double proteinPercent = 0.0;
    double carbsPercent = 0.0;
    double fatPercent = 0.0;

    if (calories > 0) {
      proteinPercent = ((proteinGrams * 4) / calories) * 100;
      carbsPercent = ((carbsGrams * 4) / calories) * 100;
      fatPercent = ((fatGrams * 9) / calories) * 100;
    }

    // Use recipe grams if available, otherwise estimate from macros
    final grams = recipe.grams > 0
        ? recipe.grams
        : (proteinGrams + carbsGrams + fatGrams);

    final nutritionData = FoodNutritionStruct(
      foodName: recipe.name,
      grams: grams,
      calories: calories,
      macros: MacrosStruct(
        carbs: MacroDetailStruct(
          grams: carbsGrams,
          percentage: carbsPercent,
        ),
        protein: MacroDetailStruct(
          grams: proteinGrams,
          percentage: proteinPercent,
        ),
        fat: MacroDetailStruct(
          grams: fatGrams,
          percentage: fatPercent,
        ),
      ),
      cholesterol: recipe.cholesterol,
      sodium: recipe.sodium,
      minerals: recipe.minerals,
      imageUrl: recipe.imageUrl,
      // No mealId: ensures a new meal is created (not an update)
    );

    context.pushNamed(
      'FoodDetails',
      queryParameters: {
        'fromHistory': serializeParam(
          true,
          ParamType.bool,
        ),
        'nutritionData': serializeParam(
          nutritionData,
          ParamType.DataStruct,
        ),
      }.withoutNulls,
    );
  }
}
