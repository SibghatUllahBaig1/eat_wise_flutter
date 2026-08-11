import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';

/// Service for managing recipes
class RecipeService extends FirestoreService {
  Map<String, dynamic> _mapRecipeDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = Map<String, dynamic>.from(doc.data());
    data['id'] = doc.id;
    data['createdAt'] = timestampToDateTime(data['createdAt']);
    data['updatedAt'] = timestampToDateTime(data['updatedAt']);
    return data;
  }

  void _sortRecipesNewestFirst(List<Map<String, dynamic>> recipes) {
    recipes.sort((a, b) {
      final aCreated = a['createdAt'] as DateTime?;
      final bCreated = b['createdAt'] as DateTime?;
      if (aCreated != null && bCreated != null) {
        final byCreated = bCreated.compareTo(aCreated);
        if (byCreated != 0) return byCreated;
      } else if (aCreated != null) {
        return -1;
      } else if (bCreated != null) {
        return 1;
      }

      final aUpdated = a['updatedAt'] as DateTime?;
      final bUpdated = b['updatedAt'] as DateTime?;
      if (aUpdated != null && bUpdated != null) {
        final byUpdated = bUpdated.compareTo(aUpdated);
        if (byUpdated != 0) return byUpdated;
      } else if (aUpdated != null) {
        return -1;
      } else if (bUpdated != null) {
        return 1;
      }

      final aName = (a['name'] as String? ?? '').toLowerCase();
      final bName = (b['name'] as String? ?? '').toLowerCase();
      return aName.compareTo(bName);
    });
  }

  /// Get all recipes from Firestore (matches admin panel — no server-side limit).
  Future<List<Map<String, dynamic>>> getAllRecipes() async {
    try {
      final snapshot = await firestore.collection('recipes').get();
      final recipes = snapshot.docs.map(_mapRecipeDoc).toList();
      _sortRecipesNewestFirst(recipes);
      return recipes;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get recipes by tags
  Future<List<Map<String, dynamic>>> getRecipesByTags({
    required List<String> tags,
    int limit = 50,
  }) async {
    try {
      final snapshot = await firestore
          .collection('recipes')
          .where('tags', arrayContainsAny: tags)
          .orderBy('createdAt', descending: true)
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

  /// Search recipes by title
  Future<List<Map<String, dynamic>>> searchRecipes({
    required String query,
    int limit = 50,
  }) async {
    try {
      // Note: For better search, consider using Algolia or similar service
      // This is a basic implementation
      final snapshot = await firestore
          .collection('recipes')
          .orderBy('title')
          .startAt([query])
          .endAt([query + '\uf8ff'])
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

  /// Get recipe by ID
  Future<Map<String, dynamic>?> getRecipeById(String recipeId) async {
    try {
      final doc = await firestore.collection('recipes').doc(recipeId).get();

      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      data['createdAt'] = timestampToDateTime(data['createdAt']);
      data['updatedAt'] = timestampToDateTime(data['updatedAt']);

      return data;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream all recipes, sorted newest-first on the client.
  Stream<List<Map<String, dynamic>>> streamRecipes() {
    return firestore.collection('recipes').snapshots().map((snapshot) {
      final recipes = snapshot.docs.map(_mapRecipeDoc).toList();
      _sortRecipesNewestFirst(recipes);
      return recipes;
    });
  }

  /// Add recipe to favorites
  Future<void> addToFavorites({
    required String userId,
    required String recipeId,
  }) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('favorite_recipes')
          .doc(recipeId)
          .set({
        'recipeId': recipeId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Remove recipe from favorites
  Future<void> removeFromFavorites({
    required String userId,
    required String recipeId,
  }) async {
    try {
      await usersCollection
          .doc(userId)
          .collection('favorite_recipes')
          .doc(recipeId)
          .delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get user's favorite recipes
  Future<List<Map<String, dynamic>>> getFavoriteRecipes({
    required String userId,
  }) async {
    try {
      final favSnapshot = await usersCollection
          .doc(userId)
          .collection('favorite_recipes')
          .orderBy('addedAt', descending: true)
          .get();

      if (favSnapshot.docs.isEmpty) return [];

      final recipeIds = favSnapshot.docs.map((doc) => doc.id).toList();

      // Fetch actual recipe data
      final recipes = <Map<String, dynamic>>[];
      for (var recipeId in recipeIds) {
        final recipe = await getRecipeById(recipeId);
        if (recipe != null) {
          recipes.add(recipe);
        }
      }

      return recipes;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Delete a recipe by ID
  Future<void> deleteRecipe(String recipeId) async {
    try {
      await firestore.collection('recipes').doc(recipeId).delete();
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Get recipes by diet category
  Future<List<Map<String, dynamic>>> getRecipesByCategory({
    required String category,
    int limit = 50,
  }) async {
    try {
      final snapshot = await firestore
          .collection('recipes')
          .where('dietCategories', arrayContains: category)
          .limit(limit)
          .get();

      final recipes = snapshot.docs.map(_mapRecipeDoc).toList();
      _sortRecipesNewestFirst(recipes);
      return recipes;
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }

  /// Stream recipes by diet category
  Stream<List<Map<String, dynamic>>> streamRecipesByCategory({
    required String category,
    int limit = 50,
  }) {
    return firestore
        .collection('recipes')
        .where('dietCategories', arrayContains: category)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      final recipes = snapshot.docs.map(_mapRecipeDoc).toList();
      _sortRecipesNewestFirst(recipes);
      return recipes;
    });
  }

  /// Add recipe to user's meal log for today
  Future<void> addRecipeToMealLog({
    required String userId,
    required String recipeId,
  }) async {
    try {
      // Get recipe details
      final recipe = await getRecipeById(recipeId);
      if (recipe == null) {
        throw Exception('Recipe not found');
      }

      final today = DateTime.now();
      final normalizedDate = DateTime(today.year, today.month, today.day);

      // Create meal entry from recipe
      final mealData = {
        'name': recipe['name'] ?? 'Recipe',
        'imageUrl': recipe['imageUrl'] ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'date': Timestamp.fromDate(normalizedDate),
        'nutrition': {
          'calories': recipe['calories'] ?? 0,
          'carbs': recipe['carbs'] ?? 0,
          'protein': recipe['protein'] ?? 0,
          'fat': recipe['fat'] ?? 0,
        },
        'isFromRecipe': true,
        'recipeId': recipeId,
      };

      await usersCollection.doc(userId).collection('meals').add(mealData);
    } catch (e) {
      throw Exception(handleFirestoreError(e));
    }
  }
}
