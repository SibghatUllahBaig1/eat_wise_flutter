import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_recipe_card_model.dart';
export 'z_recipe_card_model.dart';

class ZRecipeCardWidget extends StatefulWidget {
  const ZRecipeCardWidget({
    super.key,
    required this.recipeData,
  });

  final RecipesStruct? recipeData;

  @override
  State<ZRecipeCardWidget> createState() => _ZRecipeCardWidgetState();
}

class _ZRecipeCardWidgetState extends State<ZRecipeCardWidget> {
  late ZRecipeCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZRecipeCardModel());
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
          context.pushNamed(
            RecipesPageWidget.routeName,
            queryParameters: {
              'recipeData': serializeParam(
                widget!.recipeData,
                ParamType.DataStruct,
              ),
            }.withoutNulls,
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    child: Image.network(
                      valueOrDefault<String>(
                        widget!.recipeData?.image,
                        'https://picsum.photos/seed/57/600',
                      ),
                      width: double.infinity,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(1.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 12.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (FFAppState()
                              .favoritesRecipes
                              .contains(widget!.recipeData)) {
                            FFAppState().removeFromFavoritesRecipes(
                                widget!.recipeData!);
                            FFAppState().update(() {});
                          } else {
                            FFAppState()
                                .addToFavoritesRecipes(widget!.recipeData!);
                            FFAppState().update(() {});
                          }
                        },
                        child: Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).barrier,
                            shape: BoxShape.circle,
                          ),
                          child: Builder(
                            builder: (context) {
                              if (FFAppState()
                                  .favoritesRecipes
                                  .contains(widget!.recipeData)) {
                                return Icon(
                                  FFIcons.kheartFilled,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 22.0,
                                );
                              } else {
                                return Icon(
                                  FFIcons.kheart,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 22.0,
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                child: Text(
                  valueOrDefault<String>(
                    widget!.recipeData?.title,
                    'Vegan  Mocha Yogurt Bowl',
                  ),
                  maxLines: 2,
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        lineHeight: 1.5,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 14.0, 16.0, 16.0),
                child: Text(
                  '${widget!.recipeData?.kcal?.toString()} kcal',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        lineHeight: 1.0,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
