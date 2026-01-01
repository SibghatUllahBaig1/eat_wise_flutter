import '/backend/schema/structs/index.dart';
import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/z_calorie_intake_goal/z_calorie_intake_goal_widget.dart';
import '/profile/components/z_calorie_unit/z_calorie_unit_widget.dart';
import '/profile/components/z_reminder_time/z_reminder_time_widget.dart';
import '/profile/components/z_repeat/z_repeat_widget.dart';
import '/profile/components/z_ringtone/z_ringtone_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calorie_counter_model.dart';
export 'calorie_counter_model.dart';

class CalorieCounterWidget extends StatefulWidget {
  const CalorieCounterWidget({super.key});

  static String routeName = 'CalorieCounter';
  static String routePath = '/calorieCounter';

  @override
  State<CalorieCounterWidget> createState() => _CalorieCounterWidgetState();
}

class _CalorieCounterWidgetState extends State<CalorieCounterWidget> {
  late CalorieCounterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalorieCounterModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 22.0,
              borderWidth: 1.0,
              buttonSize: 44.0,
              icon: Icon(
                FFIcons.karrowLeft,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                FFAppState().updateTrackerSettingsStruct(
                  (e) => e
                    ..updateCalorie(
                      (e) => e..soundVolume = _model.sliderValue,
                    ),
                );
                safeSetState(() {});
                context.pop();
              },
            ),
          ),
          title: Text(
            'Calorie Counter',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
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
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: ZCalorieIntakeGoalWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Calorie Intake Goal',
                              value: FFAppState()
                                  .trackerSettings
                                  .calorie
                                  .goal
                                  .toString(),
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
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
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: ZCalorieUnitWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Units',
                              value: FFAppState().trackerSettings.calorie.unit,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (FFAppState().trackerSettings.calorie.reminder ==
                              true) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateCalorie(
                                  (e) => e..reminder = false,
                                ),
                            );
                            safeSetState(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateCalorie(
                                  (e) => e..reminder = true,
                                ),
                            );
                            safeSetState(() {});
                          }
                        },
                        child: wrapWithModel(
                          model: _model.textSwitchModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: TextSwitchWidget(
                            switchBoolean:
                                FFAppState().trackerSettings.calorie.reminder,
                            text: 'Meal Logging Reminder',
                          ),
                        ),
                      ),
                      Divider(
                        height: 1.0,
                        thickness: 1.0,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: FlutterFlowTheme.of(context).divider,
                      ),
                      Builder(
                        builder: (context) => Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 12.0, 0.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
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
                                    child: GestureDetector(
                                      onTap: () {
                                        FocusScope.of(dialogContext).unfocus();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      child: ZRepeatWidget(
                                        trackerType: 0,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 20.0, 0.0, 20.0),
                                  child: Text(
                                    'Repeat',
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleSmall
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 6.0, 0.0),
                                    child: Builder(
                                      builder: (context) {
                                        if (FFAppState()
                                                .trackerSettings
                                                .calorie
                                                .repeat
                                                .length ==
                                            7) {
                                          return Text(
                                            'Everyday',
                                            textAlign: TextAlign.end,
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
                                          );
                                        } else if (FFAppState()
                                                .trackerSettings
                                                .calorie
                                                .repeat
                                                .length ==
                                            0) {
                                          return Text(
                                            'Never',
                                            textAlign: TextAlign.end,
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
                                          );
                                        } else {
                                          return Builder(
                                            builder: (context) {
                                              final repeatDays = FFAppState()
                                                  .trackerSettings
                                                  .calorie
                                                  .repeat
                                                  .toList();

                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: List.generate(
                                                    repeatDays.length,
                                                    (repeatDaysIndex) {
                                                  final repeatDaysItem =
                                                      repeatDays[
                                                          repeatDaysIndex];
                                                  return Text(
                                                    '${functions.first3Characters(repeatDaysItem)}${FFAppState().trackerSettings.calorie.repeat.lastOrNull == repeatDaysItem ? ' ' : ', '}',
                                                    textAlign: TextAlign.end,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodySmall
                                                                    .fontStyle,
                                                          ),
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodySmall
                                                                  .fontStyle,
                                                        ),
                                                  );
                                                }),
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                Icon(
                                  FFIcons.kchevronRight,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
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
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: ZReminderTimeWidget(
                                      trackerType: 0,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Reminder Time',
                              value:
                                  '${FFAppState().trackerSettings.calorie.reminderTime.hour}:${FFAppState().trackerSettings.calorie.reminderTime.min} ${FFAppState().trackerSettings.calorie.reminderTime.type}',
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
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
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: ZRingtoneWidget(
                                      trackerType: 0,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel4,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Ringtone',
                              value: valueOrDefault<String>(
                                FFAppState().trackerSettings.calorie.ringtone,
                                'null',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 0.0, 16.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Icon(
                              FFIcons.kvolumeX,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderThemeData(
                                  showValueIndicator: ShowValueIndicator.always,
                                ),
                                child: Slider(
                                  activeColor:
                                      FlutterFlowTheme.of(context).primary,
                                  inactiveColor:
                                      FlutterFlowTheme.of(context).alternate,
                                  min: 0.0,
                                  max: 10.0,
                                  value: _model.sliderValue ??= FFAppState()
                                      .trackerSettings
                                      .calorie
                                      .soundVolume,
                                  label: _model.sliderValue?.toStringAsFixed(2),
                                  onChanged: (newValue) {
                                    newValue = double.parse(
                                        newValue.toStringAsFixed(2));
                                    safeSetState(
                                        () => _model.sliderValue = newValue);
                                  },
                                ),
                              ),
                            ),
                            Icon(
                              FFIcons.kvolumeMax,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (FFAppState().trackerSettings.calorie.vibration ==
                              true) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateCalorie(
                                  (e) => e..vibration = false,
                                ),
                            );
                            safeSetState(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateCalorie(
                                  (e) => e..vibration = true,
                                ),
                            );
                            safeSetState(() {});
                          }
                        },
                        child: wrapWithModel(
                          model: _model.textSwitchModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: TextSwitchWidget(
                            switchBoolean:
                                FFAppState().trackerSettings.calorie.vibration,
                            text: 'Vibration',
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (FFAppState()
                                  .trackerSettings
                                  .calorie
                                  .stopWhen100p ==
                              true) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateCalorie(
                                  (e) => e..stopWhen100p = false,
                                ),
                            );
                            safeSetState(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateCalorie(
                                  (e) => e..stopWhen100p = true,
                                ),
                            );
                            safeSetState(() {});
                          }
                        },
                        child: wrapWithModel(
                          model: _model.textSwitchModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: TextSwitchWidget(
                            switchBoolean: FFAppState()
                                .trackerSettings
                                .calorie
                                .stopWhen100p,
                            text: 'Stop When 100%',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
