import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'billing_subscriptions_widget.dart' show BillingSubscriptionsWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BillingSubscriptionsModel
    extends FlutterFlowModel<BillingSubscriptionsWidget> {
  ///  Local state fields for this page.

  List<String> plan = [
    'Unlimited Meal Tracking',
    'Personalized Meal Plans',
    'Macro & Nutrient Breakdown',
    'Water & Activity Tracking',
    'Sync with Devices',
    'Priority Support',
    'Ad-Free Experience'
  ];
  void addToPlan(String item) => plan.add(item);
  void removeFromPlan(String item) => plan.remove(item);
  void removeAtIndexFromPlan(int index) => plan.removeAt(index);
  void insertAtIndexInPlan(int index, String item) => plan.insert(index, item);
  void updatePlanAtIndex(int index, Function(String) updateFn) =>
      plan[index] = updateFn(plan[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
