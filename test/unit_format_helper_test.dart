import 'package:eat_wise/backend/utils/unit_format_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UnitFormatHelper height', () {
    test('179 cm converts to 5 ft 10 in', () {
      final imperial = UnitFormatHelper.cmToFeetInches(179);
      expect(imperial.feet, 5);
      expect(imperial.inches, 10);
    });

    test('180 cm converts to 5 ft 11 in', () {
      final imperial = UnitFormatHelper.cmToFeetInches(180);
      expect(imperial.feet, 5);
      expect(imperial.inches, 11);
    });

    test('183 cm converts to 6 ft 0 in', () {
      final imperial = UnitFormatHelper.cmToFeetInches(183);
      expect(imperial.feet, 6);
      expect(imperial.inches, 0);
    });

    test('feet and inches round-trip to cm', () {
      final cm = UnitFormatHelper.feetInchesToCm(5, 10);
      expect(cm, closeTo(177.8, 0.5));
    });

    test('parseFeetInchesInput returns canonical cm', () {
      final cm = UnitFormatHelper.parseFeetInchesInput('5', '10');
      expect(cm, isNotNull);
      expect(cm!, closeTo(177.8, 0.5));
    });

    test('formatHeight shows imperial correctly', () {
      expect(
        UnitFormatHelper.formatHeight(179, 'ft'),
        "5' 10\"",
      );
    });
  });

  group('UnitFormatHelper weight', () {
    test('72 kg converts to lbs', () {
      final lbs = UnitFormatHelper.kgToDisplay(72, 'lbs');
      expect(lbs, closeTo(158.7, 0.1));
    });

    test('weight round-trip kg -> lbs -> kg', () {
      const kg = 72.0;
      final lbs = UnitFormatHelper.kgToDisplay(kg, 'lbs');
      final back = UnitFormatHelper.displayToKg(lbs, 'lbs');
      expect(back, closeTo(kg, 0.01));
    });

    test('parseWeightInput returns canonical kg', () {
      final kg = UnitFormatHelper.parseWeightInput('158.7', 'lbs');
      expect(kg, isNotNull);
      expect(kg!, closeTo(72, 0.1));
    });
  });

  group('UnitFormatHelper BMI', () {
    test('calculateBmi with canonical values', () {
      final bmi = UnitFormatHelper.calculateBmi(
        weightKg: 72,
        heightCm: 179,
      );
      expect(bmi, isNotNull);
      expect(bmi!, closeTo(22.5, 0.5));
    });
  });
}
