import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'terms_of_service_model.dart';
export 'terms_of_service_model.dart';

class TermsOfServiceWidget extends StatefulWidget {
  const TermsOfServiceWidget({super.key});

  static String routeName = 'TermsOfService';
  static String routePath = '/termsOfService';

  @override
  State<TermsOfServiceWidget> createState() => _TermsOfServiceWidgetState();
}

class _TermsOfServiceWidgetState extends State<TermsOfServiceWidget> {
  late TermsOfServiceModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TermsOfServiceModel());
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
            buttonSize: 54.0,
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
            'Terms of Service',
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
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Text(
                  'Welcome to Calorio! These Terms of Service (“Terms”) govern your use of the Calorio mobile application (“App”), operated by Calorio (\"we\", \"our\", \"us\"). By downloading, accessing, or using our App, you agree to these Terms. If you do not agree, please do not use Kalorik.\n\n1. Use of the App\n1.1. Eligibility\nYou must be at least 13 years old to use Calorio. If you are under the age of majority in your country, you must have parental or guardian consent.\n\n1.2. Account Registration\nYou may be required to create an account. You agree to provide accurate and complete information and keep it up to date.\n\n1.3. Health Disclaimer\nCalorio provides calorie tracking and fitness guidance. However, it does not constitute medical advice. Always consult a physician before starting any diet or fitness program. Use the App at your own risk.\n\n2. User Responsibilities\nBy using the App, you agree:\n\nNot to misuse or disrupt the service\n\nNot to post or submit false, misleading, or harmful information\n\nTo comply with all applicable laws and regulations\n\nTo respect the intellectual property and privacy rights of others\n\n3. Subscriptions & Payments\nSome features may be available only via a paid subscription.\n\nYou will be informed of the pricing and terms before making a purchase\n\nSubscriptions may renew automatically unless canceled\n\nYou can manage or cancel your subscription through your app store account\n\nNo refunds are provided for partial subscription periods unless required by law.\n\n4. Intellectual Property\nAll content within Calorio — including design, text, graphics, logos, and software — is owned by Calorio or its licensors and is protected by intellectual property laws. You may not copy, modify, distribute, or create derivative works without written permission.\n\n5. Termination\nWe reserve the right to suspend or terminate your account if you violate these Terms or misuse the App. You may also delete your account at any time via settings or by contacting support.\n\n6. Limitation of Liability\nTo the maximum extent permitted by law:\n\nCalorio is provided \"as is\" without warranties of any kind\n\nWe are not liable for any direct, indirect, incidental, or consequential damages\n\nWe do not guarantee that the App will always be secure or error-free\n\n7. Modifications\nWe may update these Terms from time to time. If we make material changes, we will notify you via the App or other means. Your continued use after changes means you accept the updated Terms.\n\n8. Governing Law\nThese Terms are governed by the laws of [insert applicable country or region]. Any disputes arising under or related to these Terms shall be resolved in the courts of [insert jurisdiction].\n\n9. Contact Us\nIf you have questions or concerns about these Terms, please contact us:\n\n📧 support@calorio.app\n🌐 www.calorio.app',
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
