import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'z_personal_food_content_widget.dart' show ZPersonalFoodContentWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZPersonalFoodContentModel
    extends FlutterFlowModel<ZPersonalFoodContentWidget> {
  ///  Local state fields for this component.

  List<double> peiLegand = [8.2, 3.2, 4.8];
  void addToPeiLegand(double item) => peiLegand.add(item);
  void removeFromPeiLegand(double item) => peiLegand.remove(item);
  void removeAtIndexFromPeiLegand(int index) => peiLegand.removeAt(index);
  void insertAtIndexInPeiLegand(int index, double item) =>
      peiLegand.insert(index, item);
  void updatePeiLegandAtIndex(int index, Function(double) updateFn) =>
      peiLegand[index] = updateFn(peiLegand[index]);

  List<double> peiValue = [24.0, 16.0, 20.0];
  void addToPeiValue(double item) => peiValue.add(item);
  void removeFromPeiValue(double item) => peiValue.remove(item);
  void removeAtIndexFromPeiValue(int index) => peiValue.removeAt(index);
  void insertAtIndexInPeiValue(int index, double item) =>
      peiValue.insert(index, item);
  void updatePeiValueAtIndex(int index, Function(double) updateFn) =>
      peiValue[index] = updateFn(peiValue[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
