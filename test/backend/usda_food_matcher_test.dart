import 'package:eat_wise/backend/api_requests/portion_parser.dart';
import 'package:eat_wise/backend/api_requests/usda_food_matcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PortionParser', () {
    test('parseExplicitGrams parses grams suffix', () {
      expect(PortionParser.parseExplicitGrams('50g banana'), 50);
      expect(PortionParser.parseExplicitGrams('50 g banana'), 50);
      expect(PortionParser.parseExplicitGrams('50 grams banana'), 50);
    });

    test('parseExplicitGrams parses kg suffix', () {
      expect(PortionParser.parseExplicitGrams('0.05 kg rice'), 50);
    });

    test('parseExplicitGrams returns null when no portion stated', () {
      expect(PortionParser.parseExplicitGrams('banana'), isNull);
      expect(PortionParser.parseExplicitGrams(''), isNull);
    });

    test('stripPortionClause removes explicit weight', () {
      expect(PortionParser.stripPortionClause('50g banana'), 'banana');
      expect(PortionParser.stripPortionClause('0.05 kg rice'), 'rice');
    });
  });

  group('UsdaFoodMatcher', () {
    test('buildSearchQuery appends raw for whole produce', () {
      expect(
        UsdaFoodMatcher.buildSearchQuery(foodName: 'banana'),
        'banana raw',
      );
      expect(
        UsdaFoodMatcher.buildSearchQuery(
          foodName: 'banana',
          description: 'A fresh yellow banana',
        ),
        'banana raw',
      );
    });

    test('buildSearchQuery uses whole milk query for milk', () {
      expect(
        UsdaFoodMatcher.buildSearchQuery(foodName: 'milk'),
        'milk whole',
      );
    });

    test('hasValidNutrition detects empty and valid nutrition', () {
      expect(
        UsdaFoodMatcher.hasValidNutrition({
          'calories': 0,
          'protein': 0,
          'carbs': 0,
          'fat': 0,
        }),
        isFalse,
      );
      expect(
        UsdaFoodMatcher.hasValidNutrition({
          'calories': 61,
          'protein': 3.2,
          'carbs': 4.8,
          'fat': 3.3,
        }),
        isTrue,
      );
    });

    test('buildSearchQuery does not append raw for prepared foods', () {
      expect(
        UsdaFoodMatcher.buildSearchQuery(
          foodName: 'banana chips',
          userInput: 'banana chips',
        ),
        'banana chips',
      );
    });

    test('rankCandidates prefers Foundation raw over Branded processed', () {
      final ranked = UsdaFoodMatcher.rankCandidates(
        foodName: 'banana',
        searchResults: [
          {
            'fdcId': 1,
            'description': 'Banana chips',
            'dataType': 'Branded',
            'brandName': 'SnackCo',
          },
          {
            'fdcId': 2,
            'description': 'Bananas, raw',
            'dataType': 'Foundation',
            'brandName': null,
          },
        ],
      );

      expect(ranked.first.fdcId, 2);
      expect(ranked.first.description, 'Bananas, raw');
    });

    test('isClearWinner detects large score gap', () {
      final clear = [
        UsdaCandidate(
          fdcId: 1,
          description: 'Bananas, raw',
          dataType: 'Foundation',
          score: 150,
        ),
        UsdaCandidate(
          fdcId: 2,
          description: 'Banana chips',
          dataType: 'Branded',
          score: 50,
        ),
      ];
      expect(UsdaFoodMatcher.isClearWinner(clear), isTrue);

      final ambiguous = [
        UsdaCandidate(
          fdcId: 1,
          description: 'Bananas, raw',
          dataType: 'Foundation',
          score: 120,
        ),
        UsdaCandidate(
          fdcId: 2,
          description: 'Banana, overripe, raw',
          dataType: 'SR Legacy',
          score: 110,
        ),
      ];
      expect(UsdaFoodMatcher.isClearWinner(ambiguous), isFalse);
    });

    test('passesCalorieSanity rejects inflated produce calories', () {
      expect(
        UsdaFoodMatcher.passesCalorieSanity(
          foodName: 'banana',
          caloriesPer100g: 89,
        ),
        isTrue,
      );
      expect(
        UsdaFoodMatcher.passesCalorieSanity(
          foodName: 'banana',
          caloriesPer100g: 312,
        ),
        isFalse,
      );
    });

    test('isRelevantPrimaryFood keeps milk and rejects cheese yogurt', () {
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'milk',
          'Milk, whole, 3.25% milkfat',
        ),
        isTrue,
      );
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'milk',
          'Milk, buttermilk, fluid, whole',
        ),
        isTrue,
      );
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'milk',
          'Cheese, ricotta, whole milk',
        ),
        isFalse,
      );
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'milk',
          'Yogurt, plain, whole milk',
        ),
        isFalse,
      );
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'milk',
          'Strawberry milk, whole',
        ),
        isFalse,
      );
    });

    test('isRelevantPrimaryFood handles banana vs banana bread', () {
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood('banana', 'Bananas, raw'),
        isTrue,
      );
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'banana',
          'Bread, banana nut',
        ),
        isFalse,
      );
    });

    test('isRelevantPrimaryFood handles french fries queries', () {
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'french fries',
          'Potatoes, french fried, all types, salt added in processing, frozen, unprepared',
        ),
        isTrue,
      );
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'french fries',
          'FRENCH FRIES',
        ),
        isTrue,
      );
      expect(
        UsdaFoodMatcher.isRelevantPrimaryFood(
          'french fries',
          'Bread, white, commercially prepared',
        ),
        isFalse,
      );
    });

    test('filterRelevantResults removes irrelevant hits', () {
      final filtered = UsdaFoodMatcher.filterRelevantResults('milk', [
        {
          'fdcId': 1,
          'description': 'Milk, whole, 3.25% milkfat',
          'dataType': 'Foundation',
        },
        {
          'fdcId': 2,
          'description': 'Cheese, ricotta, whole milk',
          'dataType': 'Foundation',
        },
      ]);

      expect(filtered.length, 1);
      expect(filtered.first['fdcId'], 1);
    });

    test('passesCalorieSanity skips strict checks for prepared foods', () {
      expect(
        UsdaFoodMatcher.passesCalorieSanity(
          foodName: 'banana chips',
          caloriesPer100g: 312,
          userInput: 'banana chips',
        ),
        isTrue,
      );
    });
  });
}
