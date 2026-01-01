import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_weight_card/z_weight_card_widget.dart';
import 'dart:ui';
import 'weight_intake_history_widget.dart' show WeightIntakeHistoryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WeightIntakeHistoryModel
    extends FlutterFlowModel<WeightIntakeHistoryWidget> {
  ///  Local state fields for this page.

  int? selectedDay = 29;

  bool calendar = false;

  ///  State fields for stateful widgets in this page.

  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel1;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel2;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel3;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel4;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel5;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel6;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel7;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel8;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel9;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel10;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel11;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel12;
  // Model for zWeightCard component.
  late ZWeightCardModel zWeightCardModel13;

  @override
  void initState(BuildContext context) {
    zWeightCardModel1 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel2 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel3 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel4 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel5 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel6 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel7 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel8 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel9 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel10 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel11 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel12 = createModel(context, () => ZWeightCardModel());
    zWeightCardModel13 = createModel(context, () => ZWeightCardModel());
  }

  @override
  void dispose() {
    zWeightCardModel1.dispose();
    zWeightCardModel2.dispose();
    zWeightCardModel3.dispose();
    zWeightCardModel4.dispose();
    zWeightCardModel5.dispose();
    zWeightCardModel6.dispose();
    zWeightCardModel7.dispose();
    zWeightCardModel8.dispose();
    zWeightCardModel9.dispose();
    zWeightCardModel10.dispose();
    zWeightCardModel11.dispose();
    zWeightCardModel12.dispose();
    zWeightCardModel13.dispose();
  }
}
