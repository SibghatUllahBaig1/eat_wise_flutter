// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoodNutritionStruct extends BaseStruct {
  FoodNutritionStruct({
    String? foodName,
    double? grams,
    double? calories,
    MacrosStruct? macros,
    NutrientStruct? cholesterol,
    NutrientStruct? sodium,
    MineralsStruct? minerals,
    String? imageUrl,
    DateTime? timestamp,
    double? confidence,
    String? mealId,
  })  : _foodName = foodName,
        _grams = grams,
        _calories = calories,
        _macros = macros,
        _cholesterol = cholesterol,
        _sodium = sodium,
        _minerals = minerals,
        _imageUrl = imageUrl,
        _timestamp = timestamp,
        _confidence = confidence,
        _mealId = mealId;

  // "foodName" field.
  String? _foodName;
  String get foodName => _foodName ?? '';
  set foodName(String? val) => _foodName = val;
  bool hasFoodName() => _foodName != null;

  // "grams" field.
  double? _grams;
  double get grams => _grams ?? 0.0;
  set grams(double? val) => _grams = val;
  void incrementGrams(double amount) => grams = grams + amount;
  bool hasGrams() => _grams != null;

  // "calories" field.
  double? _calories;
  double get calories => _calories ?? 0.0;
  set calories(double? val) => _calories = val;
  void incrementCalories(double amount) => calories = calories + amount;
  bool hasCalories() => _calories != null;

  // "macros" field.
  MacrosStruct? _macros;
  MacrosStruct get macros => _macros ?? MacrosStruct();
  set macros(MacrosStruct? val) => _macros = val;
  void updateMacros(Function(MacrosStruct) updateFn) {
    updateFn(_macros ??= MacrosStruct());
  }

  bool hasMacros() => _macros != null;

  // "cholesterol" field.
  NutrientStruct? _cholesterol;
  NutrientStruct get cholesterol => _cholesterol ?? NutrientStruct();
  set cholesterol(NutrientStruct? val) => _cholesterol = val;
  void updateCholesterol(Function(NutrientStruct) updateFn) {
    updateFn(_cholesterol ??= NutrientStruct());
  }

  bool hasCholesterol() => _cholesterol != null;

  // "sodium" field.
  NutrientStruct? _sodium;
  NutrientStruct get sodium => _sodium ?? NutrientStruct();
  set sodium(NutrientStruct? val) => _sodium = val;
  void updateSodium(Function(NutrientStruct) updateFn) {
    updateFn(_sodium ??= NutrientStruct());
  }

  bool hasSodium() => _sodium != null;

  // "minerals" field.
  MineralsStruct? _minerals;
  MineralsStruct get minerals => _minerals ?? MineralsStruct();
  set minerals(MineralsStruct? val) => _minerals = val;
  void updateMinerals(Function(MineralsStruct) updateFn) {
    updateFn(_minerals ??= MineralsStruct());
  }

  bool hasMinerals() => _minerals != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;
  bool hasImageUrl() => _imageUrl != null;

  // "timestamp" field.
  DateTime? _timestamp;
  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? val) => _timestamp = val;
  bool hasTimestamp() => _timestamp != null;

  // "confidence" field.
  double? _confidence;
  double get confidence => _confidence ?? 0.0;
  set confidence(double? val) => _confidence = val;
  void incrementConfidence(double amount) => confidence = confidence + amount;
  bool hasConfidence() => _confidence != null;

  // "mealId" field.
  String? _mealId;
  String get mealId => _mealId ?? '';
  set mealId(String? val) => _mealId = val;
  bool hasMealId() => _mealId != null;

  static FoodNutritionStruct fromMap(Map<String, dynamic> data) =>
      FoodNutritionStruct(
        foodName: data['foodName'] as String?,
        grams: castToType<double>(data['grams']),
        calories: castToType<double>(data['calories']),
        macros: MacrosStruct.maybeFromMap(data['macros']),
        cholesterol: NutrientStruct.maybeFromMap(data['cholesterol']),
        sodium: NutrientStruct.maybeFromMap(data['sodium']),
        minerals: MineralsStruct.maybeFromMap(data['minerals']),
        imageUrl: data['imageUrl'] as String?,
        timestamp: data['timestamp'] as DateTime?,
        confidence: castToType<double>(data['confidence']),
        mealId: data['mealId'] as String?,
      );

  static FoodNutritionStruct? maybeFromMap(dynamic data) => data is Map
      ? FoodNutritionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'foodName': _foodName,
        'grams': _grams,
        'calories': _calories,
        'macros': _macros?.toMap(),
        'cholesterol': _cholesterol?.toMap(),
        'sodium': _sodium?.toMap(),
        'minerals': _minerals?.toMap(),
        'imageUrl': _imageUrl,
        'timestamp': _timestamp,
        'confidence': _confidence,
        'mealId': _mealId,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'foodName': serializeParam(_foodName, ParamType.String),
        'grams': serializeParam(_grams, ParamType.double),
        'calories': serializeParam(_calories, ParamType.double),
        'macros': serializeParam(_macros, ParamType.DataStruct),
        'cholesterol': serializeParam(_cholesterol, ParamType.DataStruct),
        'sodium': serializeParam(_sodium, ParamType.DataStruct),
        'minerals': serializeParam(_minerals, ParamType.DataStruct),
        'imageUrl': serializeParam(_imageUrl, ParamType.String),
        'timestamp': serializeParam(_timestamp, ParamType.DateTime),
        'confidence': serializeParam(_confidence, ParamType.double),
        'mealId': serializeParam(_mealId, ParamType.String),
      }.withoutNulls;

  static FoodNutritionStruct fromSerializableMap(Map<String, dynamic> data) =>
      FoodNutritionStruct(
        foodName: deserializeParam(data['foodName'], ParamType.String, false),
        grams: deserializeParam(data['grams'], ParamType.double, false),
        calories: deserializeParam(data['calories'], ParamType.double, false),
        macros: deserializeStructParam(
            data['macros'], ParamType.DataStruct, false,
            structBuilder: MacrosStruct.fromSerializableMap),
        cholesterol: deserializeStructParam(
            data['cholesterol'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        sodium: deserializeStructParam(
            data['sodium'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        minerals: deserializeStructParam(
            data['minerals'], ParamType.DataStruct, false,
            structBuilder: MineralsStruct.fromSerializableMap),
        imageUrl: deserializeParam(data['imageUrl'], ParamType.String, false),
        timestamp:
            deserializeParam(data['timestamp'], ParamType.DateTime, false),
        confidence:
            deserializeParam(data['confidence'], ParamType.double, false),
        mealId: deserializeParam(data['mealId'], ParamType.String, false),
      );

  @override
  String toString() => 'FoodNutritionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FoodNutritionStruct &&
        foodName == other.foodName &&
        grams == other.grams &&
        calories == other.calories &&
        macros == other.macros &&
        cholesterol == other.cholesterol &&
        sodium == other.sodium &&
        minerals == other.minerals &&
        imageUrl == other.imageUrl &&
        timestamp == other.timestamp &&
        confidence == other.confidence &&
        mealId == other.mealId;
  }

  @override
  int get hashCode => const ListEquality().hash([
        foodName,
        grams,
        calories,
        macros,
        cholesterol,
        sodium,
        minerals,
        imageUrl,
        timestamp,
        confidence,
        mealId
      ]);
}

FoodNutritionStruct createFoodNutritionStruct({
  String? foodName,
  double? grams,
  double? calories,
  MacrosStruct? macros,
  NutrientStruct? cholesterol,
  NutrientStruct? sodium,
  MineralsStruct? minerals,
  String? imageUrl,
  DateTime? timestamp,
  double? confidence,
  String? mealId,
}) =>
    FoodNutritionStruct(
      foodName: foodName,
      grams: grams,
      calories: calories,
      macros: macros,
      cholesterol: cholesterol,
      sodium: sodium,
      minerals: minerals,
      imageUrl: imageUrl,
      timestamp: timestamp,
      confidence: confidence,
      mealId: mealId,
    );
