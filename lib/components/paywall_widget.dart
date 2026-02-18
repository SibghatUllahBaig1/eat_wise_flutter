import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class PaywallWidget extends StatefulWidget {
  const PaywallWidget({
    super.key,
    required this.featureName,
    this.onUpgrade,
  });

  final String featureName;
  final VoidCallback? onUpgrade;

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  final _backend = BackendManager();

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
              'Upgrade to access ${widget.featureName}',
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

/// Helper function to check feature access and show paywall if needed
Future<bool> checkFeatureAccess({
  required BuildContext context,
  required String featureName,
  VoidCallback? onUpgrade,
}) async {
  final backend = BackendManager();
  final userId = currentUserUid;

  if (userId.isEmpty) return false;

  final hasAccess = await backend.subscriptionService.hasFeatureAccess(
    userId: userId,
    featureName: featureName,
  );

  if (!hasAccess) {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: PaywallWidget(
          featureName: featureName,
          onUpgrade: onUpgrade,
        ),
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
    );
    return false;
  }

  return true;
}

