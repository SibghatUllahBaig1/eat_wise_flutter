/// Canonical storage is always kg and cm; display follows tracker unit settings.
class ImperialHeight {
  const ImperialHeight({required this.feet, required this.inches});

  final int feet;
  final int inches;
}

class UnitFormatHelper {
  static const double _kgToLbs = 2.2046226218;
  static const double _cmToIn = 0.3937007874;

  static const double minHeightCm = 50;
  static const double maxHeightCm = 300;
  static const double minWeightKg = 1;
  static const double maxWeightKg = 500;

  static bool isLbs(String? unit) =>
      unit != null && unit.toLowerCase().contains('lb');

  static bool isFt(String? unit) =>
      unit != null &&
      (unit.toLowerCase().contains('ft') ||
          unit.toLowerCase().contains('feet'));

  // --- Weight ---

  static double kgToDisplay(double kg, String? unit) =>
      isLbs(unit) ? kg * _kgToLbs : kg;

  static double displayToKg(double value, String? unit) =>
      isLbs(unit) ? value / _kgToLbs : value;

  static String weightUnitLabel(String? unit) => isLbs(unit) ? 'lbs' : 'kg';

  static String formatWeight(
    double kg,
    String? unit, {
    int decimals = 1,
    bool includeUnit = true,
  }) {
    final display = kgToDisplay(kg, unit);
    final value = display.toStringAsFixed(decimals);
    return includeUnit ? '$value ${weightUnitLabel(unit)}' : value;
  }

  static String formatWeightForInput(double kg, String? unit) =>
      formatWeight(kg, unit, decimals: isLbs(unit) ? 1 : 1, includeUnit: false);

  static double? parseWeightInput(String text, String? unit) {
    final value = double.tryParse(text.trim());
    if (value == null || value <= 0) return null;
    return displayToKg(value, unit);
  }

  static bool isValidWeightKg(double? kg) =>
      kg != null && kg >= minWeightKg && kg <= maxWeightKg;

  static String weightValidationMessage(String? unit) {
    if (isLbs(unit)) {
      final min = kgToDisplay(minWeightKg, unit).round();
      final max = kgToDisplay(maxWeightKg, unit).round();
      return 'Please enter a valid weight ($min–$max lbs)';
    }
    return 'Please enter a valid weight (${minWeightKg.round()}–${maxWeightKg.round()} kg)';
  }

  // --- Height ---

  static String heightUnitLabel(String? unit) => isFt(unit) ? 'ft/in' : 'cm';

  static ImperialHeight cmToFeetInches(double cm) {
    final totalInches = (cm * _cmToIn).round();
    return ImperialHeight(
      feet: totalInches ~/ 12,
      inches: totalInches % 12,
    );
  }

  static double feetInchesToCm(int feet, int inches) {
    if (feet < 0 || inches < 0 || inches > 11) return 0;
    final totalInches = (feet * 12) + inches;
    return totalInches / _cmToIn;
  }

  static double? parseFeetInchesInput(String feetText, String inchesText) {
    final feet = int.tryParse(feetText.trim());
    final inches = int.tryParse(inchesText.trim());
    if (feet == null || inches == null) return null;
    if (feet < 0 || inches < 0 || inches > 11) return null;
    final cm = feetInchesToCm(feet, inches);
    return cm > 0 ? cm : null;
  }

  static double? parseHeightInput(String text, String? unit) {
    if (isFt(unit)) return null;
    final value = double.tryParse(text.trim());
    if (value == null || value <= 0) return null;
    return value;
  }

  static String formatHeight(double cm, String? unit) {
    if (isFt(unit)) {
      final imperial = cmToFeetInches(cm);
      return '${imperial.feet}\' ${imperial.inches}"';
    }
    return '${cm.round()} cm';
  }

  static String formatHeightCmForInput(double cm) =>
      cm > 0 ? cm.round().toString() : '';

  static bool isValidHeightCm(double? cm) =>
      cm != null && cm >= minHeightCm && cm <= maxHeightCm;

  static String heightValidationMessage(String? unit) {
    if (isFt(unit)) {
      final min = cmToFeetInches(minHeightCm);
      final max = cmToFeetInches(maxHeightCm);
      return 'Please enter a valid height '
          '(${min.feet} ft ${min.inches} in – ${max.feet} ft ${max.inches} in)';
    }
    return 'Please enter a valid height '
        '(${minHeightCm.round()}–${maxHeightCm.round()} cm)';
  }

  // --- BMI (always kg + cm) ---

  static double? calculateBmi({
    required double weightKg,
    required double heightCm,
  }) {
    if (weightKg <= 0 || heightCm <= 0) return null;
    final heightM = heightCm / 100.0;
    return weightKg / (heightM * heightM);
  }

  static String bmiCategory(double bmi) {
    if (bmi < 15) return 'Very Severely Underweight';
    if (bmi < 16) return 'Severely Underweight';
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    if (bmi < 40) return 'Obese Class II';
    return 'Obese Class III';
  }
}
