import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing user feedback
class FeedbackService extends FirestoreService {
  /// Submit user feedback
  Future<String> submitFeedback({
    required String userId,
    required double rating, // 1-5 stars
    String? comment,
    String? category, // bug_report, feature_request, general, etc.
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final feedbackCollection = firestore.collection('feedback');
      
      final data = {
        'userId': userId,
        'rating': rating,
        'comment': comment,
        'category': category ?? 'general',
        'metadata': metadata,
        'status': 'pending', // pending, reviewed, resolved
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Remove null values
      data.removeWhere((key, value) => value == null);

      final docRef = await feedbackCollection.add(data);
      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get user's feedback history
  Future<List<Map<String, dynamic>>> getUserFeedback({
    required String userId,
    int limit = 50,
  }) async {
    try {
      final snapshot = await firestore
          .collection('feedback')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update feedback status (admin function)
  Future<void> updateFeedbackStatus({
    required String feedbackId,
    required String status, // pending, reviewed, resolved
    String? adminResponse,
  }) async {
    try {
      final feedbackDoc = firestore.collection('feedback').doc(feedbackId);
      
      final data = <String, dynamic>{
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (adminResponse != null) {
        data['adminResponse'] = adminResponse;
        data['respondedAt'] = FieldValue.serverTimestamp();
      }

      await feedbackDoc.update(data);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get average rating for the app
  Future<Map<String, dynamic>> getAverageRating() async {
    try {
      final snapshot = await firestore
          .collection('feedback')
          .where('rating', isGreaterThan: 0)
          .get();

      if (snapshot.docs.isEmpty) {
        return {
          'averageRating': 0.0,
          'totalRatings': 0,
          'ratingDistribution': {
            '5': 0,
            '4': 0,
            '3': 0,
            '2': 0,
            '1': 0,
          },
        };
      }

      double totalRating = 0;
      Map<String, int> distribution = {
        '5': 0,
        '4': 0,
        '3': 0,
        '2': 0,
        '1': 0,
      };

      for (var doc in snapshot.docs) {
        final rating = (doc.data()['rating'] as num).toDouble();
        totalRating += rating;
        
        final ratingKey = rating.round().toString();
        if (distribution.containsKey(ratingKey)) {
          distribution[ratingKey] = distribution[ratingKey]! + 1;
        }
      }

      return {
        'averageRating': totalRating / snapshot.docs.length,
        'totalRatings': snapshot.docs.length,
        'ratingDistribution': distribution,
      };
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete feedback
  Future<void> deleteFeedback({
    required String feedbackId,
  }) async {
    try {
      await firestore.collection('feedback').doc(feedbackId).delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}

