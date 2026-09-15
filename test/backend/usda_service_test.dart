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
  });
}
