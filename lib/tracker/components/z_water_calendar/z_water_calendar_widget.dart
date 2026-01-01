import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'z_water_calendar_model.dart';
export 'z_water_calendar_model.dart';

class ZWaterCalendarWidget extends StatefulWidget {
  const ZWaterCalendarWidget({super.key});

  @override
  State<ZWaterCalendarWidget> createState() => _ZWaterCalendarWidgetState();
}

class _ZWaterCalendarWidgetState extends State<ZWaterCalendarWidget>
    with TickerProviderStateMixin {
  late ZWaterCalendarModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZWaterCalendarModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.selectedMonthAndYear = FFAppState().tracker.currentDate;
      _model.size = (MediaQuery.sizeOf(context).width - 100) / 7;
      safeSetState(() {});
    });

    animationsMap.addAll({
      'iconOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          RotateEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 1.0,
            end: 0.5,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                if (_model.showMore) {
                  return Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              6.0, 0.0, 6.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FlutterFlowIconButton(
                                borderRadius: 50.0,
                                buttonSize: 44.0,
                                fillColor:
                                    FlutterFlowTheme.of(context).transparent,
                                icon: Icon(
                                  FFIcons.kchevronLeft,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                                onPressed: () async {
                                  _model.selectedMonthAndYear =
                                      functions.getLastMonthDateTime(
                                          _model.selectedMonthAndYear!);
                                  safeSetState(() {});
                                },
                              ),
                              Text(
                                '${dateTimeFormat("MMM", _model.selectedMonthAndYear)}, ${dateTimeFormat("y", _model.selectedMonthAndYear)}',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
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
                                    ),
                              ),
                              FlutterFlowIconButton(
                                borderColor: Colors.transparent,
                                borderRadius: 50.0,
                                buttonSize: 44.0,
                                fillColor:
                                    FlutterFlowTheme.of(context).transparent,
                                icon: Icon(
                                  FFIcons.kchevronRight,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                                onPressed: () async {
                                  _model.selectedMonthAndYear =
                                      functions.getNextMonthDateTime(
                                          _model.selectedMonthAndYear!);
                                  safeSetState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Mon',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Thu',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Wed',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Thu',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Fri',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Sat',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Sun',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .labelSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 16.0, 16.0),
                          child: Builder(
                            builder: (context) {
                              final daysList = functions
                                  .getMonthDays(
                                      'Monday',
                                      dateTimeFormat("yyyy/MM",
                                          _model.selectedMonthAndYear))
                                  .toList();

                              return Wrap(
                                spacing: 6.0,
                                runSpacing: 6.0,
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                direction: Axis.horizontal,
                                runAlignment: WrapAlignment.start,
                                verticalDirection: VerticalDirection.down,
                                clipBehavior: Clip.none,
                                children: List.generate(daysList.length,
                                    (daysListIndex) {
                                  final daysListItem = daysList[daysListIndex];
                                  return Builder(
                                    builder: (context) {
                                      if (FFAppState()
                                          .tracker
                                          .step
                                          .where((e) => e.date == daysListItem)
                                          .toList()
                                          .isNotEmpty) {
                                        return Container(
                                          width: _model.size,
                                          height: _model.size,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              FFAppState().updateTrackerStruct(
                                                (e) => e
                                                  ..selectedDate = daysListItem,
                                              );
                                              FFAppState().update(() {});
                                            },
                                            child: CircularPercentIndicator(
                                              percent: FFAppState()
                                                  .tracker
                                                  .water
                                                  .where((e) =>
                                                      e.date == daysListItem)
                                                  .toList()
                                                  .firstOrNull!
                                                  .progress,
                                              radius: 18.0,
                                              lineWidth: 3.0,
                                              animation: true,
                                              animateFromLastPercent: true,
                                              progressColor:
                                                  FlutterFlowTheme.of(context)
                                                      .waterColor,
                                              backgroundColor:
                                                  FlutterFlowTheme.of(context)
                                                      .waterAccent,
                                              center: Text(
                                                dateTimeFormat(
                                                    "d", daysListItem),
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: () {
                                                            if (daysListItem ==
                                                                FFAppState()
                                                                    .tracker
                                                                    .selectedDate) {
                                                              return FlutterFlowTheme
                                                                      .of(context)
                                                                  .waterColor;
                                                            } else if (daysListItem <=
                                                                FFAppState()
                                                                    .tracker
                                                                    .currentDate!) {
                                                              return FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText;
                                                            } else {
                                                              return FlutterFlowTheme
                                                                      .of(context)
                                                                  .secondaryText;
                                                            }
                                                          }(),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (dateTimeFormat(
                                              "yyyy/MM", daysListItem) ==
                                          dateTimeFormat("yyyy/MM",
                                              _model.selectedMonthAndYear)) {
                                        return InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            if (daysListItem <=
                                                FFAppState()
                                                    .tracker
                                                    .currentDate!) {
                                              FFAppState().updateTrackerStruct(
                                                (e) => e
                                                  ..selectedDate = daysListItem,
                                              );
                                              FFAppState().update(() {});
                                            }
                                          },
                                          child: Container(
                                            width: (MediaQuery.sizeOf(context)
                                                        .width -
                                                    100) /
                                                7,
                                            height: (MediaQuery.sizeOf(context)
                                                        .width -
                                                    100) /
                                                7,
                                            decoration: BoxDecoration(
                                              color: daysListItem ==
                                                      FFAppState()
                                                          .tracker
                                                          .selectedDate
                                                  ? FlutterFlowTheme.of(context)
                                                      .waterAccent
                                                  : FlutterFlowTheme.of(context)
                                                      .transparent,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Text(
                                              dateTimeFormat("d", daysListItem),
                                              textAlign: TextAlign.center,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: () {
                                                          if (daysListItem ==
                                                              FFAppState()
                                                                  .tracker
                                                                  .selectedDate) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .waterColor;
                                                          } else if (daysListItem <=
                                                              FFAppState()
                                                                  .tracker
                                                                  .currentDate!) {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText;
                                                          } else {
                                                            return FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryText;
                                                          }
                                                        }(),
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                        lineHeight: 1.0,
                                                      ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          width: (MediaQuery.sizeOf(context)
                                                      .width -
                                                  100) /
                                              7,
                                          height: (MediaQuery.sizeOf(context)
                                                      .width -
                                                  100) /
                                              7,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                        );
                                      }
                                    },
                                  );
                                }),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final days = functions
                            .daysFunction(
                                'Monday', FFAppState().tracker.currentDate!, 7)
                            .toList()
                            .take(7)
                            .toList();

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
                                  FFAppState().updateTrackerStruct(
                                    (e) => e..selectedDate = daysItem,
                                  );
                                  FFAppState().update(() {});
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: daysItem ==
                                            FFAppState().tracker.selectedDate
                                        ? FlutterFlowTheme.of(context)
                                            .waterAccent
                                        : FlutterFlowTheme.of(context)
                                            .transparent,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: daysItem ==
                                              FFAppState().tracker.selectedDate
                                          ? FlutterFlowTheme.of(context)
                                              .waterColor
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
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: daysItem ==
                                                        FFAppState()
                                                            .tracker
                                                            .selectedDate
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .waterColor
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
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
                                        CircularPercentIndicator(
                                          percent: valueOrDefault<double>(
                                            FFAppState()
                                                .tracker
                                                .water
                                                .where(
                                                    (e) => e.date == daysItem)
                                                .toList()
                                                .firstOrNull
                                                ?.progress,
                                            0.5,
                                          ),
                                          radius: 15.0,
                                          lineWidth: 3.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor:
                                              FlutterFlowTheme.of(context)
                                                  .waterColor,
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .waterAccent,
                                          center: Text(
                                            dateTimeFormat("d", daysItem),
                                            style: FlutterFlowTheme.of(context)
                                                .bodySmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodySmall
                                                            .fontStyle,
                                                  ),
                                                  color: daysItem ==
                                                          FFAppState()
                                                              .tracker
                                                              .selectedDate
                                                      ? FlutterFlowTheme.of(
                                                              context)
                                                          .waterColor
                                                      : FlutterFlowTheme.of(
                                                              context)
                                                          .primaryText,
                                                  fontSize: 14.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodySmall
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ].divide(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).divide(SizedBox(width: 3.0)),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (_model.showMore) {
                  if (animationsMap['iconOnActionTriggerAnimation'] != null) {
                    animationsMap['iconOnActionTriggerAnimation']!
                        .controller
                        .reverse();
                  }
                  _model.showMore = false;
                  safeSetState(() {});
                } else {
                  if (animationsMap['iconOnActionTriggerAnimation'] != null) {
                    animationsMap['iconOnActionTriggerAnimation']!
                        .controller
                        .forward(from: 0.0);
                  }
                  _model.showMore = true;
                  safeSetState(() {});
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 6.0),
                    child: Icon(
                      FFIcons.kchevronDown,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 22.0,
                    ).animateOnActionTrigger(
                      animationsMap['iconOnActionTriggerAnimation']!,
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
