import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing water intake tracking
class WaterTrackerService extends FirestoreService {
  /// Add a drink entry to water tracker
  Future<String> addDrinkEntry({
    required String userId,
    required DateTime date,
    required int amount, // in ml
    required String drinkType, // Coffee, Tea, Juice, Water, etc.
    required String drinkIcon, // Image asset path
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final drinksCollection = usersCollection
          .doc(userId)
          .collection('water_tracker')
          .doc(dateKey)
          .collection('drinks');

      final data = {
        'userId': userId,
        'amount': amount,
        'drinkType': drinkType,
        'drinkIcon': drinkIcon,
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await drinksCollection.add(data);

      // Update daily total
      await _updateDailyTotal(userId, date);

      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update daily total water intake
  Future<void> _updateDailyTotal(String userId, DateTime date) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayDoc =
          usersCollection.doc(userId).collection('water_tracker').doc(dateKey);
      final drinksSnapshot = await dayDoc.collection('drinks').get();

      int totalIntake = 0;
      for (var doc in drinksSnapshot.docs) {
        totalIntake += (doc.data()['amount'] as int?) ?? 0;
      }

      // Get user's water goal from settings
      final userDoc = await usersCollection.doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      final goal = (userData?['waterGoal'] as int?) ?? 2000;

      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'totalIntake': totalIntake,
        'goal': goal,
        'progress': goal > 0 ? (totalIntake / goal) : 0.0,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await dayDoc.set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get drinks for a specific date
  Future<List<Map<String, dynamic>>> getDrinksForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final snapshot = await usersCollection
          .doc(userId)
          .collection('water_tracker')
          .doc(dateKey)
          .collection('drinks')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        if (data['timestamp'] != null) {
          data['timestamp'] = timestampToDateTime(data['timestamp']);
        }
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream drinks for a specific date
  Stream<List<Map<String, dynamic>>> streamDrinksForDate({
    required String userId,
    required DateTime date,
  }) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return usersCollection
        .doc(userId)
        .collection('water_tracker')
        .doc(dateKey)
        .collection('drinks')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        if (data['timestamp'] != null) {
          data['timestamp'] = timestampToDateTime(data['timestamp']);
        }
        return data;
      }).toList();
    });
  }

  /// Delete a drink entry
  Future<void> deleteDrinkEntry({
    required String userId,
    required DateTime date,
    required String drinkId,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      await usersCollection
          .doc(userId)
          .collection('water_tracker')
          .doc(dateKey)
          .collection('drinks')
          .doc(drinkId)
          .delete();

      // Update daily total
      await _updateDailyTotal(userId, date);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update a drink entry
  Future<void> updateDrinkEntry({
    required String userId,
    required DateTime date,
    required String drinkId,
    required int amount,
    String? drinkType,
    String? drinkIcon,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final updateData = <String, dynamic>{
        'amount': amount,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (drinkType != null) {
        updateData['drinkType'] = drinkType;
      }
      if (drinkIcon != null) {
        updateData['drinkIcon'] = drinkIcon;
      }

      await usersCollection
          .doc(userId)
          .collection('water_tracker')
          .doc(dateKey)
          .collection('drinks')
          .doc(drinkId)
          .update(updateData);

      // Update daily total
      await _updateDailyTotal(userId, date);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get water intake summary for a specific date
  Future<Map<String, dynamic>?> getWaterIntake({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final doc = await usersCollection
          .doc(userId)
          .collection('water_tracker')
          .doc(dateKey)
          .get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      if (data['date'] != null) {
        data['date'] = timestampToDateTime(data['date']);
      }
      if (data['updatedAt'] != null) {
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      }

      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream water intake summary for a specific date
  Stream<Map<String, dynamic>?> streamWaterIntake({
    required String userId,
    required DateTime date,
  }) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return usersCollection
        .doc(userId)
        .collection('water_tracker')
        .doc(dateKey)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      if (data['date'] != null) {
        data['date'] = timestampToDateTime(data['date']);
      }
      if (data['updatedAt'] != null) {
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      }

      return data;
    });
  }

  /// Get water intake history for a date range
  Future<List<Map<String, dynamic>>> getWaterIntakeHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('water_tracker')
          .where('date', isGreaterThanOrEqualTo: dateTimeToTimestamp(startDate))
          .where('date', isLessThanOrEqualTo: dateTimeToTimestamp(endDate))
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['date'] = timestampToDateTime(data['date']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update water goal and recalculate progress for selected date
  Future<void> updateWaterGoal({
    required String userId,
    required int goal,
    DateTime? date,
  }) async {
    try {
      // Update user settings
      await usersCollection.doc(userId).set({
        'waterGoal': goal,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Recalculate progress for the given date (or today if not specified)
      final targetDate = date ?? DateTime.now();
      final dateKey =
          '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

      final dayDoc =
          usersCollection.doc(userId).collection('water_tracker').doc(dateKey);
      final docSnapshot = await dayDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final totalIntake = (data?['totalIntake'] as int?) ?? 0;
        final newProgress = goal > 0 ? (totalIntake / goal) : 0.0;

        await dayDoc.update({
          'goal': goal,
          'progress': newProgress,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}
