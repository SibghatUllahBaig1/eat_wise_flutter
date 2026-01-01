import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_repeat_model.dart';
export 'z_repeat_model.dart';

class ZRepeatWidget extends StatefulWidget {
  const ZRepeatWidget({
    super.key,
    required this.trackerType,
  });

  final int? trackerType;

  @override
  State<ZRepeatWidget> createState() => _ZRepeatWidgetState();
}

class _ZRepeatWidgetState extends State<ZRepeatWidget> {
  late ZRepeatModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZRepeatModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget!.trackerType == 0) {
        _model.selectedDays =
            FFAppState().trackerSettings.calorie.repeat.toList().cast<String>();
        safeSetState(() {});
      } else if (widget!.trackerType == 1) {
        _model.selectedDays =
            FFAppState().trackerSettings.water.repeat.toList().cast<String>();
        safeSetState(() {});
      } else if (widget!.trackerType == 2) {
        _model.selectedDays =
            FFAppState().trackerSettings.step.repeat.toList().cast<String>();
        safeSetState(() {});
      } else {
        _model.selectedDays =
            FFAppState().trackerSettings.weight.repeat.toList().cast<String>();
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(32.0, 0.0, 32.0, 0.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Repeat',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).titleLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleLarge.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        lineHeight: 1.0,
                      ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Builder(
                    builder: (context) {
                      final daysList = _model.days.toList();

                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children:
                            List.generate(daysList.length, (daysListIndex) {
                          final daysListItem = daysList[daysListIndex];
                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (_model.selectedDays.contains(daysListItem)) {
                                _model.removeFromSelectedDays(daysListItem);
                                safeSetState(() {});
                              } else {
                                _model.addToSelectedDays(daysListItem);
                                safeSetState(() {});
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 24.0,
                                  height: 24.0,
                                  decoration: BoxDecoration(
                                    color: _model.selectedDays
                                            .contains(daysListItem)
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .transparent,
                                    borderRadius: BorderRadius.circular(4.0),
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: _model.selectedDays
                                              .contains(daysListItem)
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .iconColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Visibility(
                                    visible: _model.selectedDays
                                        .contains(daysListItem),
                                    child: Icon(
                                      FFIcons.kcheck,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 18.0,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        24.0, 16.0, 0.0, 16.0),
                                    child: Text(
                                      daysListItem,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FFButtonWidget(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        text: 'Cancel',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).transparent,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          if (widget!.trackerType == 0) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateCalorie(
                                  (e) =>
                                      e..repeat = _model.selectedDays.toList(),
                                ),
                            );
                            FFAppState().update(() {});
                          } else if (widget!.trackerType == 1) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWater(
                                  (e) =>
                                      e..repeat = _model.selectedDays.toList(),
                                ),
                            );
                            FFAppState().update(() {});
                          } else if (widget!.trackerType == 2) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateStep(
                                  (e) =>
                                      e..repeat = _model.selectedDays.toList(),
                                ),
                            );
                            FFAppState().update(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) =>
                                      e..repeat = _model.selectedDays.toList(),
                                ),
                            );
                            FFAppState().update(() {});
                          }

                          Navigator.pop(context);
                        },
                        text: 'OK',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
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
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ].divide(SizedBox(width: 4.0)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
