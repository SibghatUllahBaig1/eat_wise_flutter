import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step4_model.dart';
export 'onboarding_step4_model.dart';

/// Step 4: Select Goal
class OnboardingStep4Widget extends StatefulWidget {
  const OnboardingStep4Widget({super.key});

  static String routeName = 'OnboardingStep4';
  static String routePath = '/onboarding-step4';

  @override
  State<OnboardingStep4Widget> createState() => _OnboardingStep4WidgetState();
}

class _OnboardingStep4WidgetState extends State<OnboardingStep4Widget> {
  late OnboardingStep4Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> goals = [
    {'title': 'Lose Weight', 'description': 'Reduce body weight gradually'},
    {'title': 'Maintain Weight', 'description': 'Keep current weight stable'},
    {'title': 'Gain Weight', 'description': 'Increase body weight healthily'},
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep4Model());
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
                LinearProgressIndicator(
                  value: 0.57, // 4/7 steps
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                SizedBox(height: 32.0),

                Text(
                  'What\'s your goal?',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.0),

                Text(
                  'Choose your primary health goal',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                SizedBox(height: 32.0),

                // Goal options
                ...goals
                    .map((goal) => Padding(
                          padding: EdgeInsets.only(bottom: 12.0),
                          child: InkWell(
                            onTap: () => setState(
                                () => _model.selectedGoal = goal['title']!),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: _model.selectedGoal == goal['title']
                                    ? FlutterFlowTheme.of(context)
                                        .primary
                                        .withOpacity(0.1)
                                    : FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: _model.selectedGoal == goal['title']
                                      ? FlutterFlowTheme.of(context).primary
                                      : FlutterFlowTheme.of(context).alternate,
                                  width: 2.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          goal['title']!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          goal['description']!,
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryText,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_model.selectedGoal == goal['title'])
                                    Icon(
                                      Icons.check_circle,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),

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
                          if (_model.selectedGoal.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Please select a goal')),
                            );
                            return;
                          }

                          FFAppState().updateUserProfileStruct(
                              (profile) => profile..goal = _model.selectedGoal);

                          context.pushNamed('OnboardingStep5');
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
