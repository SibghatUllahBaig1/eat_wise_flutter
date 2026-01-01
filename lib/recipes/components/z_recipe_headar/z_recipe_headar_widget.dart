import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'z_recipe_headar_model.dart';
export 'z_recipe_headar_model.dart';

class ZRecipeHeadarWidget extends StatefulWidget {
  const ZRecipeHeadarWidget({
    super.key,
    required this.recipeData,
  });

  final RecipesStruct? recipeData;

  @override
  State<ZRecipeHeadarWidget> createState() => _ZRecipeHeadarWidgetState();
}

class _ZRecipeHeadarWidgetState extends State<ZRecipeHeadarWidget> {
  late ZRecipeHeadarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZRecipeHeadarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      height: 240.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              child: Image.network(
                valueOrDefault<String>(
                  widget!.recipeData?.image,
                  'https://picsum.photos/seed/573/600',
                ),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(6.0, 16.0, 6.0, 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).transparent,
                      borderRadius: 22.0,
                      borderWidth: 1.0,
                      buttonSize: 44.0,
                      fillColor:
                          FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        FFIcons.karrowLeft,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pop();
                      },
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Builder(
                          builder: (context) => Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 6.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderColor:
                                  FlutterFlowTheme.of(context).transparent,
                              borderRadius: 22.0,
                              borderWidth: 1.0,
                              buttonSize: 44.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              icon: Icon(
                                FFIcons.kshare,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                await Share.share(
                                  widget!.recipeData!.title,
                                  sharePositionOrigin:
                                      getWidgetBoundingBox(context),
                                );
                              },
                            ),
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            if (FFAppState()
                                .favoritesRecipes
                                .contains(widget!.recipeData)) {
                              return FlutterFlowIconButton(
                                borderRadius: 22.0,
                                borderWidth: 1.0,
                                buttonSize: 44.0,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                icon: Icon(
                                  FFIcons.kheartFilled,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  FFAppState().removeFromFavoritesRecipes(
                                      widget!.recipeData!);
                                  safeSetState(() {});
                                },
                              );
                            } else {
                              return FlutterFlowIconButton(
                                borderRadius: 22.0,
                                borderWidth: 1.0,
                                buttonSize: 44.0,
                                fillColor: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                icon: Icon(
                                  FFIcons.kheart,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  FFAppState().addToFavoritesRecipes(
                                      widget!.recipeData!);
                                  safeSetState(() {});
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
