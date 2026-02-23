import 'package:flutter/material.dart';
import '/backend/auth/auth_handler.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/register/entry_page/entry_page_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountStatusWidget extends StatefulWidget {
  const AccountStatusWidget({
    super.key,
    required this.status,
  });

  final String status; // 'suspended' or 'blocked'

  static String routeName = 'AccountStatus';
  static String routePath = '/accountStatus';

  @override
  State<AccountStatusWidget> createState() => _AccountStatusWidgetState();
}

class _AccountStatusWidgetState extends State<AccountStatusWidget> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    setState(() => _isLoggingOut = true);
    try {
      final authHandler = AuthHandler();
      await authHandler.signOut();
      if (mounted) {
        context.go(EntryPageWidget.routePath);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSuspended = widget.status == 'suspended';
    final statusColor = isSuspended
        ? FlutterFlowTheme.of(context).warning
        : FlutterFlowTheme.of(context).error;
    final statusTitle =
        isSuspended ? 'Account Suspended' : 'Account Blocked';
    final statusMessage = isSuspended
        ? 'Your account has been suspended. Please contact our support team for more information.'
        : 'Your account has been blocked. Please contact our support team for more information.';
    final statusIcon =
        isSuspended ? Icons.pause_circle_rounded : Icons.block_rounded;

    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Status Icon
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      statusIcon,
                      size: 50.0,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 32.0),

                  // Title
                  Text(
                    statusTitle,
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                          ),
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),

                  // Message
                  Text(
                    statusMessage,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                          ),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48.0),

                  // Logout Button
                  FFButtonWidget(
                    onPressed: _isLoggingOut ? null : _handleLogout,
                    text: 'Log Out',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      color: statusColor,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: Colors.white,
                              ),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

