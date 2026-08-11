import 'dart:async';

import '/backend/services/recipe_cache_service.dart';
import '/backend/schema/structs/index.dart';
import '/backend/utils/recipe_struct_utils.dart';
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
import 'energy_value_model.dart';
export 'energy_value_model.dart';

class EnergyValueWidget extends StatefulWidget {
  const EnergyValueWidget({
    super.key,
    required this.energy,
  });

  final String? energy;

  static String routeName = 'EnergyValue';
  static String routePath = '/energyValue';

  @override
  State<EnergyValueWidget> createState() => _EnergyValueWidgetState();
}

class _EnergyValueWidgetState extends State<EnergyValueWidget> {
  late EnergyValueModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EnergyValueModel());

    // Load all recipes on page load
    _loadAllRecipes();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.pageViewController?.animateToPage(
        functions.indexFromList(
            FFAppState()
                .categories
                .energy
                .map((e) => e.title)
                .toList()
                .toList(),
            widget!.energy!),
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  Future<void> _loadAllRecipes() async {
    try {
      _model.isLoadingRecipes = true;
      _model.allRecipes =
          await RecipeCacheService.instance.getRecipes(forceRefresh: true);
      debugPrint(
          'Loaded ${_model.allRecipes.length} recipes for energy filtering');

      if (mounted) {
        safeSetState(() {});
      }
    } catch (e) {
      debugPrint('Error loading recipes: $e');
    } finally {
      _model.isLoadingRecipes = false;
    }
  }

  List<Map<String, dynamic>> _getFilteredRecipesByEnergy(String energyRange) {
    if (_model.allRecipes.isEmpty) {
      return [];
    }

    // Parse energy range (e.g., "50-100 kcal" -> min: 50, max: 100)
    final parts = energyRange.replaceAll(' kcal', '').split('-');
    if (parts.length < 2) {
      return [];
    }

    final minCal = int.tryParse(parts[0].trim()) ?? 0;
    final maxCal = energyRange.contains('+')
        ? 10000 // For "700+ kcal", set a very high max
        : (int.tryParse(parts[1].trim()) ?? 0);

    debugPrint(
        'Filtering recipes for energy range: $energyRange ($minCal - $maxCal kcal)');

    final filtered = _model.allRecipes.where((recipe) {
      final cal = recipe['calories'] as int? ?? 0;
      final matches = cal >= minCal && cal <= maxCal;
      if (matches) {
        debugPrint('  - ${recipe['name']}: $cal kcal ✓');
      }
      return matches;
    }).toList();

    debugPrint(
        'Found ${filtered.length} recipes for $energyRange out of ${_model.allRecipes.length}');
    return filtered;
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
            'Energy Value',
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
                  final energyList = FFAppState().categories.energy.toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children:
                          List.generate(energyList.length, (energyListIndex) {
                        final energyListItem = energyList[energyListIndex];
                        return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await _model.pageViewController?.animateToPage(
                              energyListIndex,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          child: Container(
                            height: 44.0,
                            decoration: BoxDecoration(
                              color:
                                  energyListItem.title == _model.selectedEnergy
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
                                      valueOrDefault<String>(
                                        energyListItem.image,
                                        'https://picsum.photos/seed/495/600',
                                      ),
                                      width: 24.0,
                                      height: 24.0,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Text(
                                    valueOrDefault<String>(
                                      energyListItem.title,
                                      '200-300 kcal',
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
                                          color: energyListItem.title ==
                                                  _model.selectedEnergy
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
                  final energyPageList =
                      FFAppState().categories.energy.toList();

                  return Container(
                    width: double.infinity,
                    height: 500.0,
                    child: PageView.builder(
                      controller: _model.pageViewController ??= PageController(
                          initialPage:
                              max(0, min(0, energyPageList.length - 1))),
                      onPageChanged: (_) async {
                        _model.pageItem = _model.pageViewCurrentIndex;
                        safeSetState(() {});
                        _model.selectedEnergy = energyPageList
                            .elementAtOrNull(_model.pageItem!)
                            ?.title;
                        safeSetState(() {});
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: energyPageList.length,
                      itemBuilder: (context, energyPageListIndex) {
                        final energyPageListItem =
                            energyPageList[energyPageListIndex];
                        final energyRange = energyPageListItem.title;

                        // Get filtered recipes for this energy range
                        final filteredRecipes =
                            _getFilteredRecipesByEnergy(energyRange);

                        return Builder(
                          builder: (context) {
                            if (filteredRecipes.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Text(
                                    'No recipes available for $energyRange',
                                    style:
                                        FlutterFlowTheme.of(context).bodyLarge,
                                  ),
                                ),
                              );
                            }

                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: List.generate(filteredRecipes.length,
                                        (recipesListIndex) {
                                  final recipeData =
                                      filteredRecipes[recipesListIndex];

                                  final recipesListItem =
                                      recipeStructFromMap(recipeData);

                                  return wrapWithModel(
                                    model: _model.zRecipeCardModels.getModel(
                                      recipesListIndex.toString(),
                                      recipesListIndex,
                                    ),
                                    updateCallback: () => safeSetState(() {}),
                                    child: ZRecipeCardWidget(
                                      key: Key(
                                        'Key44e_${recipesListIndex.toString()}',
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
