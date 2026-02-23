import '/buttons/text_right/text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/rate_us/rate_us_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'help_support_model.dart';
export 'help_support_model.dart';

class HelpSupportWidget extends StatefulWidget {
  const HelpSupportWidget({super.key});

  static String routeName = 'HelpSupport';
  static String routePath = '/helpSupport';

  @override
  State<HelpSupportWidget> createState() => _HelpSupportWidgetState();
}

class _HelpSupportWidgetState extends State<HelpSupportWidget> {
  late HelpSupportModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HelpSupportModel());
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
              borderColor: Colors.transparent,
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
            'Help & Support',
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
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // NOTE: FAQ navigation has been removed - backend functionality will not be implemented
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   focusColor: Colors.transparent,
                      //   hoverColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () async {
                      //     context.pushNamed(FaqWidget.routeName);
                      //   },
                      //   child: wrapWithModel(
                      //     model: _model.textRightModel1,
                      //     updateCallback: () => safeSetState(() {}),
                      //     child: TextRightWidget(
                      //       text: 'FAQ',
                      //     ),
                      //   ),
                      // ),
                      // NOTE: Contact Support navigation has been removed - backend functionality will not be implemented
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   focusColor: Colors.transparent,
                      //   hoverColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () async {
                      //     context.pushNamed(SupportWidget.routeName);
                      //   },
                      //   child: wrapWithModel(
                      //     model: _model.textRightModel2,
                      //     updateCallback: () => safeSetState(() {}),
                      //     child: TextRightWidget(
                      //       text: 'Contact Support',
                      //     ),
                      //   ),
                      // ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(PrivacyPolicyWidget.routeName);
                        },
                        child: wrapWithModel(
                          model: _model.textRightModel3,
                          updateCallback: () => safeSetState(() {}),
                          child: TextRightWidget(
                            text: 'Privacy Policy',
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(TermsOfServiceWidget.routeName);
                        },
                        child: wrapWithModel(
                          model: _model.textRightModel4,
                          updateCallback: () => safeSetState(() {}),
                          child: TextRightWidget(
                            text: 'Terms of Service',
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(AboutUsWidget.routeName);
                        },
                        child: wrapWithModel(
                          model: _model.textRightModel5,
                          updateCallback: () => safeSetState(() {}),
                          child: TextRightWidget(
                            text: 'About Us',
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          context.pushNamed(ContactUsWidget.routeName);
                        },
                        child: wrapWithModel(
                          model: _model.textRightModel6,
                          updateCallback: () => safeSetState(() {}),
                          child: TextRightWidget(
                            text: 'Contact Us',
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await showDialog(
                              barrierColor:
                                  FlutterFlowTheme.of(context).barrier,
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: RateUsWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textRightModel10,
                            updateCallback: () => safeSetState(() {}),
                            child: TextRightWidget(
                              text: 'Rate us',
                            ),
                          ),
                        ),
                      ),
                      // NOTE: Social Media navigation has been removed - backend functionality will not be implemented
                      // InkWell(
                      //   splashColor: Colors.transparent,
                      //   focusColor: Colors.transparent,
                      //   hoverColor: Colors.transparent,
                      //   highlightColor: Colors.transparent,
                      //   onTap: () async {
                      //     context.pushNamed(SocilaMediaWidget.routeName);
                      //   },
                      //   child: wrapWithModel(
                      //     model: _model.textRightModel12,
                      //     updateCallback: () => safeSetState(() {}),
                      //     child: TextRightWidget(
                      //       text: 'Follow us on Social Media',
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ]
                .divide(SizedBox(height: 12.0))
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
