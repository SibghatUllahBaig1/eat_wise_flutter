import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/faq2/faq2_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'faq_model.dart';
export 'faq_model.dart';

class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key});

  static String routeName = 'FAQ';
  static String routePath = '/faq';

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
  late FaqModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FaqModel());
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
            'FAQ',
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
              wrapWithModel(
                model: _model.faq2Model1,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'What is Calorio and how does it work?',
                  answer:
                      'Calorio helps you track your daily calories, set personal health goals, and stay on top of your nutrition. Simply log your meals, and we’ll do the math!',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model2,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'Is Calorio free to use?',
                  answer:
                      'Yes! Calorio offers essential features for free. A premium version is available for extra tools like advanced insights and custom plans.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model3,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'How do I track what I eat?',
                  answer:
                      'You can search for foods, scan barcodes, or manually enter items to log your meals. Calorio calculates the calories and nutrients for you.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model4,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'Can I change my goal later?',
                  answer:
                      'Absolutely. You can update your goals anytime in the app settings — whether you\'re shifting from weight loss to muscle gain or adjusting your calorie intake.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model5,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question:
                      'Is Kalorik suitable for people with dietary restrictions?',
                  answer:
                      'Yes! You can set dietary preferences like vegetarian, vegan, gluten-free, and more — and Kalorik will tailor suggestions accordingly.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model6,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'How accurate is the calorie tracking?',
                  answer:
                      'Calorio uses a reliable food database and gives estimated values based on portion size. For best results, measure portions when possible.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model7,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'Does Calorio sync with fitness apps or devices?',
                  answer:
                      'Yes, Calorio supports syncing with popular apps and devices like Google Fit and Apple Health to better track your activity and adjust your calorie needs.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model8,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'What if I forget to log a meal?',
                  answer:
                      'Don’t worry — you can always go back and add meals later. Just try to stay consistent for the most accurate tracking.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model9,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question: 'How is my personal data handled?',
                  answer:
                      'Your privacy is important to us. Calorio does not share your personal data with third parties without your consent. Learn more in our Privacy Policy.',
                ),
              ),
              wrapWithModel(
                model: _model.faq2Model10,
                updateCallback: () => safeSetState(() {}),
                child: Faq2Widget(
                  question:
                      'I need help with something else. Where can I contact support?',
                  answer:
                      'You can reach out to our support team via the Help section in the app or email us directly at support@calorio.app.',
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
