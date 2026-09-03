import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_delete_food/z_delete_food_widget.dart';
import '/backend/schema/structs/index.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_food_details_app_bar_model.dart';
export 'z_food_details_app_bar_model.dart';

class ZFoodDetailsAppBarWidget extends StatefulWidget {
  const ZFoodDetailsAppBarWidget({
    super.key,
    required this.fromHistory,
    this.nutritionData,
  });

  final bool? fromHistory;
  final FoodNutritionStruct? nutritionData;

  @override
  State<ZFoodDetailsAppBarWidget> createState() =>
      _ZFoodDetailsAppBarWidgetState();
}

class _ZFoodDetailsAppBarWidgetState extends State<ZFoodDetailsAppBarWidget> {
  late ZFoodDetailsAppBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZFoodDetailsAppBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 0.0, 6.0),
                    child: FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).transparent,
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
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nutritionData?.foodName ?? 'Food Details',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
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
                        if (_usdaMatchSubtitle(widget.nutritionData).isNotEmpty)
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 2.0),
                            child: Text(
                              _usdaMatchSubtitle(widget.nutritionData),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: FlutterFlowTheme.of(context)
                                  .bodySmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget!.fromHistory ?? true)
                      Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 6.0, 6.0, 6.0),
                          child: FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 22.0,
                            borderWidth: 1.0,
                            buttonSize: 44.0,
                            icon: Icon(
                              FFIcons.ktrash03,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            onPressed: () async {
                              await showDialog(
                                barrierColor:
                                    FlutterFlowTheme.of(context).barrier,
                                context: context,
                                builder: (dialogContext) {
                                  return Dialog(
                                    elevation: 0,
                                    insetPadding: EdgeInsets.zero,
                                    backgroundColor: Colors.transparent,
                                    alignment: AlignmentDirectional(0.0, 0.0)
                                        .resolve(Directionality.of(context)),
                                    child: ZDeleteFoodWidget(
                                      mealId: widget.nutritionData?.mealId,
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _usdaMatchSubtitle(FoodNutritionStruct? data) {
    if (data == null || data.usdaDescription.isEmpty) {
      return '';
    }
    if (data.usdaDataType.isNotEmpty) {
      return 'Matched: ${data.usdaDescription} (${data.usdaDataType})';
    }
    return 'Matched: ${data.usdaDescription}';
  }
}
