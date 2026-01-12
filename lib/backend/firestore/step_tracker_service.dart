import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing step tracking
class StepTrackerService extends FirestoreService {
  /// Add a step entry to step tracker
  Future<String> addStepEntry({
    required String userId,
    required DateTime date,
    required int steps,
    required int duration, // in minutes
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final stepsCollection = usersCollection
          .doc(userId)
          .collection('step_tracker')
          .doc(dateKey)
          .collection('steps');

      // Calculate calories and distance
      final calories = _calculateCalories(steps);
      final distance = _calculateDistance(steps);

      final data = {
        'userId': userId,
        'steps': steps,
        'duration': duration,
        'calories': calories,
        'distance': distance,
        'timestamp': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await stepsCollection.add(data);

      // Update daily total
      await _updateDailyTotal(userId, date);

      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Calculate calories burned from steps
  /// Formula: steps × 0.04 (approximate)
  int _calculateCalories(int steps) {
    return (steps * 0.04).round();
  }

  /// Calculate distance from steps in kilometers
  /// Formula: steps × 0.0008 (approximate, assuming average stride)
  double _calculateDistance(int steps) {
    return double.parse((steps * 0.0008).toStringAsFixed(1));
  }

  /// Update daily total step count
  Future<void> _updateDailyTotal(String userId, DateTime date) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final dayDoc =
          usersCollection.doc(userId).collection('step_tracker').doc(dateKey);
      final stepsSnapshot = await dayDoc.collection('steps').get();

      int totalSteps = 0;
      int totalDuration = 0;
      int totalCalories = 0;
      double totalDistance = 0.0;

      for (var doc in stepsSnapshot.docs) {
        totalSteps += (doc.data()['steps'] as int?) ?? 0;
        totalDuration += (doc.data()['duration'] as int?) ?? 0;
        totalCalories += (doc.data()['calories'] as int?) ?? 0;
        totalDistance += (doc.data()['distance'] as num?)?.toDouble() ?? 0.0;
      }

      // Get user's step goal from settings
      final userDoc = await usersCollection.doc(userId).get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      final goal = (userData?['stepGoal'] as int?) ?? 5000;

      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'totalSteps': totalSteps,
        'totalDuration': totalDuration,
        'totalCalories': totalCalories,
        'totalDistance': totalDistance,
        'goal': goal,
        'progress': goal > 0 ? (totalSteps / goal) : 0.0,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await dayDoc.set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get step entries for a specific date
  Future<List<Map<String, dynamic>>> getStepsForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final snapshot = await usersCollection
          .doc(userId)
          .collection('step_tracker')
          .doc(dateKey)
          .collection('steps')
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

  /// Stream step entries for a specific date
  Stream<List<Map<String, dynamic>>> streamStepsForDate({
    required String userId,
    required DateTime date,
  }) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return usersCollection
        .doc(userId)
        .collection('step_tracker')
        .doc(dateKey)
        .collection('steps')
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

  /// Delete a step entry
  Future<void> deleteStepEntry({
    required String userId,
    required DateTime date,
    required String stepId,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      await usersCollection
          .doc(userId)
          .collection('step_tracker')
          .doc(dateKey)
          .collection('steps')
          .doc(stepId)
          .delete();

      // Update daily total
      await _updateDailyTotal(userId, date);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update a step entry
  Future<void> updateStepEntry({
    required String userId,
    required DateTime date,
    required String stepId,
    required int steps,
    int? duration,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final updateData = <String, dynamic>{
        'steps': steps,
        'calories': _calculateCalories(steps),
        'distance': _calculateDistance(steps),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (duration != null) {
        updateData['duration'] = duration;
      }

      await usersCollection
          .doc(userId)
          .collection('step_tracker')
          .doc(dateKey)
          .collection('steps')
          .doc(stepId)
          .update(updateData);

      // Update daily total
      await _updateDailyTotal(userId, date);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get step summary for a specific date
  Future<Map<String, dynamic>?> getStepSummary({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final doc = await usersCollection
          .doc(userId)
          .collection('step_tracker')
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

  /// Stream step summary for a specific date
  Stream<Map<String, dynamic>?> streamStepSummary({
    required String userId,
    required DateTime date,
  }) {
    final dateKey =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    return usersCollection
        .doc(userId)
        .collection('step_tracker')
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

  /// Get step history for a date range
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

  /// Update step goal and recalculate progress for selected date
  Future<void> updateStepGoal({
    required String userId,
    required int goal,
    DateTime? date,
  }) async {
    try {
      // Update user settings
      await usersCollection.doc(userId).set({
        'stepGoal': goal,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Recalculate progress for the given date (or today if not specified)
      final targetDate = date ?? DateTime.now();
      final dateKey =
          '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}';

      final dayDoc =
          usersCollection.doc(userId).collection('step_tracker').doc(dateKey);
      final docSnapshot = await dayDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        final totalSteps = (data?['totalSteps'] as int?) ?? 0;
        final newProgress = goal > 0 ? (totalSteps / goal) : 0.0;

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

  /// Legacy method for backward compatibility
  /// Use addStepEntry instead for new implementations
  @Deprecated('Use addStepEntry instead')
  Future<void> incrementStepCount({
    required String userId,
    required int steps,
    int? goal,
  }) async {
    try {
      final today = DateTime.now();
      // Default duration: 10 minutes per 1000 steps
      final duration = (steps / 100).round();
      await addStepEntry(
        userId: userId,
        date: today,
        steps: steps,
        duration: duration,
      );
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Legacy method for backward compatibility
  /// Use getStepSummary instead
  @Deprecated('Use getStepSummary instead')
  Future<Map<String, dynamic>?> getStepCount({
    required String userId,
    required DateTime date,
  }) async {
    return getStepSummary(userId: userId, date: date);
  }

  /// Legacy method for backward compatibility
  /// Use streamStepSummary instead
  @Deprecated('Use streamStepSummary instead')
  Stream<Map<String, dynamic>?> streamStepCount({
    required String userId,
    required DateTime date,
  }) {
    return streamStepSummary(userId: userId, date: date);
  }
}
