import '/backend/schema/structs/index.dart';
import '/buttons/text_switch/text_switch_widget.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/z_current_weight/z_current_weight_widget.dart';
import '/profile/components/z_goal_weight/z_goal_weight_widget.dart';
import '/profile/components/z_height/z_height_widget.dart';
import '/profile/components/z_height_unit/z_height_unit_widget.dart';
import '/profile/components/z_reminder_time/z_reminder_time_widget.dart';
import '/profile/components/z_repeat/z_repeat_widget.dart';
import '/profile/components/z_ringtone/z_ringtone_widget.dart';
import '/profile/components/z_weight_unit/z_weight_unit_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'weight_tracker_model.dart';
export 'weight_tracker_model.dart';

class WeightTrackerWidget extends StatefulWidget {
  const WeightTrackerWidget({super.key});

  static String routeName = 'WeightTracker';
  static String routePath = '/weightTracker';

  @override
  State<WeightTrackerWidget> createState() => _WeightTrackerWidgetState();
}

class _WeightTrackerWidgetState extends State<WeightTrackerWidget> {
  late WeightTrackerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WeightTrackerModel());

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
                    ..updateWeight(
                      (e) => e..soundVolume = _model.sliderValue,
                    ),
                );
                safeSetState(() {});
                context.pop();
              },
            ),
          ),
          title: Text(
            'Weight Tracker',
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
                                    child: ZCurrentWeightWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Current Weight',
                              value:
                                  '${FFAppState().trackerSettings.weight.currentWeight.toString()} kg',
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
                                    child: ZGoalWeightWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Goal Weight',
                              value:
                                  '${FFAppState().trackerSettings.weight.goalWeight.toString()} kg',
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
                                    child: ZHeightWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel3,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Height',
                              value:
                                  '${FFAppState().trackerSettings.weight.height.toString()} см',
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
                                    child: ZWeightUnitWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel4,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Weight Units',
                              value: FFAppState()
                                  .trackerSettings
                                  .weight
                                  .weightUnit,
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
                                    child: ZHeightUnitWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel5,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Height Units',
                              value: FFAppState()
                                  .trackerSettings
                                  .weight
                                  .heightUnit,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if (FFAppState().trackerSettings.weight.bmi == true) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..bmi = false,
                                ),
                            );
                            safeSetState(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..bmi = true,
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
                                FFAppState().trackerSettings.weight.bmi,
                            text: 'Body Mass Index (BMI)',
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
                          if (FFAppState().trackerSettings.weight.reminder ==
                              true) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..reminder = false,
                                ),
                            );
                            safeSetState(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..reminder = true,
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
                                FFAppState().trackerSettings.weight.reminder,
                            text: 'Weight Logging Reminder',
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
                                        trackerType: 3,
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
                                                .water
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
                                                .water
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
                                                  .weight
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
                                                    '${functions.first3Characters(repeatDaysItem)}${FFAppState().trackerSettings.weight.repeat.lastOrNull == repeatDaysItem ? ' ' : ', '}',
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
                                      trackerType: 3,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel6,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Reminder Time',
                              value:
                                  '${FFAppState().trackerSettings.weight.reminderTime.hour}:${FFAppState().trackerSettings.weight.reminderTime.min} ${FFAppState().trackerSettings.weight.reminderTime.type}',
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
                                      trackerType: 3,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel7,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Ringtone',
                              value:
                                  FFAppState().trackerSettings.weight.ringtone,
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
                                      .weight
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
                          if (FFAppState().trackerSettings.weight.vibration ==
                              true) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..vibration = false,
                                ),
                            );
                            safeSetState(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..vibration = true,
                                ),
                            );
                            safeSetState(() {});
                          }
                        },
                        child: wrapWithModel(
                          model: _model.textSwitchModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: TextSwitchWidget(
                            switchBoolean:
                                FFAppState().trackerSettings.weight.vibration,
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
                                  .weight
                                  .stopWhen100p ==
                              true) {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..stopWhen100p = false,
                                ),
                            );
                            safeSetState(() {});
                          } else {
                            FFAppState().updateTrackerSettingsStruct(
                              (e) => e
                                ..updateWeight(
                                  (e) => e..stopWhen100p = true,
                                ),
                            );
                            safeSetState(() {});
                          }
                        },
                        child: wrapWithModel(
                          model: _model.textSwitchModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: TextSwitchWidget(
                            switchBoolean: FFAppState()
                                .trackerSettings
                                .weight
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
