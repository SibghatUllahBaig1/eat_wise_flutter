---
name: Firebase & Firestore Patterns
globs: ["lib/backend/**/*.dart", "**/*service*.dart", "**/*controller*.dart"]
alwaysApply: false
description: Firebase and Firestore integration patterns for this EatWise app
---

# Firebase & Firestore Integration Patterns

## Document Structure

- User data path: `users/{userId}/`
- Tracker data: `users/{userId}/tracker/{date}/`
- Use subcollections for related data (e.g., steps, water, weight under tracker)
- Store dates as Firestore Timestamp objects
- Include metadata fields: `createdAt`, `updatedAt`

## Service Layer Pattern

```dart
class TrackerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> saveData(String userId, DateTime date, Map<String, dynamic> data) async {
    try {
      await _firestore
        .collection('users')
        .doc(userId)
        .collection('tracker')
        .doc(dateToString(date))
        .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving data: $e');
      rethrow;
    }
  }
}
```

## Query Patterns

- Always check authentication before queries: `if (currentUserUid.isEmpty) return;`
- Use `.where()` for filtering data
- Limit queries with `.limit()` to prevent excessive reads
- Order results with `.orderBy()` when needed
- Handle empty results gracefully with `.firstOrNull`

## Data Conversion

```dart
// To Firestore
final data = {
  'value': stepCount,
  'date': Timestamp.fromDate(date),
  'userId': currentUserUid,
  'updatedAt': FieldValue.serverTimestamp(),
};

// From Firestore
final stepCount = (doc.data()?['value'] as num?)?.toInt() ?? 0;
final date = (doc.data()?['date'] as Timestamp?)?.toDate() ?? DateTime.now();
```

## Error Handling

- Wrap all Firestore operations in try-catch blocks
- Use `debugPrint()` for logging errors
- Show user-friendly error messages via SnackBar
- Provide fallback values for failed queries
- Handle network errors gracefully

## Real-time Updates

- Use `.snapshots()` for real-time data when needed
- Dispose of stream subscriptions properly
- Update local state when Firestore data changes
- Handle connection state changes

## Batch Operations

```dart
final batch = _firestore.batch();
batch.set(docRef1, data1);
batch.update(docRef2, data2);
batch.delete(docRef3);
await batch.commit();
```

## Security Considerations

- Never expose sensitive data in client code
- Validate data before writing to Firestore
- Use Firestore Security Rules for access control
- Store API keys securely (not in code)
- Sanitize user input before storing

## Performance Optimization

- Use `.get()` for one-time reads, `.snapshots()` for real-time
- Cache frequently accessed data locally
- Minimize document reads by structuring data efficiently
- Use pagination for large datasets
- Avoid reading entire collections

## Date Handling

```dart
// Convert date to document ID
String dateToDocId(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

// Store in Firestore
'date': Timestamp.fromDate(date)

// Read from Firestore
final date = (snapshot.data()?['date'] as Timestamp?)?.toDate();
```

## Common Queries in This Project

```dart
// Get today's tracker data
final todayData = await _firestore
  .collection('users')
  .doc(userId)
  .collection('tracker')
  .doc(dateToDocId(DateTime.now()))
  .get();

// Get date range
final rangeData = await _firestore
  .collection('users')
  .doc(userId)
  .collection('tracker')
  .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
  .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
  .orderBy('date', descending: true)
  .get();
```

## Offline Support

- Enable offline persistence: `FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true)`
- Handle offline state in UI
- Queue writes for when connection returns
- Show appropriate loading/offline indicators

## Testing

- Use Firebase Emulator for local testing
- Mock Firestore in unit tests
- Test error scenarios (network failures, permission denied)
- Verify data structure matches Firestore schema

