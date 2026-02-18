import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/user_profile_struct.dart';

/// Service for checking and managing onboarding status
class OnboardingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if user has completed onboarding
  /// Returns true if onboarding is completed, false otherwise
  Future<bool> hasCompletedOnboarding(String userId) async {
    try {
      // Check if user profile exists in the new structure
      final profileDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('data')
          .get();

      if (!profileDoc.exists) {
        return false;
      }

      final data = profileDoc.data();
      if (data == null) {
        return false;
      }

      // Check if onboardingCompleted flag is set
      final onboardingCompleted = data['onboardingCompleted'] as bool?;
      if (onboardingCompleted == true) {
        return true;
      }

      // Also check if all required fields are filled
      // This is a fallback in case the flag wasn't set
      final hasAllRequiredFields = data['fullName'] != null &&
          data['email'] != null &&
          data['age'] != null &&
          data['gender'] != null &&
          data['heightCm'] != null &&
          data['weightKg'] != null &&
          data['goal'] != null &&
          data['activityLevel'] != null &&
          data['dailyCalorieGoal'] != null;

      return hasAllRequiredFields;
    } catch (e) {
      print('Error checking onboarding status: $e');
      return false;
    }
  }

  /// Get user profile data
  Future<UserProfileStruct?> getUserProfile(String userId) async {
    try {
      final profileDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('data')
          .get();

      if (!profileDoc.exists) {
        return null;
      }

      final data = profileDoc.data();
      if (data == null) {
        return null;
      }

      return UserProfileStruct.fromMap(data);
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  /// Mark onboarding as completed
  Future<void> markOnboardingCompleted(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('profile')
          .doc('data')
          .set({
        'onboardingCompleted': true,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error marking onboarding as completed: $e');
    }
  }
}

