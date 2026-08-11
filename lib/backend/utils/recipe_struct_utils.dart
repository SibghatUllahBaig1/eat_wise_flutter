import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/structs/index.dart';

DateTime? _parseRecipeDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value);
  if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
  return null;
}

/// Converts Firestore or cached recipe JSON into a complete [RecipesStruct].
RecipesStruct recipeStructFromMap(Map<String, dynamic> data) {
  final normalized = Map<String, dynamic>.from(data);

  for (final key in ['createdAt', 'updatedAt']) {
    normalized[key] = _parseRecipeDateTime(normalized[key]);
  }

  return RecipesStruct.fromMap(normalized);
}

/// Returns [partial] when it already has detail fields; otherwise looks up the
/// full recipe in [cachedRecipes] by document id or name.
RecipesStruct resolveRecipeStruct(
  RecipesStruct? partial, {
  required List<Map<String, dynamic>> cachedRecipes,
}) {
  if (partial == null) {
    return RecipesStruct();
  }

  final hasDetailFields = partial.ingredients.isNotEmpty ||
      partial.instructions.isNotEmpty;
  if (hasDetailFields) {
    return partial;
  }

  Map<String, dynamic>? match;
  for (final recipe in cachedRecipes) {
    if (partial.name.isNotEmpty && recipe['name'] == partial.name) {
      match = recipe;
      break;
    }
  }

  if (match != null) {
    return recipeStructFromMap(match);
  }

  return partial;
}
