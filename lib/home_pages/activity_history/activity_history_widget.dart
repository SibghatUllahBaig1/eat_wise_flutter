import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_activity_templates/z_activity_templates_widget.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'activity_history_model.dart';
export 'activity_history_model.dart';

class ActivityHistoryWidget extends StatefulWidget {
  const ActivityHistoryWidget({
    super.key,
    this.selectedDate,
  });

  final DateTime? selectedDate;

  static String routeName = 'ActivityHistory';
  static String routePath = '/activityHistory';

  @override
  State<ActivityHistoryWidget> createState() => _ActivityHistoryWidgetState();
}

class _ActivityHistoryWidgetState extends State<ActivityHistoryWidget> {
  late ActivityHistoryModel _model;
  final backend = BackendManager();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityHistoryModel());

    // Initialize daily goal controller with saved value or default 525
    _model.dailyGoalController?.text =
        FFAppState().trackerSettings.activity.goal.toString();
    if (_model.dailyGoalController!.text == '0') {
      _model.dailyGoalController?.text = '525';
    }

    // Load activities when widget is first created
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadActivities();
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadActivities() async {
    if (currentUserUid.isEmpty) return;

    final date = widget.selectedDate ??
        FFAppState().tracker.selectedDate ??
        DateTime.now();
    _model.activities = await backend.activityService.getActivitiesByDate(
      userId: currentUserUid,
      date: date,
    );

    // Calculate total calories burned
    _model.totalCaloriesBurned = _model.activities.fold<int>(
      0,
      (sum, activity) => sum + ((activity['caloriesBurned'] as int?) ?? 0),
    );
  }

  IconData _getActivityIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) return FFIcons.ksport2;

    switch (iconName) {
      case 'sport1':
        return FFIcons.ksport1;
      case 'sport2':
        return FFIcons.ksport2;
      case 'sport3':
        return FFIcons.ksport3;
      case 'sport4':
        return FFIcons.ksport4;
      case 'sport5':
        return FFIcons.ksport5;
      case 'sport6':
        return FFIcons.ksport6;
      case 'sport7':
        return FFIcons.ksport7;
      case 'sport8':
        return FFIcons.ksport8;
      case 'sport9':
        return FFIcons.ksport9;
      case 'sport10':
        return FFIcons.ksport10;
      case 'sport11':
        return FFIcons.ksport11;
      case 'sport12':
        return FFIcons.ksport12;
      case 'sport13':
        return FFIcons.ksport13;
      case 'sport14':
        return FFIcons.ksport14;
      case 'sport15':
        return FFIcons.ksport15;
      case 'sport16':
        return FFIcons.ksport16;
      case 'sport17':
        return FFIcons.ksport17;
      case 'sport19':
        return FFIcons.ksport19;
      case 'other':
        return FFIcons.kdotsHorizontal;
      default:
        return FFIcons.ksport2;
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(ActivityHistoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload activities when widget is updated (e.g., when returning from another page)
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadActivities();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                context.pop();
              },
            ),
          ),
          title: Text(
            'Activity',
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
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Daily Goal field
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                'Daily Goal',
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
                            Container(
                              width: 100,
                              child: TextFormField(
                                controller: _model.dailyGoalController,
                                focusNode: _model.dailyGoalFocusNode,
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 8.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                  ),
                                  suffixText: 'cal',
                                  suffixStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                ),
                                onChanged: (value) {
                                  // Save the goal to app state
                                  final goal = int.tryParse(value) ?? 525;
                                  FFAppState().updateTrackerSettingsStruct(
                                    (e) => e
                                      ..updateActivity(
                                        (e) => e..goal = goal,
                                      ),
                                  );
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Total field
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                'Total',
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
                            Text(
                              '${_model.totalCaloriesBurned} cal',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Display activities from Firestore
                  if (_model.activities.isNotEmpty)
                    ...List.generate(_model.activities.length, (index) {
                      final activity = _model.activities[index];
                      final activityName =
                          activity['activityName']?.toString() ??
                              'Unknown Activity';
                      final caloriesBurned =
                          (activity['caloriesBurned'] as int?) ?? 0;
                      final duration = (activity['duration'] as int?) ?? 0;
                      final iconName =
                          activity['iconName']?.toString() ?? 'sport2';
                      final activityId = activity['id']?.toString() ?? '';

                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, index == 0 ? 16.0 : 12.0, 16.0, 0.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            // Navigate to Activity Details with the activity data
                            context.pushNamed(
                              ActivityDetailsWidget.routeName,
                              queryParameters: {
                                'activityData': serializeParam(
                                  activity,
                                  ParamType.JSON,
                                ),
                              }.withoutNulls,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      _getActivityIcon(iconName),
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 32.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            activityName,
                                            style: FlutterFlowTheme.of(context)
                                                .titleSmall
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .titleSmall
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleSmall
                                                          .fontStyle,
                                                  lineHeight: 1.0,
                                                ),
                                          ),
                                          Text(
                                            '$caloriesBurned cal, $duration min',
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelMedium
                                                          .fontStyle,
                                                  lineHeight: 1.0,
                                                ),
                                          ),
                                        ].divide(SizedBox(height: 12.0)),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    FFIcons.kchevronRight,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                  // Show message if no activities
                  if (_model.activities.isEmpty)
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FFIcons.ksport2,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 48.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'No activities logged yet',
                                style: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Tap the Add button below to log your first activity',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ]
                    .addToStart(SizedBox(height: 16.0))
                    .addToEnd(SizedBox(height: 24.0)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    await showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          child: Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: ZActivityTemplatesWidget(),
                          ),
                        );
                      },
                    ).then((value) => safeSetState(() {}));
                  },
                  text: 'Add',
                  icon: Icon(
                    FFIcons.kplus,
                    size: 20.0,
                  ),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    iconColor: FlutterFlowTheme.of(context).info,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).info,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
