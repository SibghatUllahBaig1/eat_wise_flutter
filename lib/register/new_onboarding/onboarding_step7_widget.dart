import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/firestore/user_service.dart';
import '/backend/services/calorie_calculator_service.dart';
import '/backend/services/calorie_goal_history_helper.dart';
import '/backend/services/profile_sync_helper.dart';
import '/backend/firestore/weight_tracker_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step7_model.dart';
export 'onboarding_step7_model.dart';
import 'package:google_fonts/google_fonts.dart';

/// Step 7: Calculate calories and complete onboarding
class OnboardingStep7Widget extends StatefulWidget {
  const OnboardingStep7Widget({super.key});

  static String routeName = 'OnboardingStep7';
  static String routePath = '/onboarding-step7';

  @override
  State<OnboardingStep7Widget> createState() => _OnboardingStep7WidgetState();
}

class _OnboardingStep7WidgetState extends State<OnboardingStep7Widget>
    with TickerProviderStateMixin {
  late OnboardingStep7Model _model;
  late AnimationController _progressController;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep7Model());

    // Initialize progress animation controller
    _progressController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Calculate calories when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateCalories());
  }

  Future<void> _calculateCalories() async {
    setState(() => _model.isCalculating = true);

    // Start progress animation
    _progressController.forward();

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
        final savedProfile = FFAppState().userProfile;
        await _userService.saveUserProfileData(
          userId: currentUserUid,
          profile: savedProfile,
        );
        ProfileSyncHelper.applyProfileToTrackerState(savedProfile);
        await ProfileSyncHelper.seedWeightTrackerFromProfile(
          userId: currentUserUid,
          profile: savedProfile,
        );
        await CalorieGoalHistoryHelper.seedInitialGoal(
          userId: currentUserUid,
          dailyCalorieGoal: savedProfile.dailyCalorieGoal,
          goalType: savedProfile.goal,
        );
      }

      // Wait for progress animation to complete (4 seconds)
      await Future.delayed(const Duration(seconds: 4));

      if (mounted) {
        setState(() {
          _model.isCalculating = false;
          _model.isComplete = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _model.isCalculating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error calculating calories: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
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
                  // Modern loading screen with progress
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated circular progress indicator
                      SizedBox(
                        width: 120.0,
                        height: 120.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Background circle
                            Container(
                              width: 120.0,
                              height: 120.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.1),
                              ),
                            ),
                            // Animated progress circle
                            AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: CircleProgressPainter(
                                    progress: _progressController.value,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                  size: const Size(120.0, 120.0),
                                );
                              },
                            ),
                            // Center icon
                            Icon(
                              Icons.restaurant_menu_rounded,
                              size: 50.0,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      // Title
                      Text(
                        'Creating Your Plan',
                        style: GoogleFonts.inter(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12.0),
                      // Subtitle
                      Text(
                        'Calculating your personalized nutrition plan...',
                        style: GoogleFonts.inter(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32.0),
                      // Linear progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: LinearProgressIndicator(
                          minHeight: 6.0,
                          value: _progressController.value,
                          backgroundColor: FlutterFlowTheme.of(context)
                              .primary
                              .withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      // Progress percentage
                      AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          final percentage =
                              (_progressController.value * 100).toInt();
                          return Text(
                            '$percentage%',
                            style: GoogleFonts.inter(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: FlutterFlowTheme.of(context).primary,
                            ),
                          );
                        },
                      ),
                    ],
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

/// Custom painter for circular progress indicator
class CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  CircleProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3.0;

    // Draw progress arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // Start from top
      progress * 2 * 3.14159, // Sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
