import '/backend/schema/structs/index.dart';
import '/backend/firestore/chart_data_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/progress/components/chart_caloria/chart_caloria_widget.dart';
import '/progress/components/chart_step/chart_step_widget.dart';
import '/progress/components/chart_water/chart_water_widget.dart';
import '/progress/components/chart_weight/chart_weight_widget.dart';
import '/tracker/components/z_calendar/z_calendar_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'progress_widget.dart' show ProgressWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProgressModel extends FlutterFlowModel<ProgressWidget> {
  ///  Local state fields for this page.

  int? dayType = 0;

  ///  State fields for stateful widgets in this page.

  // Chart data service
  final ChartDataService _chartDataService = ChartDataService();

  // Loading state
  bool _isLoadingChartData = false;
  bool get isLoadingChartData => _isLoadingChartData;

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for ChartCaloria component.
  late ChartCaloriaModel chartCaloriaModel1;
  // Model for ChartWater component.
  late ChartWaterModel chartWaterModel1;
  // Model for ChartStep component.
  late ChartStepModel chartStepModel1;
  // Model for ChartWeight component.
  late ChartWeightModel chartWeightModel1;
  // Model for ChartCaloria component.
  late ChartCaloriaModel chartCaloriaModel2;
  // Model for ChartWater component.
  late ChartWaterModel chartWaterModel2;
  // Model for ChartStep component.
  late ChartStepModel chartStepModel2;
  // Model for ChartWeight component.
  late ChartWeightModel chartWeightModel2;
  // Model for ChartCaloria component.
  late ChartCaloriaModel chartCaloriaModel3;
  // Model for ChartWater component.
  late ChartWaterModel chartWaterModel3;
  // Model for ChartStep component.
  late ChartStepModel chartStepModel3;
  // Model for ChartWeight component.
  late ChartWeightModel chartWeightModel3;
  // Model for zNawBar component.
  late ZNawBarModel zNawBarModel;

  @override
  void initState(BuildContext context) {
    chartCaloriaModel1 = createModel(context, () => ChartCaloriaModel());
    chartWaterModel1 = createModel(context, () => ChartWaterModel());
    chartStepModel1 = createModel(context, () => ChartStepModel());
    chartWeightModel1 = createModel(context, () => ChartWeightModel());
    chartCaloriaModel2 = createModel(context, () => ChartCaloriaModel());
    chartWaterModel2 = createModel(context, () => ChartWaterModel());
    chartStepModel2 = createModel(context, () => ChartStepModel());
    chartWeightModel2 = createModel(context, () => ChartWeightModel());
    chartCaloriaModel3 = createModel(context, () => ChartCaloriaModel());
    chartWaterModel3 = createModel(context, () => ChartWaterModel());
    chartStepModel3 = createModel(context, () => ChartStepModel());
    chartWeightModel3 = createModel(context, () => ChartWeightModel());
    zNawBarModel = createModel(context, () => ZNawBarModel());
  }

  /// Load chart data from Firestore
  Future<void> loadChartData(BuildContext context) async {
    final userId = currentUserUid;
    if (userId.isEmpty) {
      debugPrint('Cannot load chart data: User not authenticated');
      return;
    }

    _isLoadingChartData = true;

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();
      final periodType = dayType ?? 0;

      debugPrint(
          'Loading chart data for period: $periodType, date: $selectedDate');

      final chartData = await _chartDataService.loadChartData(
        userId: userId,
        selectedDate: selectedDate,
        periodType: periodType,
      );

      // Update FFAppState with the loaded chart data
      FFAppState().update(() {
        FFAppState().chart = chartData;
      });

      debugPrint('Chart data loaded successfully');
    } catch (e) {
      debugPrint('Error loading chart data: $e');
    } finally {
      _isLoadingChartData = false;
    }
  }

  /// Reload chart data when period type changes
  Future<void> onPeriodTypeChanged(
      BuildContext context, int newPeriodType) async {
    dayType = newPeriodType;
    await loadChartData(context);
  }

  @override
  void dispose() {
    chartCaloriaModel1.dispose();
    chartWaterModel1.dispose();
    chartStepModel1.dispose();
    chartWeightModel1.dispose();
    chartCaloriaModel2.dispose();
    chartWaterModel2.dispose();
    chartStepModel2.dispose();
    chartWeightModel2.dispose();
    chartCaloriaModel3.dispose();
    chartWaterModel3.dispose();
    chartStepModel3.dispose();
    chartWeightModel3.dispose();
    zNawBarModel.dispose();
  }
}
