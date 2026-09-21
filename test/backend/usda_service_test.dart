import 'package:eat_wise/backend/api_requests/usda_food_matcher.dart';
import 'package:eat_wise/backend/api_requests/usda_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('USDAService.parseNutritionDataForTest', () {
    test('parses Foundation nested nutrient format', () {
      final parsed = USDAService.parseNutritionDataForTest({
        'description': 'Bananas, raw',
        'foodNutrients': [
          {
            'nutrient': {'number': '208'},
            'amount': 89,
          },
          {
            'nutrient': {'number': '203'},
            'amount': 1.1,
          },
          {
            'nutrient': {'number': '205'},
            'amount': 22.8,
          },
          {
            'nutrient': {'number': '204'},
            'amount': 0.3,
          },
        ],
      });

      expect(parsed['calories'], 89);
      expect(parsed['protein'], 1.1);
      expect(parsed['carbs'], 22.8);
      expect(parsed['fat'], 0.3);
    });

    test('parses Branded flat nutrient format with nutrientId', () {
      final parsed = USDAService.parseNutritionDataForTest({
        'description': 'MILK',
        'servingSize': 240,
        'servingSizeUnit': 'ml',
        'foodNutrients': [
          {'nutrientId': 1008, 'value': 146},
          {'nutrientId': 1003, 'value': 7.68},
          {'nutrientId': 1005, 'value': 11.52},
          {'nutrientId': 1004, 'value': 7.92},
        ],
      });

      expect(parsed['calories'], greaterThan(0));
      expect(parsed['protein'], greaterThan(0));
      expect(parsed['carbs'], greaterThan(0));
      expect(parsed['fat'], greaterThan(0));
    });

    test('parses labelNutrients and scales to per 100g', () {
      final parsed = USDAService.parseNutritionDataForTest({
        'description': 'MILK',
        'servingSize': 240,
        'servingSizeUnit': 'ml',
        'foodNutrients': [],
        'labelNutrients': {
          'calories': {'value': 146},
          'protein': {'value': 8},
          'carbohydrates': {'value': 12},
          'fat': {'value': 8},
        },
      });

      expect(parsed['calories'], closeTo(60.8, 0.5));
      expect(parsed['protein'], closeTo(3.3, 0.2));
      expect(parsed['carbs'], closeTo(5.0, 0.2));
      expect(parsed['fat'], closeTo(3.3, 0.2));
    });

    test('detects unlabeled foodNutrients shape', () {
      expect(
        USDAService.foodNutrientsAreUnlabeledForTest([
          {'type': 'FoodNutrient', 'id': 25495928, 'amount': 179.0},
        ]),
        isTrue,
      );
      expect(
        USDAService.foodNutrientsAreUnlabeledForTest([
          {'number': '208', 'amount': 179},
        ]),
        isFalse,
      );
      expect(
        USDAService.foodNutrientsAreUnlabeledForTest([
          {'nutrientId': 1008, 'value': 146},
        ]),
        isFalse,
      );
      expect(
        USDAService.foodNutrientsAreUnlabeledForTest([
          {
            'nutrient': {'id': 1008, 'number': '208'},
            'amount': 100,
          },
        ]),
        isFalse,
      );
    });

    test('parses nested nutrient.id format', () {
      final parsed = USDAService.parseNutritionDataForTest({
        'description': 'Test food',
        'foodNutrients': [
          {
            'nutrient': {'id': 1008, 'number': '208'},
            'amount': 250,
          },
          {
            'nutrient': {'id': 1003, 'number': '203'},
            'amount': 12,
          },
          {
            'nutrient': {'id': 1005, 'number': '205'},
            'amount': 30,
          },
          {
            'nutrient': {'id': 1004, 'number': '204'},
            'amount': 8,
          },
        ],
      });

      expect(parsed['calories'], 250);
      expect(parsed['protein'], 12);
      expect(parsed['carbs'], 30);
      expect(parsed['fat'], 8);
    });

    test('converts kJ energy to kcal when kcal nutrient is absent', () {
      final parsed = USDAService.parseNutritionDataForTest({
        'description': 'Energy from kJ only',
        'foodNutrients': [
          {
            'nutrient': {'number': '268', 'id': 1062},
            'amount': 418.4,
          },
        ],
      });

      expect(parsed['calories'], closeTo(100, 0.1));
      expect(UsdaFoodMatcher.hasValidNutrition(parsed), isTrue);
    });

    test('unlabeled full format fails until abridged nutrients are merged', () {
      final unlabeledOnly = USDAService.parseNutritionDataForTest({
        'description': 'FRENCH FRIES',
        'dataType': 'Branded',
        'servingSize': 84,
        'servingSizeUnit': 'g',
        'foodNutrients': [
          {'type': 'FoodNutrient', 'id': 25495928, 'amount': 179.0},
        ],
      });

      expect(UsdaFoodMatcher.hasValidNutrition(unlabeledOnly), isFalse);

      final withAbridged = USDAService.parseNutritionDataForTest({
        'description': 'FRENCH FRIES',
        'dataType': 'Branded',
        'servingSize': 84,
        'servingSizeUnit': 'g',
        '_nutrientsArePerServing': true,
        'foodNutrients': [
          {'number': '208', 'amount': 179},
          {'number': '204', 'amount': 8.33},
          {'number': '205', 'amount': 22.6},
          {'number': '203', 'amount': 2.38},
        ],
      });

      expect(UsdaFoodMatcher.hasValidNutrition(withAbridged), isTrue);
    });

    test('parses Branded abridged nutrients scaled to per 100g', () {
      final parsed = USDAService.parseNutritionDataForTest({
        'description': 'FRENCH FRIES',
        'dataType': 'Branded',
        'servingSize': 84,
        'servingSizeUnit': 'g',
        '_nutrientsArePerServing': true,
        'foodNutrients': [
          {'number': '208', 'name': 'Energy', 'amount': 179, 'unitName': 'KCAL'},
          {'number': '204', 'name': 'Total lipid (fat)', 'amount': 8.33, 'unitName': 'G'},
          {'number': '205', 'name': 'Carbohydrate, by difference', 'amount': 22.6, 'unitName': 'G'},
          {'number': '203', 'name': 'Protein', 'amount': 2.38, 'unitName': 'G'},
        ],
      });

      expect(parsed['calories'], closeTo(213.1, 0.5));
      expect(parsed['fat'], closeTo(9.92, 0.1));
      expect(parsed['carbs'], closeTo(26.9, 0.2));
      expect(parsed['protein'], closeTo(2.83, 0.1));
      expect(UsdaFoodMatcher.hasValidNutrition(parsed), isTrue);
    });
  });
}
