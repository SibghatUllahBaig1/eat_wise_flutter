import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/backend/services/onboarding_service.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';

/// Widget that determines the initial route based on authentication and onboarding status
class InitialRouteWidget extends StatefulWidget {
  const InitialRouteWidget({super.key});

  static String routeName = 'InitialRoute';
  static String routePath = '/';

  @override
  State<InitialRouteWidget> createState() => _InitialRouteWidgetState();
}

class _InitialRouteWidgetState extends State<InitialRouteWidget> {
  final OnboardingService _onboardingService = OnboardingService();

  @override
  void initState() {
    super.initState();
    _checkRouting();
  }

  Future<void> _checkRouting() async {
    // Wait for Firebase Auth to fully initialize and load persisted user
    // Increased delay to ensure auth state is loaded from storage
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    // Get the current user directly from Firebase Auth
    final user = FirebaseAuth.instance.currentUser;

    // Debug logging
    debugPrint('InitialRoute: Checking auth state...');
    debugPrint(
        'InitialRoute: User is ${user == null ? "null" : "logged in (${user.uid})"}');

    if (user == null) {
      // Not logged in - go to entry page
      debugPrint('InitialRoute: Navigating to EntryPage');
      if (mounted) {
        context.go(EntryPageWidget.routePath);
      }
    } else {
      // User is logged in - check onboarding status
      final hasCompleted =
          await _onboardingService.hasCompletedOnboarding(user.uid);

      if (!mounted) return;

      if (hasCompleted) {
        // Onboarding completed - go to home page
        debugPrint('InitialRoute: Onboarding complete, navigating to HomePage');
        context.go(HomePageWidget.routePath);
      } else {
        // Onboarding not completed - go to onboarding step 1
        debugPrint(
            'InitialRoute: Onboarding incomplete, navigating to OnboardingStep1');
        context.go(OnboardingStep1Widget.routePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Image.asset(
              'assets/images/custom-images/logo.png',
              height: 80.0,
            ),
            const SizedBox(height: 32.0),
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).primary,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Loading...',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
