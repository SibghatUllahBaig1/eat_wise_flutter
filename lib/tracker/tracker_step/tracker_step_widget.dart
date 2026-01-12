import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_step_calendar/z_step_calendar_widget.dart';
import '/tracker/components/z_step_history_list/z_step_history_list_widget.dart';
import '/tracker/components/z_step_tracker_edit/z_step_tracker_edit_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import '/backend/backend_manager.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'tracker_step_model.dart';
export 'tracker_step_model.dart';

class TrackerStepWidget extends StatefulWidget {
  const TrackerStepWidget({super.key});

  static String routeName = 'TrackerStep';
  static String routePath = '/trackerStep';

  @override
  State<TrackerStepWidget> createState() => _TrackerStepWidgetState();
}

class _TrackerStepWidgetState extends State<TrackerStepWidget> {
  late TrackerStepModel _model;
  final backend = BackendManager();
  List<Map<String, dynamic>>? _stepEntries;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrackerStepModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  Future<void> _onDeleteStep(String stepId) async {
    if (currentUserUid.isEmpty) return;

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();
      // I'm assuming deleteStepEntry exists on the backend service.
      await backend.stepTrackerService.deleteStepEntry(
        userId: currentUserUid,
        stepId: stepId,
        date: selectedDate,
      );
      await _loadStepData();
    } catch (e) {
      print('Error deleting step entry: $e');
    }
  }

  /// Load step data from Firestore and update FFAppState
  Future<void> _loadStepData() async {
    if (currentUserUid.isEmpty) return;

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();

      // Get step summary from Firestore
      final summary = await backend.stepTrackerService.getStepSummary(
        userId: currentUserUid,
        date: selectedDate,
      );

      final entries = await backend.stepTrackerService.getStepsForDate(
        userId: currentUserUid,
        date: selectedDate,
      );

      _stepEntries = entries;

      if (summary != null) {
        // Update FFAppState with real data
        final totalSteps = summary['totalSteps'] as int? ?? 0;
        final goal =
            summary['goal'] as int? ?? FFAppState().trackerSettings.step.goal;
        final progress = summary['progress'] as double? ?? 0.0;

        // Update the tracker state
        FFAppState().updateTrackerStruct((tracker) {
          // Find existing entry for this date or create new one
          final existingIndex = tracker.step.indexWhere(
            (e) =>
                e.date != null &&
                e.date!.year == selectedDate.year &&
                e.date!.month == selectedDate.month &&
                e.date!.day == selectedDate.day,
          );

          final trackerValue = TrackerValueStruct(
            date: selectedDate,
            value: totalSteps,
            progress: progress,
            unit: 'steps',
          );

          if (existingIndex >= 0) {
            // Update existing entry
            tracker.step[existingIndex] = trackerValue;
          } else {
            // Add new entry
            tracker.step.add(trackerValue);
          }
        });

        // Update goal if different
        if (goal != FFAppState().trackerSettings.step.goal) {
          FFAppState().updateTrackerSettingsStruct((settings) {
            settings.step.goal = goal;
          });
        }

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      print('Error loading step data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // Reload data when selected date changes
    final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();
    if (_model.lastLoadedDate != selectedDate) {
      _model.lastLoadedDate = selectedDate;
      _stepEntries = null;
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        await _loadStepData();
      });
    }

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
            'Step Counter',
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
          actions: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 22.0,
                  borderWidth: 1.0,
                  buttonSize: 44.0,
                  icon: Icon(
                    FFIcons.ksettings,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(StepCounterWidget.routeName);
                  },
                ),
              ),
            ),
          ],
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
            children: [
              wrapWithModel(
                model: _model.zStepCalendarModel,
                updateCallback: () => safeSetState(() {}),
                child: ZStepCalendarWidget(),
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            0.0, 24.0, 0.0, 32.0),
                        child: Container(
                          width: 250.0,
                          height: 250.0,
                          child: Stack(
                            alignment: AlignmentDirectional(0.0, -1.0),
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 132.0),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  child: custom_widgets.SemiCircleProgress(
                                    width: double.infinity,
                                    height: double.infinity,
                                    progress: valueOrDefault<double>(
                                      FFAppState()
                                          .tracker
                                          .step
                                          .where((e) =>
                                              e.date ==
                                              FFAppState().tracker.selectedDate)
                                          .toList()
                                          .firstOrNull
                                          ?.progress,
                                      0.0,
                                    ),
                                    progressColor:
                                        FlutterFlowTheme.of(context).stepColor,
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).divider,
                                    text: 'Steps',
                                    textColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 16.0,
                                    thickness: 24.0,
                                    showText: false,
                                    gradeOfCircle: 245.0,
                                    animationDuration: 800,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Steps',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                          lineHeight: 1.0,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 12.0, 0.0, 0.0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        FFAppState()
                                            .tracker
                                            .step
                                            .where((e) =>
                                                e.date ==
                                                FFAppState()
                                                    .tracker
                                                    .selectedDate)
                                            .toList()
                                            .firstOrNull
                                            ?.value
                                            ?.toString(),
                                        '0',
                                      ),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .displayMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .displayMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .displayMedium
                                                      .fontStyle,
                                            ),
                                            fontSize: 40.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .displayMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .displayMedium
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 16.0, 0.0, 0.0),
                                    child: Text(
                                      '/ ${FFAppState().trackerSettings.step.goal.toString()}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                            lineHeight: 1.0,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: AlignmentDirectional(0.0, 1.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await showModalBottomSheet(
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      context: context,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: ZStepTrackerEditWidget(),
                                          ),
                                        );
                                      },
                                    ).then((value) => _loadStepData());
                                  },
                                  child: Container(
                                    width: 44.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .stepColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      FFIcons.kedit,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            'History',
                            style: FlutterFlowTheme.of(context)
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

                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                    child: Text(
                      dateTimeFormat(
                          "yMMMd", FFAppState().tracker.selectedDate!),
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
                            fontWeight: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .fontStyle,
                            lineHeight: 1.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: wrapWithModel(
                      model: _model.zStepHistoryListModel,
                      updateCallback: () => safeSetState(() {}),
                      child: ZStepHistoryListWidget(
                        stepEntries: _stepEntries,
                        onDelete: _onDeleteStep,
                      ),
                    ),
                  ),
                ],
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
