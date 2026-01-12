import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';
import 'meal_service.dart';
import 'water_tracker_service.dart';
import 'weight_tracker_service.dart';
import 'step_tracker_service.dart';
import '/app_state.dart';

/// Service for synchronizing data between app state and Firestore
class SyncService {
  final UserService _userService = UserService();
  final MealService _mealService = MealService();
  final WaterTrackerService _waterService = WaterTrackerService();
  final WeightTrackerService _weightService = WeightTrackerService();
  final StepTrackerService _stepService = StepTrackerService();

  /// Sync user profile from app state to Firestore
  Future<void> syncUserProfile({
    required String userId,
  }) async {
    try {
      final appState = FFAppState();

      await _userService.createOrUpdateUserProfile(
        userId: userId,
        displayName: FirebaseAuth.instance.currentUser?.displayName,
        email: FirebaseAuth.instance.currentUser?.email,
        photoUrl: FirebaseAuth.instance.currentUser?.photoURL,
        gender: appState.gender,
        dateOfBirth: appState.dateOfBirth,
        height: appState.height,
        weight: {
          'value': appState.weight.value,
          'unit': appState.weight.unit,
        },
        targetWeight: {
          'value': appState.newWeight.value,
          'unit': appState.newWeight.unit,
        },
        onboardingAnswers: {
          'goal': appState.onboardingAnswers.goal,
          'dateOfBirth': appState.onboardingAnswers.dateOfBirth,
        },
      );
    } catch (e) {
      throw Exception('Failed to sync user profile: $e');
    }
  }

  /// Sync user settings from app state to Firestore
  Future<void> syncUserSettings({
    required String userId,
  }) async {
    try {
      final appState = FFAppState();

      await _userService.updateUserSettings(
        userId: userId,
        notifications: {
          'mealtime': appState.notification.mealtime,
          'breakfast': appState.notification.breakfast,
          'lunch': appState.notification.lunch,
          'supper':
              appState.notification.supper, // Changed from 'dinner' to 'supper'
          'snack': appState.notification.snack,
          'water': appState.notification.water,
          'checkYourProgress': appState.notification.checkYourProgress,
          'dayOfTheWeek': appState.notification.dayOfTheWeek,
        },
        darkMode: appState.darkMode,
        language: {
          'language': appState.selectedLang.language,
          'langCode': appState.selectedLang.langCode,
          'flag': appState.selectedLang.flag,
        },
        accountSecurity: {
          'biometricId': appState.accountSecurity.biometricId,
          'faceId': appState.accountSecurity.faceId,
          'smsAuthenticator': appState.accountSecurity.smsAuthenticator,
          'googleAuthenticator': appState.accountSecurity.googleAuthenticator,
        },
      );
    } catch (e) {
      throw Exception('Failed to sync user settings: $e');
    }
  }

  /// Sync goals from app state to Firestore
  /// Note: Goals sync removed - GoalsService was deleted
  Future<void> syncGoals({
    required String userId,
  }) async {
    // Goals sync functionality removed
  }

  /// Load user profile from Firestore to app state
  Future<void> loadUserProfile({
    required String userId,
  }) async {
    try {
      final profile = await _userService.getUserProfile(userId);

      if (profile != null) {
        final appState = FFAppState();

        appState.gender = profile['gender'] ?? 'Male';
        appState.dateOfBirth = profile['dateOfBirth'];
        appState.height = profile['height'] ?? '';

        if (profile['weight'] != null) {
          appState.updateWeightStruct((weight) {
            // Convert to double, not string
            final weightValue = profile['weight']['value'];
            weight.value = weightValue is num ? weightValue.toDouble() : 0.0;
            weight.unit = profile['weight']['unit'] ?? 'kg';
          });
        }

        if (profile['targetWeight'] != null) {
          appState.updateNewWeightStruct((weight) {
            // Convert to double, not string
            final weightValue = profile['targetWeight']['value'];
            weight.value = weightValue is num ? weightValue.toDouble() : 0.0;
            weight.unit = profile['targetWeight']['unit'] ?? 'kg';
          });
        }

        if (profile['onboardingAnswers'] != null) {
          final answers = profile['onboardingAnswers'] as Map<String, dynamic>;
          appState.updateOnboardingAnswersStruct((onboarding) {
            onboarding.goal = answers['goal'] ?? '';
            // AnswersStruct only has 'goal' and 'dateOfBirth' fields
            // Other fields don't exist in the struct
            if (answers['dateOfBirth'] != null) {
              onboarding.dateOfBirth = answers['dateOfBirth'];
            }
          });
        }
      }
    } catch (e) {
      throw Exception('Failed to load user profile: $e');
    }
  }

  /// Load user settings from Firestore to app state
  Future<void> loadUserSettings({
    required String userId,
  }) async {
    try {
      final settings = await _userService.getUserSettings(userId);

      if (settings != null) {
        final appState = FFAppState();

        appState.darkMode = settings['darkMode'] ?? 'Light';

        if (settings['notifications'] != null) {
          final notifications =
              settings['notifications'] as Map<String, dynamic>;
          appState.updateNotificationStruct((notif) {
            notif.mealtime = notifications['mealtime'] ?? false;
            notif.water = notifications['water'] ?? false;
            notif.checkYourProgress =
                notifications['checkYourProgress'] ?? false;
          });
        }

        if (settings['language'] != null) {
          final language = settings['language'] as Map<String, dynamic>;
          appState.updateSelectedLangStruct((lang) {
            lang.language = language['language'] ?? 'English';
            lang.langCode = language['langCode'] ?? 'en';
            lang.flag = language['flag'] ?? '';
          });
        }
      }
    } catch (e) {
      throw Exception('Failed to load user settings: $e');
    }
  }

  /// Full sync: Load all user data from Firestore to app state
  Future<void> fullSync({
    required String userId,
  }) async {
    try {
      await Future.wait([
        loadUserProfile(userId: userId),
        loadUserSettings(userId: userId),
      ]);
    } catch (e) {
      throw Exception('Failed to perform full sync: $e');
    }
  }
}
