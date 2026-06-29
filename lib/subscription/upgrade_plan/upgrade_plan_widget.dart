import 'dart:io';

import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'upgrade_plan_model.dart';
export 'upgrade_plan_model.dart';

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

  Future<void> _reload() async {
    await _model.loadOfferings();
    if (mounted) setState(() {});
  }

  Future<void> _handleSubscribe(String planId) async {
    final success = await _model.purchasePlan(planId);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome to EatWise ${_capitalize(planId)}!'),
          backgroundColor: FlutterFlowTheme.of(context).success,
        ),
      );
      setState(() {});
    } else if (_model.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_model.errorMessage!),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  Future<void> _handleRestore() async {
    final success = await _model.restorePurchases();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? 'Purchases restored successfully.'
            : (_model.errorMessage ?? 'No purchases to restore.')),
        backgroundColor: success
            ? FlutterFlowTheme.of(context).success
            : FlutterFlowTheme.of(context).error,
      ),
    );
    if (success) setState(() {});
  }

  Future<void> _openSubscriptionManagement() async {
    final uri = !kIsWeb && Platform.isIOS
        ? Uri.parse('https://apps.apple.com/account/subscriptions')
        : Uri.parse('https://play.google.com/store/account/subscriptions');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _capitalize(String value) =>
      value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

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
          child: _model.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _reload,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_model.isOnTrial) _buildTrialBanner(context),
                        _buildHeader(context),
                        if (_model.errorMessage != null &&
                            !_model.revenueCatAvailable)
                          _buildInfoBanner(context, _model.errorMessage!),
                        _buildBillingToggle(context),
                        ...UpgradePlanModel.plans.map(
                          (plan) => _buildPlanCard(context, plan),
                        ),
                        const SizedBox(height: 8),
                        _buildFooter(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTrialBanner(BuildContext context) {
    final days = _model.trialDaysRemaining();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.workspace_premium,
              color: FlutterFlowTheme.of(context).primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                days != null
                    ? 'Premium trial active · $days day${days == 1 ? '' : 's'} left'
                    : 'Premium trial active',
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
      child: Column(
        children: [
          Text(
            'Choose Your Plan',
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).headlineLarge.override(
                  fontFamily: 'Outfit',
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            '7-day free trial on Premium · Cancel anytime',
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
              badge: 'Save 33%',
              selected: _model.billingPeriod == BillingPeriod.annual,
              onTap: () => setState(
                  () => _model.billingPeriod = BillingPeriod.annual),
            ),
            _billingChip(
              context,
              label: 'Monthly',
              selected: _model.billingPeriod == BillingPeriod.monthly,
              onTap: () => setState(
                  () => _model.billingPeriod = BillingPeriod.monthly),
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

  Widget _buildPlanCard(BuildContext context, PlanDefinition plan) {
    final isCurrent = _model.isCurrentPlan(plan.id);
    final isPremium = plan.isPopular;
    final isFree = plan.id == 'free';

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isPremium
              ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.08)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPremium
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: isPremium ? 2 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    plan.title,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0.0,
                        ),
                  ),
                  const Spacer(),
                  if (isPremium)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'POPULAR',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  if (isCurrent)
                    Container(
                      margin: EdgeInsets.only(left: isPremium ? 8 : 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).success,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'CURRENT',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _model.priceLabel(plan),
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                _model.priceSubtitle(plan),
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 14),
              ...plan.features.map(
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
              if (!isFree) ...[
                const SizedBox(height: 8),
                FFButtonWidget(
                  onPressed: (_model.isPurchasing || isCurrent)
                      ? null
                      : () => _handleSubscribe(plan.id),
                  text: isCurrent
                      ? 'Current Plan'
                      : (_model.isPurchasing ? 'Processing...' : 'Subscribe'),
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 48,
                    color: isCurrent
                        ? FlutterFlowTheme.of(context).secondaryText
                        : FlutterFlowTheme.of(context).primary,
                    textStyle:
                        FlutterFlowTheme.of(context).titleSmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final showManage = _model.currentTier != null &&
        _model.currentTier != 'free' &&
        !_model.isOnTrial;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          TextButton(
            onPressed: _model.isPurchasing ? null : _handleRestore,
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
          if (showManage)
            TextButton(
              onPressed: _openSubscriptionManagement,
              child: Text(
                !kIsWeb && Platform.isIOS
                    ? 'Manage in App Store'
                    : 'Manage in Google Play',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).primary,
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
