import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'upgrade_plan_widget.dart' show UpgradePlanWidget;

enum BillingPeriod { monthly, annual }

/// EatWise has a single Pro entitlement (`PSP yatoo LLC Pro`) sold as two
/// packages — monthly and annual. This model only tracks which billing
/// period the user has toggled to; purchasing, restoring, and entitlement
/// state all live in the single reactive `SubscriptionController` (see
/// `backend/services/subscription_controller.dart`), read directly by the
/// widget so there is exactly one source of truth app-wide.
class UpgradePlanModel extends FlutterFlowModel<UpgradePlanWidget> {
  BillingPeriod billingPeriod = BillingPeriod.annual;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
