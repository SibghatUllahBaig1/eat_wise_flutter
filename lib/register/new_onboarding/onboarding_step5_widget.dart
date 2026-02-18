import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step5_model.dart';
export 'onboarding_step5_model.dart';

/// Step 5: Select Activity Level
class OnboardingStep5Widget extends StatefulWidget {
  const OnboardingStep5Widget({super.key});

  static String routeName = 'OnboardingStep5';
  static String routePath = '/onboarding-step5';

  @override
  State<OnboardingStep5Widget> createState() => _OnboardingStep5WidgetState();
}

class _OnboardingStep5WidgetState extends State<OnboardingStep5Widget> {
  late OnboardingStep5Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> activityLevels = [
    {'title': 'Sedentary', 'description': 'Little or no exercise'},
    {'title': 'Lightly Active', 'description': 'Light exercise 1-3 days/week'},
    {
      'title': 'Moderately Active',
      'description': 'Moderate exercise 3-5 days/week'
    },
    {'title': 'Very Active', 'description': 'Hard exercise 6-7 days/week'},
    {
      'title': 'Extra Active',
      'description': 'Very hard exercise & physical job'
    },
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep5Model());
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
                  value: 0.71, // 5/7 steps
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                SizedBox(height: 32.0),

                Text(
                  'Activity level',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.0),

                Text(
                  'How active are you on a typical day?',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                SizedBox(height: 24.0),

                Expanded(
                  child: ListView(
                    children: activityLevels
                        .map((level) => Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () => setState(() => _model
                                    .selectedActivityLevel = level['title']!),
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: _model.selectedActivityLevel ==
                                            level['title']
                                        ? FlutterFlowTheme.of(context)
                                            .primary
                                            .withOpacity(0.1)
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedActivityLevel ==
                                              level['title']
                                          ? FlutterFlowTheme.of(context).primary
                                          : FlutterFlowTheme.of(context)
                                              .alternate,
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
                                              level['title']!,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyLarge
                                                  .override(
                                                    fontFamily: 'Readex Pro',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              level['description']!,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodySmall
                                                  .override(
                                                    fontFamily: 'Readex Pro',
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_model.selectedActivityLevel ==
                                          level['title'])
                                        Icon(
                                          Icons.check_circle,
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          size: 24.0,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),

                SizedBox(height: 16.0),

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
                          if (_model.selectedActivityLevel.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Please select an activity level')),
                            );
                            return;
                          }

                          FFAppState().updateUserProfileStruct((profile) =>
                              profile
                                ..activityLevel = _model.selectedActivityLevel);

                          context.pushNamed('OnboardingStep6');
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
