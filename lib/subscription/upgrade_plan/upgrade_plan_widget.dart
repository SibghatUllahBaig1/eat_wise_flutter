import 'dart:io';

import '/backend/services/entitlement_status.dart';
import '/backend/services/free_trial_service.dart';
import '/backend/services/purchase_result.dart';
import '/backend/services/subscription_controller.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'upgrade_plan_model.dart';
export 'upgrade_plan_model.dart';

/// The single EatWise Pro paywall/subscription-management screen.
///
/// There is one entitlement (`PSP yatoo LLC Pro`) sold as a monthly or
/// annual package. All purchase/restore/entitlement state comes from the
/// app-wide `SubscriptionController` (`context.watch<SubscriptionController>()`)
/// — this widget holds no subscription state of its own beyond the local
/// monthly/annual toggle.
class UpgradePlanWidget extends StatefulWidget {
  const UpgradePlanWidget({super.key});

  static String routeName = 'UpgradePlan';
  static String routePath = '/upgradePlan';

  @override
  State<UpgradePlanWidget> createState() => _UpgradePlanWidgetState();
}

class _UpgradePlanWidgetState extends State<UpgradePlanWidget> {
  late UpgradePlanModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UpgradePlanModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Package? _selectedPackage(SubscriptionController subscription) {
    return _model.billingPeriod == BillingPeriod.annual
        ? subscription.annualPackage
        : subscription.monthlyPackage;
  }

  Future<void> _handleSubscribe(SubscriptionController subscription) async {
    final package = _selectedPackage(subscription);
    if (package == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Purchases are not configured yet. Add your RevenueCat API keys and products, then try again.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    final result = await subscription.purchase(package);
    if (!mounted) return;

    switch (result.type) {
      case PurchaseOutcomeType.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome to EatWise Pro!'),
            backgroundColor: FlutterFlowTheme.of(context).success,
          ),
        );
        break;
      case PurchaseOutcomeType.cancelled:
        // User backed out of the purchase sheet — no error, no-op.
        break;
      case PurchaseOutcomeType.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message ?? 'Purchase failed. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
        break;
    }
  }

  Future<void> _handleRestore(SubscriptionController subscription) async {
    final result = await subscription.restore();
    if (!mounted) return;

    final message = switch (result.type) {
      RestoreOutcomeType.restored => 'Purchases restored successfully.',
      RestoreOutcomeType.noPreviousPurchase =>
        'No previous purchases found for this account.',
      RestoreOutcomeType.error =>
        result.message ?? 'Restore failed. Please try again.',
    };
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: result.isRestored
            ? FlutterFlowTheme.of(context).success
            : FlutterFlowTheme.of(context).secondaryText,
      ),
    );
  }

  Future<void> _openSubscriptionManagement(
      SubscriptionController subscription) async {
    final managementUrl = subscription.managementUrl;
    final uri = managementUrl != null
        ? Uri.parse(managementUrl)
        : (!kIsWeb && Platform.isIOS
            ? Uri.parse('https://apps.apple.com/account/subscriptions')
            : Uri.parse('https://play.google.com/store/account/subscriptions'));
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async => context.pop(),
          ),
          title: Text(
            'Subscription',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  letterSpacing: 0.0,
                ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Consumer<SubscriptionController>(
            builder: (context, subscription, _) {
              if (subscription.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                );
              }
              final revenueCatAvailable = subscription.offerings?.current !=
                      null &&
                  subscription.offerings!.current!.availablePackages.isNotEmpty;

              return RefreshIndicator(
                onRefresh: subscription.refreshOfferings,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (subscription.status == EntitlementStatus.inGracePeriod)
                        _buildGracePeriodBanner(context),
                      _buildHeader(context, subscription),
                      if (!revenueCatAvailable)
                        _buildInfoBanner(context,
                            'Could not load live pricing. Please try again shortly.'),
                      if (!subscription.isPro) ...[
                        _buildBillingToggle(context),
                        _buildPlanCard(context, subscription),
                      ] else
                        _buildManageCard(context, subscription),
                      const SizedBox(height: 8),
                      _buildFooter(context, subscription),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGracePeriodBanner(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FlutterFlowTheme.of(context).warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: FlutterFlowTheme.of(context).warning),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "There's a problem with your last payment. Please update your payment method — your Pro access continues during the grace period.",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBanner(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).accent1,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Readex Pro',
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SubscriptionController subscription) {
    final isPro = subscription.isPro;
    final title = subscription.isOnFreeTrial
        ? 'Pro Trial — ${subscription.freeTrialDaysRemaining ?? 0} days left'
        : isPro
            ? "You're on EatWise Pro"
            : 'Upgrade to EatWise Pro';
    final subtitle = subscription.isOnFreeTrial
        ? 'Enjoy full Pro access during your free trial. Subscribe anytime to keep access after it ends.'
        : isPro
            ? 'Unlimited meal tracking, macro breakdowns, and more.'
            : 'Start with a ${FreeTrialService.duration.inDays}-day free trial, or subscribe for unlimited meal tracking, macro breakdowns, and full water & activity tracking.';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            _billingChip(
              context,
              label: 'Annual',
              badge: 'Best value',
              selected: _model.billingPeriod == BillingPeriod.annual,
              onTap: () =>
                  setState(() => _model.billingPeriod = BillingPeriod.annual),
            ),
            _billingChip(
              context,
              label: 'Monthly',
              selected: _model.billingPeriod == BillingPeriod.monthly,
              onTap: () =>
                  setState(() => _model.billingPeriod = BillingPeriod.monthly),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billingChip(
    BuildContext context, {
    required String label,
    String? badge,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? FlutterFlowTheme.of(context).primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(height: 2),
                Text(
                  badge,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? Colors.white.withValues(alpha: 0.9)
                        : FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static const _proFeatures = [
    'Unlimited meal tracking',
    'Personalized meal plans',
    'Macro & nutrient breakdown',
    'Water & activity tracking',
  ];

  Widget _buildPlanCard(
      BuildContext context, SubscriptionController subscription) {
    final package = _selectedPackage(subscription);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EatWise Pro',
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Outfit',
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                package?.storeProduct.priceString ??
                    (_model.billingPeriod == BillingPeriod.annual
                        ? '\$29.99/yr'
                        : '\$4.99/mo'),
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _model.billingPeriod == BillingPeriod.annual
                    ? 'Billed annually · Cancel anytime'
                    : 'Billed monthly · Cancel anytime',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 14),
              ..._proFeatures.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 18,
                        color: FlutterFlowTheme.of(context).success,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feature,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FFButtonWidget(
                onPressed: subscription.isPurchasing
                    ? null
                    : () => _handleSubscribe(subscription),
                text: subscription.isPurchasing ? 'Processing...' : 'Subscribe',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 48,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManageCard(
      BuildContext context, SubscriptionController subscription) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: FlutterFlowTheme.of(context).alternate),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.workspace_premium,
                      color: FlutterFlowTheme.of(context).primary),
                  const SizedBox(width: 10),
                  Text(
                    'Active plan',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                subscription.activeProductIdentifier ?? 'EatWise Pro',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 16),
              FFButtonWidget(
                onPressed: () => _openSubscriptionManagement(subscription),
                text: !kIsWeb && Platform.isIOS
                    ? 'Manage in App Store'
                    : 'Manage in Google Play',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 48,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                  elevation: 0,
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(
      BuildContext context, SubscriptionController subscription) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          TextButton(
            onPressed: subscription.isPurchasing
                ? null
                : () => _handleRestore(subscription),
            child: Text(
              'Restore Purchases',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Text(
            'Payment will be charged to your App Store or Google Play account. Subscriptions renew automatically unless cancelled at least 24 hours before the end of the current period.',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }
}
