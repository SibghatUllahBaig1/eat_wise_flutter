import '/backend/services/meal_reminder_service.dart';
import '/backend/services/meal_reminder_preferences.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'z_meal_reminder_model.dart';
export 'z_meal_reminder_model.dart';

class ZMealReminderWidget extends StatefulWidget {
  const ZMealReminderWidget({
    super.key,
    required this.mealType,
  });

  final String mealType;

  @override
  State<ZMealReminderWidget> createState() => _ZMealReminderWidgetState();
}

class _ZMealReminderWidgetState extends State<ZMealReminderWidget> {
  late ZMealReminderModel _model;
  final MealReminderService _reminderService = MealReminderService();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZMealReminderModel());
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings =
        await MealReminderPreferences.loadMealReminder(widget.mealType);
    safeSetState(() {
      _model.reminderEnabled = settings['enabled'] as bool;
      _model.hour = settings['hour'] as int;
      _model.minute = settings['minute'] as int;
      _model.vibrationEnabled = settings['vibration'] as bool;
      _model.repeatDays = List<String>.from(settings['repeatDays'] as List);
    });
  }

  Future<void> _saveSettings() async {
    await MealReminderPreferences.saveMealReminder(
      mealType: widget.mealType,
      enabled: _model.reminderEnabled,
      hour: _model.hour,
      minute: _model.minute,
      vibration: _model.vibrationEnabled,
      repeatDays: _model.repeatDays,
    );

    if (_model.reminderEnabled) {
      await _reminderService.scheduleMealReminder(
        id: _getMealReminderId(),
        mealType: widget.mealType,
        hour: _model.hour,
        minute: _model.minute,
        enableVibration: _model.vibrationEnabled,
        repeatDays: _model.repeatDays,
      );
    } else {
      await _reminderService.cancelMealReminder(_getMealReminderId());
    }
  }

  int _getMealReminderId() {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return 2001;
      case 'lunch':
        return 2002;
      case 'dinner':
        return 2003;
      case 'snack':
        return 2004;
      default:
        return 2000;
    }
  }

  String _getMealTitle() {
    switch (widget.mealType.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast Reminder';
      case 'lunch':
        return 'Lunch Reminder';
      case 'dinner':
        return 'Dinner Reminder';
      case 'snack':
        return 'Snack Reminder';
      default:
        return 'Meal Reminder';
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // Enable/Disable reminder
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {
            safeSetState(
                () => _model.reminderEnabled = !_model.reminderEnabled);
            await _saveSettings();
          },
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 15.0, 20.0),
                    child: Text(
                      _getMealTitle(),
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
                _buildToggle(_model.reminderEnabled),
              ],
            ),
          ),
        ),
        if (_model.reminderEnabled) ...[
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).divider,
          ),
          // Reminder time
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              final greenColor = FlutterFlowTheme.of(context).primary;
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay(hour: _model.hour, minute: _model.minute),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: greenColor,
                            onPrimary: Colors.white,
                            onSurface: FlutterFlowTheme.of(context).primaryText,
                          ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(
                          foregroundColor: greenColor,
                        ),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                safeSetState(() {
                  _model.hour = picked.hour;
                  _model.minute = picked.minute;
                });
                await _saveSettings();
              }
            },
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Reminder Time',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                  ),
                  Expanded(
                    child: Text(
                      '${_model.hour.toString().padLeft(2, '0')}:${_model.minute.toString().padLeft(2, '0')}',
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                    child: Icon(
                      Icons.chevron_right,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).divider,
          ),
          // Vibration
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              safeSetState(
                  () => _model.vibrationEnabled = !_model.vibrationEnabled);
              await _saveSettings();
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 15.0, 20.0),
                    child: Text(
                      'Vibration',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                    ),
                  ),
                ),
                _buildToggle(_model.vibrationEnabled),
              ],
            ),
          ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: FlutterFlowTheme.of(context).divider,
          ),
          // Repeat days
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              _showRepeatSelector();
            },
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Repeat',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                  ),
                  Expanded(
                    child: Text(
                      _model.repeatDays.length == 7
                          ? 'Everyday'
                          : _model.repeatDays.isEmpty
                              ? 'Never'
                              : '${_model.repeatDays.length} days',
                      textAlign: TextAlign.end,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(6.0, 0.0, 0.0, 0.0),
                    child: Icon(
                      Icons.chevron_right,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildToggle(bool value) {
    return Container(
      width: 48.0,
      height: 28.0,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: value
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).divider,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(value ? 1.0 : -1.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 2.0, 0.0),
              child: Container(
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).info,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.0,
                      color: Color(0x0E000000),
                      offset: Offset(value ? -1.0 : 1.0, 0.0),
                    )
                  ],
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRepeatSelector() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    // Keep a local copy so the dialog can update independently
    List<String> localDays = List<String>.from(_model.repeatDays);

    showDialog(
      context: context,
      builder: (dialogContext) {
        final greenColor = FlutterFlowTheme.of(context).primary;
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              title: Text(
                'Repeat',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: days.map((day) {
                    final isSelected = localDays.contains(day);
                    return InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setDialogState(() {
                          if (isSelected) {
                            localDays.remove(day);
                          } else {
                            localDays.add(day);
                          }
                        });
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 10.0, 0.0, 10.0),
                        child: Row(
                          children: [
                            Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? greenColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6.0),
                                border: Border.all(
                                  color: isSelected
                                      ? greenColor
                                      : FlutterFlowTheme.of(context).divider,
                                  width: 2.0,
                                ),
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16.0,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              day,
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                    ),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(
                    'Cancel',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final nav = Navigator.of(dialogContext);
                    safeSetState(() => _model.repeatDays = localDays);
                    await _saveSettings();
                    nav.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 10.0),
                  ),
                  child: Text(
                    'OK',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                          color: Colors.white,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
