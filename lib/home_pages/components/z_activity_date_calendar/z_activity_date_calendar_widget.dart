import '/backend/utils/date_utils.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'z_activity_date_calendar_model.dart';
export 'z_activity_date_calendar_model.dart';

/// Date picker styled like the water tracker calendar — for logging activities
/// on past dates without affecting home calorie tracking.
class ZActivityDateCalendarWidget extends StatefulWidget {
  const ZActivityDateCalendarWidget({
    super.key,
    this.initialSelectedDate,
    this.onDateSelected,
  });

  final DateTime? initialSelectedDate;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  State<ZActivityDateCalendarWidget> createState() =>
      _ZActivityDateCalendarWidgetState();
}

class _ZActivityDateCalendarWidgetState extends State<ZActivityDateCalendarWidget>
    with TickerProviderStateMixin {
  late ZActivityDateCalendarModel _model;
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZActivityDateCalendarModel());

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final initial = normalizeToDate(widget.initialSelectedDate ?? DateTime.now());
      _model.selectedDate = initial;
      _model.selectedMonthAndYear = initial;
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
  void didUpdateWidget(covariant ZActivityDateCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedDate == oldWidget.initialSelectedDate) return;
    if (widget.initialSelectedDate == null) return;
    final normalized = normalizeToDate(widget.initialSelectedDate!);
    _model.selectedDate = normalized;
    _model.selectedMonthAndYear = normalized;
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  DateTime get _currentDate => normalizeToDate(DateTime.now());

  bool _isSelected(DateTime date) =>
      isSameCalendarDay(date, _model.selectedDate);

  bool _isFuture(DateTime date) => normalizeToDate(date).isAfter(_currentDate);

  void _selectDate(DateTime date) {
    if (_isFuture(date)) return;
    final normalized = normalizeToDate(date);
    _model.selectedDate = normalized;
    _model.selectedMonthAndYear = normalized;
    widget.onDateSelected?.call(normalized);
    safeSetState(() {});
  }

  List<DateTime> _weekDays() =>
      functions.weekDaysMondayToSunday(_model.selectedDate ?? _currentDate).toList();

  List<DateTime> _monthDays() => functions
      .getMonthDays(
        'Monday',
        dateTimeFormat('yyyy/MM', _model.selectedMonthAndYear),
      )
      .toList();

  Color _accentColor(BuildContext context) =>
      FlutterFlowTheme.of(context).primary;

  Color _accentBackground(BuildContext context) =>
      FlutterFlowTheme.of(context).successAccent;

  Color _dayColor(BuildContext context, DateTime date) {
    if (_isSelected(date)) {
      return _accentColor(context);
    }
    if (_isFuture(date)) {
      return FlutterFlowTheme.of(context).secondaryText;
    }
    return FlutterFlowTheme.of(context).primaryText;
  }

  Widget _weekDayCell(BuildContext context, DateTime day) {
    final selected = _isSelected(day);
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _selectDate(day),
        child: Container(
          decoration: BoxDecoration(
            color: selected
                ? _accentBackground(context)
                : FlutterFlowTheme.of(context).transparent,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: selected
                  ? _accentColor(context)
                  : FlutterFlowTheme.of(context).transparent,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dateTimeFormat('E', day),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(),
                        color: _dayColor(context, day),
                        fontSize: 12.0,
                      ),
                ),
                CircularPercentIndicator(
                  percent: 0.0,
                  radius: 15.0,
                  lineWidth: 3.0,
                  animation: false,
                  progressColor: _accentColor(context),
                  backgroundColor: _accentBackground(context),
                  center: Text(
                    dateTimeFormat('d', day),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.normal),
                          color: _dayColor(context, day),
                          fontSize: 14.0,
                        ),
                  ),
                ),
              ].divide(SizedBox(height: 10.0)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthDayCell(BuildContext context, DateTime day) {
    final inMonth = dateTimeFormat('yyyy/MM', day) ==
        dateTimeFormat('yyyy/MM', _model.selectedMonthAndYear);
    if (!inMonth) {
      return SizedBox(width: _model.size, height: _model.size);
    }

    final selected = _isSelected(day);
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _selectDate(day),
      child: Container(
        width: _model.size,
        height: _model.size,
        decoration: BoxDecoration(
          color: selected
              ? _accentBackground(context)
              : FlutterFlowTheme.of(context).transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          dateTimeFormat('d', day),
          textAlign: TextAlign.center,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                color: _dayColor(context, day),
              ),
        ),
      ),
    );
  }

  void _toggleExpanded() {
    if (_model.showMore) {
      animationsMap['iconOnActionTriggerAnimation']?.controller.reverse();
      _model.showMore = false;
    } else {
      animationsMap['iconOnActionTriggerAnimation']?.controller.forward(from: 0.0);
      _model.showMore = true;
    }
    safeSetState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: _model.showMore
                ? Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 6.0, 0.0),
                          child: Row(
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
                                onPressed: () {
                                  _model.selectedMonthAndYear =
                                      functions.getLastMonthDateTime(
                                          _model.selectedMonthAndYear!);
                                  safeSetState(() {});
                                },
                              ),
                              Text(
                                dateTimeFormat('yMMM', _model.selectedMonthAndYear),
                                style: FlutterFlowTheme.of(context).titleMedium,
                              ),
                              FlutterFlowIconButton(
                                borderRadius: 50.0,
                                buttonSize: 44.0,
                                fillColor: FlutterFlowTheme.of(context).transparent,
                                icon: Icon(
                                  FFIcons.kchevronRight,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 22.0,
                                ),
                                onPressed: () {
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
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                          child: Row(
                            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                                .map(
                                  (label) => Expanded(
                                    child: Text(
                                      label,
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context).labelSmall,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 8.0),
                          child: Wrap(
                            spacing: 6.0,
                            runSpacing: 6.0,
                            children: _monthDays()
                                .map((day) => _monthDayCell(context, day))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Row(
                      children: _weekDays()
                          .map((day) => _weekDayCell(context, day))
                          .toList()
                          .divide(SizedBox(width: 3.0)),
                    ),
                  ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: _toggleExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
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
    );
  }
}
