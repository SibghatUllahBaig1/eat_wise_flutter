import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '/app_state.dart';
import 'user_service.dart';
import 'meal_service.dart';
import 'water_tracker_service.dart';
import 'weight_tracker_service.dart';
import 'step_tracker_service.dart';
import '/backend/services/profile_sync_helper.dart';
import '/backend/services/weight_sync_helper.dart';
import '/backend/services/water_sync_helper.dart';
import '/backend/schema/structs/index.dart';

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

  /// Load user profile data (new structure) into app state and trackers.
  Future<void> loadUserProfileData({
    required String userId,
  }) async {
    try {
      final profile = await _userService.getUserProfileData(userId);
      if (profile != null) {
        ProfileSyncHelper.hydrateFromProfile(profile);
        await _userService.syncRootIdentityFromProfile(
          userId: userId,
          profile: profile,
        );
      }
    } catch (e) {
      debugPrint('Failed to load user profile data: $e');
    }
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

  /// Load tracker data from Firestore to app state for a specific date
  Future<void> loadTrackerData({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final appState = FFAppState();

      // Normalize date to remove time component
      final normalizedDate = DateTime(date.year, date.month, date.day);

      debugPrint('Loading tracker data for date: $normalizedDate');

      // Load water data
      final waterData = await _waterService.getWaterIntake(
        userId: userId,
        date: normalizedDate,
      );
      debugPrint('Water data loaded: $waterData');

      // Load step data
      final stepData = await _stepService.getStepSummary(
        userId: userId,
        date: normalizedDate,
      );
      debugPrint('Step data loaded: $stepData');

      // Load weight data (latest weight and starting weight)
      final weightData = await _weightService.getLatestWeight(
        userId: userId,
      );
      final startingWeightData = await _weightService.getStartingWeight(
        userId: userId,
      );
      debugPrint('Weight data loaded: $weightData');
      debugPrint('Starting weight data loaded: $startingWeightData');

      // Update FFAppState with the loaded data
      appState.updateTrackerStruct((tracker) {
        // Update water data for the current date
        // Support both 'totalIntake' (new system) and 'intake' (old system)
        final waterIntake = waterData?['totalIntake'] as int? ??
            waterData?['intake'] as int? ??
            0;
        final waterProgress = WaterSyncHelper.calculateWaterProgress(
          waterIntake,
          appState.trackerSettings.water.goal,
        );

        debugPrint(
            'Adding water entry: intake=$waterIntake, progress=$waterProgress, date=$normalizedDate');
        debugPrint(
            'Current tracker.currentDate before update: ${tracker.currentDate}');

        // Remove existing water entry for this date
        tracker.water.removeWhere((w) {
          if (w.date == null) return false;
          return w.date!.year == normalizedDate.year &&
              w.date!.month == normalizedDate.month &&
              w.date!.day == normalizedDate.day;
        });

        // Add new water entry (even if no data exists, add 0)
        tracker.water.add(TrackerValueStruct(
          date: normalizedDate,
          value: waterIntake,
          progress: waterProgress,
        ));

        debugPrint('Water list now has ${tracker.water.length} entries');
        debugPrint(
            'Water entries: ${tracker.water.map((w) => 'date=${w.date}, value=${w.value}').join(', ')}');

        // Also update currentDate to match the loaded date
        tracker.currentDate = normalizedDate;
        debugPrint('Updated tracker.currentDate to: ${tracker.currentDate}');

        // Update step data for the current date
        // Support both 'totalSteps' (new system) and 'steps' (old system)
        final stepCount =
            stepData?['totalSteps'] as int? ?? stepData?['steps'] as int? ?? 0;
        final stepProgress = stepData?['progress'] as double? ?? 0.0;

        debugPrint(
            'Adding step entry: count=$stepCount, progress=$stepProgress, date=$normalizedDate');

        // Remove existing step entry for this date
        tracker.step.removeWhere((s) {
          if (s.date == null) return false;
          return s.date!.year == normalizedDate.year &&
              s.date!.month == normalizedDate.month &&
              s.date!.day == normalizedDate.day;
        });

        // Add new step entry (even if no data exists, add 0)
        tracker.step.add(TrackerValueStruct(
          date: normalizedDate,
          value: stepCount,
          progress: stepProgress,
        ));

        debugPrint('Step list now has ${tracker.step.length} entries');

        // Update weight data (latest weight and starting weight)
        // First, add starting weight if it exists
        if (startingWeightData != null) {
          final startWeight = startingWeightData['weight'] as num? ?? 0;
          final startWeightDate = startingWeightData['date'] as DateTime?;

          if (startWeightDate != null) {
            // Remove existing weight entry for this date
            tracker.weight.removeWhere((w) {
              if (w.date == null) return false;
              return w.date!.year == startWeightDate.year &&
                  w.date!.month == startWeightDate.month &&
                  w.date!.day == startWeightDate.day;
            });

            // Add starting weight entry
            tracker.weight.add(TrackerValueStruct(
              date: startWeightDate,
              value: startWeight.toInt(),
              unit: 'kg',
              progress: 0.0, // Starting weight has 0% progress
            ));
          }
        }

        // Then, add latest weight if it exists and is different from starting weight
        if (weightData != null) {
          final weight = weightData['weight'] as num? ?? 0;
          final weightDate = weightData['date'] as DateTime?;

          if (weightDate != null) {
            // Check if this is not the same as starting weight date
            final isDifferentFromStart = startingWeightData == null ||
                (startingWeightData['date'] as DateTime?)
                        ?.difference(weightDate)
                        .inDays
                        .abs() !=
                    0;

            if (isDifferentFromStart) {
              // Remove existing weight entry for this date
              tracker.weight.removeWhere((w) {
                if (w.date == null) return false;
                return w.date!.year == weightDate.year &&
                    w.date!.month == weightDate.month &&
                    w.date!.day == weightDate.day;
              });

              // Calculate progress based on starting weight and goal weight
              double progress = 0.0;
              final startWeight = startingWeightData?['weight'] as num?;
              final goalWeight = appState.trackerSettings.weight.goalWeight;

              if (startWeight != null &&
                  goalWeight > 0 &&
                  startWeight != goalWeight) {
                progress = ((weight.toDouble() - startWeight.toDouble()) /
                        (goalWeight.toDouble() - startWeight.toDouble()))
                    .clamp(0.0, 1.0);
              }

              // Add latest weight entry
              tracker.weight.add(TrackerValueStruct(
                date: weightDate,
                value: weight.toInt(),
                unit: 'kg',
                progress: progress,
              ));
            }
          }
        }
      });

      WeightSyncHelper.propagateCanonicalCurrentWeight();

      // Trigger UI update
      appState.update(() {});
    } catch (e) {
      throw Exception('Failed to load tracker data: $e');
    }
  }

  /// Full sync: Load all user data from Firestore to app state
  Future<void> fullSync({
    required String userId,
  }) async {
    try {
      await Future.wait([
        loadUserProfile(userId: userId),
        loadUserProfileData(userId: userId),
        loadUserSettings(userId: userId),
      ]);
    } catch (e) {
      throw Exception('Failed to perform full sync: $e');
    }
  }
}
