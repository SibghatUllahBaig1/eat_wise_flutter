import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing support messages and tickets
class SupportService extends FirestoreService {
  /// Create a new support ticket
  Future<String> createSupportTicket({
    required String userId,
    required String subject,
    required String message,
    String? category, // technical, billing, general, feature_request
    String? priority, // low, medium, high
    List<String>? attachmentUrls,
  }) async {
    try {
      final ticketsCollection =
          usersCollection.doc(userId).collection('support_tickets');

      final data = {
        'userId': userId,
        'subject': subject,
        'message': message,
        'category': category ?? 'general',
        'priority': priority ?? 'medium',
        'status': 'open', // open, in_progress, resolved, closed
        'attachmentUrls': attachmentUrls ?? [],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await ticketsCollection.add(data);

      // Add initial message to ticket messages subcollection
      await ticketsCollection.doc(docRef.id).collection('messages').add({
        'userId': userId,
        'message': message,
        'isUserMessage': true,
        'attachmentUrls': attachmentUrls ?? [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Add a message to an existing support ticket
  Future<String> addMessageToTicket({
    required String userId,
    required String ticketId,
    required String message,
    required bool isUserMessage,
    List<String>? attachmentUrls,
  }) async {
    try {
      final messagesCollection = usersCollection
          .doc(userId)
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages');

      final data = {
        'userId': userId,
        'message': message,
        'isUserMessage': isUserMessage,
        'attachmentUrls': attachmentUrls ?? [],
        'seen': false,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await messagesCollection.add(data);

      // Update ticket's last updated time
      await usersCollection
          .doc(userId)
          .collection('support_tickets')
          .doc(ticketId)
          .update({
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessageAt': FieldValue.serverTimestamp(),
      });

      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get all support tickets for a user
  Future<List<Map<String, dynamic>>> getUserTickets({
    required String userId,
    String? status, // filter by status
    int limit = 50,
  }) async {
    try {
      Query query = usersCollection
          .doc(userId)
          .collection('support_tickets')
          .orderBy('updatedAt', descending: true)
          .limit(limit);

      if (status != null) {
        query = query.where('status', isEqualTo: status);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        data['updatedAt'] = timestampToDateTime(data['updatedAt']);
        if (data['lastMessageAt'] != null) {
          data['lastMessageAt'] = timestampToDateTime(data['lastMessageAt']);
        }
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get messages for a specific ticket
  Future<List<Map<String, dynamic>>> getTicketMessages({
    required String userId,
    required String ticketId,
    int limit = 100,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages')
          .orderBy('createdAt', descending: false)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['createdAt'] = timestampToDateTime(data['createdAt']);
        return data;
      }).toList();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update ticket status
  Future<void> updateTicketStatus({
    required String userId,
    required String ticketId,
    required String status,
  }) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('support_tickets')
          .doc(ticketId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Mark messages as seen
  Future<void> markMessagesAsSeen({
    required String userId,
    required String ticketId,
    required List<String> messageIds,
  }) async {
    try {
      final batch = this.batch;

      for (var messageId in messageIds) {
        final messageRef = usersCollection
            .doc(userId)
            .collection('support_tickets')
            .doc(ticketId)
            .collection('messages')
            .doc(messageId);

        batch.update(messageRef, {'seen': true});
      }

      await batch.commit();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get unread message count for a ticket
  Future<int> getUnreadMessageCount({
    required String userId,
    required String ticketId,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages')
          .where('seen', isEqualTo: false)
          .where('isUserMessage', isEqualTo: false) // Only count admin messages
          .get();

      return snapshot.docs.length;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete a support ticket
  Future<void> deleteTicket({
    required String userId,
    required String ticketId,
  }) async {
    try {
      // Delete all messages first
      final messagesSnapshot = await usersCollection
          .doc(userId)
          .collection('support_tickets')
          .doc(ticketId)
          .collection('messages')
          .get();

      final batch = this.batch;
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the ticket
      batch.delete(
        usersCollection.doc(userId).collection('support_tickets').doc(ticketId),
      );

      await batch.commit();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}
