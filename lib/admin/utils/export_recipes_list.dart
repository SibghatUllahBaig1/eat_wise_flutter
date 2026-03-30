import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility to export all recipe names from Firestore
/// Use this to get a list of all recipes in the database
class ExportRecipesList {
  static final _firestore = FirebaseFirestore.instance;

  /// Get all recipe names and IDs
  static Future<void> exportRecipesList() async {
    try {
      print('\n📚 Fetching all recipes from Firestore...\n');

      final snapshot = await _firestore.collection('recipes').get();

      if (snapshot.docs.isEmpty) {
        print('❌ No recipes found in the database');
        return;
      }

      print('✅ Found ${snapshot.docs.length} recipes:\n');
      print('=' * 80);

      for (int i = 0; i < snapshot.docs.length; i++) {
        final doc = snapshot.docs[i];
        final data = doc.data();

        print('\n${i + 1}. ${data['name'] ?? 'N/A'}');
        print('   ID: ${doc.id}');
        print('   Description: ${data['description'] ?? 'N/A'}');
        print('   Current Calories: ${data['calories'] ?? 'N/A'}');
        print('   Protein: ${data['protein'] ?? 'N/A'}g');
        print('   Carbs: ${data['carbs'] ?? 'N/A'}g');
        print('   Fat: ${data['fat'] ?? 'N/A'}g');
      }

      print('\n' + '=' * 80);
      print('\n✅ Recipe list exported!');
      print('\nProvide nutrition data for each recipe in this format:');
      print('Recipe Name: {');
      print('  calories: number,');
      print('  protein: number,');
      print('  carbs: number,');
      print('  fat: number,');
      print('  fiber: number,');
      print('  sugar: number,');
      print('  saturatedFat: number,');
      print('  cholesterol: {value: number, unit: string},');
      print('  sodium: {value: number, unit: string},');
      print('  minerals: {');
      print('    calcium: {value: number, unit: string},');
      print('    iron: {value: number, unit: string},');
      print('    potassium: {value: number, unit: string},');
      print('    magnesium: {value: number, unit: string},');
      print('    phosphorus: {value: number, unit: string},');
      print('    zinc: {value: number, unit: string},');
      print('    copper: {value: number, unit: string},');
      print('    selenium: {value: number, unit: string}');
      print('  }');
      print('}');
    } catch (e) {
      print('❌ Error fetching recipes: $e');
    }
  }
}

