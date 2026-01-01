import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_step_calendar/z_step_calendar_widget.dart';
import '/tracker/components/z_steps/z_steps_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'step_intake_history_model.dart';
export 'step_intake_history_model.dart';

class StepIntakeHistoryWidget extends StatefulWidget {
  const StepIntakeHistoryWidget({super.key});

  static String routeName = 'StepIntakeHistory';
  static String routePath = '/stepIntakeHistory';

  @override
  State<StepIntakeHistoryWidget> createState() =>
      _StepIntakeHistoryWidgetState();
}

class _StepIntakeHistoryWidgetState extends State<StepIntakeHistoryWidget> {
  late StepIntakeHistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StepIntakeHistoryModel());
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
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
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
                context.pop();
              },
            ),
          ),
          title: Text(
            'Step Intake History',
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
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              wrapWithModel(
                model: _model.zStepCalendarModel,
                updateCallback: () => safeSetState(() {}),
                child: ZStepCalendarWidget(),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  dateTimeFormat("yMMMd", FFAppState().tracker.selectedDate!),
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                        lineHeight: 1.0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    wrapWithModel(
                      model: _model.zStepsModel1,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 850,
                        time: '8m',
                        burning: 40,
                        distance: 0.7,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel2,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 950,
                        time: '9m',
                        burning: 45,
                        distance: 0.8,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel3,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1200,
                        time: '12m',
                        burning: 60,
                        distance: 1.0,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel4,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 900,
                        time: '8m',
                        burning: 60,
                        distance: 0.5,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel5,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1000,
                        time: '11m',
                        burning: 55,
                        distance: 1.0,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel6,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 400,
                        time: '5m',
                        burning: 30,
                        distance: 0.3,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel7,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 2000,
                        time: '18m',
                        burning: 45,
                        distance: 1.7,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel8,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1200,
                        time: '12m',
                        burning: 60,
                        distance: 1.1,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel9,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1350,
                        time: '9m',
                        burning: 55,
                        distance: 1.1,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel10,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1050,
                        time: '10m',
                        burning: 65,
                        distance: 1.0,
                      ),
                    ),
                  ].divide(SizedBox(height: 12.0)),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Text(
                  dateTimeFormat(
                      "yMMMd",
                      functions
                          .getNextDate(FFAppState().tracker.selectedDate!)),
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).labelMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).labelMedium.fontStyle,
                        lineHeight: 1.0,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    wrapWithModel(
                      model: _model.zStepsModel11,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 850,
                        time: '8m',
                        burning: 40,
                        distance: 0.7,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel12,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 950,
                        time: '9m',
                        burning: 45,
                        distance: 0.8,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel13,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1200,
                        time: '12m',
                        burning: 60,
                        distance: 1.0,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel14,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 900,
                        time: '8m',
                        burning: 60,
                        distance: 0.5,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel15,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1000,
                        time: '11m',
                        burning: 55,
                        distance: 1.0,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel16,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 400,
                        time: '5m',
                        burning: 30,
                        distance: 0.3,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel17,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 2000,
                        time: '18m',
                        burning: 45,
                        distance: 1.7,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel18,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1200,
                        time: '12m',
                        burning: 60,
                        distance: 1.1,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel19,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1350,
                        time: '9m',
                        burning: 55,
                        distance: 1.1,
                      ),
                    ),
                    wrapWithModel(
                      model: _model.zStepsModel20,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepsWidget(
                        step: 1050,
                        time: '10m',
                        burning: 65,
                        distance: 1.0,
                      ),
                    ),
                  ].divide(SizedBox(height: 12.0)),
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
