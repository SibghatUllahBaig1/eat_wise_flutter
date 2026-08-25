import 'dart:io';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home_pages/components/z_home_calendar/z_home_calendar_widget.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/home_pages/components/z_nutrition/z_nutrition_widget.dart';
import '/home_pages/components/z_statistics/z_statistics_widget.dart';
import '/tracker/components/z_step_tracker/z_step_tracker_widget.dart';
import '/index.dart';
import '/backend/backend_manager.dart';
import '/backend/schema/structs/index.dart';
import '/backend/services/app_day_service.dart';
import '/backend/services/pedometer_service.dart';
import '/backend/utils/date_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

/// Eat what do you want!
class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;
  final _backend = BackendManager();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  /// Load step data for the selected calendar day (Apple Health on iOS).
  Future<void> _loadStepsForSelectedDate() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    final date = normalizeToDate(
      FFAppState().tracker.selectedDate ??
          FFAppState().tracker.currentDate ??
          DateTime.now(),
    );

    try {
      if (Platform.isIOS) {
        await PedometerService().refreshStepsForDate(uid, date);
        return;
      }

      final summary = await _backend.stepTrackerService.getStepSummary(
        userId: uid,
        date: date,
      );

      if (summary == null) return;

      final totalSteps = summary['totalSteps'] as int? ?? 0;
      final goal =
          summary['goal'] as int? ?? FFAppState().trackerSettings.step.goal;
      final progress = summary['progress'] as double? ?? 0.0;

      FFAppState().updateTrackerStruct((tracker) {
        tracker.step.removeWhere((e) => isSameCalendarDay(e.date, date));
        tracker.step.add(TrackerValueStruct(
          date: date,
          value: totalSteps,
          progress: progress,
          unit: 'steps',
        ));
      });

      if (goal != FFAppState().trackerSettings.step.goal) {
        FFAppState().updateTrackerSettingsStruct((settings) {
          settings.step.goal = goal;
        });
      }
    } catch (e) {
      print('HomePage: failed to load steps for $date: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    AppDayService.instance.resetSelectedDateToToday();

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().NavBar = 0;
      safeSetState(() {});
      await _loadStepsForSelectedDate();
      if (mounted) safeSetState(() {});
    });

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 100.0.ms,
            begin: Offset(0.95, 0.95),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
    });
  }

  @override
  void activate() {
    super.activate();
    AppDayService.instance.resetSelectedDateToToday();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadStepsForSelectedDate();
      if (mounted) safeSetState(() {});
    });
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
          leadingWidth: 120.0,
          leading: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
            child: SizedBox(
              width: 80.0,
              height: 80.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/images/custom-images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          title: Text(
            'Home',
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
              child: SizedBox(
                width: 44.0,
                height: 44.0,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseAuth.instance.currentUser == null
                      ? null
                      : FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('notifications')
                          .where('read', isEqualTo: false)
                          .snapshots(),
                  builder: (context, snapshot) {
                    final unreadCount = snapshot.data?.docs.length ?? 0;
                    return Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 22.0,
                          borderWidth: 1.5,
                          buttonSize: 44.0,
                          icon: Icon(
                            FFIcons.kbell,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 22.0,
                          ),
                          onPressed: () async {
                            context.pushNamed(NotificationWidget.routeName);
                          },
                        ),
                        if (unreadCount > 0)
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              constraints: const BoxConstraints(
                                  minWidth: 14, minHeight: 14),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).error,
                                shape: unreadCount < 10
                                    ? BoxShape.circle
                                    : BoxShape.rectangle,
                                borderRadius: unreadCount < 10
                                    ? null
                                    : BorderRadius.circular(7),
                              ),
                              alignment: Alignment.center,
                              padding: unreadCount < 10
                                  ? EdgeInsets.zero
                                  : const EdgeInsets.symmetric(horizontal: 3),
                              child: Text(
                                unreadCount > 99 ? '99+' : '$unreadCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                        child: wrapWithModel(
                          model: _model.zHomeCalendarModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ZHomeCalendarWidget(),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: wrapWithModel(
                          model: _model.zStatisticsModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ZStatisticsWidget(),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: wrapWithModel(
                          model: _model.zStepTrackerModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ZStepTrackerWidget(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            16.0, 24.0, 16.0, 0.0),
                        child: Text(
                          'Nutrition',
                          style:
                              FlutterFlowTheme.of(context).titleLarge.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleLarge
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                        child: wrapWithModel(
                          model: _model.zNutritionModel,
                          updateCallback: () => safeSetState(() {}),
                          child: ZNutritionWidget(),
                        ),
                      ),
                    ].addToEnd(SizedBox(height: 24.0)),
                  ),
                ).animateOnPageLoad(
                    animationsMap['columnOnPageLoadAnimation']!),
              ),
            ),
            wrapWithModel(
              model: _model.zNawBarModel,
              updateCallback: () => safeSetState(() {}),
              child: ZNawBarWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
