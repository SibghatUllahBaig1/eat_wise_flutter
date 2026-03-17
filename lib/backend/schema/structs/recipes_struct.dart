// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RecipesStruct extends BaseStruct {
  RecipesStruct({
    String? name,
    String? description,
    String? imageUrl,
    List<String>? ingredients,
    List<String>? instructions,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    int? time,
    String? difficulty,
    List<String>? dietCategories,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? grams,
    NutrientStruct? cholesterol,
    NutrientStruct? sodium,
    MineralsStruct? minerals,
  })  : _name = name,
        _description = description,
        _imageUrl = imageUrl,
        _ingredients = ingredients,
        _instructions = instructions,
        _calories = calories,
        _protein = protein,
        _carbs = carbs,
        _fat = fat,
        _time = time,
        _difficulty = difficulty,
        _dietCategories = dietCategories,
        _createdAt = createdAt,
        _updatedAt = updatedAt,
        _grams = grams,
        _cholesterol = cholesterol,
        _sodium = sodium,
        _minerals = minerals;

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  set name(String? val) => _name = val;

  bool hasName() => _name != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  // "imageUrl" field.
  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  set imageUrl(String? val) => _imageUrl = val;

  bool hasImageUrl() => _imageUrl != null;

  // "ingredients" field.
  List<String>? _ingredients;
  List<String> get ingredients => _ingredients ?? const [];
  set ingredients(List<String>? val) => _ingredients = val;

  void updateIngredients(Function(List<String>) updateFn) {
    updateFn(_ingredients ??= []);
  }

  bool hasIngredients() => _ingredients != null;

  // "instructions" field.
  List<String>? _instructions;
  List<String> get instructions => _instructions ?? const [];
  set instructions(List<String>? val) => _instructions = val;

  void updateInstructions(Function(List<String>) updateFn) {
    updateFn(_instructions ??= []);
  }

  bool hasInstructions() => _instructions != null;

  // "calories" field.
  int? _calories;
  int get calories => _calories ?? 0;
  set calories(int? val) => _calories = val;

  void incrementCalories(int amount) => calories = calories + amount;

  bool hasCalories() => _calories != null;

  // "protein" field.
  double? _protein;
  double get protein => _protein ?? 0.0;
  set protein(double? val) => _protein = val;

  bool hasProtein() => _protein != null;

  // "carbs" field.
  double? _carbs;
  double get carbs => _carbs ?? 0.0;
  set carbs(double? val) => _carbs = val;

  bool hasCarbs() => _carbs != null;

  // "fat" field.
  double? _fat;
  double get fat => _fat ?? 0.0;
  set fat(double? val) => _fat = val;

  bool hasFat() => _fat != null;

  // "time" field.
  int? _time;
  int get time => _time ?? 0;
  set time(int? val) => _time = val;

  bool hasTime() => _time != null;

  // "difficulty" field.
  String? _difficulty;
  String get difficulty => _difficulty ?? '';
  set difficulty(String? val) => _difficulty = val;

  bool hasDifficulty() => _difficulty != null;

  // "dietCategories" field.
  List<String>? _dietCategories;
  List<String> get dietCategories => _dietCategories ?? const [];
  set dietCategories(List<String>? val) => _dietCategories = val;

  void updateDietCategories(Function(List<String>) updateFn) {
    updateFn(_dietCategories ??= []);
  }

  bool hasDietCategories() => _dietCategories != null;

  // "createdAt" field.
  DateTime? _createdAt;
  DateTime? get createdAt => _createdAt;
  set createdAt(DateTime? val) => _createdAt = val;

  bool hasCreatedAt() => _createdAt != null;

  // "updatedAt" field.
  DateTime? _updatedAt;
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(DateTime? val) => _updatedAt = val;

  bool hasUpdatedAt() => _updatedAt != null;

  // "grams" field.
  double? _grams;
  double get grams => _grams ?? 0.0;
  set grams(double? val) => _grams = val;

  bool hasGrams() => _grams != null;

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

  static RecipesStruct fromMap(Map<String, dynamic> data) => RecipesStruct(
        name: data['name'] as String?,
        description: data['description'] as String?,
        imageUrl: data['imageUrl'] as String?,
        ingredients: getDataList(data['ingredients']),
        instructions: getDataList(data['instructions']),
        calories: castToType<int>(data['calories']),
        protein: castToType<double>(data['protein']),
        carbs: castToType<double>(data['carbs']),
        fat: castToType<double>(data['fat']),
        time: castToType<int>(data['time']),
        difficulty: data['difficulty'] as String?,
        dietCategories: getDataList(data['dietCategories']),
        createdAt: data['createdAt'] as DateTime?,
        updatedAt: data['updatedAt'] as DateTime?,
        grams: castToType<double>(data['grams']),
        cholesterol: NutrientStruct.maybeFromMap(data['cholesterol']),
        sodium: NutrientStruct.maybeFromMap(data['sodium']),
        minerals: MineralsStruct.maybeFromMap(data['minerals']),
      );

  static RecipesStruct? maybeFromMap(dynamic data) =>
      data is Map ? RecipesStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'name': _name,
        'description': _description,
        'imageUrl': _imageUrl,
        'ingredients': _ingredients,
        'instructions': _instructions,
        'calories': _calories,
        'protein': _protein,
        'carbs': _carbs,
        'fat': _fat,
        'time': _time,
        'difficulty': _difficulty,
        'dietCategories': _dietCategories,
        'createdAt': _createdAt,
        'updatedAt': _updatedAt,
        'grams': _grams,
        'cholesterol': _cholesterol?.toMap(),
        'sodium': _sodium?.toMap(),
        'minerals': _minerals?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'name': serializeParam(
          _name,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
        'imageUrl': serializeParam(
          _imageUrl,
          ParamType.String,
        ),
        'ingredients': serializeParam(
          _ingredients,
          ParamType.String,
          isList: true,
        ),
        'instructions': serializeParam(
          _instructions,
          ParamType.String,
          isList: true,
        ),
        'calories': serializeParam(
          _calories,
          ParamType.int,
        ),
        'protein': serializeParam(
          _protein,
          ParamType.double,
        ),
        'carbs': serializeParam(
          _carbs,
          ParamType.double,
        ),
        'fat': serializeParam(
          _fat,
          ParamType.double,
        ),
        'time': serializeParam(
          _time,
          ParamType.int,
        ),
        'difficulty': serializeParam(
          _difficulty,
          ParamType.String,
        ),
        'dietCategories': serializeParam(
          _dietCategories,
          ParamType.String,
          isList: true,
        ),
        'createdAt': serializeParam(
          _createdAt,
          ParamType.DateTime,
        ),
        'updatedAt': serializeParam(
          _updatedAt,
          ParamType.DateTime,
        ),
        'grams': serializeParam(
          _grams,
          ParamType.double,
        ),
        'cholesterol': serializeParam(
          _cholesterol,
          ParamType.DataStruct,
        ),
        'sodium': serializeParam(
          _sodium,
          ParamType.DataStruct,
        ),
        'minerals': serializeParam(
          _minerals,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static RecipesStruct fromSerializableMap(Map<String, dynamic> data) =>
      RecipesStruct(
        name: deserializeParam(
          data['name'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
        imageUrl: deserializeParam(
          data['imageUrl'],
          ParamType.String,
          false,
        ),
        ingredients: deserializeParam<String>(
          data['ingredients'],
          ParamType.String,
          true,
        ),
        instructions: deserializeParam<String>(
          data['instructions'],
          ParamType.String,
          true,
        ),
        calories: deserializeParam(
          data['calories'],
          ParamType.int,
          false,
        ),
        protein: deserializeParam(
          data['protein'],
          ParamType.double,
          false,
        ),
        carbs: deserializeParam(
          data['carbs'],
          ParamType.double,
          false,
        ),
        fat: deserializeParam(
          data['fat'],
          ParamType.double,
          false,
        ),
        time: deserializeParam(
          data['time'],
          ParamType.int,
          false,
        ),
        difficulty: deserializeParam(
          data['difficulty'],
          ParamType.String,
          false,
        ),
        dietCategories: deserializeParam<String>(
          data['dietCategories'],
          ParamType.String,
          true,
        ),
        createdAt: deserializeParam(
          data['createdAt'],
          ParamType.DateTime,
          false,
        ),
        updatedAt: deserializeParam(
          data['updatedAt'],
          ParamType.DateTime,
          false,
        ),
        grams: deserializeParam(
          data['grams'],
          ParamType.double,
          false,
        ),
        cholesterol: deserializeStructParam(
          data['cholesterol'],
          ParamType.DataStruct,
          false,
          structBuilder: NutrientStruct.fromSerializableMap,
        ),
        sodium: deserializeStructParam(
          data['sodium'],
          ParamType.DataStruct,
          false,
          structBuilder: NutrientStruct.fromSerializableMap,
        ),
        minerals: deserializeStructParam(
          data['minerals'],
          ParamType.DataStruct,
          false,
          structBuilder: MineralsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'RecipesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is RecipesStruct &&
        name == other.name &&
        description == other.description &&
        imageUrl == other.imageUrl &&
        listEquality.equals(ingredients, other.ingredients) &&
        listEquality.equals(instructions, other.instructions) &&
        calories == other.calories &&
        protein == other.protein &&
        carbs == other.carbs &&
        fat == other.fat &&
        time == other.time &&
        difficulty == other.difficulty &&
        listEquality.equals(dietCategories, other.dietCategories) &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        grams == other.grams &&
        cholesterol == other.cholesterol &&
        sodium == other.sodium &&
        minerals == other.minerals;
  }

  @override
  int get hashCode => const ListEquality().hash([
        name,
        description,
        imageUrl,
        ingredients,
        instructions,
        calories,
        protein,
        carbs,
        fat,
        time,
        difficulty,
        dietCategories,
        createdAt,
        updatedAt,
        grams,
        cholesterol,
        sodium,
        minerals,
      ]);
}

RecipesStruct createRecipesStruct({
  String? name,
  String? description,
  String? imageUrl,
  List<String>? ingredients,
  List<String>? instructions,
  int? calories,
  double? protein,
  double? carbs,
  double? fat,
  int? time,
  String? difficulty,
  List<String>? dietCategories,
  DateTime? createdAt,
  DateTime? updatedAt,
  double? grams,
  NutrientStruct? cholesterol,
  NutrientStruct? sodium,
  MineralsStruct? minerals,
}) =>
    RecipesStruct(
      name: name,
      description: description,
      imageUrl: imageUrl,
      ingredients: ingredients,
      instructions: instructions,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      time: time,
      difficulty: difficulty,
      dietCategories: dietCategories,
      createdAt: createdAt,
      updatedAt: updatedAt,
      grams: grams,
      cholesterol: cholesterol,
      sodium: sodium,
      minerals: minerals,
    );
