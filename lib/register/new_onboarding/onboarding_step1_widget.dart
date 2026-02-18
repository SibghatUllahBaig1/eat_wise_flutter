import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/app_state.dart';
import 'onboarding_step1_model.dart';
export 'onboarding_step1_model.dart';

/// Step 1: Collect Full Name (Email is automatically retrieved from auth)
class OnboardingStep1Widget extends StatefulWidget {
  const OnboardingStep1Widget({super.key});

  static String routeName = 'OnboardingStep1';
  static String routePath = '/onboarding-step1';

  @override
  State<OnboardingStep1Widget> createState() => _OnboardingStep1WidgetState();
}

class _OnboardingStep1WidgetState extends State<OnboardingStep1Widget> {
  late OnboardingStep1Model _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingStep1Model());

    _model.nameController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();

    // Pre-fill name from display name if available
    if (currentUserDisplayName.isNotEmpty) {
      _model.nameController.text = currentUserDisplayName;
    }
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
                  value: 0.14, // 1/7 steps
                  backgroundColor: FlutterFlowTheme.of(context).alternate,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                SizedBox(height: 32.0),

                // Title
                Text(
                  'Let\'s get to know you',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily: 'Outfit',
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: 8.0),

                Text(
                  'We\'ll use this information to personalize your experience',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
                SizedBox(height: 32.0),

                // Full Name field
                TextFormField(
                  controller: _model.nameController,
                  focusNode: _model.nameFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
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

                // Next button
                FFButtonWidget(
                  onPressed: () async {
                    // Validate name field
                    if (_model.nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please enter your full name'),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                        ),
                      );
                      return;
                    }

                    // Get email from authenticated user
                    final userEmail = currentUserEmail;

                    if (userEmail.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Unable to retrieve email. Please try signing in again.'),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                        ),
                      );
                      return;
                    }

                    // Save to app state
                    FFAppState().updateUserProfileStruct((profile) => profile
                      ..fullName = _model.nameController.text.trim()
                      ..email = userEmail);

                    context.pushNamed('OnboardingStep2');
                  },
                  text: 'Next',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Readex Pro',
                          color: Colors.white,
                        ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
