import 'package:eat_wise/backend/api_requests/usda_search_option.dart';
import 'package:eat_wise/backend/api_requests/usda_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UsdaSearchOption', () {
    test('subtitle includes dataType and brand', () {
      const option = UsdaSearchOption(
        fdcId: 1,
        description: 'MILK',
        dataType: 'Branded',
        brandName: 'Acme Dairy',
      );

      expect(option.subtitle, 'Branded · Acme Dairy');
    });

    test('mapSearchResults converts raw USDA hits', () {
      final options = USDAService.mapSearchResults([
        {
          'fdcId': 123,
          'description': 'Bananas, raw',
          'dataType': 'Foundation',
          'brandName': null,
        },
      ]);

      expect(options.length, 1);
      expect(options.first.fdcId, 123);
      expect(options.first.description, 'Bananas, raw');
    });
  });
}
