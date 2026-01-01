import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_home_calendar_model.dart';
export 'z_home_calendar_model.dart';

class ZHomeCalendarWidget extends StatefulWidget {
  const ZHomeCalendarWidget({super.key});

  @override
  State<ZHomeCalendarWidget> createState() => _ZHomeCalendarWidgetState();
}

class _ZHomeCalendarWidgetState extends State<ZHomeCalendarWidget> {
  late ZHomeCalendarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZHomeCalendarModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.selectedDate = FFAppState().tracker.selectedDate;
      _model.dates = functions
          .daysFunction('Monday', FFAppState().tracker.currentDate!, 7)
          .toList()
          .cast<DateTime>();
      safeSetState(() {});
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

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      dateTimeFormat("yMMMM", _model.selectedDate),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleMedium
                                .fontStyle,
                            lineHeight: 1.0,
                          ),
                    ),
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 20.0,
                    buttonSize: 32.0,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    icon: Icon(
                      FFIcons.karrowLeft,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 16.0,
                    ),
                    onPressed: () async {
                      _model.dates = functions
                          .getLastWeekDate(_model.selectedDate!)
                          .toList()
                          .cast<DateTime>();
                      safeSetState(() {});
                      _model.selectedDate = _model.dates.firstOrNull;
                      safeSetState(() {});
                    },
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 20.0,
                      buttonSize: 32.0,
                      fillColor: FlutterFlowTheme.of(context).primaryBackground,
                      icon: Icon(
                        FFIcons.karrowRight,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 16.0,
                      ),
                      onPressed: () async {
                        _model.dates = functions
                            .getNextWeekDate(_model.selectedDate!)
                            .toList()
                            .cast<DateTime>();
                        safeSetState(() {});
                        _model.selectedDate = _model.dates.firstOrNull;
                        safeSetState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Builder(
                  builder: (context) {
                    final days = _model.dates.toList().take(7).toList();

                    return Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(days.length, (daysIndex) {
                        final daysItem = days[daysIndex];
                        return Expanded(
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              if (daysItem <=
                                  FFAppState().tracker.currentDate!) {
                                FFAppState().updateTrackerStruct(
                                  (e) => e..selectedDate = daysItem,
                                );
                                FFAppState().update(() {});
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: daysItem ==
                                        FFAppState().tracker.selectedDate
                                    ? FlutterFlowTheme.of(context).accent1
                                    : FlutterFlowTheme.of(context).transparent,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: daysItem ==
                                          FFAppState().tracker.selectedDate
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context)
                                          .transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 8.0, 0.0, 8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      dateTimeFormat("E", daysItem),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: () {
                                              if (daysItem ==
                                                  FFAppState()
                                                      .tracker
                                                      .selectedDate) {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .primary;
                                              } else if (daysItem <=
                                                  FFAppState()
                                                      .tracker
                                                      .currentDate!) {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .primaryText;
                                              } else {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .secondaryText;
                                              }
                                            }(),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Text(
                                      dateTimeFormat("d", daysItem),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: () {
                                              if (daysItem ==
                                                  FFAppState()
                                                      .tracker
                                                      .selectedDate) {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .primary;
                                              } else if (daysItem <=
                                                  FFAppState()
                                                      .tracker
                                                      .currentDate!) {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .primaryText;
                                              } else {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .secondaryText;
                                              }
                                            }(),
                                            fontSize: 14.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).divide(SizedBox(width: 3.0)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
