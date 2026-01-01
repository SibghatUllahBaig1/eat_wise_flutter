import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'chart_step_widget.dart' show ChartStepWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChartStepModel extends FlutterFlowModel<ChartStepWidget> {
  ///  Local state fields for this component.

  int? chartType = 0;

  List<int> chartValues = [6000, 5000, 4000, 3000, 2000, 1000];
  void addToChartValues(int item) => chartValues.add(item);
  void removeFromChartValues(int item) => chartValues.remove(item);
  void removeAtIndexFromChartValues(int index) => chartValues.removeAt(index);
  void insertAtIndexInChartValues(int index, int item) =>
      chartValues.insert(index, item);
  void updateChartValuesAtIndex(int index, Function(int) updateFn) =>
      chartValues[index] = updateFn(chartValues[index]);

  ChartValuesStruct? selectedValue;
  void updateSelectedValueStruct(Function(ChartValuesStruct) updateFn) {
    updateFn(selectedValue ??= ChartValuesStruct());
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
