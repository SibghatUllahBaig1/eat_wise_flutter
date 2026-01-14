import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing weight tracking
/// Uses a simple structure similar to step tracker: one document per date
class WeightTrackerService extends FirestoreService {
  /// Add or update weight for a specific date
  Future<void> addOrUpdateWeight({
    required String userId,
    required DateTime date,
    required double weight,
    double? startWeight,
    double? goalWeight,
  }) async {
    try {
      final weightCollection =
          usersCollection.doc(userId).collection('weight_tracker');

      // Use date as document ID to ensure one entry per day
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // Calculate progress if we have start and goal weights
      double? progress;
      if (startWeight != null &&
          goalWeight != null &&
          startWeight != goalWeight) {
        final totalChange = goalWeight - startWeight;
        final currentChange = weight - startWeight;
        progress = totalChange != 0
            ? (currentChange / totalChange).clamp(0.0, 1.0)
            : 0.0;
      }

      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'weight': weight,
        'unit': 'kg',
        'progress': progress,
        'startWeight': startWeight,
        'goalWeight': goalWeight,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await weightCollection.doc(dateKey).set(data, SetOptions(merge: true));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get weight for a specific date
  Future<Map<String, dynamic>?> getWeightForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      final doc = await usersCollection
          .doc(userId)
          .collection('weight_tracker')
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

  /// Delete weight entry for a specific date
  Future<void> deleteWeightEntry({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      await usersCollection
          .doc(userId)
          .collection('weight_tracker')
          .doc(dateKey)
          .delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get the most recent weight entry before a specific date
  Future<Map<String, dynamic>?> getLastWeightBefore({
    required String userId,
    required DateTime beforeDate,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('weight_tracker')
          .where('date', isLessThan: dateTimeToTimestamp(beforeDate))
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      data['date'] = timestampToDateTime(data['date']);
      data['createdAt'] = timestampToDateTime(data['createdAt']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);

      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get weight history for a date range
  Future<List<Map<String, dynamic>>> getWeightHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('weight_tracker')
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

  /// Stream weight history (last N entries)
  Stream<List<Map<String, dynamic>>> streamWeightHistory({
    required String userId,
    int limit = 30,
  }) {
    return usersCollection
        .doc(userId)
        .collection('weight_tracker')
        .orderBy('date', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['date'] = timestampToDateTime(data['date']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    });
  }

  /// Get latest weight entry
  Future<Map<String, dynamic>?> getLatestWeight({
    required String userId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('weight_tracker')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      data['date'] = timestampToDateTime(data['date']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);

      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get starting weight (first entry)
  Future<Map<String, dynamic>?> getStartingWeight({
    required String userId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('weight_tracker')
          .orderBy('date', descending: false)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      data['date'] = timestampToDateTime(data['date']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);

      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Calculate weight change between two entries
  double calculateWeightChange(double currentWeight, double previousWeight) {
    return currentWeight - previousWeight;
  }
}
