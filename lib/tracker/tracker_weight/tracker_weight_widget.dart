import '/backend/utils/unit_format_helper.dart';
import '/backend/schema/structs/index.dart';
import '/backend/firestore/weight_tracker_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_weight_card/z_weight_card_widget.dart';
import '/tracker/components/z_weight_tracker_edit/z_weight_tracker_edit_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'tracker_weight_model.dart';
export 'tracker_weight_model.dart';

class TrackerWeightWidget extends StatefulWidget {
  const TrackerWeightWidget({super.key});

  static String routeName = 'TrackerWeight';
  static String routePath = '/trackerWeight';

  @override
  State<TrackerWeightWidget> createState() => _TrackerWeightWidgetState();
}

class _TrackerWeightWidgetState extends State<TrackerWeightWidget> {
  late TrackerWeightModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrackerWeightModel());

    // Load weight data from Firestore
    _loadWeightData();
  }

  Future<void> _loadWeightData() async {
    final userId = currentUserUid;
    if (userId.isEmpty) return;

    try {
      final service = WeightTrackerService();

      // Load last 30 days of weight data
      final history = await service
          .streamWeightHistory(
            userId: userId,
            limit: 30,
          )
          .first;

      if (history.isNotEmpty && mounted) {
        // Update FFAppState with loaded data
        FFAppState().updateTrackerStruct((e) => e
          ..weight = history.map((entry) {
            return TrackerValueStruct(
              date: entry['date'] as DateTime,
              value: (entry['weight'] as double).toInt(),
              unit: entry['unit'] as String? ?? 'kg',
              progress: entry['progress'] as double? ?? 0.0,
            );
          }).toList());
        FFAppState().update(() {});
      }
    } catch (e) {
      debugPrint('Error loading weight data: $e');
    }
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
                    context.pushNamed(WeightTrackerWidget.routeName);
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
              Padding(
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
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current',
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 4.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        // Get latest weight (most recent entry)
                                        final weightList =
                                            FFAppState().tracker.weight;
                                        final latestWeight = weightList
                                                .isNotEmpty
                                            ? weightList.reduce((a, b) =>
                                                (a.date?.isAfter(b.date ??
                                                            DateTime(1970)) ??
                                                        false)
                                                    ? a
                                                    : b)
                                            : null;

                                        final weightUnit = FFAppState()
                                            .trackerSettings
                                            .weight
                                            .weightUnit;
                                        final latestKg =
                                            latestWeight?.value?.toDouble() ??
                                                0.0;
                                        final displayWeight = latestKg > 0
                                            ? UnitFormatHelper
                                                .formatWeightForInput(
                                                    latestKg, weightUnit)
                                            : '--';

                                        return RichText(
                                          textScaler:
                                              MediaQuery.of(context).textScaler,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: displayWeight,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .headlineMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
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
                                                text: UnitFormatHelper
                                                    .weightUnitLabel(
                                                        weightUnit),
                                                style: TextStyle(),
                                              )
                                            ],
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
                                                  lineHeight: 1.0,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    Builder(
                                      builder: (context) {
                                        // Calculate weight change from previous entry
                                        final weightList =
                                            FFAppState().tracker.weight;
                                        if (weightList.length < 2) {
                                          return SizedBox.shrink();
                                        }

                                        // Get latest and second latest weights
                                        final sortedWeights = weightList
                                            .toList()
                                          ..sort((a, b) => (b.date ??
                                                  DateTime(1970))
                                              .compareTo(
                                                  a.date ?? DateTime(1970)));

                                        final latest = sortedWeights[0]
                                                .value
                                                ?.toDouble() ??
                                            0.0;
                                        final previous = sortedWeights[1]
                                                .value
                                                ?.toDouble() ??
                                            0.0;
                                        final change = latest - previous;

                                        if (change == 0) {
                                          return SizedBox.shrink();
                                        }

                                        final isIncrease = change > 0;

                                        final weightUnit = FFAppState()
                                            .trackerSettings
                                            .weight
                                            .weightUnit;
                                        final changeDisplay =
                                            UnitFormatHelper.formatWeightForInput(
                                                change.abs(), weightUnit);

                                        return Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 0.0, 0.0, 0.0),
                                              child: Icon(
                                                isIncrease
                                                    ? Icons.expand_circle_down
                                                    : Icons.expand_less,
                                                color: isIncrease
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .error
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .success,
                                                size: 18.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(6.0, 0.0, 0.0, 0.0),
                                              child: Text(
                                                '${isIncrease ? '+' : '-'}${changeDisplay} ${UnitFormatHelper.weightUnitLabel(weightUnit)}',
                                                style: FlutterFlowTheme.of(
                                                        context)
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
                                                      color: isIncrease
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .error
                                                          : FlutterFlowTheme.of(
                                                                  context)
                                                              .success,
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
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  // Get weight data
                                  final weightList =
                                      FFAppState().tracker.weight;

                                  // Get oldest weight (starting weight)
                                  final startingWeight = weightList.isNotEmpty
                                      ? weightList.reduce((a, b) => (a.date
                                                  ?.isBefore(b.date ??
                                                      DateTime.now()) ??
                                              false)
                                          ? a
                                          : b)
                                      : null;

                                  // Get latest weight (current weight)
                                  final latestWeight = weightList.isNotEmpty
                                      ? weightList.reduce((a, b) => (a.date
                                                  ?.isAfter(b.date ??
                                                      DateTime(1970)) ??
                                              false)
                                          ? a
                                          : b)
                                      : null;

                                  // Get goal weight from settings
                                  final goalWeight = FFAppState()
                                      .trackerSettings
                                      .weight
                                      .goalWeight;

                                  // Calculate progress
                                  double progress = 0.0;
                                  if (startingWeight != null &&
                                      latestWeight != null &&
                                      goalWeight > 0) {
                                    final start =
                                        startingWeight.value?.toDouble() ?? 0.0;
                                    final current =
                                        latestWeight.value?.toDouble() ?? 0.0;
                                    final goal = goalWeight.toDouble();

                                    if (start != goal) {
                                      progress =
                                          ((current - start) / (goal - start))
                                              .clamp(0.0, 1.0);
                                    }
                                  }

                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 24.0, 0.0, 0.0),
                                        child: LinearPercentIndicator(
                                          percent: progress,
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  96,
                                          lineHeight: 16.0,
                                          animation: true,
                                          animateFromLastPercent: true,
                                          progressColor:
                                              FlutterFlowTheme.of(context)
                                                  .weightColor,
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .divider,
                                          barRadius: Radius.circular(16.0),
                                          padding: EdgeInsets.zero,
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 12.0, 0.0, 0.0),
                                            child: Text(
                                              startingWeight != null
                                                  ? 'Starting: ${startingWeight.value}'
                                                  : 'Starting: --',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
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
                                                        lineHeight: 1.0,
                                                      ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 12.0, 0.0, 0.0),
                                            child: Text(
                                              goalWeight > 0
                                                  ? 'Goal: ${UnitFormatHelper.formatWeight(goalWeight.toDouble(), FFAppState().trackerSettings.weight.weightUnit)}'
                                                  : 'Goal: --',
                                              style:
                                                  FlutterFlowTheme.of(context)
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
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
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
                                                        lineHeight: 1.0,
                                                      ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 32.0, 0.0, 0.0),
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
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: ZWeightTrackerEditWidget(),
                                    ),
                                  );
                                },
                              ).then((value) => safeSetState(() {}));
                            },
                            text: 'Update',
                            options: FFButtonOptions(
                              width: double.infinity,
                              height: 44.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24.0, 0.0, 24.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: FlutterFlowTheme.of(context).weightColor,
                              textStyle: FlutterFlowTheme.of(context)
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
                                    color: FlutterFlowTheme.of(context).info,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                              elevation: 0.0,
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            showLoadingIndicator: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(
                        'History',
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
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: currentUserUid.isNotEmpty
                      ? WeightTrackerService().streamWeightHistory(
                          userId: currentUserUid,
                          limit: 9,
                        )
                      : Stream.value([]),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).weightColor,
                          ),
                        ),
                      );
                    }

                    final weightHistory = snapshot.data!;

                    if (weightHistory.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text(
                          'No weight entries yet. Tap "Update" to add your first entry!',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(weightHistory.length, (index) {
                        final entry = weightHistory[index];
                        final weight = entry['weight'] as double;
                        final date = entry['date'] as DateTime;

                        // Calculate weight change from previous entry
                        double? weightChange;
                        bool isIncrease = false;

                        if (index < weightHistory.length - 1) {
                          final previousWeight =
                              weightHistory[index + 1]['weight'] as double;
                          weightChange = weight - previousWeight;
                          isIncrease = weightChange > 0;
                        }

                        // Format date
                        final now = DateTime.now();
                        final yesterday =
                            DateTime(now.year, now.month, now.day - 1);
                        final entryDate =
                            DateTime(date.year, date.month, date.day);

                        String timeText;
                        if (entryDate ==
                            DateTime(now.year, now.month, now.day)) {
                          timeText =
                              'Today, ${dateTimeFormat("MMM d, y", date)}';
                        } else if (entryDate == yesterday) {
                          timeText =
                              'Yesterday, ${dateTimeFormat("MMM d, y", date)}';
                        } else {
                          timeText = dateTimeFormat("MMM d, y", date);
                        }

                        return ZWeightCardWidget(
                          weight: weight,
                          time: timeText,
                          plus: isIncrease,
                          value: weightChange?.abs() ?? 0.0,
                        );
                      }).divide(SizedBox(height: 16.0)),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
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
