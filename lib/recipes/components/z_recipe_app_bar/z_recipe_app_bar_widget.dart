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
import 'z_recipe_app_bar_model.dart';
export 'z_recipe_app_bar_model.dart';

class ZRecipeAppBarWidget extends StatefulWidget {
  const ZRecipeAppBarWidget({
    super.key,
    required this.recipeData,
  });

  final RecipesStruct? recipeData;

  @override
  State<ZRecipeAppBarWidget> createState() => _ZRecipeAppBarWidgetState();
}

class _ZRecipeAppBarWidgetState extends State<ZRecipeAppBarWidget> {
  late ZRecipeAppBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZRecipeAppBarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 6.0, 6.0, 6.0),
                          child: FlutterFlowIconButton(
                            borderColor:
                                FlutterFlowTheme.of(context).transparent,
                            borderRadius: 22.0,
                            borderWidth: 1.0,
                            buttonSize: 44.0,
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
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
                        child: Builder(
                          builder: (context) {
                            if (FFAppState()
                                .favoritesRecipes
                                .contains(widget!.recipeData)) {
                              return FlutterFlowIconButton(
                                borderColor:
                                    FlutterFlowTheme.of(context).transparent,
                                borderRadius: 22.0,
                                borderWidth: 1.0,
                                buttonSize: 44.0,
                                icon: Icon(
                                  FFIcons.kheartFilled,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  FFAppState().removeFromFavoritesRecipes(
                                      widget!.recipeData!);
                                  FFAppState().update(() {});
                                },
                              );
                            } else {
                              return FlutterFlowIconButton(
                                borderColor:
                                    FlutterFlowTheme.of(context).transparent,
                                borderRadius: 22.0,
                                borderWidth: 1.0,
                                buttonSize: 44.0,
                                icon: Icon(
                                  FFIcons.kheart,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 24.0,
                                ),
                                onPressed: () async {
                                  FFAppState().addToFavoritesRecipes(
                                      widget!.recipeData!);
                                  FFAppState().update(() {});
                                },
                              );
                            }
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
}
