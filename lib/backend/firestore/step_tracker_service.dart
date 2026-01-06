import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing step tracking
class StepTrackerService extends FirestoreService {
  /// Add or update step count for a specific date
  Future<void> addStepCount({
    required String userId,
    required DateTime date,
    required int steps,
    required int goal,
  }) async {
    try {
      final stepCollection = usersCollection.doc(userId).collection('step_tracker');
      
      // Use date as document ID to ensure one entry per day
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'steps': steps,
        'goal': goal,
        'progress': goal > 0 ? (steps / goal) : 0.0,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await stepCollection.doc(dateKey).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Increment step count for today
  Future<void> incrementStepCount({
    required String userId,
    required int steps,
    int? goal,
  }) async {
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final stepDoc = usersCollection.doc(userId).collection('step_tracker').doc(dateKey);
      
      // Get current data
      final doc = await stepDoc.get();
      
      if (doc.exists) {
        final currentSteps = (doc.data()?['steps'] as int?) ?? 0;
        final currentGoal = (doc.data()?['goal'] as int?) ?? (goal ?? 10000);
        final newSteps = currentSteps + steps;
        
        await stepDoc.update({
          'steps': newSteps,
          'progress': currentGoal > 0 ? (newSteps / currentGoal) : 0.0,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new entry
        await addStepCount(
          userId: userId,
          date: today,
          steps: steps,
          goal: goal ?? 10000,
        );
      }
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get step count for a specific date
  Future<Map<String, dynamic>?> getStepCount({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final doc = await usersCollection
          .doc(userId)
          .collection('step_tracker')
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

  /// Stream step count for a specific date
  Stream<Map<String, dynamic>?> streamStepCount({
    required String userId,
    required DateTime date,
  }) {
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    
    return usersCollection
        .doc(userId)
        .collection('step_tracker')
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

  /// Get step count history for a date range
  Future<List<Map<String, dynamic>>> getStepHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('step_tracker')
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

  /// Update step goal
  Future<void> updateStepGoal({
    required String userId,
    required int goal,
  }) async {
    try {
      // Update user settings
      await usersCollection.doc(userId).set({
        'stepGoal': goal,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}

