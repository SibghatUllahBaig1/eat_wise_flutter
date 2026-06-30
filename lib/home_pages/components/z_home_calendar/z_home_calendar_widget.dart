import '/backend/schema/structs/index.dart';
import '/backend/utils/date_utils.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import 'dart:async';
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
import 'z_home_calendar_model.dart';
export 'z_home_calendar_model.dart';

class ZHomeCalendarWidget extends StatefulWidget {
  const ZHomeCalendarWidget({super.key});

  @override
  State<ZHomeCalendarWidget> createState() => _ZHomeCalendarWidgetState();
}

class _ZHomeCalendarWidgetState extends State<ZHomeCalendarWidget>
    with TickerProviderStateMixin {
  late ZHomeCalendarModel _model;

  final animationsMap = <String, AnimationInfo>{};

  static const Color _withinGoalColor = Color(0xFF4CAF50);
  static const Color _overGoalColor = Color(0xFFF44336);

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZHomeCalendarModel());

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.selectedDate = FFAppState().tracker.selectedDate;
      _model.selectedMonthAndYear = FFAppState().tracker.currentDate;
      _model.size = (MediaQuery.sizeOf(context).width - 100) / 7;
      _model.dates = functions
          .lastDaysWindow(FFAppState().tracker.currentDate!, 7)
          .toList()
          .cast<DateTime>();

      final weekDates = functions
          .lastDaysWindow(FFAppState().tracker.currentDate!, 7)
          .toList();
      await _model.loadNutritionProgressForDates(weekDates);
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

  bool _isSelected(DateTime date) =>
      isSameCalendarDay(date, FFAppState().tracker.selectedDate);

  bool _isFuture(DateTime date) =>
      !isSameCalendarDay(date, FFAppState().tracker.currentDate!) &&
      date.isAfter(FFAppState().tracker.currentDate!);

  List<DateTime> _monthDaysForSelectedMonth() => functions
      .getMonthDays(
        'Monday',
        dateTimeFormat('yyyy/MM', _model.selectedMonthAndYear),
      )
      .toList();

  Future<void> _loadVisibleMonthProgress() async {
    if (!mounted) return;
    _model.isLoadingMonthProgress = true;
    safeSetState(() {});

    await _model.loadNutritionProgressForDates(_monthDaysForSelectedMonth());

    if (!mounted) return;
    _model.isLoadingMonthProgress = false;
    safeSetState(() {});
  }

  void _toggleCalendarExpanded() {
    if (_model.showMore) {
      animationsMap['iconOnActionTriggerAnimation']?.controller.reverse();
      _model.showMore = false;
      safeSetState(() {});
      return;
    }

    animationsMap['iconOnActionTriggerAnimation']?.controller.forward(from: 0.0);
    _model.showMore = true;
    safeSetState(() {});
    unawaited(_loadVisibleMonthProgress());
  }

  Color _dayTextColor(BuildContext context, DateTime date, {bool selected = false}) {
    if (selected) {
      return _withinGoalColor;
    }
    if (_isFuture(date)) {
      return FlutterFlowTheme.of(context).secondaryText;
    }
    return FlutterFlowTheme.of(context).primaryText;
  }

  Widget _buildWeekDayCell(BuildContext context, DateTime daysItem) {
    final selected = _isSelected(daysItem);

    return Expanded(
      child: StreamBuilder<Map<String, dynamic>>(
        stream: _model.streamNutritionData(daysItem),
        builder: (context, snapshot) {
          final data =
              snapshot.data ?? {'progress': 0.0, 'withinGoal': true};
          final progress = (data['progress'] as num?)?.toDouble() ?? 0.0;
          final withinGoal = data['withinGoal'] as bool? ?? true;
          final progressColor =
              withinGoal ? _withinGoalColor : _overGoalColor;

          return InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              if (!_isFuture(daysItem)) {
                FFAppState().updateTrackerStruct(
                  (e) => e..selectedDate = normalizeToDate(daysItem),
                );
                FFAppState().update(() {});
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: selected
                    ? progressColor.withValues(alpha: 0.12)
                    : FlutterFlowTheme.of(context).transparent,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: selected ? progressColor : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      dateTimeFormat('E', daysItem),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: _dayTextColor(context, daysItem,
                                selected: selected),
                            fontSize: 12.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                    CircularPercentIndicator(
                      percent: progress.clamp(0.0, 1.0),
                      radius: 15.0,
                      lineWidth: 3.0,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: progressColor,
                      backgroundColor: progressColor.withValues(alpha: 0.2),
                      center: Text(
                        dateTimeFormat('d', daysItem),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.normal,
                              ),
                              color: _dayTextColor(context, daysItem,
                                  selected: selected),
                              fontSize: 14.0,
                            ),
                      ),
                    ),
                  ].divide(SizedBox(height: 10.0)),
                ),
              ),
            ),
          );
        },
      ),
    );
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
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              child: Builder(
                builder: (context) {
                  if (_model.showMore) {
                    return Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                6.0, 0.0, 6.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlutterFlowIconButton(
                                  borderRadius: 50.0,
                                  buttonSize: 44.0,
                                  fillColor:
                                      FlutterFlowTheme.of(context).transparent,
                                  icon: Icon(
                                    FFIcons.kchevronLeft,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 22.0,
                                  ),
                                  onPressed: () {
                                    _model.selectedMonthAndYear =
                                        functions.getLastMonthDateTime(
                                            _model.selectedMonthAndYear!);
                                    safeSetState(() {});
                                    unawaited(_loadVisibleMonthProgress());
                                  },
                                ),
                                Text(
                                  '${dateTimeFormat('MMM', _model.selectedMonthAndYear)}, ${dateTimeFormat('y', _model.selectedMonthAndYear)}',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FlutterFlowTheme.of(
                                                  context)
                                              .titleMedium
                                              .fontWeight,
                                        ),
                                      ),
                                ),
                                FlutterFlowIconButton(
                                  borderRadius: 50.0,
                                  buttonSize: 44.0,
                                  fillColor:
                                      FlutterFlowTheme.of(context).transparent,
                                  icon: Icon(
                                    FFIcons.kchevronRight,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 22.0,
                                  ),
                                  onPressed: () {
                                    _model.selectedMonthAndYear =
                                        functions.getNextMonthDateTime(
                                            _model.selectedMonthAndYear!);
                                    safeSetState(() {});
                                    unawaited(_loadVisibleMonthProgress());
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 16.0, 16.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ]
                                  .map(
                                    (label) => Expanded(
                                      child: Text(
                                        label,
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 16.0, 8.0),
                            child: Builder(
                              builder: (context) {
                                final daysList = _monthDaysForSelectedMonth();

                                return Wrap(
                                  spacing: 6.0,
                                  runSpacing: 6.0,
                                  children:
                                      List.generate(daysList.length, (index) {
                                    final day = daysList[index];
                                    final inMonth = dateTimeFormat(
                                            'yyyy/MM', day) ==
                                        dateTimeFormat('yyyy/MM',
                                            _model.selectedMonthAndYear);
                                    if (!inMonth) {
                                      return SizedBox(
                                        width: _model.size,
                                        height: _model.size,
                                      );
                                    }

                                    final progress =
                                        _model.getProgressForDate(day);
                                    final withinGoal =
                                        _model.isWithinGoalForDate(day);
                                    final progressColor = withinGoal
                                        ? _withinGoalColor
                                        : _overGoalColor;
                                    final selected = _isSelected(day);

                                    return InkWell(
                                      onTap: () {
                                        if (!_isFuture(day)) {
                                          FFAppState().updateTrackerStruct(
                                            (e) => e
                                              ..selectedDate =
                                                  normalizeToDate(day),
                                          );
                                          FFAppState().update(() {});
                                        }
                                      },
                                      child: Container(
                                        width: _model.size,
                                        height: _model.size,
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? progressColor
                                                  .withValues(alpha: 0.12)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: selected
                                                ? progressColor
                                                : Colors.transparent,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: progress > 0
                                            ? CircularPercentIndicator(
                                                percent: progress,
                                                radius: 16.0,
                                                lineWidth: 3.0,
                                                animation: false,
                                                progressColor: progressColor,
                                                backgroundColor: progressColor
                                                    .withValues(alpha: 0.2),
                                                center: Text(
                                                  dateTimeFormat('d', day),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall,
                                                ),
                                              )
                                            : Text(
                                                dateTimeFormat('d', day),
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      color: _dayTextColor(
                                                        context,
                                                        day,
                                                        selected: selected,
                                                      ),
                                                    ),
                                              ),
                                      ),
                                    );
                                  }),
                                );
                              },
                            ),
                          ),
                          if (_model.isLoadingMonthProgress)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: SizedBox(
                                height: 2.0,
                                child: LinearProgressIndicator(
                                  backgroundColor: FlutterFlowTheme.of(context)
                                      .divider
                                      .withValues(alpha: 0.3),
                                  color: _withinGoalColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }

                  final days = functions
                      .lastDaysWindow(FFAppState().tracker.currentDate!, 7)
                      .toList();

                  return Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        16.0, 16.0, 16.0, 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateTimeFormat('yMMMM', _model.selectedDate),
                          style: FlutterFlowTheme.of(context).titleMedium,
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: Row(
                            children: List.generate(days.length, (index) {
                              return _buildWeekDayCell(context, days[index]);
                            }).divide(SizedBox(width: 3.0)),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 12.0, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  color: _withinGoalColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 16.0, 0.0),
                                child: Text(
                                  'Within goal',
                                  style:
                                      FlutterFlowTheme.of(context).labelSmall,
                                ),
                              ),
                              Container(
                                width: 10.0,
                                height: 10.0,
                                decoration: BoxDecoration(
                                  color: _overGoalColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 0.0, 0.0),
                                child: Text(
                                  'Over goal',
                                  style:
                                      FlutterFlowTheme.of(context).labelSmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            InkWell(
              onTap: _toggleCalendarExpanded,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
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
