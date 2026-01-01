import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_personal_food_app_bar/z_personal_food_app_bar_widget.dart';
import '/home_pages/components/z_personal_food_content/z_personal_food_content_widget.dart';
import '/home_pages/components/z_personal_food_headar/z_personal_food_headar_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'personal_food_details_widget.dart' show PersonalFoodDetailsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PersonalFoodDetailsModel
    extends FlutterFlowModel<PersonalFoodDetailsWidget> {
  ///  Local state fields for this page.

  int? quantity = 1;

  bool favorite = false;

  List<double> pieLegand = [8.2, 8.0, 4.2];
  void addToPieLegand(double item) => pieLegand.add(item);
  void removeFromPieLegand(double item) => pieLegand.remove(item);
  void removeAtIndexFromPieLegand(int index) => pieLegand.removeAt(index);
  void insertAtIndexInPieLegand(int index, double item) =>
      pieLegand.insert(index, item);
  void updatePieLegandAtIndex(int index, Function(double) updateFn) =>
      pieLegand[index] = updateFn(pieLegand[index]);

  List<double> pieValue = [12.0, 20.0, 24.0];
  void addToPieValue(double item) => pieValue.add(item);
  void removeFromPieValue(double item) => pieValue.remove(item);
  void removeAtIndexFromPieValue(int index) => pieValue.removeAt(index);
  void insertAtIndexInPieValue(int index, double item) =>
      pieValue.insert(index, item);
  void updatePieValueAtIndex(int index, Function(double) updateFn) =>
      pieValue[index] = updateFn(pieValue[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
