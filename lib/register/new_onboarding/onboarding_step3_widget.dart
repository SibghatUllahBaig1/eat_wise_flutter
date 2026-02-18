import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step3_model.dart';
export 'onboarding_step3_model.dart';

/// Step 3: Collect Height and Weight
class OnboardingStep3Widget extends StatefulWidget {
  const OnboardingStep3Widget({super.key});

  static String routeName = 'OnboardingStep3';
  static String routePath = '/onboarding-step3';

  @override
  State<OnboardingStep3Widget> createState() => _OnboardingStep3WidgetState();
}

class _OnboardingStep3WidgetState extends State<OnboardingStep3Widget> {
  late OnboardingStep3Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep3Model());

    _model.heightController ??= TextEditingController();
    _model.heightFocusNode ??= FocusNode();

    _model.weightController ??= TextEditingController();
    _model.weightFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress indicator
                LinearProgressIndicator(
                  value: 0.42, // 3/7 steps
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                SizedBox(height: 32.0),

                // Title
                Text(
                  'Your measurements',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.0),

                Text(
                  'We need these to calculate your daily calorie needs',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                SizedBox(height: 32.0),

                // Height field
                TextFormField(
                  controller: _model.heightController,
                  focusNode: _model.heightFocusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Height (cm)',
                    hintText: 'Enter your height in centimeters',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),

                // Weight field
                TextFormField(
                  controller: _model.weightController,
                  focusNode: _model.weightFocusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Weight (kg)',
                    hintText: 'Enter your weight in kilograms',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),

                Spacer(),

                // Previous and Next buttons
                Row(
                  children: [
                    // Previous button
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () {
                          context.pop();
                        },
                        text: 'Previous',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          textStyle: FlutterFlowTheme.of(context)
                              .titleSmall
                              .override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // Next button
                    Expanded(
                      child: FFButtonWidget(
                        onPressed: () async {
                          if (_model.heightController.text.isEmpty ||
                              _model.weightController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please fill in all fields')),
                            );
                            return;
                          }

                          // Save to app state
                          FFAppState().updateUserProfileStruct((profile) =>
                              profile
                                ..heightCm = double.tryParse(
                                        _model.heightController.text) ??
                                    0.0
                                ..weightKg = double.tryParse(
                                        _model.weightController.text) ??
                                    0.0);

                          context.pushNamed('OnboardingStep4');
                        },
                        text: 'Next',
                        options: FFButtonOptions(
                          width: double.infinity,
                          height: 50.0,
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
