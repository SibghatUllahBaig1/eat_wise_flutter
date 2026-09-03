import 'package:eat_wise/backend/api_requests/portion_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PortionParser', () {
    test('parseExplicitGrams handles decimal grams', () {
      expect(PortionParser.parseExplicitGrams('52.5g apple'), 52.5);
    });

    test('parseExplicitGrams prefers first match in text', () {
      expect(PortionParser.parseExplicitGrams('50g banana and 100g apple'), 50);
    });
  });
}
