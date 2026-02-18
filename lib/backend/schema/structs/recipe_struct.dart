import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeStruct {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final int calories;
  final List<String> ingredients;
  final List<String> instructions;
  final String dietCategory;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecipeStruct({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.calories,
    required this.ingredients,
    required this.instructions,
    required this.dietCategory,
    required this.createdAt,
    required this.updatedAt,
  });

  // Create from Firestore document
  factory RecipeStruct.fromMap(Map<String, dynamic> map, String id) {
    return RecipeStruct(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      calories: map['calories'] ?? 0,
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
      dietCategory: map['dietCategory'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'calories': calories,
      'ingredients': ingredients,
      'instructions': instructions,
      'dietCategory': dietCategory,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // Serialize for FFAppState
  String serialize() => jsonEncode(toSerializableMap());

  Map<String, dynamic> toSerializableMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'calories': calories,
      'ingredients': ingredients,
      'instructions': instructions,
      'dietCategory': dietCategory,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  static RecipeStruct fromSerializableMap(Map<String, dynamic> map) {
    return RecipeStruct(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      calories: map['calories'] ?? 0,
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
      dietCategory: map['dietCategory'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] ?? 0),
    );
  }

  RecipeStruct copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? calories,
    List<String>? ingredients,
    List<String>? instructions,
    String? dietCategory,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RecipeStruct(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      calories: calories ?? this.calories,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      dietCategory: dietCategory ?? this.dietCategory,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

