import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/payment_methods_card/payment_methods_card_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'payment_methods_widget.dart' show PaymentMethodsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentMethodsModel extends FlutterFlowModel<PaymentMethodsWidget> {
  ///  Local state fields for this page.

  List<String> plan = [
    'Ad-free experience',
    'Advanced calorie tracking',
    'Activity & exercise logging',
    'Detailed progress insights',
    'Exclusive early access',
    'Priority customer support'
  ];
  void addToPlan(String item) => plan.add(item);
  void removeFromPlan(String item) => plan.remove(item);
  void removeAtIndexFromPlan(int index) => plan.removeAt(index);
  void insertAtIndexInPlan(int index, String item) => plan.insert(index, item);
  void updatePlanAtIndex(int index, Function(String) updateFn) =>
      plan[index] = updateFn(plan[index]);

  ///  State fields for stateful widgets in this page.

  // Models for PaymentMethodsCard dynamic component.
  late FlutterFlowDynamicModels<PaymentMethodsCardModel>
      paymentMethodsCardModels;

  @override
  void initState(BuildContext context) {
    paymentMethodsCardModels =
        FlutterFlowDynamicModels(() => PaymentMethodsCardModel());
  }

  @override
  void dispose() {
    paymentMethodsCardModels.dispose();
  }
}
