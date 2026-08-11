import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/utils/date_utils.dart';
import 'firestore_service.dart';

/// One calorie goal effective from a calendar day onward.
class CalorieGoalHistoryEntry {
  const CalorieGoalHistoryEntry({
    required this.effectiveFrom,
    required this.dailyCalorieGoal,
    this.goal,
  });

  final DateTime effectiveFrom;
  final int dailyCalorieGoal;
  final String? goal;
}

/// Persists calorie goal changes so past calendar days keep their original target.
class CalorieGoalHistoryService extends FirestoreService {
  static const String baselineDocId = '1970-01-01';

  CollectionReference<Map<String, dynamic>> _historyCollection(String userId) =>
      usersCollection.doc(userId).collection('calorie_goal_history');

  String _dateKey(DateTime date) {
    final day = normalizeToDate(date);
    return '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
  }

  /// Returns history entries sorted oldest to newest by [effectiveFrom].
  Future<List<CalorieGoalHistoryEntry>> fetchHistory(String userId) async {
    try {
      final snapshot = await _historyCollection(userId).get();
      final entries = snapshot.docs.map((doc) {
        final data = doc.data();
        final effectiveFrom = timestampToDateTime(data['effectiveFrom']) ??
            _parseDateKey(doc.id);
        return CalorieGoalHistoryEntry(
          effectiveFrom: normalizeToDate(effectiveFrom),
          dailyCalorieGoal: (data['dailyCalorieGoal'] as num?)?.toInt() ?? 0,
          goal: data['goal'] as String?,
        );
      }).where((entry) => entry.dailyCalorieGoal > 0).toList();

      entries.sort(
        (a, b) => a.effectiveFrom.compareTo(b.effectiveFrom),
      );
      return entries;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Latest goal effective on [date], or [fallback] when no history applies.
  static int resolveGoalForDate(
    List<CalorieGoalHistoryEntry> history,
    DateTime date,
    int fallback,
  ) {
    if (history.isEmpty) return fallback;

    final day = normalizeToDate(date);
    var resolved = fallback;
    for (final entry in history) {
      if (!entry.effectiveFrom.isAfter(day)) {
        resolved = entry.dailyCalorieGoal;
      } else {
        break;
      }
    }
    return resolved > 0 ? resolved : fallback;
  }

  Future<void> upsertEntry({
    required String userId,
    required DateTime effectiveFrom,
    required int dailyCalorieGoal,
    String? goal,
  }) async {
    if (dailyCalorieGoal <= 0) return;

    try {
      final day = normalizeToDate(effectiveFrom);
      final docId = _dateKey(day);
      await _historyCollection(userId).doc(docId).set(
        {
          'effectiveFrom': dateTimeToTimestamp(day),
          'dailyCalorieGoal': dailyCalorieGoal,
          if (goal != null && goal.isNotEmpty) 'goal': goal,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Records a goal change effective from [effectiveFrom] (defaults to today).
  Future<void> recordGoalChange({
    required String userId,
    required int previousGoal,
    required int newGoal,
    String? goalType,
    DateTime? effectiveFrom,
  }) async {
    if (newGoal <= 0 || newGoal == previousGoal) return;

    final effectiveDay = normalizeToDate(effectiveFrom ?? DateTime.now());
    final history = await fetchHistory(userId);

    if (history.isEmpty && previousGoal > 0) {
      await upsertEntry(
        userId: userId,
        effectiveFrom: DateTime(1970, 1, 1),
        dailyCalorieGoal: previousGoal,
        goal: goalType,
      );
    }

    await upsertEntry(
      userId: userId,
      effectiveFrom: effectiveDay,
      dailyCalorieGoal: newGoal,
      goal: goalType,
    );
  }

  /// Seeds the first history entry after onboarding (no baseline needed).
  Future<void> seedInitialGoal({
    required String userId,
    required int dailyCalorieGoal,
    String? goalType,
    DateTime? effectiveFrom,
  }) async {
    if (dailyCalorieGoal <= 0) return;

    final history = await fetchHistory(userId);
    if (history.isNotEmpty) return;

    await upsertEntry(
      userId: userId,
      effectiveFrom: effectiveFrom ?? DateTime.now(),
      dailyCalorieGoal: dailyCalorieGoal,
      goal: goalType,
    );
  }

  DateTime _parseDateKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return DateTime(1970, 1, 1);
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }
}
