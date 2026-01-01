import '/backend/schema/structs/index.dart';
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
