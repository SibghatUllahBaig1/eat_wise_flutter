import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step6_model.dart';
export 'onboarding_step6_model.dart';

/// Step 6: Select Dietary Preference
class OnboardingStep6Widget extends StatefulWidget {
  const OnboardingStep6Widget({super.key});

  static String routeName = 'OnboardingStep6';
  static String routePath = '/onboarding-step6';

  @override
  State<OnboardingStep6Widget> createState() => _OnboardingStep6WidgetState();
}

class _OnboardingStep6WidgetState extends State<OnboardingStep6Widget> {
  late OnboardingStep6Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> dietaryPreferences = [
    {'title': 'No Preference', 'description': 'I eat everything'},
    {
      'title': 'Vegetarian',
      'description': 'No meat, but dairy and eggs are okay'
    },
    {'title': 'Vegan', 'description': 'No animal products'},
    {
      'title': 'Pescatarian',
      'description': 'Fish and seafood, but no other meat'
    },
    {'title': 'Keto', 'description': 'Low carb, high fat'},
    {'title': 'Paleo', 'description': 'Whole foods, no processed foods'},
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep6Model());
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
                  value: 0.85, // 6/7 steps
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                SizedBox(height: 32.0),

                Text(
                  'Dietary preference',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.0),

                Text(
                  'Do you follow any specific diet?',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                SizedBox(height: 24.0),

                Expanded(
                  child: ListView(
                    children: dietaryPreferences
                        .map((pref) => Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () => setState(() =>
                                    _model.selectedDietaryPreference =
                                        pref['title']!),
                                child: Container(
                                  padding: EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: _model.selectedDietaryPreference ==
                                            pref['title']
                                        ? FlutterFlowTheme.of(context)
                                            .primary
                                            .withOpacity(0.1)
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: _model.selectedDietaryPreference ==
                                              pref['title']
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
                                              pref['title']!,
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
                                              pref['description']!,
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
                                      if (_model.selectedDietaryPreference ==
                                          pref['title'])
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
                          if (_model.selectedDietaryPreference.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Please select a dietary preference')),
                            );
                            return;
                          }

                          FFAppState().updateUserProfileStruct((profile) =>
                              profile
                                ..dietaryPreference =
                                    _model.selectedDietaryPreference);

                          context.pushNamed('OnboardingStep7');
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
