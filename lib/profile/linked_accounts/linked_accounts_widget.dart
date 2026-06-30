import '/backend/auth/auth_handler.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'linked_accounts_model.dart';
export 'linked_accounts_model.dart';

class LinkedAccountsWidget extends StatefulWidget {
  const LinkedAccountsWidget({super.key});

  static String routeName = 'LinkedAccounts';
  static String routePath = '/linkedAccounts';

  @override
  State<LinkedAccountsWidget> createState() => _LinkedAccountsWidgetState();
}

class _LinkedAccountsWidgetState extends State<LinkedAccountsWidget> {
  late LinkedAccountsModel _model;
  final AuthHandler _authHandler = AuthHandler();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LinkedAccountsModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  bool _isLinked(User user, String providerId) =>
      user.providerData.any((info) => info.providerId == providerId);

  Future<void> _showMessage(String message) async {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _linkGoogle() async {
    final success = await _authHandler.linkWithGoogle();
    if (!mounted) return;
    if (success) {
      await _showMessage('Google account linked');
    } else if (_authHandler.error != null) {
      await _showMessage(_authHandler.error!);
    }
    safeSetState(() {});
  }

  Future<void> _linkApple() async {
    final success = await _authHandler.linkWithApple();
    if (!mounted) return;
    if (success) {
      await _showMessage('Apple account linked');
    } else if (_authHandler.error != null) {
      await _showMessage(_authHandler.error!);
    }
    safeSetState(() {});
  }

  Future<void> _unlink(String providerId, String label) async {
    final success = await _authHandler.unlinkProvider(providerId);
    if (!mounted) return;
    if (success) {
      await _showMessage('$label account unlinked');
    } else if (_authHandler.error != null) {
      await _showMessage(_authHandler.error!);
    }
    safeSetState(() {});
  }

  Future<void> _linkEmail() async {
    final emailController = TextEditingController(
      text: FirebaseAuth.instance.currentUser?.email ?? '',
    );
    final passwordController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Link Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Link'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    final success = await _authHandler.linkWithEmailPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if (!mounted) return;
    if (success) {
      await _showMessage('Email account linked');
    } else if (_authHandler.error != null) {
      await _showMessage(_authHandler.error!);
    }
    safeSetState(() {});
  }

  Widget _buildProviderRow({
    required BuildContext context,
    required User user,
    required String providerId,
    required String label,
    required Widget leading,
    required Future<void> Function() onLink,
  }) {
    final linked = _isLinked(user, providerId);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              leading,
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 12.0, 0.0),
                  child: Text(
                    label,
                    style: FlutterFlowTheme.of(context).titleSmall,
                  ),
                ),
              ),
              if (linked)
                FFButtonWidget(
                  onPressed: () => _unlink(providerId, label),
                  text: 'Unlink',
                  options: FFButtonOptions(
                    height: 36.0,
                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    textStyle: FlutterFlowTheme.of(context).labelMedium,
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                )
              else
                FFButtonWidget(
                  onPressed: onLink,
                  text: 'Link',
                  options: FFButtonOptions(
                    height: 36.0,
                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).labelMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          color: FlutterFlowTheme.of(context).info,
                        ),
                    elevation: 0.0,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
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
            borderRadius: 22.0,
            buttonSize: 44.0,
            icon: Icon(
              FFIcons.karrowLeft,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 24.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Linked Accounts',
            style: FlutterFlowTheme.of(context).titleLarge,
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            final user = snapshot.data ?? FirebaseAuth.instance.currentUser;
            if (user == null) {
              return const Center(child: Text('Not signed in'));
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProviderRow(
                    context: context,
                    user: user,
                    providerId: 'google.com',
                    label: 'Google',
                    leading: Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.asset(
                        'assets/images/gg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    onLink: _linkGoogle,
                  ),
                  SizedBox(height: 12.0),
                  _buildProviderRow(
                    context: context,
                    user: user,
                    providerId: 'apple.com',
                    label: 'Apple',
                    leading: Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        FFIcons.kfruit,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                    onLink: _linkApple,
                  ),
                  SizedBox(height: 12.0),
                  _buildProviderRow(
                    context: context,
                    user: user,
                    providerId: 'password',
                    label: 'Email',
                    leading: Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.email_outlined,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                    ),
                    onLink: _linkEmail,
                  ),
                ]
                    .divide(SizedBox(height: 0.0))
                    .addToStart(SizedBox(height: 16.0))
                    .addToEnd(SizedBox(height: 24.0)),
              ),
            );
          },
        ),
      ),
    );
  }
}
