import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing user notifications and notification preferences
class NotificationService extends FirestoreService {
  /// Update notification preferences
  Future<void> updateNotificationPreferences({
    required String userId,
    bool? mealtime,
    bool? breakfast,
    bool? lunch,
    bool? supper,
    bool? snack,
    bool? water,
    bool? checkYourProgress,
    String? dayOfTheWeek,
    Map<String, dynamic>? reminderTimes,
  }) async {
    try {
      final preferencesDoc = usersCollection
          .doc(userId)
          .collection('settings')
          .doc('notification_preferences');

      final data = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (mealtime != null) data['mealtime'] = mealtime;
      if (breakfast != null) data['breakfast'] = breakfast;
      if (lunch != null) data['lunch'] = lunch;
      if (supper != null) data['supper'] = supper;
      if (snack != null) data['snack'] = snack;
      if (water != null) data['water'] = water;
      if (checkYourProgress != null) {
        data['checkYourProgress'] = checkYourProgress;
      }
      if (dayOfTheWeek != null) data['dayOfTheWeek'] = dayOfTheWeek;
      if (reminderTimes != null) data['reminderTimes'] = reminderTimes;

      await preferencesDoc.set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get notification preferences
  Future<Map<String, dynamic>?> getNotificationPreferences({
    required String userId,
  }) async {
    try {
      final doc = await usersCollection
          .doc(userId)
          .collection('settings')
          .doc('notification_preferences')
          .get();

      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      if (data['updatedAt'] != null) {
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      }

      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Create a notification
  Future<String> createNotification({
    required String userId,
    required String title,
    required String message,
    String?
        type, // meal_reminder, water_reminder, progress_update, achievement, etc.
    Map<String, dynamic>? data,
    DateTime? scheduledFor,
  }) async {
    try {
      final notificationsCollection =
          usersCollection.doc(userId).collection('notifications');

      final notificationData = {
        'userId': userId,
        'title': title,
        'message': message,
        'type': type ?? 'general',
        'data': data,
        'read': false,
        'scheduledFor':
            scheduledFor != null ? dateTimeToTimestamp(scheduledFor) : null,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Remove null values
      notificationData.removeWhere((key, value) => value == null);

      final docRef = await notificationsCollection.add(notificationData);
      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get user notifications
  Future<List<Map<String, dynamic>>> getUserNotifications({
    required String userId,
    bool? readStatus, // null = all, true = read only, false = unread only
    int limit = 50,
  }) async {
    try {
      Query query = usersCollection
          .doc(userId)
          .collection('notifications')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (readStatus != null) {
        query = query.where('read', isEqualTo: readStatus);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        if (data['scheduledFor'] != null) {
          data['scheduledFor'] = timestampToDateTime(data['scheduledFor']);
        }
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Mark notification as read
  Future<void> markAsRead({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .update({
        'read': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead({
    required String userId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('notifications')
          .where('read', isEqualTo: false)
          .get();

      final batch = this.batch;
      for (var doc in snapshot.docs) {
        batch.update(doc.reference, {
          'read': true,
          'readAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete notification
  Future<void> deleteNotification({
    required String userId,
    required String notificationId,
  }) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount({
    required String userId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('notifications')
          .where('read', isEqualTo: false)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete all read notifications
  Future<void> deleteAllRead({
    required String userId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('notifications')
          .where('read', isEqualTo: true)
          .get();

      final batch = this.batch;
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}
