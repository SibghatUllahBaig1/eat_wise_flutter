import 'package:eat_wise/backend/api_requests/usda_food_matcher.dart';
import 'package:eat_wise/backend/api_requests/usda_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('USDAService.pickBestCandidate', () {
    test('returns sole candidate without calling OpenAI', () async {
      final fdcId = await USDAService.pickBestCandidate(
        foodName: 'banana',
        rankedReference: [
          UsdaCandidate(
            fdcId: 42,
            description: 'Bananas, raw',
            dataType: 'Foundation',
            score: 200,
          ),
        ],
        rankedGeneral: const [],
      );

      expect(fdcId, 42);
    });

    test('returns clear rule-based winner without OpenAI', () async {
      final fdcId = await USDAService.pickBestCandidate(
        foodName: 'banana',
        rankedReference: [
          UsdaCandidate(
            fdcId: 1,
            description: 'Bananas, raw',
            dataType: 'Foundation',
            score: 180,
          ),
          UsdaCandidate(
            fdcId: 2,
            description: 'Banana chips',
            dataType: 'Branded',
            score: 40,
          ),
        ],
        rankedGeneral: const [],
      );

      expect(fdcId, 1);
    });

    test('does not trust clear winner when primary food is irrelevant', () async {
      final fdcId = await USDAService.pickBestCandidate(
        foodName: 'milk',
        rankedReference: [
          UsdaCandidate(
            fdcId: 99,
            description: 'Cheese, ricotta, whole milk',
            dataType: 'Foundation',
            score: 200,
          ),
          UsdaCandidate(
            fdcId: 1,
            description: 'Milk, whole, 3.25% milkfat',
            dataType: 'Foundation',
            score: 120,
          ),
        ],
        rankedGeneral: const [],
      );

      expect(fdcId, 1);
    });
  });
}
