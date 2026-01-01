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
import 'date_selector_model.dart';
export 'date_selector_model.dart';

class DateSelectorWidget extends StatefulWidget {
  const DateSelectorWidget({
    super.key,
    required this.type,
  });

  final int? type;

  @override
  State<DateSelectorWidget> createState() => _DateSelectorWidgetState();
}

class _DateSelectorWidgetState extends State<DateSelectorWidget> {
  late DateSelectorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DateSelectorModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.day =
          functions.daysList().elementAtOrNull(_model.daysCurrentIndex);
      _model.month =
          functions.months().elementAtOrNull(_model.monthsCurrentIndex);
      _model.year = functions.years().elementAtOrNull(_model.yearsCurrentIndex);
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
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 155.0,
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            20.0, 0.0, 20.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                height: 155.0,
                                child: Stack(
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final daysList =
                                            functions.daysList().toList();

                                        return Container(
                                          width: 150.0,
                                          height: 155.0,
                                          child: CarouselSlider.builder(
                                            itemCount: daysList.length,
                                            itemBuilder:
                                                (context, daysListIndex, _) {
                                              final daysListItem =
                                                  daysList[daysListIndex];
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      daysListItem,
                                                      '1',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleMedium
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleMedium
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              );
                                            },
                                            carouselController:
                                                _model.daysController ??=
                                                    CarouselSliderController(),
                                            options: CarouselOptions(
                                              initialPage: max(0,
                                                  min(29, daysList.length - 1)),
                                              viewportFraction: 0.4,
                                              disableCenter: true,
                                              enlargeCenterPage: true,
                                              enlargeFactor: 0.5,
                                              enableInfiniteScroll: true,
                                              scrollDirection: Axis.vertical,
                                              autoPlay: false,
                                              onPageChanged: (index, _) async {
                                                _model.daysCurrentIndex = index;
                                                _model.day = functions
                                                    .daysList()
                                                    .elementAtOrNull(_model
                                                        .daysCurrentIndex);
                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 1.5,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 1.5,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 155.0,
                                child: Stack(
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final monthsList =
                                            functions.months().toList();

                                        return Container(
                                          width: 150.0,
                                          height: 155.0,
                                          child: CarouselSlider.builder(
                                            itemCount: monthsList.length,
                                            itemBuilder:
                                                (context, monthsListIndex, _) {
                                              final monthsListItem =
                                                  monthsList[monthsListIndex];
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      monthsListItem,
                                                      'apr.',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleLarge
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleLarge
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              );
                                            },
                                            carouselController:
                                                _model.monthsController ??=
                                                    CarouselSliderController(),
                                            options: CarouselOptions(
                                              initialPage: max(
                                                  0,
                                                  min(4,
                                                      monthsList.length - 1)),
                                              viewportFraction: 0.4,
                                              disableCenter: true,
                                              enlargeCenterPage: true,
                                              enlargeFactor: 0.5,
                                              enableInfiniteScroll: true,
                                              scrollDirection: Axis.vertical,
                                              autoPlay: false,
                                              onPageChanged: (index, _) async {
                                                _model.monthsCurrentIndex =
                                                    index;
                                                _model.month = functions
                                                    .months()
                                                    .elementAtOrNull(_model
                                                        .monthsCurrentIndex);
                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 1.5,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 1.5,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 155.0,
                                child: Stack(
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        final yearsList =
                                            functions.years().toList();

                                        return Container(
                                          width: 150.0,
                                          height: 155.0,
                                          child: CarouselSlider.builder(
                                            itemCount: yearsList.length,
                                            itemBuilder:
                                                (context, yearsListIndex, _) {
                                              final yearsListItem =
                                                  yearsList[yearsListIndex];
                                              return Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    valueOrDefault<String>(
                                                      yearsListItem,
                                                      '2003',
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .titleLarge
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleLarge
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .titleLarge
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ],
                                              );
                                            },
                                            carouselController:
                                                _model.yearsController ??=
                                                    CarouselSliderController(),
                                            options: CarouselOptions(
                                              initialPage: max(
                                                  0,
                                                  min(55,
                                                      yearsList.length - 1)),
                                              viewportFraction: 0.4,
                                              disableCenter: true,
                                              enlargeCenterPage: true,
                                              enlargeFactor: 0.5,
                                              enableInfiniteScroll: true,
                                              scrollDirection: Axis.vertical,
                                              autoPlay: false,
                                              onPageChanged: (index, _) async {
                                                _model.yearsCurrentIndex =
                                                    index;
                                                _model.year = functions
                                                    .years()
                                                    .elementAtOrNull(_model
                                                        .yearsCurrentIndex);
                                                safeSetState(() {});
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 1.5,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 1.5,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 20.0)),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, -1.0),
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                FlutterFlowTheme.of(context).transparent2
                              ],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: Container(
                          width: double.infinity,
                          height: 40.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context).transparent2,
                                FlutterFlowTheme.of(context).secondaryBackground
                              ],
                              stops: [0.0, 1.0],
                              begin: AlignmentDirectional(0.0, -1.0),
                              end: AlignmentDirectional(0, 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
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
                              16.0, 0.0, 16.0, 0.0),
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
                                color: FlutterFlowTheme.of(context).primaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          if (widget!.type == 0) {
                            FFAppState().dateOfBirth = functions.dateOfBirth(
                                _model.day!, _model.month, _model.year!);
                            FFAppState().update(() {});
                          } else {
                            FFAppState().eventDay = functions.dateOfBirth(
                                _model.day!, _model.month, _model.year!);
                            FFAppState().update(() {});
                          }

                          Navigator.pop(context);
                        },
                        text: 'OK',
                        options: FFButtonOptions(
                          height: 40.0,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).transparent,
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
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(12.0),
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
