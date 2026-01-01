import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'plan_widget.dart' show PlanWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PlanModel extends FlutterFlowModel<PlanWidget> {
  ///  Local state fields for this page.

  List<String> advantages = [
    '🧭 Easy to follow',
    '🎯 Tailored to your goals',
    '👟 Adapted to your daily routine',
    '🥗 Recipes that match your preferences',
    '🪂 No diets or restrictions',
    '✍️ Created by experienced nutritionists'
  ];
  void addToAdvantages(String item) => advantages.add(item);
  void removeFromAdvantages(String item) => advantages.remove(item);
  void removeAtIndexFromAdvantages(int index) => advantages.removeAt(index);
  void insertAtIndexInAdvantages(int index, String item) =>
      advantages.insert(index, item);
  void updateAdvantagesAtIndex(int index, Function(String) updateFn) =>
      advantages[index] = updateFn(advantages[index]);

  int? pageItem = 0;

  ///  State fields for stateful widgets in this page.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
