import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing water intake tracking
class WaterTrackerService extends FirestoreService {
  /// Add or update water intake for a specific date
  Future<void> addWaterIntake({
    required String userId,
    required DateTime date,
    required int intake, // in ml
    required int goal, // in ml
    String? unit,
  }) async {
    try {
      final waterCollection = usersCollection.doc(userId).collection('water_tracker');
      
      // Use date as document ID to ensure one entry per day
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'intake': intake,
        'goal': goal,
        'unit': unit ?? 'ml',
        'progress': goal > 0 ? (intake / goal) : 0.0,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await waterCollection.doc(dateKey).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Increment water intake for today
  Future<void> incrementWaterIntake({
    required String userId,
    required int amount, // in ml
    int? goal,
  }) async {
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final waterDoc = usersCollection.doc(userId).collection('water_tracker').doc(dateKey);
      
      // Get current data
      final doc = await waterDoc.get();
      
      if (doc.exists) {
        final currentIntake = (doc.data()?['intake'] as int?) ?? 0;
        final currentGoal = (doc.data()?['goal'] as int?) ?? (goal ?? 2000);
        final newIntake = currentIntake + amount;
        
        await waterDoc.update({
          'intake': newIntake,
          'progress': currentGoal > 0 ? (newIntake / currentGoal) : 0.0,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new entry
        await addWaterIntake(
          userId: userId,
          date: today,
          intake: amount,
          goal: goal ?? 2000,
        );
      }
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get water intake for a specific date
  Future<Map<String, dynamic>?> getWaterIntake({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final doc = await usersCollection
          .doc(userId)
          .collection('water_tracker')
          .doc(dateKey)
          .get();

      if (!doc.exists) return null;
      
      final data = doc.data()!;
      data['id'] = doc.id;
      data['date'] = timestampToDateTime(data['date']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      
      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream water intake for a specific date
  Stream<Map<String, dynamic>?> streamWaterIntake({
    required String userId,
    required DateTime date,
  }) {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    return usersCollection
        .doc(userId)
        .collection('water_tracker')
        .doc(dateKey)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      
      final data = doc.data()!;
      data['id'] = doc.id;
      data['date'] = timestampToDateTime(data['date']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      
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

  /// Update water goal
  Future<void> updateWaterGoal({
    required String userId,
    required int goal,
  }) async {
    try {
      // Update user settings
      await usersCollection.doc(userId).set({
        'waterGoal': goal,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}

