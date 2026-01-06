import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing weight tracking
class WeightTrackerService extends FirestoreService {
  /// Add weight entry
  Future<String> addWeightEntry({
    required String userId,
    required DateTime date,
    required double weight,
    required String unit, // kg or lbs
    String? notes,
  }) async {
    try {
      final weightCollection = usersCollection.doc(userId).collection('weight_tracker');
      
      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'weight': weight,
        'unit': unit,
        'notes': notes,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await weightCollection.add(data);
      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update weight entry
  Future<void> updateWeightEntry({
    required String userId,
    required String entryId,
    double? weight,
    String? unit,
    String? notes,
  }) async {
    try {
      final weightDoc = usersCollection.doc(userId).collection('weight_tracker').doc(entryId);
      
      final data = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (weight != null) data['weight'] = weight;
      if (unit != null) data['unit'] = unit;
      if (notes != null) data['notes'] = notes;

      await weightDoc.update(data);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete weight entry
  Future<void> deleteWeightEntry({
    required String userId,
    required String entryId,
  }) async {
    try {
      await usersCollection.doc(userId).collection('weight_tracker').doc(entryId).delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get weight entries for a date range
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
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream weight history
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
        data['createdAt'] = timestampToDateTime(data['createdAt']);
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
      data['createdAt'] = timestampToDateTime(data['createdAt']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      
      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Calculate weight progress
  Future<Map<String, dynamic>> getWeightProgress({
    required String userId,
    required double targetWeight,
    required String unit,
  }) async {
    try {
      final latest = await getLatestWeight(userId: userId);
      if (latest == null) {
        return {
          'currentWeight': 0.0,
          'targetWeight': targetWeight,
          'difference': 0.0,
          'progress': 0.0,
          'unit': unit,
        };
      }

      final currentWeight = latest['weight'] as double;
      final difference = currentWeight - targetWeight;
      final progress = difference.abs() / currentWeight;

      return {
        'currentWeight': currentWeight,
        'targetWeight': targetWeight,
        'difference': difference,
        'progress': progress,
        'unit': unit,
        'lastUpdated': latest['date'],
      };
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}

