import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'privacy_policy_model.dart';
export 'privacy_policy_model.dart';

class PrivacyPolicyWidget extends StatefulWidget {
  const PrivacyPolicyWidget({super.key});

  static String routeName = 'PrivacyPolicy';
  static String routePath = '/privacyPolicy';

  @override
  State<PrivacyPolicyWidget> createState() => _PrivacyPolicyWidgetState();
}

class _PrivacyPolicyWidgetState extends State<PrivacyPolicyWidget> {
  late PrivacyPolicyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PrivacyPolicyModel());
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
          leading: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: FlutterFlowTheme.of(context).transparent,
              borderRadius: 22.0,
              borderWidth: 1.0,
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
          ),
          title: Text(
            'Privacy Policy',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Text(
                  'Welcome to Calorio (\"we\", \"our\", or \"us\"). We respect your privacy and are committed to protecting the personal data you share with us. This Privacy Policy explains how we collect, use, and protect your information when you use our mobile application Kalorik.\n\n1. Information We Collect\nWhen you use Calorio, we may collect the following types of information:\n\n1.1. Personal Information\n\nName\nEmail address\nDate of birth\nGender\nAccount login details\nHealth-related goals and preferences\n\n1.2. Usage Information\nApp usage data (e.g. features used, session duration)\n\nDevice and operating system information\n\nCrash reports and performance logs\n\n1.3. Health and Fitness Data\nWith your permission, we may collect data you input manually (such as calories, meals, weight, goals) to personalize your experience and provide relevant recommendations.\n\n2. How We Use Your Information\nWe use your information to:\n\nCreate and manage your account\n\nPersonalize your health and nutrition recommendations\n\nTrack your progress toward your goals\n\nImprove the performance of the app\n\nCommunicate with you about updates and support\n\nComply with legal obligations\n\n3. Sharing Your Information\nWe do not sell or rent your personal data. We may share information with:\n\nService providers (such as analytics or cloud storage providers) under strict confidentiality agreements\n\nAuthorities if required by law or legal process\n\nYour consented third-party integrations (e.g., syncing with Apple Health or Google Fit)\n\n4. Your Choices & Rights\nYou have the right to:\n\nAccess, update, or delete your personal information\n\nWithdraw your consent at any time\n\nRequest a copy of your stored data\n\nDeactivate or delete your account\n\nYou can manage your data via the app\'s settings or by contacting our support team at support@calorio.app\n\n5. Data Security\nWe use industry-standard security measures to protect your data. However, no system can be 100% secure. We recommend using a strong password and enabling any available security features.\n\n6. Children\'s Privacy\nKalorik is not intended for users under the age of 13. We do not knowingly collect data from children. If you believe we have done so unintentionally, please contact us immediately.\n\n7. Changes to This Policy\nWe may update this Privacy Policy from time to time. We\'ll notify you of significant changes by posting an update in the app or sending a notification.\n\n8. Contact Us\nIf you have any questions or concerns about this policy or your personal data, contact us at:\n\n📧 support@calorio.app\n🌐 www.calorio.app',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                ),
              ),
            ]
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
