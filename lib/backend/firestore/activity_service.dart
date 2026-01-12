import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing physical activity/exercise tracking
class ActivityService extends FirestoreService {
  /// Add an activity entry
  Future<String> addActivity({
    required String userId,
    required DateTime date,
    required String
        activityType, // running, cycling, swimming, walking, gym, etc.
    required String activityName,
    int? duration, // in minutes
    int? caloriesBurned,
    double? distance, // in km or miles
    String? distanceUnit,
    String? intensity, // low, moderate, high
    String? notes,
    String? iconName,
    bool isFavorite = false,
  }) async {
    try {
      final activitiesCollection =
          usersCollection.doc(userId).collection('activities');

      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'activityType': activityType,
        'activityName': activityName,
        'duration': duration,
        'caloriesBurned': caloriesBurned,
        'distance': distance,
        'distanceUnit': distanceUnit,
        'intensity': intensity,
        'notes': notes,
        'iconName': iconName,
        'isFavorite': isFavorite,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Remove null values
      data.removeWhere((key, value) => value == null);

      final docRef = await activitiesCollection.add(data);
      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update an activity entry
  Future<void> updateActivity({
    required String userId,
    required String activityId,
    String? activityType,
    String? activityName,
    int? duration,
    int? caloriesBurned,
    double? distance,
    String? distanceUnit,
    String? intensity,
    String? notes,
    String? iconName,
  }) async {
    try {
      final activityDoc =
          usersCollection.doc(userId).collection('activities').doc(activityId);

      final data = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (activityType != null) data['activityType'] = activityType;
      if (activityName != null) data['activityName'] = activityName;
      if (duration != null) data['duration'] = duration;
      if (caloriesBurned != null) data['caloriesBurned'] = caloriesBurned;
      if (distance != null) data['distance'] = distance;
      if (distanceUnit != null) data['distanceUnit'] = distanceUnit;
      if (intensity != null) data['intensity'] = intensity;
      if (notes != null) data['notes'] = notes;
      if (iconName != null) data['iconName'] = iconName;

      await activityDoc.update(data);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete an activity entry
  Future<void> deleteActivity({
    required String userId,
    required String activityId,
  }) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('activities')
          .doc(activityId)
          .delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get activities for a specific date
  Future<List<Map<String, dynamic>>> getActivitiesByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final range = getDayRange(date);

      final snapshot = await usersCollection
          .doc(userId)
          .collection('activities')
          .where('date',
              isGreaterThanOrEqualTo: dateTimeToTimestamp(range['start']))
          .where('date', isLessThanOrEqualTo: dateTimeToTimestamp(range['end']))
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['date'] = timestampToDateTime(data['date']);
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get activities within a date range
  Future<List<Map<String, dynamic>>> getActivitiesByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('activities')
          .where('date', isGreaterThanOrEqualTo: dateTimeToTimestamp(startDate))
          .where('date', isLessThanOrEqualTo: dateTimeToTimestamp(endDate))
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['date'] = timestampToDateTime(data['date']);
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get daily activity summary (total calories burned, total duration)
  Future<Map<String, dynamic>> getDailyActivitySummary({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final activities = await getActivitiesByDate(userId: userId, date: date);

      int totalCalories = 0;
      int totalDuration = 0;
      double totalDistance = 0.0;

      for (var activity in activities) {
        totalCalories += (activity['caloriesBurned'] as int?) ?? 0;
        totalDuration += (activity['duration'] as int?) ?? 0;
        totalDistance += (activity['distance'] as double?) ?? 0.0;
      }

      return {
        'totalCalories': totalCalories,
        'totalDuration': totalDuration,
        'totalDistance': totalDistance,
        'activityCount': activities.length,
        'activities': activities,
        'date': date,
      };
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Add activity to favorites
  Future<void> addToFavorites({
    required String userId,
    required String activityType,
    required String activityName,
    String? iconName,
  }) async {
    try {
      final favoritesCollection =
          usersCollection.doc(userId).collection('favorite_activities');

      final data = {
        'userId': userId,
        'activityType': activityType,
        'activityName': activityName,
        'iconName': iconName,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await favoritesCollection.add(data);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get favorite activities
  Future<List<Map<String, dynamic>>> getFavoriteActivities({
    required String userId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('favorite_activities')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Toggle favorite status for an activity
  Future<void> toggleFavorite({
    required String userId,
    required String activityId,
    required bool isFavorite,
  }) async {
    try {
      final activityDoc =
          usersCollection.doc(userId).collection('activities').doc(activityId);

      await activityDoc.update({
        'isFavorite': isFavorite,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get a single activity by ID
  Future<Map<String, dynamic>?> getActivity({
    required String userId,
    required String activityId,
  }) async {
    try {
      final doc = await usersCollection
          .doc(userId)
          .collection('activities')
          .doc(activityId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;
      data['id'] = doc.id;
      if (data['date'] != null) {
        data['date'] = timestampToDateTime(data['date']);
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
}
