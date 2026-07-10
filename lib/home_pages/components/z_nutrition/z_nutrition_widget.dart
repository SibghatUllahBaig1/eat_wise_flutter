import '/backend/services/subscription_controller.dart';
import '/components/paywall_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_nutrition_model.dart';
export 'z_nutrition_model.dart';

class ZNutritionWidget extends StatefulWidget {
  const ZNutritionWidget({super.key});

  @override
  State<ZNutritionWidget> createState() => _ZNutritionWidgetState();
}

class _ZNutritionWidgetState extends State<ZNutritionWidget> {
  late ZNutritionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZNutritionModel());

    // Load meals when widget is first created
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.loadMeals();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ZNutritionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload meals when widget is updated (e.g., when returning from another page)
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.loadMeals();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Display saved meals
          if (_model.meals.isNotEmpty)
            ...List.generate(_model.meals.length, (index) {
              final meal = _model.meals[index];
              final foods = meal['foods'] as List<dynamic>? ?? [];

              // Get the first food name for display
              final firstFoodName = foods.isNotEmpty
                  ? (foods[0] as Map<String, dynamic>)['title']?.toString() ??
                      'Unknown Food'
                  : 'Unknown Food';

              // Get the first food for navigation
              final firstFood = foods.isNotEmpty
                  ? foods[0] as Map<String, dynamic>
                  : <String, dynamic>{};

              return InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  if (firstFood.isEmpty) return;

                  // Convert food data to FoodNutritionStruct and navigate
                  final nutritionData =
                      _model.convertFoodToNutritionStruct(firstFood);

                  // Add mealId to nutrition data
                  nutritionData.mealId = meal['id']?.toString() ?? '';

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
                },
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                firstFoodName,
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              '${meal['totalCalories'] ?? 0} kcal',
                              style: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                        if (foods.isNotEmpty)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              '${firstFood['gram'] ?? 0}g',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        SizedBox(height: 8.0),
                        _buildMacroRow(context, meal),
                      ],
                    ),
                  ),
                ),
              );
            }),

          // Add Food button
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              context.pushNamed('FoodCapture');
            },
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Add Food',
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
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                            lineHeight: 1.0,
                          ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Take a photo or describe your meal',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The C/P/F macro breakdown — a Pro feature. Non-Pro users see a blurred
  /// preview with a lock icon that opens the paywall on tap, rather than the
  /// row disappearing outright.
  Widget _buildMacroRow(BuildContext context, Map<String, dynamic> meal) {
    final isPro = context.watch<SubscriptionController>().isPro;
    final macroRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMacroChip(
          context,
          'C: ${meal['totalCarbs'] ?? 0}g',
          FlutterFlowTheme.of(context).primary,
        ),
        _buildMacroChip(
          context,
          'P: ${meal['totalProtein'] ?? 0}g',
          FlutterFlowTheme.of(context).secondary,
        ),
        _buildMacroChip(
          context,
          'F: ${meal['totalFat'] ?? 0}g',
          FlutterFlowTheme.of(context).tertiary,
        ),
      ],
    );

    if (isPro) return macroRow;

    return InkWell(
      borderRadius: BorderRadius.circular(8.0),
      onTap: () => checkFeatureAccess(
        context: context,
        featureName: 'macro_nutrient_breakdown',
        displayName: 'Macro & Nutrient Breakdown',
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: IgnorePointer(child: macroRow),
          ),
          Icon(
            Icons.lock_outline,
            size: 18.0,
            color: FlutterFlowTheme.of(context).secondaryText,
          ),
        ],
      ),
    );
  }

  Widget _buildMacroChip(BuildContext context, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        label,
        style: FlutterFlowTheme.of(context).bodySmall.override(
              font: GoogleFonts.inter(),
              color: color,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
