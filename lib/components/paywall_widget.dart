import '/backend/services/subscription_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaywallWidget extends StatefulWidget {
  const PaywallWidget({
    super.key,
    required this.featureName,
    this.displayName,
    this.onUpgrade,
  });

  /// Internal feature key, used only for display (humanized in the paywall copy).
  final String featureName;

  /// Optional user-facing label. Falls back to a humanized [featureName] when omitted.
  final String? displayName;
  final VoidCallback? onUpgrade;

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock_outline,
              size: 64.0,
              color: FlutterFlowTheme.of(context).primary,
            ),
            SizedBox(height: 16.0),
            Text(
              'Premium Feature',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'Outfit',
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Upgrade to access ${widget.displayName ?? _humanize(widget.featureName)}',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: 24.0),
            FFButtonWidget(
              onPressed: () {
                if (widget.onUpgrade != null) {
                  widget.onUpgrade!();
                } else {
                  context.pushNamed('UpgradePlan');
                }
              },
              text: 'Upgrade Now',
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                elevation: 3.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            SizedBox(height: 12.0),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Maybe Later',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Humanize a `snake_case` feature key for display (e.g.
/// `ai_food_analysis` -> `AI Food Analysis`).
String _humanize(String featureName) {
  if (featureName.isEmpty) return featureName;
  return featureName
      .split('_')
      .map((w) => w.isEmpty
          ? w
          : (w.toLowerCase() == 'ai'
              ? 'AI'
              : '${w[0].toUpperCase()}${w.substring(1)}'))
      .join(' ');
}

/// Checks the single reactive [SubscriptionController.isPro] source of
/// truth and shows the paywall dialog if the user isn't Pro. Returns `true`
/// only when the feature is actually unlocked.
Future<bool> checkFeatureAccess({
  required BuildContext context,
  required String featureName,
  String? displayName,
  VoidCallback? onUpgrade,
}) async {
  final subscription = context.read<SubscriptionController>();
  await subscription.refreshProGrant();
  if (!context.mounted) return false;

  final isPro = subscription.isPro;

  if (!isPro) {
    if (!context.mounted) return false;
    await showDialog(
      context: context,
      builder: (dialogContext) {
        final maxWidth = MediaQuery.sizeOf(dialogContext).width - 48.0;
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: PaywallWidget(
              featureName: featureName,
              displayName: displayName,
              onUpgrade: onUpgrade,
            ),
          ),
        );
      },
    );
    return false;
  }

  return true;
}
