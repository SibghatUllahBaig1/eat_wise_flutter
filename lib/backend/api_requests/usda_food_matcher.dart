/// Rule-based USDA food candidate ranking and query building.
class UsdaCandidate {
  UsdaCandidate({
    required this.fdcId,
    required this.description,
    required this.dataType,
    this.brandName,
    this.score = 0,
  });

  final int fdcId;
  final String description;
  final String dataType;
  final String? brandName;
  double score;

  Map<String, dynamic> toMap() => {
        'fdcId': fdcId,
        'description': description,
        'dataType': dataType,
        if (brandName != null && brandName!.isNotEmpty) 'brandName': brandName,
      };
}

class UsdaFoodMatcher {
  static const clearWinnerGap = 25.0;
  static const maxProduceCaloriesPer100g = 200.0;

  static const _preparedKeywords = [
    'chips',
    'bread',
    'prepared',
    'fried',
    'dried',
    'canned',
    'mix',
    'snack',
    'baked',
    'roasted',
    'sweetened',
    'candy',
    'bar',
    'sauce',
    'juice',
    'smoothie',
    'packaged',
    'frozen meal',
  ];

  static const _rawKeywords = [
    'raw',
    'fresh',
    'whole',
    'peeled',
    'ripe',
  ];

  static const _wholeFoodStaples = [
    'milk',
    'egg',
    'cheese',
    'yogurt',
    'butter',
    'cream',
    'chicken',
    'beef',
    'pork',
    'fish',
    'salmon',
    'tuna',
    'rice',
    'oats',
    'oatmeal',
    'pasta',
    'flour',
    'honey',
  ];

  static const preferredSearchDataTypes = [
    'Foundation',
    'SR Legacy',
    'Survey (FNDDS)',
  ];

  /// Primary segments that conflict with a single-word staple query.
  static const _conflictingPrimariesForMilk = {
    'cheese',
    'yogurt',
    'butter',
    'cream',
    'ice cream',
    'kefir',
    'whey',
  };

  static const _produceCalorieRanges = {
    'banana': (50.0, 120.0),
    'apple': (40.0, 70.0),
    'orange': (40.0, 60.0),
    'grape': (60.0, 80.0),
    'strawberr': (25.0, 40.0),
    'blueberr': (50.0, 70.0),
    'carrot': (30.0, 50.0),
    'broccoli': (25.0, 45.0),
    'spinach': (15.0, 30.0),
    'tomato': (15.0, 25.0),
    'cucumber': (10.0, 20.0),
    'watermelon': (25.0, 40.0),
    'avocado': (140.0, 180.0),
    'potato': (70.0, 90.0),
    'rice': (120.0, 150.0),
  };

  /// Builds a USDA search query from food identification context.
  static String buildSearchQuery({
    required String foodName,
    String? description,
    String? userInput,
  }) {
    final context = _combinedContext(
      foodName: foodName,
      description: description,
      userInput: userInput,
    );

    if (_looksPreparedOrBranded(context)) {
      return foodName.trim();
    }

    if (_looksLikeWholeStaple(context)) {
      final trimmed = foodName.trim().toLowerCase();
      if (trimmed == 'milk') return 'milk whole';
      if (!trimmed.contains('whole') &&
          !trimmed.contains('raw') &&
          !trimmed.contains('skim') &&
          !trimmed.contains('2%') &&
          !trimmed.contains('1%')) {
        return '${foodName.trim()} whole';
      }
    }

    if (_looksLikeWholeProduce(context)) {
      final trimmed = foodName.trim();
      if (!trimmed.toLowerCase().contains('raw')) {
        return '$trimmed raw';
      }
    }

    return foodName.trim();
  }

  /// Parses the primary food name from a USDA description (before first comma).
  static String primarySegment(String description) {
    final segment = description.split(',').first.trim().toLowerCase();
    return segment;
  }

  /// True when the USDA entry's primary food matches the user's search keyword.
  static bool isRelevantPrimaryFood(String query, String description) {
    final normalizedQuery = _normalizeQuery(query);
    if (normalizedQuery.isEmpty) return true;

    final primary = primarySegment(description);
    if (primary.isEmpty) return false;

    if (_primaryMatchesQuery(primary, normalizedQuery)) {
      return true;
    }

    return _descriptionMatchesQuery(description.toLowerCase(), normalizedQuery);
  }

  /// Drops USDA hits whose primary food does not match the search keyword.
  static List<Map<String, dynamic>> filterRelevantResults(
    String query,
    List<Map<String, dynamic>> searchResults,
  ) {
    return searchResults
        .where((result) {
          final description = (result['description'] as String?) ?? '';
          return isRelevantPrimaryFood(query, description);
        })
        .toList();
  }

  static bool isReferenceDataType(String dataType) {
    return preferredSearchDataTypes.contains(dataType);
  }

  /// True when parsed nutrition contains usable macro/calorie data.
  static bool hasValidNutrition(Map<String, dynamic> nutritionData) {
    final calories = (nutritionData['calories'] as num?)?.toDouble() ?? 0;
    final protein = (nutritionData['protein'] as num?)?.toDouble() ?? 0;
    final carbs = (nutritionData['carbs'] as num?)?.toDouble() ?? 0;
    final fat = (nutritionData['fat'] as num?)?.toDouble() ?? 0;
    return calories > 0 || protein > 0 || carbs > 0 || fat > 0;
  }

  /// Scores and ranks USDA search results (highest score first).
  static List<UsdaCandidate> rankCandidates({
    required String foodName,
    required List<Map<String, dynamic>> searchResults,
    String? description,
    String? userInput,
  }) {
    final context = _combinedContext(
      foodName: foodName,
      description: description,
      userInput: userInput,
    );
    final looksLikeWholeFood = (_looksLikeWholeProduce(context) ||
            _looksLikeWholeStaple(context)) &&
        !_looksPreparedOrBranded(context);
    final queryTokens = _tokenize(foodName);
    final normalizedQuery = _normalizeQuery(foodName);

    final candidates = searchResults.map((result) {
      final candidate = UsdaCandidate(
        fdcId: result['fdcId'] as int,
        description: (result['description'] as String?) ?? '',
        dataType: (result['dataType'] as String?) ?? '',
        brandName: result['brandName'] as String?,
      );
      candidate.score = _scoreCandidate(
        candidate: candidate,
        queryTokens: queryTokens,
        normalizedQuery: normalizedQuery,
        looksLikeWholeFood: looksLikeWholeFood,
      );
      return candidate;
    }).toList();

    candidates.sort((a, b) => b.score.compareTo(a.score));
    return candidates;
  }

  /// True when the top candidate beats the second by [clearWinnerGap].
  static bool isClearWinner(List<UsdaCandidate> candidates) {
    if (candidates.isEmpty) return false;
    if (candidates.length == 1) return true;
    return candidates[0].score >= candidates[1].score + clearWinnerGap;
  }

  /// Validates calories per 100g against known produce ranges.
  static bool passesCalorieSanity({
    required String foodName,
    required double caloriesPer100g,
    String? description,
    String? userInput,
  }) {
    final context = _combinedContext(
      foodName: foodName,
      description: description,
      userInput: userInput,
    );

    if (_looksPreparedOrBranded(context)) {
      return true;
    }

    final lowerName = foodName.toLowerCase();
    for (final entry in _produceCalorieRanges.entries) {
      if (lowerName.contains(entry.key)) {
        return caloriesPer100g >= entry.value.$1 &&
            caloriesPer100g <= entry.value.$2;
      }
    }

    if (_looksLikeSingleIngredientProduce(context) &&
        caloriesPer100g > maxProduceCaloriesPer100g) {
      return false;
    }

    return true;
  }

  static String _combinedContext({
    required String foodName,
    String? description,
    String? userInput,
  }) {
    return '${foodName.toLowerCase()} '
        '${description?.toLowerCase() ?? ''} '
        '${userInput?.toLowerCase() ?? ''}';
  }

  static bool _looksPreparedOrBranded(String context) {
    return _preparedKeywords.any(context.contains);
  }

  static bool _looksLikeWholeStaple(String context) {
    if (_looksPreparedOrBranded(context)) return false;
    return _wholeFoodStaples.any(context.contains);
  }

  static bool _looksLikeWholeProduce(String context) {
    if (_rawKeywords.any(context.contains)) return true;

    // Single common produce word with no prepared cues.
    final tokens = _tokenize(context);
    if (tokens.length <= 3 && !_looksPreparedOrBranded(context)) {
      for (final produce in _produceCalorieRanges.keys) {
        if (context.contains(produce)) return true;
      }
    }
    return false;
  }

  static bool _looksLikeSingleIngredientProduce(String context) {
    if (_looksPreparedOrBranded(context)) return false;
    for (final produce in _produceCalorieRanges.keys) {
      if (context.contains(produce)) return true;
    }
    return false;
  }

  static String _normalizeQuery(String query) {
    return query
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\d+(?:\.\d+)?\s*(?:g|grams?|kg)\b'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static bool _primaryMatchesQuery(String primary, String normalizedQuery) {
    if (primary == normalizedQuery) return true;
    if (_matchesPlural(primary, normalizedQuery)) return true;

    final queryTokens =
        normalizedQuery.split(RegExp(r'\s+')).where((t) => t.length > 2);
    if (queryTokens.length > 1) {
      if (queryTokens.every((token) => _tokenMatchesInText(token, primary))) {
        return true;
      }
    }

    if (normalizedQuery == 'milk' && _conflictingPrimariesForMilk.contains(primary)) {
      return false;
    }

    if (normalizedQuery.length >= 3 && primary.startsWith(normalizedQuery)) {
      return true;
    }

    return false;
  }

  static bool _descriptionMatchesQuery(
    String descLower,
    String normalizedQuery,
  ) {
    final queryTokens =
        normalizedQuery.split(RegExp(r'\s+')).where((t) => t.length > 2).toList();
    if (queryTokens.length <= 1) return false;
    return queryTokens.every((token) => _tokenMatchesInText(token, descLower));
  }

  static bool _tokenMatchesInText(String token, String text) {
    if (text.contains(token)) return true;
    if (token == 'fries' && text.contains('fried')) return true;
    if (token == 'fried' && text.contains('fries')) return true;
    return false;
  }

  static bool _matchesPlural(String primary, String query) {
    if (primary == query) return true;
    if (primary == '${query}s') return true;
    if (query.endsWith('s') && primary == query.substring(0, query.length - 1)) {
      return true;
    }
    if (primary.endsWith('s') && query == primary.substring(0, primary.length - 1)) {
      return true;
    }
    if (primary.endsWith('es') && query == primary.substring(0, primary.length - 2)) {
      return true;
    }
    return false;
  }

  static double _scoreCandidate({
    required UsdaCandidate candidate,
    required List<String> queryTokens,
    required String normalizedQuery,
    required bool looksLikeWholeFood,
  }) {
    var score = 0.0;
    score += _dataTypeScore(candidate.dataType);

    final descLower = candidate.description.toLowerCase();
    final primary = primarySegment(candidate.description);

    if (isRelevantPrimaryFood(normalizedQuery, candidate.description)) {
      score += 50;
    } else {
      score -= 80;
    }
    for (final keyword in _rawKeywords) {
      if (descLower.contains(keyword)) {
        score += 25;
      }
    }

    var penalty = 0.0;
    for (final keyword in _preparedKeywords) {
      if (descLower.contains(keyword)) {
        penalty += 35;
      }
    }
    score -= penalty.clamp(0, 105).toDouble();

    score += _nameOverlapScore(queryTokens, descLower);

    if (looksLikeWholeFood &&
        candidate.brandName != null &&
        candidate.brandName!.trim().isNotEmpty) {
      score -= 20;
    }

    return score;
  }

  static double _dataTypeScore(String dataType) {
    switch (dataType) {
      case 'Foundation':
        return 100;
      case 'SR Legacy':
        return 80;
      case 'Survey (FNDDS)':
        return 60;
      case 'Branded':
        return 20;
      default:
        return 40;
    }
  }

  static double _nameOverlapScore(List<String> queryTokens, String description) {
    if (queryTokens.isEmpty) return 0;

    final descTokens = _tokenize(description);
    if (descTokens.isEmpty) return 0;

    final overlap =
        queryTokens.where((token) => descTokens.contains(token)).length;
    final ratio = overlap / queryTokens.length;
    return (ratio * 30).clamp(0, 30).toDouble();
  }

  static List<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((token) => token.length > 2)
        .toList();
  }
}
