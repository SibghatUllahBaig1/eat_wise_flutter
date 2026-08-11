import '/backend/services/recipe_cache_service.dart';
import '/backend/schema/structs/index.dart';
import '/backend/utils/recipe_struct_utils.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/recipes/components/z_recipe_card/z_recipe_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'diets_model.dart';
export 'diets_model.dart';

class DietsWidget extends StatefulWidget {
  const DietsWidget({
    super.key,
    required this.diets,
  });

  final String? diets;

  static String routeName = 'Diets';
  static String routePath = '/diets';

  @override
  State<DietsWidget> createState() => _DietsWidgetState();
}

class _DietsWidgetState extends State<DietsWidget> {
  late DietsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DietsModel());

    // Set initial selected diet
    _model.selectedDiet = widget.diets ?? 'All';

    // Load all recipes and categories once on page load
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    try {
      _model.categoryRecipes =
          await RecipeCacheService.instance.getRecipes(forceRefresh: true);
      debugPrint('Loaded ${_model.categoryRecipes.length} recipes');

      // Debug: Log first recipe data
      if (_model.categoryRecipes.isNotEmpty) {
        final firstRecipe = _model.categoryRecipes[0];
        debugPrint('First recipe data: $firstRecipe');
        debugPrint('First recipe time: ${firstRecipe['time']}');
        debugPrint('First recipe difficulty: ${firstRecipe['difficulty']}');
        debugPrint('First recipe protein: ${firstRecipe['protein']}');
        debugPrint('First recipe carbs: ${firstRecipe['carbs']}');
        debugPrint('First recipe fat: ${firstRecipe['fat']}');
        debugPrint(
            'First recipe dietCategories: ${firstRecipe['dietCategories']}');
      }

      // Load categories
      final categoriesSnapshot = await FirebaseFirestore.instance
          .collection('diet_categories')
          .orderBy('name')
          .get();

      _model.categories =
          categoriesSnapshot.docs.map((doc) => doc.data()).toList();
      debugPrint('Loaded ${_model.categories.length} categories');

      // Initialize PageController after data is loaded
      if (mounted) {
        setState(() {
          _initializePageController();
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
    }
  }

  void _initializePageController() {
    final allCategories = _getAllCategories();
    final initialIndex = widget.diets == null || widget.diets == 'All'
        ? 0
        : allCategories.indexWhere((cat) => cat['name'] == widget.diets);

    _model.pageViewController ??= PageController(
      initialPage: initialIndex >= 0 ? initialIndex : 0,
    );
  }

  List<Map<String, dynamic>> _getAllCategories() {
    return [
      {'name': 'All', 'emoji': '🍽️', 'isAll': true},
      ..._model.categories.map((cat) {
        return {
          ...cat,
          'isAll': false,
        };
      }),
    ];
  }

  List<Map<String, dynamic>> _getFilteredRecipes(
      String categoryName, bool isAll) {
    if (isAll) {
      debugPrint('Filtering All: ${_model.categoryRecipes.length} recipes');
      return _model.categoryRecipes;
    }
    final filtered = _model.categoryRecipes.where((recipe) {
      final dietCategories = recipe['dietCategories'] as List<dynamic>?;
      return dietCategories?.contains(categoryName) ?? false;
    }).toList();
    debugPrint(
        'Filtering $categoryName: ${filtered.length} recipes out of ${_model.categoryRecipes.length}');
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
            'Diets',
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
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _model.categories.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Category tabs
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 12.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children:
                            List.generate(_getAllCategories().length, (index) {
                          final category = _getAllCategories()[index];
                          final categoryName = category['name'] as String;
                          final categoryEmoji = category['emoji'] as String;
                          final isSelected =
                              categoryName == _model.selectedDiet;

                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                _model.selectedDiet = categoryName;
                                _model.pageItem = index;
                              });
                              _model.pageViewController?.animateToPage(
                                index,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: isSelected
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
                                    Text(
                                      categoryEmoji,
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                    SizedBox(width: 8.0),
                                    Text(
                                      categoryName,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                            ),
                                            color: isSelected
                                                ? FlutterFlowTheme.of(context)
                                                    .info
                                                : FlutterFlowTheme.of(context)
                                                    .primaryText,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                                .divide(SizedBox(width: 12.0))
                                .addToStart(SizedBox(width: 16.0))
                                .addToEnd(SizedBox(width: 16.0)),
                      ),
                    ),
                  ),
                  // PageView for recipes
                  Expanded(
                    child: PageView.builder(
                      controller: _model.pageViewController,
                      onPageChanged: (index) {
                        setState(() {
                          _model.pageItem = index;
                          _model.selectedDiet =
                              _getAllCategories()[index]['name'] as String;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: _getAllCategories().length,
                      itemBuilder: (context, pageIndex) {
                        final category = _getAllCategories()[pageIndex];
                        final categoryName = category['name'] as String;
                        final isAll = (category['isAll'] as bool?) ?? false;

                        // Filter recipes locally based on category
                        final filteredRecipes =
                            _getFilteredRecipes(categoryName, isAll);

                        if (filteredRecipes.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Text(
                                'No recipes available for this category',
                                style: FlutterFlowTheme.of(context).bodyLarge,
                              ),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: List.generate(filteredRecipes.length,
                                    (recipeIndex) {
                              final recipeData = filteredRecipes[recipeIndex];

                              final recipeStruct =
                                  recipeStructFromMap(recipeData);

                              return wrapWithModel(
                                model: _model.zRecipeCardModels.getModel(
                                  '${pageIndex}_$recipeIndex',
                                  recipeIndex,
                                ),
                                updateCallback: () => setState(() {}),
                                child: ZRecipeCardWidget(
                                  key: Key('Recipe_${pageIndex}_$recipeIndex'),
                                  recipeData: recipeStruct,
                                ),
                              );
                            })
                                .divide(SizedBox(height: 16.0))
                                .addToStart(SizedBox(height: 12.0))
                                .addToEnd(SizedBox(height: 24.0)),
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
