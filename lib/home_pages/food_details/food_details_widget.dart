import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_food_details_app_bar/z_food_details_app_bar_widget.dart';
import '/home_pages/components/z_food_details_content/z_food_details_content_widget.dart';
import '/home_pages/components/z_food_details_headar/z_food_details_headar_widget.dart';
import '/backend/schema/structs/index.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'food_details_model.dart';
export 'food_details_model.dart';

class FoodDetailsWidget extends StatefulWidget {
  const FoodDetailsWidget({
    super.key,
    bool? fromHistory,
    this.nutritionData,
  }) : this.fromHistory = fromHistory ?? false;

  final bool fromHistory;
  final FoodNutritionStruct? nutritionData;

  static String routeName = 'FoodDetails';
  static String routePath = '/foodDetails';

  @override
  State<FoodDetailsWidget> createState() => _FoodDetailsWidgetState();
}

class _FoodDetailsWidgetState extends State<FoodDetailsWidget> {
  late FoodDetailsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodDetailsModel());
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
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                      FlutterFlowTheme.of(context).primaryBackground,
                  expandedHeightAppBAr: 240.0,
                  shareborderRadius: 24.0,
                  homepage: () => ZFoodDetailsContentWidget(
                    nutritionData: widget.nutritionData,
                    onNutritionDataChanged: (updatedData) {
                      // Store the updated nutrition data in the model
                      // Preserve the mealId from the original nutrition data
                      if (updatedData != null &&
                          widget.nutritionData?.mealId != null) {
                        updatedData.mealId = widget.nutritionData!.mealId;
                      }
                      _model.contentModel = ZFoodDetailsContentModel()
                        ..calculatedNutrition = updatedData;
                    },
                  ),
                  pageSimpleAppBar: () => ZFoodDetailsAppBarWidget(
                    fromHistory: widget!.fromHistory,
                    nutritionData: widget.nutritionData,
                  ),
                  pageSliverAppBar: () => ZFoodDetailsHeadarWidget(
                    fromHistory: widget!.fromHistory,
                    nutritionData: widget.nutritionData,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: FlutterFlowTheme.of(context).shadow,
                    offset: Offset(
                      0.0,
                      2.0,
                    ),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                    child: FFButtonWidget(
                      onPressed: () async {
                        await _model.saveMeal(context, widget.nutritionData,
                            fromHistory: widget.fromHistory);
                      },
                      text: 'Save',
                      options: FFButtonOptions(
                        width: double.infinity,
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
