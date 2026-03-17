import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'z_activities_model.dart';
export 'z_activities_model.dart';

class ZActivitiesWidget extends StatefulWidget {
  const ZActivitiesWidget({super.key});

  @override
  State<ZActivitiesWidget> createState() => _ZActivitiesWidgetState();
}

class _ZActivitiesWidgetState extends State<ZActivitiesWidget> {
  late ZActivitiesModel _model;
  final backend = BackendManager();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZActivitiesModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Future<Map<String, dynamic>> _getActivityData() async {
    if (currentUserUid.isEmpty) {
      return {
        'totalCalories': 0,
        'goal': 525,
        'progress': 0.0,
      };
    }

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();
      final summary = await backend.activityService.getDailyActivitySummary(
        userId: currentUserUid,
        date: selectedDate,
      );

      // Get goal from app state (set in Activity History page)
      // Default to 525 if not set
      int goal = FFAppState().trackerSettings.activity.goal;
      if (goal == 0) {
        goal = 525;
      }

      final totalCalories = summary['totalCalories'] as int? ?? 0;
      final progress = goal > 0 ? (totalCalories / goal).clamp(0.0, 1.0) : 0.0;

      return {
        'totalCalories': totalCalories,
        'goal': goal,
        'progress': progress,
      };
    } catch (e) {
      print('Error loading activity data: $e');
      // Get goal from app state even in error case
      int goal = FFAppState().trackerSettings.activity.goal;
      if (goal == 0) {
        goal = 525;
      }
      return {
        'totalCalories': 0,
        'goal': goal,
        'progress': 0.0,
      };
    }
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    'ActivityHistory',
                    queryParameters: {
                      'selectedDate': serializeParam(
                        FFAppState().tracker.selectedDate ?? DateTime.now(),
                        ParamType.DateTime,
                      ),
                    }.withoutNulls,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent1,
                        shape: BoxShape.circle,
                      ),
                      child: Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          FFIcons.krun,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        child: Text(
                          'Activities',
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                        ),
                      ),
                    ),
                    Icon(
                      FFIcons.kchevronRight,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: FutureBuilder<Map<String, dynamic>>(
                  key: ValueKey(FFAppState().tracker.selectedDate),
                  future: _getActivityData(),
                  builder: (context, snapshot) {
                    // Show loading state
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      );
                    }

                    // Get data or use defaults
                    final data = snapshot.data ??
                        {
                          'totalCalories': 0,
                          'goal': 525,
                          'progress': 0.0,
                        };

                    final totalCalories = data['totalCalories'] as int;
                    final goal = data['goal'] as int;
                    final progress = data['progress'] as double;
                    final progressPercent = (progress * 100).round();

                    return InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        context.pushNamed(
                          'ActivityHistory',
                          queryParameters: {
                            'selectedDate': serializeParam(
                              FFAppState().tracker.selectedDate ??
                                  DateTime.now(),
                              ParamType.DateTime,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      textScaler:
                                          MediaQuery.of(context).textScaler,
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: totalCalories.toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .headlineMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .headlineMedium
                                                            .fontStyle,
                                                  ),
                                                  fontSize: 24.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .headlineMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          TextSpan(
                                            text: ' ',
                                            style: TextStyle(),
                                          ),
                                          TextSpan(
                                            text: 'kcal',
                                            style: TextStyle(),
                                          )
                                        ],
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
                                    Text(
                                      'Goal: $goal kcal',
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
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
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
                                  ].divide(SizedBox(height: 16.0)),
                                ),
                              ),
                              CircularPercentIndicator(
                                percent: progress,
                                radius: 32.0,
                                lineWidth: 7.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor:
                                    FlutterFlowTheme.of(context).primary,
                                backgroundColor:
                                    FlutterFlowTheme.of(context).divider,
                                center: Text(
                                  '$progressPercent%',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
