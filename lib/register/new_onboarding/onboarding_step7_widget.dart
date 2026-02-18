import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/services/calorie_calculator_service.dart';
import '/backend/firestore/user_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step7_model.dart';
export 'onboarding_step7_model.dart';

/// Step 7: Calculate calories and complete onboarding
class OnboardingStep7Widget extends StatefulWidget {
  const OnboardingStep7Widget({super.key});

  static String routeName = 'OnboardingStep7';
  static String routePath = '/onboarding-step7';

  @override
  State<OnboardingStep7Widget> createState() => _OnboardingStep7WidgetState();
}

class _OnboardingStep7WidgetState extends State<OnboardingStep7Widget> {
  late OnboardingStep7Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep7Model());

    // Calculate calories when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateCalories());
  }

  Future<void> _calculateCalories() async {
    setState(() => _model.isCalculating = true);

    try {
      final profile = FFAppState().userProfile;

      // Calculate using Mifflin-St Jeor formula
      final result = CalorieCalculatorService.calculateCalorieGoal(
        gender: profile.gender,
        age: profile.age,
        weightKg: profile.weightKg,
        heightCm: profile.heightCm,
        activityLevel: profile.activityLevel,
        goal: profile.goal,
      );

      // Update profile with calculated values
      FFAppState().updateUserProfileStruct((p) => p
        ..calculatedBMR = result['bmr'] as int
        ..calculatedTDEE = result['tdee'] as int
        ..dailyCalorieGoal = result['dailyCalories'] as int
        ..onboardingCompleted = true);

      // Save to Firestore
      if (currentUserUid.isNotEmpty) {
        await _userService.saveUserProfileData(
          userId: currentUserUid,
          profile: FFAppState().userProfile,
        );
      }

      setState(() {
        _model.isCalculating = false;
        _model.isComplete = true;
      });
    } catch (e) {
      setState(() => _model.isCalculating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error calculating calories: $e')),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = FFAppState().userProfile;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_model.isCalculating) ...[
                  CircularProgressIndicator(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Calculating your personalized plan...',
                    style: FlutterFlowTheme.of(context).headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ] else if (_model.isComplete) ...[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 80.0,
                  ),
                  SizedBox(height: 24.0),

                  Text(
                    'You\'re all set!',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Outfit',
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 16.0),

                  Text(
                    'Your personalized calorie goal',
                    style: FlutterFlowTheme.of(context).bodyLarge.override(
                          fontFamily: 'Readex Pro',
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                  SizedBox(height: 8.0),

                  Text(
                    '${profile.dailyCalorieGoal} kcal/day',
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          fontFamily: 'Outfit',
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 32.0),

                  Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow('BMR', '${profile.calculatedBMR} kcal'),
                        Divider(),
                        _buildInfoRow('TDEE', '${profile.calculatedTDEE} kcal'),
                        Divider(),
                        _buildInfoRow('Goal', profile.goal),
                      ],
                    ),
                  ),

                  Spacer(),

                  // Previous and Start buttons
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
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
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
                      // Start button
                      Expanded(
                        child: FFButtonWidget(
                          onPressed: () async {
                            context.goNamed('HomePage');
                          },
                          text: 'Start Your Journey',
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50.0,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyLarge.override(
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
