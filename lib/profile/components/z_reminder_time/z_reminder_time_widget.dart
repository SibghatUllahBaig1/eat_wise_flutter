import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_reminder_time_model.dart';
export 'z_reminder_time_model.dart';

class ZReminderTimeWidget extends StatefulWidget {
  const ZReminderTimeWidget({
    super.key,
    required this.trackerType,
  });

  final int? trackerType;

  @override
  State<ZReminderTimeWidget> createState() => _ZReminderTimeWidgetState();
}

class _ZReminderTimeWidgetState extends State<ZReminderTimeWidget> {
  late ZReminderTimeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZReminderTimeModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget!.trackerType == 0) {
        _model.hour = FFAppState().trackerSettings.calorie.reminderTime.hour;
        _model.min = FFAppState().trackerSettings.calorie.reminderTime.min;
        _model.type = FFAppState().trackerSettings.calorie.reminderTime.type;
        _model.typeIndex =
            FFAppState().trackerSettings.calorie.reminderTime.type == 'AM'
                ? 0
                : 1;
        _model.minIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.calorie.reminderTime.min,
            functions.getMinutes().toList());
        _model.hourIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.calorie.reminderTime.hour,
            functions.getHours().toList());
        safeSetState(() {});
      } else if (widget!.trackerType == 1) {
        _model.hour = FFAppState().trackerSettings.water.reminderTime.hour;
        _model.min = FFAppState().trackerSettings.water.reminderTime.min;
        _model.type = FFAppState().trackerSettings.water.reminderTime.type;
        _model.typeIndex =
            FFAppState().trackerSettings.water.reminderTime.type == 'AM'
                ? 0
                : 1;
        _model.minIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.water.reminderTime.min,
            functions.getMinutes().toList());
        _model.hourIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.water.reminderTime.hour,
            functions.getHours().toList());
        safeSetState(() {});
      } else if (widget!.trackerType == 2) {
        _model.hour = FFAppState().trackerSettings.step.reminderTime.hour;
        _model.min = FFAppState().trackerSettings.step.reminderTime.min;
        _model.type = FFAppState().trackerSettings.step.reminderTime.type;
        _model.typeIndex =
            FFAppState().trackerSettings.step.reminderTime.type == 'AM' ? 0 : 1;
        _model.minIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.step.reminderTime.min,
            functions.getMinutes().toList());
        _model.hourIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.step.reminderTime.hour,
            functions.getHours().toList());
        safeSetState(() {});
      } else {
        _model.hour = FFAppState().trackerSettings.weight.reminderTime.hour;
        _model.min = FFAppState().trackerSettings.weight.reminderTime.min;
        _model.type = FFAppState().trackerSettings.weight.reminderTime.type;
        _model.typeIndex =
            FFAppState().trackerSettings.weight.reminderTime.type == 'AM'
                ? 0
                : 1;
        _model.minIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.weight.reminderTime.min,
            functions.getMinutes().toList());
        _model.hourIndex = functions.getIndexOfItems(
            FFAppState().trackerSettings.weight.reminderTime.hour,
            functions.getHours().toList());
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
                  'Reminder Time',
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final hourList = functions.getHours().toList();

                            return Container(
                              width: 120.0,
                              height: 180.0,
                              child: CarouselSlider.builder(
                                itemCount: hourList.length,
                                itemBuilder: (context, hourListIndex, _) {
                                  final hourListItem = hourList[hourListIndex];
                                  return Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        hourListItem,
                                        'null',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .fontStyle,
                                            ),
                                            color: hourListItem == _model.hour
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            fontSize: 24.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  );
                                },
                                carouselController:
                                    _model.carouselHourController ??=
                                        CarouselSliderController(),
                                options: CarouselOptions(
                                  initialPage: max(
                                      0,
                                      min(
                                          valueOrDefault<int>(
                                            () {
                                              if (widget!.trackerType == 0) {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .calorie
                                                            .reminderTime
                                                            .hour,
                                                        functions
                                                            .getHours()
                                                            .toList());
                                              } else if (widget!.trackerType ==
                                                  1) {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .water
                                                            .reminderTime
                                                            .hour,
                                                        functions
                                                            .getHours()
                                                            .toList());
                                              } else if (widget!.trackerType ==
                                                  2) {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .step
                                                            .reminderTime
                                                            .hour,
                                                        functions
                                                            .getHours()
                                                            .toList());
                                              } else {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .weight
                                                            .reminderTime
                                                            .hour,
                                                        functions
                                                            .getHours()
                                                            .toList());
                                              }
                                            }(),
                                            0,
                                          ),
                                          hourList.length - 1)),
                                  viewportFraction: 0.21,
                                  disableCenter: true,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.25,
                                  enableInfiniteScroll: false,
                                  scrollDirection: Axis.vertical,
                                  autoPlay: false,
                                  onPageChanged: (index, _) async {
                                    _model.carouselHourCurrentIndex = index;
                                    _model.hourIndex =
                                        _model.carouselHourCurrentIndex;
                                    safeSetState(() {});
                                    _model.hour = hourList
                                        .elementAtOrNull(_model.hourIndex!)!;
                                    safeSetState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final minList = functions.getMinutes().toList();

                            return Container(
                              width: 120.0,
                              height: 180.0,
                              child: CarouselSlider.builder(
                                itemCount: minList.length,
                                itemBuilder: (context, minListIndex, _) {
                                  final minListItem = minList[minListIndex];
                                  return Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        minListItem,
                                        'null',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .fontStyle,
                                            ),
                                            color: minListItem == _model.min
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            fontSize: 24.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  );
                                },
                                carouselController:
                                    _model.carouselMinController ??=
                                        CarouselSliderController(),
                                options: CarouselOptions(
                                  initialPage: max(
                                      0,
                                      min(
                                          valueOrDefault<int>(
                                            () {
                                              if (widget!.trackerType == 0) {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .calorie
                                                            .reminderTime
                                                            .min,
                                                        functions
                                                            .getMinutes()
                                                            .toList());
                                              } else if (widget!.trackerType ==
                                                  1) {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .water
                                                            .reminderTime
                                                            .min,
                                                        functions
                                                            .getMinutes()
                                                            .toList());
                                              } else if (widget!.trackerType ==
                                                  2) {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .step
                                                            .reminderTime
                                                            .min,
                                                        functions
                                                            .getMinutes()
                                                            .toList());
                                              } else {
                                                return functions
                                                    .getIndexOfItems(
                                                        FFAppState()
                                                            .trackerSettings
                                                            .weight
                                                            .reminderTime
                                                            .min,
                                                        functions
                                                            .getMinutes()
                                                            .toList());
                                              }
                                            }(),
                                            0,
                                          ),
                                          minList.length - 1)),
                                  viewportFraction: 0.21,
                                  disableCenter: true,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.25,
                                  enableInfiniteScroll: false,
                                  scrollDirection: Axis.vertical,
                                  autoPlay: false,
                                  onPageChanged: (index, _) async {
                                    _model.carouselMinCurrentIndex = index;
                                    _model.minIndex =
                                        _model.carouselMinCurrentIndex;
                                    safeSetState(() {});
                                    _model.min = minList
                                        .elementAtOrNull(_model.minIndex!)!;
                                    safeSetState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Builder(
                          builder: (context) {
                            final yearsList = _model.typeList.toList();

                            return Container(
                              width: 120.0,
                              height: 180.0,
                              child: CarouselSlider.builder(
                                itemCount: yearsList.length,
                                itemBuilder: (context, yearsListIndex, _) {
                                  final yearsListItem =
                                      yearsList[yearsListIndex];
                                  return Align(
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        yearsListItem,
                                        'null',
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleLarge
                                                      .fontStyle,
                                            ),
                                            color: yearsListItem == _model.type
                                                ? FlutterFlowTheme.of(context)
                                                    .primaryText
                                                : FlutterFlowTheme.of(context)
                                                    .secondaryText,
                                            fontSize: 24.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleLarge
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  );
                                },
                                carouselController:
                                    _model.carouselTypeController ??=
                                        CarouselSliderController(),
                                options: CarouselOptions(
                                  initialPage: max(
                                      0,
                                      min(
                                          valueOrDefault<int>(
                                            _model.type == 'AM' ? 0 : 1,
                                            0,
                                          ),
                                          yearsList.length - 1)),
                                  viewportFraction: 0.21,
                                  disableCenter: true,
                                  enlargeCenterPage: true,
                                  enlargeFactor: 0.25,
                                  enableInfiniteScroll: false,
                                  scrollDirection: Axis.vertical,
                                  autoPlay: false,
                                  onPageChanged: (index, _) async {
                                    _model.carouselTypeCurrentIndex = index;
                                    _model.typeIndex =
                                        _model.carouselTypeCurrentIndex;
                                    safeSetState(() {});
                                    _model.type = yearsList
                                        .elementAtOrNull(_model.typeIndex!)!;
                                    safeSetState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ].divide(SizedBox(width: 24.0)),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
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
                                  (e) => e
                                    ..reminderTime = RimenderTimeStruct(
                                      hour: _model.hour,
                                      min: _model.min,
                                      type: _model.type,
                                    ),
                                ),
                            );
                            FFAppState().update(() {});
                          } else if (widget!.trackerType == 1) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWater(
                                  (e) => e
                                    ..reminderTime = RimenderTimeStruct(
                                      hour: _model.hour,
                                      min: _model.min,
                                      type: _model.type,
                                    ),
                                ),
                            );
                            FFAppState().update(() {});
                          } else if (widget!.trackerType == 2) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateStep(
                                  (e) => e
                                    ..reminderTime = RimenderTimeStruct(
                                      hour: _model.hour,
                                      min: _model.min,
                                      type: _model.type,
                                    ),
                                ),
                            );
                            FFAppState().update(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e
                                    ..reminderTime = RimenderTimeStruct(
                                      hour: _model.hour,
                                      min: _model.min,
                                      type: _model.type,
                                    ),
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
