import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';
import '/backend/schema/structs/index.dart';

/// Service for managing meal tracking
class MealService extends FirestoreService {
  /// Add a meal entry
  Future<String> addMeal({
    required String userId,
    required DateTime date,
    required String type, // breakfast, lunch, dinner, snack
    required List<Map<String, dynamic>> foods,
    int? totalCalories,
    int? totalCarbs,
    int? totalProtein,
    int? totalFat,
    String? notes,
    String? imageUrl,
  }) async {
    try {
      final mealsCollection = usersCollection.doc(userId).collection('meals');

      // Calculate totals if not provided
      if (totalCalories == null ||
          totalCarbs == null ||
          totalProtein == null ||
          totalFat == null) {
        int calories = 0;
        int carbs = 0;
        int protein = 0;
        int fat = 0;

        for (var food in foods) {
          calories += (food['kcal'] as int?) ?? 0;
          carbs += (food['carbs'] as int?) ?? 0;
          protein += (food['protein'] as int?) ?? 0;
          fat += (food['fat'] as int?) ?? 0;
        }

        totalCalories ??= calories;
        totalCarbs ??= carbs;
        totalProtein ??= protein;
        totalFat ??= fat;
      }

      final data = {
        'userId': userId,
        'date': dateTimeToTimestamp(date),
        'type': type,
        'foods': foods,
        'totalCalories': totalCalories,
        'totalCarbs': totalCarbs,
        'totalProtein': totalProtein,
        'totalFat': totalFat,
        'notes': notes,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await mealsCollection.add(data);
      return docRef.id;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Update a meal entry
  Future<void> updateMeal({
    required String userId,
    required String mealId,
    DateTime? date,
    String? type,
    List<Map<String, dynamic>>? foods,
    int? totalCalories,
    int? totalCarbs,
    int? totalProtein,
    int? totalFat,
    String? notes,
    String? imageUrl,
  }) async {
    try {
      final mealDoc =
          usersCollection.doc(userId).collection('meals').doc(mealId);

      final data = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (date != null) data['date'] = dateTimeToTimestamp(date);
      if (type != null) data['type'] = type;
      if (foods != null) {
        data['foods'] = foods;

        // Recalculate totals
        int calories = 0;
        int carbs = 0;
        int protein = 0;
        int fat = 0;

        for (var food in foods) {
          calories += (food['kcal'] as int?) ?? 0;
          carbs += (food['carbs'] as int?) ?? 0;
          protein += (food['protein'] as int?) ?? 0;
          fat += (food['fat'] as int?) ?? 0;
        }

        data['totalCalories'] = totalCalories ?? calories;
        data['totalCarbs'] = totalCarbs ?? carbs;
        data['totalProtein'] = totalProtein ?? protein;
        data['totalFat'] = totalFat ?? fat;
      }
      if (notes != null) data['notes'] = notes;
      if (imageUrl != null) data['imageUrl'] = imageUrl;

      await mealDoc.update(data);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete a meal entry
  Future<void> deleteMeal({
    required String userId,
    required String mealId,
  }) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('meals')
          .doc(mealId)
          .delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get meals for a specific date
  Future<List<Map<String, dynamic>>> getMealsByDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final range = getDayRange(date);

      final snapshot = await usersCollection
          .doc(userId)
          .collection('meals')
          .where('date',
              isGreaterThanOrEqualTo: dateTimeToTimestamp(range['start']))
          .where('date', isLessThanOrEqualTo: dateTimeToTimestamp(range['end']))
          .orderBy('date')
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

  /// Get meals for a date range
  Future<List<Map<String, dynamic>>> getMealsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final snapshot = await usersCollection
          .doc(userId)
          .collection('meals')
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

  /// Stream meals for a specific date
  Stream<List<Map<String, dynamic>>> streamMealsByDate({
    required String userId,
    required DateTime date,
  }) {
    final range = getDayRange(date);

    return usersCollection
        .doc(userId)
        .collection('meals')
        .where('date',
            isGreaterThanOrEqualTo: dateTimeToTimestamp(range['start']))
        .where('date', isLessThanOrEqualTo: dateTimeToTimestamp(range['end']))
        .orderBy('date')
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

  /// Get daily nutrition summary
  Future<Map<String, int>> getDailyNutritionSummary({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final meals = await getMealsByDate(userId: userId, date: date);

      int totalCalories = 0;
      int totalCarbs = 0;
      int totalProtein = 0;
      int totalFat = 0;

      for (var meal in meals) {
        totalCalories += (meal['totalCalories'] as int?) ?? 0;
        totalCarbs += (meal['totalCarbs'] as int?) ?? 0;
        totalProtein += (meal['totalProtein'] as int?) ?? 0;
        totalFat += (meal['totalFat'] as int?) ?? 0;
      }

      return {
        'calories': totalCalories,
        'carbs': totalCarbs,
        'protein': totalProtein,
        'fat': totalFat,
      };
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get weekly nutrition summary
  Future<List<Map<String, dynamic>>> getWeeklyNutritionSummary({
    required String userId,
    required DateTime date,
  }) async {
    try {
      final range = getWeekRange(date);
      final meals = await getMealsByDateRange(
        userId: userId,
        startDate: range['start']!,
        endDate: range['end']!,
      );

      // Group by day
      final Map<String, Map<String, int>> dailySummary = {};

      for (var meal in meals) {
        final mealDate = meal['date'] as DateTime;
        final dayKey = '${mealDate.year}-${mealDate.month}-${mealDate.day}';

        if (!dailySummary.containsKey(dayKey)) {
          dailySummary[dayKey] = {
            'calories': 0,
            'carbs': 0,
            'protein': 0,
            'fat': 0,
          };
        }

        dailySummary[dayKey]!['calories'] =
            (dailySummary[dayKey]!['calories']! +
                ((meal['totalCalories'] as int?) ?? 0));
        dailySummary[dayKey]!['carbs'] = (dailySummary[dayKey]!['carbs']! +
            ((meal['totalCarbs'] as int?) ?? 0));
        dailySummary[dayKey]!['protein'] = (dailySummary[dayKey]!['protein']! +
            ((meal['totalProtein'] as int?) ?? 0));
        dailySummary[dayKey]!['fat'] =
            (dailySummary[dayKey]!['fat']! + ((meal['totalFat'] as int?) ?? 0));
      }

      return dailySummary.entries.map((entry) {
        final parts = entry.key.split('-');
        return {
          'date': DateTime(
              int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2])),
          'day': int.parse(parts[2]),
          ...entry.value,
        };
      }).toList()
        ..sort(
            (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get meal history for analytics (alias for getMealsByDateRange)
  Future<List<Map<String, dynamic>>> getMealHistory({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    return getMealsByDateRange(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
