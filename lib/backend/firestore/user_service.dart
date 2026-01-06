import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';
import '/backend/schema/structs/index.dart';

/// Service for managing user profile and settings
class UserService extends FirestoreService {
  /// Create or update user profile
  Future<void> createOrUpdateUserProfile({
    required String userId,
    String? displayName,
    String? email,
    String? photoUrl,
    String? gender,
    DateTime? dateOfBirth,
    String? height,
    Map<String, dynamic>? weight,
    Map<String, dynamic>? targetWeight,
    Map<String, dynamic>? onboardingAnswers,
  }) async {
    try {
      final userDoc = usersCollection.doc(userId);
      
      final data = {
        'userId': userId,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'gender': gender,
        'dateOfBirth': dateTimeToTimestamp(dateOfBirth),
        'height': height,
        'weight': weight,
        'targetWeight': targetWeight,
        'onboardingAnswers': onboardingAnswers,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Remove null values
      data.removeWhere((key, value) => value == null);

      await userDoc.set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get user profile
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).get();
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      
      // Convert timestamps
      if (data['dateOfBirth'] != null) {
        data['dateOfBirth'] = timestampToDateTime(data['dateOfBirth']);
      }
      if (data['createdAt'] != null) {
        data['createdAt'] = timestampToDateTime(data['createdAt']);
      }
      if (data['updatedAt'] != null) {
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      }
      
      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream user profile
  Stream<Map<String, dynamic>?> streamUserProfile(String userId) {
    return usersCollection.doc(userId).snapshots().map((doc) {
      if (!doc.exists) return null;
      
      final data = doc.data() as Map<String, dynamic>;
      
      // Convert timestamps
      if (data['dateOfBirth'] != null) {
        data['dateOfBirth'] = timestampToDateTime(data['dateOfBirth']);
      }
      if (data['createdAt'] != null) {
        data['createdAt'] = timestampToDateTime(data['createdAt']);
      }
      if (data['updatedAt'] != null) {
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      }
      
      return data;
    });
  }

  /// Update user settings
  Future<void> updateUserSettings({
    required String userId,
    Map<String, dynamic>? notifications,
    String? darkMode,
    Map<String, dynamic>? language,
    Map<String, dynamic>? accountSecurity,
  }) async {
    try {
      final settingsDoc = usersCollection.doc(userId).collection('settings').doc('preferences');
      
      final data = {
        'notifications': notifications,
        'darkMode': darkMode,
        'language': language,
        'accountSecurity': accountSecurity,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Remove null values
      data.removeWhere((key, value) => value == null);

      await settingsDoc.set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get user settings
  Future<Map<String, dynamic>?> getUserSettings(String userId) async {
    try {
      final doc = await usersCollection.doc(userId).collection('settings').doc('preferences').get();
      if (!doc.exists) return null;
      return doc.data();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream user settings
  Stream<Map<String, dynamic>?> streamUserSettings(String userId) {
    return usersCollection
        .doc(userId)
        .collection('settings')
        .doc('preferences')
        .snapshots()
        .map((doc) => doc.exists ? doc.data() : null);
  }

  /// Delete user account and all data
  Future<void> deleteUserAccount(String userId) async {
    try {
      final batch = this.batch;
      
      // Delete user document
      batch.delete(usersCollection.doc(userId));
      
      await batch.commit();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}

