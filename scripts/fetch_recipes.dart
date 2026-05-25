import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

void main() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  final firestore = FirebaseFirestore.instance;

  try {
    print('📚 Fetching all recipes from Firestore...\n');

    final snapshot = await firestore.collection('recipes').get();

    if (snapshot.docs.isEmpty) {
      print('❌ No recipes found in the database');
      return;
    }

    print('✅ Found ${snapshot.docs.length} recipes:\n');
    print('=' * 80);

    for (int i = 0; i < snapshot.docs.length; i++) {
      final doc = snapshot.docs[i];
      final data = doc.data();

      print('\n📖 Recipe ${i + 1}:');
      print('ID: ${doc.id}');
      print('Name: ${data['name'] ?? 'N/A'}');
      print('Description: ${data['description'] ?? 'N/A'}');
      print('Calories: ${data['calories'] ?? 'N/A'}');
      print('Protein: ${data['protein'] ?? 'N/A'}g');
      print('Carbs: ${data['carbs'] ?? 'N/A'}g');
      print('Fat: ${data['fat'] ?? 'N/A'}g');
      print('Fiber: ${data['fiber'] ?? 'N/A'}g');
      print('Sugar: ${data['sugar'] ?? 'N/A'}g');
      print('Saturated Fat: ${data['saturatedFat'] ?? 'N/A'}g');
      print('Cholesterol: ${data['cholesterol'] ?? 'N/A'}');
      print('Sodium: ${data['sodium'] ?? 'N/A'}');
      print('Minerals: ${data['minerals'] ?? 'N/A'}');
      print('Ingredients: ${data['ingredients'] ?? []}');
      print('Instructions: ${data['instructions'] ?? []}');
      print('Diet Categories: ${data['dietCategories'] ?? []}');
      print('Time: ${data['time'] ?? 'N/A'} min');
      print('Difficulty: ${data['difficulty'] ?? 'N/A'}');
      print('-' * 80);
    }

    print('\n✅ Recipe list complete!');
  } catch (e) {
    print('❌ Error fetching recipes: $e');
  }
}
