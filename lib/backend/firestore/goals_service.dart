import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing user goals
class GoalsService extends FirestoreService {
  /// Create a new goal
  Future<String> createGoal({
    required String userId,
    required String goalType, // weight_loss, muscle_gain, maintain_weight, eat_healthier, boost_energy, improve_wellness
    required String title,
    String? description,
    Map<String, dynamic>? targetValues,
    DateTime? targetDate,
    bool isActive = true,
  }) async {
    try {
      final goalsCollection = usersCollection.doc(userId).collection('goals');
      
      final data = {
        'userId': userId,
        'goalType': goalType,
        'title': title,
        'description': description,
        'targetValues': targetValues,
        'targetDate': dateTimeToTimestamp(targetDate),
        'isActive': isActive,
        'progress': 0.0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await goalsCollection.add(data);
      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update goal
  Future<void> updateGoal({
    required String userId,
    required String goalId,
    String? title,
    String? description,
    Map<String, dynamic>? targetValues,
    DateTime? targetDate,
    bool? isActive,
    double? progress,
  }) async {
    try {
      final goalDoc = usersCollection.doc(userId).collection('goals').doc(goalId);
      
      final data = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title != null) data['title'] = title;
      if (description != null) data['description'] = description;
      if (targetValues != null) data['targetValues'] = targetValues;
      if (targetDate != null) data['targetDate'] = dateTimeToTimestamp(targetDate);
      if (isActive != null) data['isActive'] = isActive;
      if (progress != null) data['progress'] = progress;

      await goalDoc.update(data);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete goal
  Future<void> deleteGoal({
    required String userId,
    required String goalId,
  }) async {
    try {
      await usersCollection.doc(userId).collection('goals').doc(goalId).delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get all goals for a user
  Future<List<Map<String, dynamic>>> getUserGoals({
    required String userId,
    bool? activeOnly,
  }) async {
    try {
      Query query = usersCollection.doc(userId).collection('goals');
      
      if (activeOnly == true) {
        query = query.where('isActive', isEqualTo: true);
      }
      
      final snapshot = await query.orderBy('createdAt', descending: true).get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['targetDate'] = timestampToDateTime(data['targetDate']);
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream user goals
  Stream<List<Map<String, dynamic>>> streamUserGoals({
    required String userId,
    bool? activeOnly,
  }) {
    Query query = usersCollection.doc(userId).collection('goals');
    
    if (activeOnly == true) {
      query = query.where('isActive', isEqualTo: true);
    }
    
    return query.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['targetDate'] = timestampToDateTime(data['targetDate']);
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    });
  }

  /// Get active goal
  Future<Map<String, dynamic>?> getActiveGoal({
    required String userId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('goals')
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      
      final doc = snapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      data['targetDate'] = timestampToDateTime(data['targetDate']);
      data['createdAt'] = timestampToDateTime(data['createdAt']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);
      
      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Calculate goal progress based on current metrics
  Future<double> calculateGoalProgress({
    required String userId,
    required String goalId,
    required Map<String, dynamic> currentValues,
    required Map<String, dynamic> targetValues,
  }) async {
    try {
      // Simple progress calculation (can be customized based on goal type)
      double progress = 0.0;
      
      if (targetValues.containsKey('weight') && currentValues.containsKey('weight')) {
        final targetWeight = targetValues['weight'] as double;
        final currentWeight = currentValues['weight'] as double;
        final startWeight = currentValues['startWeight'] as double? ?? currentWeight;
        
        if (startWeight != targetWeight) {
          progress = ((startWeight - currentWeight) / (startWeight - targetWeight)).clamp(0.0, 1.0);
        }
      }
      
      // Update goal progress
      await updateGoal(userId: userId, goalId: goalId, progress: progress);
      
      return progress;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}

