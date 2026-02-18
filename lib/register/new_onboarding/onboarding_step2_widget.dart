import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step2_model.dart';
export 'onboarding_step2_model.dart';

/// Step 2: Collect Age and Gender
class OnboardingStep2Widget extends StatefulWidget {
  const OnboardingStep2Widget({super.key});

  static String routeName = 'OnboardingStep2';
  static String routePath = '/onboarding-step2';

  @override
  State<OnboardingStep2Widget> createState() => _OnboardingStep2WidgetState();
}

class _OnboardingStep2WidgetState extends State<OnboardingStep2Widget> {
  late OnboardingStep2Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep2Model());

    _model.ageController ??= TextEditingController();
    _model.ageFocusNode ??= FocusNode();
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
                  value: 0.28, // 2/7 steps
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                SizedBox(height: 32.0),

                // Title
                Text(
                  'Tell us about yourself',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.0),

                Text(
                  'This helps us calculate your personalized calorie goal',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                SizedBox(height: 32.0),

                // Age field
                TextFormField(
                  controller: _model.ageController,
                  focusNode: _model.ageFocusNode,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Age',
                    hintText: 'Enter your age',
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
                SizedBox(height: 24.0),

                // Gender selection
                Text(
                  'Gender',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: 12.0),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            setState(() => _model.selectedGender = 'Male'),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: _model.selectedGender == 'Male'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: _model.selectedGender == 'Male'
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Male',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: _model.selectedGender == 'Male'
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: InkWell(
                        onTap: () =>
                            setState(() => _model.selectedGender = 'Female'),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: _model.selectedGender == 'Female'
                                ? FlutterFlowTheme.of(context).primary
                                : FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: _model.selectedGender == 'Female'
                                  ? FlutterFlowTheme.of(context).primary
                                  : FlutterFlowTheme.of(context).alternate,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Female',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: _model.selectedGender == 'Female'
                                        ? Colors.white
                                        : FlutterFlowTheme.of(context)
                                            .primaryText,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          if (_model.ageController.text.isEmpty ||
                              _model.selectedGender.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Please fill in all fields')),
                            );
                            return;
                          }

                          // Save to app state
                          FFAppState()
                              .updateUserProfileStruct((profile) => profile
                                ..age =
                                    int.tryParse(_model.ageController.text) ?? 0
                                ..gender = _model.selectedGender);

                          context.pushNamed('OnboardingStep3');
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
