import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
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
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Upgrade Plan',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
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
              : _model.errorMessage != null
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64.0,
                              color: FlutterFlowTheme.of(context).error,
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              _model.errorMessage!,
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).bodyLarge,
                            ),
                            SizedBox(height: 24.0),
                            FFButtonWidget(
                              onPressed: () async {
                                setState(() {
                                  _model.loadOfferings();
                                });
                              },
                              text: 'Retry',
                              options: FFButtonOptions(
                                height: 50.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    24.0, 0.0, 24.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: FlutterFlowTheme.of(context).primary,
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                                elevation: 3.0,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Header section
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 24.0, 24.0, 32.0),
                            child: Column(
                              children: [
                                Text(
                                  'Choose Your Plan',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineLarge
                                      .override(
                                        fontFamily: 'Outfit',
                                        letterSpacing: 0.0,
                                      ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  '7-day free trial • Cancel anytime',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // Subscription plans
                          _buildPlanCard(
                            context,
                            title: 'Standard',
                            price: '\$9.99/month',
                            features: [
                              'Meal tracking',
                              'Activity tracking',
                              'Basic recipes',
                              'Progress charts',
                              'Water & step tracking',
                            ],
                            isCurrentPlan: _model.hasTier('standard'),
                            onTap: () async {
                              final package =
                                  _model.getPackageByIdentifier('standard');
                              if (package != null) {
                                final success =
                                    await _model.purchasePackage(package);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Successfully subscribed to Standard!'),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).success,
                                    ),
                                  );
                                  setState(() {});
                                }
                              }
                            },
                          ),

                          SizedBox(height: 16.0),

                          _buildPlanCard(
                            context,
                            title: 'Premium',
                            price: '\$14.99/month',
                            features: [
                              'Everything in Standard',
                              'AI food analysis',
                              'Advanced recipes',
                              'Custom meal plans',
                              'Advanced analytics',
                              'Export data',
                            ],
                            isCurrentPlan: _model.hasTier('premium'),
                            isPremium: true,
                            onTap: () async {
                              final package =
                                  _model.getPackageByIdentifier('premium');
                              if (package != null) {
                                final success =
                                    await _model.purchasePackage(package);
                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Successfully subscribed to Premium!'),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).success,
                                    ),
                                  );
                                  setState(() {});
                                }
                              }
                            },
                          ),

                          SizedBox(height: 32.0),

                          // Restore purchases button
                          TextButton(
                            onPressed: () async {
                              final success = await _model.restorePurchases();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Purchases restored!'),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).success,
                                  ),
                                );
                                setState(() {});
                              } else if (_model.errorMessage != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(_model.errorMessage!),
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).error,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Restore Purchases',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: FlutterFlowTheme.of(context).primary,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),

                          SizedBox(height: 32.0),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    required List<String> features,
    required bool isCurrentPlan,
    bool isPremium = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isPremium
              ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
              : FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: isPremium
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: isPremium ? 2.0 : 1.0,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Outfit',
                          letterSpacing: 0.0,
                        ),
                  ),
                  if (isPremium)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Text(
                        'POPULAR',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.white,
                              fontSize: 10.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                price,
                style: FlutterFlowTheme.of(context).titleLarge.override(
                      fontFamily: 'Outfit',
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                    ),
              ),
              SizedBox(height: 16.0),
              ...features.map((feature) => Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 20.0,
                          color: FlutterFlowTheme.of(context).success,
                        ),
                        SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            feature,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 16.0),
              FFButtonWidget(
                onPressed: isCurrentPlan ? null : onTap,
                text: isCurrentPlan ? 'Current Plan' : 'Subscribe',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: isCurrentPlan
                      ? FlutterFlowTheme.of(context).secondaryText
                      : FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(25.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
