import 'package:eat_wise/backend/api_requests/food_analysis_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FoodAnalysisService.buildFromSelectionData', () {
    const mockUsdaPer100g = {
      'calories': 89.0,
      'protein': 1.1,
      'carbs': 22.8,
      'fat': 0.3,
      'cholesterol': 0.0,
      'sodium': 1.0,
      'calcium': 5.0,
      'iron': 0.3,
      'potassium': 358.0,
      'magnesium': 27.0,
      'phosphorus': 22.0,
      'zinc': 0.2,
      'copper': 0.1,
      'selenium': 0.001,
    };

    test('uses explicit grams from user description', () {
      final result = FoodAnalysisService.buildFromSelectionData(
        userDescription: '50g banana',
        usdaData: mockUsdaPer100g,
        usdaDescription: 'Bananas, raw',
        usdaDataType: 'Foundation',
      );

      expect(result.grams, 50);
      expect(result.calories, closeTo(44.5, 0.1));
      expect(result.foodName, 'Bananas, raw');
      expect(result.usdaDescription, 'Bananas, raw');
      expect(result.usdaDataType, 'Foundation');
    });

    test('defaults to 100g when no portion stated', () {
      final result = FoodAnalysisService.buildFromSelectionData(
        userDescription: 'milk',
        usdaData: {
          ...mockUsdaPer100g,
          'calories': 61.0,
        },
        usdaDescription: 'Milk, whole, 3.25% milkfat',
        usdaDataType: 'Foundation',
      );

      expect(result.grams, 100);
      expect(result.calories, 61);
    });
  });
}
