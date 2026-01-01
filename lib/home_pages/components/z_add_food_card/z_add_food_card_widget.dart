import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_add_food_card_model.dart';
export 'z_add_food_card_model.dart';

class ZAddFoodCardWidget extends StatefulWidget {
  const ZAddFoodCardWidget({
    super.key,
    required this.foodData,
    int? type,
  }) : this.type = type ?? 0;

  final FoodStruct? foodData;
  final int type;

  @override
  State<ZAddFoodCardWidget> createState() => _ZAddFoodCardWidgetState();
}

class _ZAddFoodCardWidgetState extends State<ZAddFoodCardWidget> {
  late ZAddFoodCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZAddFoodCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          if (widget!.type == 2) {
            context.pushNamed(
              PersonalFoodDetailsWidget.routeName,
              queryParameters: {
                'fromHistory': serializeParam(
                  false,
                  ParamType.bool,
                ),
              }.withoutNulls,
            );
          } else {
            context.pushNamed(
              FoodDetailsWidget.routeName,
              queryParameters: {
                'fromHistory': serializeParam(
                  false,
                  ParamType.bool,
                ),
              }.withoutNulls,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    if (FFAppState().selectedFoods.contains(widget!.foodData)) {
                      FFAppState().removeFromSelectedFoods(widget!.foodData!);
                      FFAppState().foodKcal =
                          FFAppState().foodKcal + (-1 * widget!.foodData!.kcal);
                      FFAppState().update(() {});
                    } else {
                      FFAppState().addToSelectedFoods(widget!.foodData!);
                      FFAppState().foodKcal =
                          FFAppState().foodKcal + widget!.foodData!.kcal;
                      FFAppState().update(() {});
                    }
                  },
                  child: Builder(
                    builder: (context) {
                      if (FFAppState()
                          .selectedFoods
                          .contains(widget!.foodData)) {
                        return Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(10.0),
                            shape: BoxShape.rectangle,
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            FFIcons.kcheck,
                            color: FlutterFlowTheme.of(context).info,
                            size: 24.0,
                          ),
                        );
                      } else {
                        return Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(10.0),
                            shape: BoxShape.rectangle,
                          ),
                          child: Icon(
                            FFIcons.kplus,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          valueOrDefault<String>(
                            widget!.foodData?.title,
                            'null',
                          ),
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                        ),
                        Text(
                          '${widget!.foodData?.kcal?.toString()}kcal, ${widget!.foodData?.gram?.toString()} gram',
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                        ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ),
                ),
                Icon(
                  FFIcons.kchevronRight,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
