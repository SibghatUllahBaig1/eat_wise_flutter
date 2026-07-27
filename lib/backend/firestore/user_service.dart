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
      final settingsDoc =
          usersCollection.doc(userId).collection('settings').doc('preferences');

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
      final doc = await usersCollection
          .doc(userId)
          .collection('settings')
          .doc('preferences')
          .get();
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

  /// Resolve a display name from root user doc and/or profile subdoc.
  static String resolveDisplayName(
    Map<String, dynamic>? root,
    Map<String, dynamic>? profile,
  ) {
    final fromRoot = root?['displayName']?.toString().trim();
    if (fromRoot != null && fromRoot.isNotEmpty) return fromRoot;

    final fromProfile = profile?['fullName']?.toString().trim();
    if (fromProfile != null && fromProfile.isNotEmpty) return fromProfile;

    return '';
  }

  /// Resolve an email from root user doc and/or profile subdoc.
  static String resolveEmail(
    Map<String, dynamic>? root,
    Map<String, dynamic>? profile,
  ) {
    final fromRoot = root?['email']?.toString().trim();
    if (fromRoot != null && fromRoot.isNotEmpty) return fromRoot;

    final fromProfile = profile?['email']?.toString().trim();
    if (fromProfile != null && fromProfile.isNotEmpty) return fromProfile;

    return '';
  }

  /// Copy identity fields from profile/data onto the root user document so
  /// admin queries and list views can read name/email without a subcollection join.
  Future<void> syncRootIdentityFromProfile({
    required String userId,
    required UserProfileStruct profile,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (profile.hasFullName() && profile.fullName.trim().isNotEmpty) {
        updates['displayName'] = profile.fullName.trim();
      }
      if (profile.hasEmail() && profile.email.trim().isNotEmpty) {
        updates['email'] = profile.email.trim();
      }
      if (updates.isEmpty) return;

      await usersCollection.doc(userId).set(updates, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Save user profile data (new structure with calorie calculations)
  Future<void> saveUserProfileData({
    required String userId,
    required UserProfileStruct profile,
  }) async {
    try {
      final profileDoc =
          usersCollection.doc(userId).collection('profile').doc('data');

      await profileDoc.set(profile.toMap(), SetOptions(merge: true));
      await syncRootIdentityFromProfile(userId: userId, profile: profile);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get user profile data (new structure)
  Future<UserProfileStruct?> getUserProfileData(String userId) async {
    try {
      final doc = await usersCollection
          .doc(userId)
          .collection('profile')
          .doc('data')
          .get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return UserProfileStruct.fromMap(data);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream user profile data (new structure)
  Stream<UserProfileStruct?> streamUserProfileData(String userId) {
    return usersCollection
        .doc(userId)
        .collection('profile')
        .doc('data')
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>;
      return UserProfileStruct.fromMap(data);
    });
  }

  /// Delete user account and all data
  /// This will permanently delete:
  /// - All meals
  /// - All activities
  /// - All tracker data (water, steps, weight)
  /// - User profile
  /// - All uploaded images from Storage
  /// - Firebase Auth account
  Future<void> deleteUserAccount(String userId) async {
    try {
      // Delete all subcollections
      await _deleteCollection(usersCollection.doc(userId).collection('meals'));
      await _deleteCollection(
          usersCollection.doc(userId).collection('activities'));
      await _deleteCollection(
          usersCollection.doc(userId).collection('profile'));
      await _deleteCollection(
          usersCollection.doc(userId).collection('water_tracker'));
      await _deleteCollection(
          usersCollection.doc(userId).collection('step_tracker'));
      await _deleteCollection(
          usersCollection.doc(userId).collection('weight_tracker'));

      // Delete user document
      await usersCollection.doc(userId).delete();

      // Note: Firebase Storage files and Auth account deletion
      // should be handled by the caller (widget) since they require
      // different Firebase instances and may need re-authentication
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Helper method to delete a collection
  Future<void> _deleteCollection(CollectionReference collection) async {
    final batchSize = 500;
    var deleted = 0;

    do {
      deleted = 0;
      final snapshot = await collection.limit(batchSize).get();

      if (snapshot.docs.isEmpty) break;

      final batch = this.batch;
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
        deleted++;
      }

      await batch.commit();
    } while (deleted >= batchSize);
  }
}
