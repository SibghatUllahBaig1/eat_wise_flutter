import '/backend/schema/structs/index.dart';
import '/backend/utils/date_utils.dart';
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
import 'z_calendar_model.dart';
export 'z_calendar_model.dart';

class ZCalendarWidget extends StatefulWidget {
  const ZCalendarWidget({
    super.key,
    this.embedded = false,
    this.initialSelectedDate,
    this.onDateSelected,
  });

  /// When true, hides Cancel/Save and reports selection via [onDateSelected].
  final bool embedded;

  final DateTime? initialSelectedDate;

  final ValueChanged<DateTime>? onDateSelected;

  @override
  State<ZCalendarWidget> createState() => _ZCalendarWidgetState();
}

class _ZCalendarWidgetState extends State<ZCalendarWidget> {
  late ZCalendarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZCalendarModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _syncSelectedDateFromWidget();
      safeSetState(() {});
    });
  }

  void _syncSelectedDateFromWidget() {
    final initial = widget.initialSelectedDate ??
        FFAppState().tracker.selectedDate ??
        FFAppState().tracker.currentDate ??
        DateTime.now();
    final normalized = normalizeToDate(initial);
    _model.selectedDate = normalized;
    _model.selectedMonthAndYear = normalized;
  }

  @override
  void didUpdateWidget(covariant ZCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedDate != oldWidget.initialSelectedDate &&
        widget.initialSelectedDate != null) {
      final normalized = normalizeToDate(widget.initialSelectedDate!);
      _model.selectedDate = normalized;
      _model.selectedMonthAndYear = normalized;
    }
  }

  DateTime? get _currentDate =>
      FFAppState().tracker.currentDate != null
          ? normalizeToDate(FFAppState().tracker.currentDate!)
          : normalizeToDate(DateTime.now());

  bool _isSameDay(DateTime? a, DateTime? b) => isSameCalendarDay(a, b);

  void _selectDate(DateTime date) {
    final normalized = normalizeToDate(date);
    _model.selectedDate = normalized;
    if (widget.embedded) {
      widget.onDateSelected?.call(normalized);
    }
    safeSetState(() {});
  }

  double _dayCellSize(BuildContext context) {
    final horizontalInset = widget.embedded ? 64.0 : 116.0;
    return (MediaQuery.sizeOf(context).width - horizontalInset) / 7;
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
        padding: EdgeInsetsDirectional.fromSTEB(
            widget.embedded ? 0.0 : 24.0, 0.0, widget.embedded ? 0.0 : 24.0, 0.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlutterFlowIconButton(
                        borderRadius: 50.0,
                        buttonSize: 44.0,
                        fillColor: FlutterFlowTheme.of(context).transparent,
                        icon: Icon(
                          FFIcons.kchevronLeft,
                          color: FlutterFlowTheme.of(context).primaryText,
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
                        dateTimeFormat("yMMM", _model.selectedMonthAndYear),
                        style:
                            FlutterFlowTheme.of(context).titleMedium.override(
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
                        fillColor: FlutterFlowTheme.of(context).transparent,
                        icon: Icon(
                          FFIcons.kchevronRight,
                          color: FlutterFlowTheme.of(context).primaryText,
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
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Mon',
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                          'Tue',
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                          style:
                              FlutterFlowTheme.of(context).labelSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
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
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                  child: Builder(
                    builder: (context) {
                      final daysList = functions
                          .getMonthDays(
                              'Monday',
                              dateTimeFormat(
                                  "yyyy/MM", _model.selectedMonthAndYear))
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
                        children:
                            List.generate(daysList.length, (daysListIndex) {
                          final daysListItem = daysList[daysListIndex];
                          return Builder(
                            builder: (context) {
                              if (dateTimeFormat("yyyy/MM", daysListItem) ==
                                  dateTimeFormat(
                                      "yyyy/MM", _model.selectedMonthAndYear)) {
                                return InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    final currentDate = _currentDate;
                                    if (currentDate != null &&
                                        !normalizeToDate(daysListItem)
                                            .isAfter(currentDate)) {
                                      _selectDate(daysListItem);
                                    }
                                  },
                                  child: Container(
                                    width: _dayCellSize(context),
                                    height: _dayCellSize(context),
                                    decoration: BoxDecoration(
                                      color: _isSameDay(
                                              daysListItem, _model.selectedDate)
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Text(
                                      dateTimeFormat("d", daysListItem),
                                      textAlign: TextAlign.center,
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
                                              if (_isSameDay(daysListItem,
                                                  _model.selectedDate)) {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .info;
                                              } else if (_currentDate !=
                                                      null &&
                                                  !normalizeToDate(daysListItem)
                                                      .isAfter(_currentDate!)) {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .primaryText;
                                              } else {
                                                return FlutterFlowTheme.of(
                                                        context)
                                                    .secondaryText;
                                              }
                                            }(),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  ),
                                );
                              } else {
                                return Container(
                                  width: _dayCellSize(context),
                                  height: _dayCellSize(context),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                );
                              }
                            },
                          );
                        }),
                      );
                    },
                  ),
                ),
                if (!widget.embedded)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16.0, 24.0, 16.0, 16.0),
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
                                16.0, 0.0, 16.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color:
                                FlutterFlowTheme.of(context).transparent,
                            textStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        FFButtonWidget(
                          onPressed: () async {
                            FFAppState().updateTrackerStruct(
                              (e) => e..selectedDate = _model.selectedDate,
                            );
                            FFAppState().update(() {});
                            Navigator.pop(context);
                          },
                          text: 'Save',
                          options: FFButtonOptions(
                            height: 40.0,
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).info,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ].divide(SizedBox(width: 6.0)),
                    ),
                  )
                else
                  const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
