import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'creat_plan_model.dart';
export 'creat_plan_model.dart';

class CreatPlanWidget extends StatefulWidget {
  const CreatPlanWidget({super.key});

  static String routeName = 'CreatPlan';
  static String routePath = '/creatPlan';

  @override
  State<CreatPlanWidget> createState() => _CreatPlanWidgetState();
}

class _CreatPlanWidgetState extends State<CreatPlanWidget>
    with TickerProviderStateMixin {
  late CreatPlanModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatPlanModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        Future(() async {
          await Future.delayed(
            Duration(
              milliseconds: 2000,
            ),
          );
          if (animationsMap['rowOnActionTriggerAnimation1'] != null) {
            animationsMap['rowOnActionTriggerAnimation1']!
                .controller
                .forward(from: 0.0)
                .whenComplete(animationsMap['rowOnActionTriggerAnimation1']!
                    .controller
                    .reverse);
          }
          _model.analyze = true;
          safeSetState(() {});
          await Future.delayed(
            Duration(
              milliseconds: 1100,
            ),
          );
          if (animationsMap['rowOnActionTriggerAnimation2'] != null) {
            animationsMap['rowOnActionTriggerAnimation2']!
                .controller
                .forward(from: 0.0)
                .whenComplete(animationsMap['rowOnActionTriggerAnimation2']!
                    .controller
                    .reverse);
          }
          _model.calculate = true;
          safeSetState(() {});
          await Future.delayed(
            Duration(
              milliseconds: 1500,
            ),
          );
          if (animationsMap['rowOnActionTriggerAnimation3'] != null) {
            animationsMap['rowOnActionTriggerAnimation3']!
                .controller
                .forward(from: 0.0)
                .whenComplete(animationsMap['rowOnActionTriggerAnimation3']!
                    .controller
                    .reverse);
          }
          _model.predict = true;
          safeSetState(() {});
          await Future.delayed(
            Duration(
              milliseconds: 1700,
            ),
          );
          if (animationsMap['rowOnActionTriggerAnimation4'] != null) {
            animationsMap['rowOnActionTriggerAnimation4']!
                .controller
                .forward(from: 0.0)
                .whenComplete(animationsMap['rowOnActionTriggerAnimation4']!
                    .controller
                    .reverse);
          }
          _model.add = true;
          safeSetState(() {});
        }),
        Future(() async {
          while (_model.percent! < 50) {
            await Future.delayed(
              Duration(
                milliseconds: 50,
              ),
            );
            _model.percent = _model.percent! + 1;
            safeSetState(() {});
          }
          while (_model.percent! < 70) {
            await Future.delayed(
              Duration(
                milliseconds: 80,
              ),
            );
            _model.percent = _model.percent! + 1;
            safeSetState(() {});
          }
          while (_model.percent! < 100) {
            await Future.delayed(
              Duration(
                milliseconds: 100,
              ),
            );
            _model.percent = _model.percent! + 1;
            safeSetState(() {});
          }
        }),
      ]);

      context.pushNamed(PlanWidget.routeName);
    });

    animationsMap.addAll({
      'rowOnActionTriggerAnimation1': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(0.95, 0.95),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 1.0,
            end: 0.0,
          ),
        ],
      ),
      'rowOnActionTriggerAnimation2': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(0.95, 0.95),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 1.0,
            end: 0.0,
          ),
        ],
      ),
      'rowOnActionTriggerAnimation3': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(0.95, 0.95),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 1.0,
            end: 0.0,
          ),
        ],
      ),
      'rowOnActionTriggerAnimation4': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(1.0, 1.0),
            end: Offset(0.95, 0.95),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 1.0,
            end: 0.0,
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
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularPercentIndicator(
                percent: (_model.percent!) / 100,
                radius: 75.0,
                lineWidth: 6.0,
                animation: false,
                animateFromLastPercent: true,
                progressColor: FlutterFlowTheme.of(context).primary,
                backgroundColor: FlutterFlowTheme.of(context).accent4,
                center: Text(
                  '${_model.percent?.toString()}%',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineSmall
                            .fontStyle,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 42.0, 0.0),
                child: Text(
                  'We are making your plan...',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).headlineLarge.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineLarge
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineLarge
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineLarge
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineLarge
                            .fontStyle,
                        lineHeight: 1.5,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(45.0, 32.0, 45.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: _model.analyze
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _model.analyze
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).iconColor,
                          width: 1.5,
                        ),
                      ),
                      child: Visibility(
                        visible: _model.analyze,
                        child: Icon(
                          FFIcons.kcheck,
                          color: FlutterFlowTheme.of(context).info,
                          size: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Analyzing your responses',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                              color: _model.analyze
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ).animateOnActionTrigger(
                  animationsMap['rowOnActionTriggerAnimation1']!,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(45.0, 16.0, 45.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: _model.calculate
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _model.calculate
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).iconColor,
                          width: 1.5,
                        ),
                      ),
                      child: Visibility(
                        visible: _model.calculate,
                        child: Icon(
                          FFIcons.kcheck,
                          color: FlutterFlowTheme.of(context).info,
                          size: 16.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                        child: Text(
                          'Calculating the target calorie content',
                          style: FlutterFlowTheme.of(context)
                              .bodyLarge
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .fontStyle,
                                ),
                                color: _model.calculate
                                    ? FlutterFlowTheme.of(context).primaryText
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                        ),
                      ),
                    ),
                  ],
                ).animateOnActionTrigger(
                  animationsMap['rowOnActionTriggerAnimation2']!,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(45.0, 16.0, 45.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: _model.predict
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _model.predict
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).iconColor,
                          width: 1.5,
                        ),
                      ),
                      child: Visibility(
                        visible: _model.predict,
                        child: Icon(
                          FFIcons.kcheck,
                          color: FlutterFlowTheme.of(context).info,
                          size: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'We predict your progress',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                              color: _model.predict
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ).animateOnActionTrigger(
                  animationsMap['rowOnActionTriggerAnimation3']!,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(45.0, 16.0, 45.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 22.0,
                      height: 22.0,
                      decoration: BoxDecoration(
                        color: _model.add
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _model.add
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).iconColor,
                          width: 1.5,
                        ),
                      ),
                      child: Visibility(
                        visible: _model.add,
                        child: Icon(
                          FFIcons.kcheck,
                          color: FlutterFlowTheme.of(context).info,
                          size: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Adding the finishing touches',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .fontStyle,
                              ),
                              color: _model.add
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ).animateOnActionTrigger(
                  animationsMap['rowOnActionTriggerAnimation4']!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
