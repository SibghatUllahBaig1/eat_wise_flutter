/// Parses explicit portion sizes from user-entered food descriptions.
class PortionParser {
  static final _gramsPattern = RegExp(
    r'(\d+(?:\.\d+)?)\s*(?:g|grams?)\b',
    caseSensitive: false,
  );

  static final _kgPattern = RegExp(
    r'(\d+(?:\.\d+)?)\s*kg\b',
    caseSensitive: false,
  );

  /// Returns grams when the user explicitly states a weight, otherwise null.
  static double? parseExplicitGrams(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    final kgMatch = _kgPattern.firstMatch(trimmed);
    if (kgMatch != null) {
      final kg = double.tryParse(kgMatch.group(1)!);
      if (kg != null && kg > 0) {
        return kg * 1000;
      }
    }

    final gramsMatch = _gramsPattern.firstMatch(trimmed);
    if (gramsMatch != null) {
      final grams = double.tryParse(gramsMatch.group(1)!);
      if (grams != null && grams > 0) {
        return grams;
      }
    }

    return null;
  }

  /// Removes an explicit gram/kg clause from the description for cleaner AI input.
  static String stripPortionClause(String text) {
    var cleaned = text.trim();
    cleaned = cleaned.replaceAll(_kgPattern, ' ');
    cleaned = cleaned.replaceAll(_gramsPattern, ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
    return cleaned;
  }
}
