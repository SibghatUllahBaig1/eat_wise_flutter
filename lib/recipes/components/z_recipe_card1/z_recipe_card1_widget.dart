import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_recipe_card1_model.dart';
export 'z_recipe_card1_model.dart';

class ZRecipeCard1Widget extends StatefulWidget {
  const ZRecipeCard1Widget({
    super.key,
    required this.articlesData,
  });

  final RecipesStruct? articlesData;

  @override
  State<ZRecipeCard1Widget> createState() => _ZRecipeCard1WidgetState();
}

class _ZRecipeCard1WidgetState extends State<ZRecipeCard1Widget> {
  late ZRecipeCard1Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZRecipeCard1Model());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        context.pushNamed(
          RecipesPageWidget.routeName,
          queryParameters: {
            'recipeData': serializeParam(
              widget!.articlesData,
              ParamType.DataStruct,
            ),
          }.withoutNulls,
        );
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.4,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120.0,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
                    child: Image.network(
                      widget!.articlesData!.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(1.0, -1.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 10.0, 0.0),
                      child: InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (FFAppState()
                              .favoritesRecipes
                              .contains(widget!.articlesData)) {
                            FFAppState().removeFromFavoritesRecipes(
                                widget!.articlesData!);
                            safeSetState(() {});
                          } else {
                            FFAppState()
                                .addToFavoritesRecipes(widget!.articlesData!);
                            safeSetState(() {});
                          }
                        },
                        child: Container(
                          width: 28.0,
                          height: 28.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).barrier,
                            shape: BoxShape.circle,
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              if (FFAppState()
                                  .favoritesRecipes
                                  .contains(widget!.articlesData)) {
                                return Icon(
                                  FFIcons.kheartFilled,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 16.0,
                                );
                              } else {
                                return Icon(
                                  FFIcons.kheart,
                                  color: FlutterFlowTheme.of(context).info,
                                  size: 16.0,
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
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 8.0, 12.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget!.articlesData?.title,
                  'Healthy Chocolate Cupcakes',
                ).maybeHandleOverflow(
                  maxChars: 30,
                  replacement: '…',
                ),
                maxLines: 2,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      lineHeight: 1.5,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 12.0),
              child: Text(
                '${widget!.articlesData?.kcal?.toString()} kcal',
                style: FlutterFlowTheme.of(context).labelSmall.override(
                      font: GoogleFonts.inter(
                        fontWeight:
                            FlutterFlowTheme.of(context).labelSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelSmall.fontStyle,
                      ),
                      letterSpacing: 0.0,
                      fontWeight:
                          FlutterFlowTheme.of(context).labelSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).labelSmall.fontStyle,
                      lineHeight: 1.0,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
