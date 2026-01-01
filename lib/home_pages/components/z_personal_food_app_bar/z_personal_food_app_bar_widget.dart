import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_delete_food/z_delete_food_widget.dart';
import '/home_pages/components/z_edit_food/z_edit_food_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_personal_food_app_bar_model.dart';
export 'z_personal_food_app_bar_model.dart';

class ZPersonalFoodAppBarWidget extends StatefulWidget {
  const ZPersonalFoodAppBarWidget({
    super.key,
    required this.fromHistory,
  });

  final bool? fromHistory;

  @override
  State<ZPersonalFoodAppBarWidget> createState() =>
      _ZPersonalFoodAppBarWidgetState();
}

class _ZPersonalFoodAppBarWidgetState extends State<ZPersonalFoodAppBarWidget> {
  late ZPersonalFoodAppBarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZPersonalFoodAppBarModel());
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
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 22.0,
                        borderWidth: 1.0,
                        buttonSize: 44.0,
                        icon: Icon(
                          FFIcons.kpencilMinus,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: ZEditFoodWidget(),
                              );
                            },
                          ).then((value) => safeSetState(() {}));
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
                      child: Builder(
                        builder: (context) {
                          if (_model.favorite) {
                            return FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 22.0,
                              borderWidth: 1.0,
                              buttonSize: 44.0,
                              icon: Icon(
                                FFIcons.kheartFilled,
                                color: FlutterFlowTheme.of(context).error,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                _model.favorite = false;
                                safeSetState(() {});
                              },
                            );
                          } else {
                            return FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 22.0,
                              borderWidth: 1.0,
                              buttonSize: 44.0,
                              icon: Icon(
                                FFIcons.kheart,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () async {
                                _model.favorite = true;
                                safeSetState(() {});
                              },
                            );
                          }
                        },
                      ),
                    ),
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
                                    child: ZDeleteFoodWidget(),
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
}
