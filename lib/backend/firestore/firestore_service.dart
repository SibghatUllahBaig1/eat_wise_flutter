import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Base Firestore service class with common operations
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get Firestore instance
  FirebaseFirestore get firestore => _firestore;

  /// Get user document reference
  DocumentReference? get currentUserDoc {
    final uid = currentUserId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid);
  }

  /// Get user collection reference
  CollectionReference get usersCollection => _firestore.collection('users');

  /// Batch write helper
  WriteBatch get batch => _firestore.batch();

  /// Transaction helper
  Future<T> runTransaction<T>(
    TransactionHandler<T> transactionHandler, {
    Duration timeout = const Duration(seconds: 30),
  }) {
    return _firestore.runTransaction(transactionHandler, timeout: timeout);
  }

  /// Convert Firestore timestamp to DateTime
  DateTime? timestampToDateTime(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is DateTime) {
      return timestamp;
    }
    return null;
  }

  /// Convert DateTime to Firestore timestamp
  Timestamp? dateTimeToTimestamp(DateTime? dateTime) {
    if (dateTime == null) return null;
    return Timestamp.fromDate(dateTime);
  }

  /// Get date range for queries (start of day to end of day)
  Map<String, DateTime> getDayRange(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return {
      'start': startOfDay,
      'end': endOfDay,
    };
  }

  /// Get date range for week
  Map<String, DateTime> getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return {
      'start': DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      'end': endOfWeek,
    };
  }

  /// Get date range for month
  Map<String, DateTime> getMonthRange(DateTime date) {
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
    return {
      'start': startOfMonth,
      'end': endOfMonth,
    };
  }

  /// Handle Firestore errors
  String handleFirestoreError(dynamic error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'You do not have permission to perform this action.';
        case 'not-found':
          return 'The requested data was not found.';
        case 'already-exists':
          return 'This data already exists.';
        case 'unavailable':
          return 'The service is currently unavailable. Please try again later.';
        case 'unauthenticated':
          return 'You must be logged in to perform this action.';
        default:
          return 'An error occurred: ${error.message}';
      }
    }
    return 'An unexpected error occurred.';
  }

  /// Dispose resources
  void dispose() {
    // Clean up if needed
  }
}

