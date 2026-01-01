// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutritionStruct extends BaseStruct {
  NutritionStruct({
    int? day,
    int? carbs,
    int? protein,
    int? fat,
  })  : _day = day,
        _carbs = carbs,
        _protein = protein,
        _fat = fat;

  // "day" field.
  int? _day;
  int get day => _day ?? 0;
  set day(int? val) => _day = val;

  void incrementDay(int amount) => day = day + amount;

  bool hasDay() => _day != null;

  // "carbs" field.
  int? _carbs;
  int get carbs => _carbs ?? 0;
  set carbs(int? val) => _carbs = val;

  void incrementCarbs(int amount) => carbs = carbs + amount;

  bool hasCarbs() => _carbs != null;

  // "protein" field.
  int? _protein;
  int get protein => _protein ?? 0;
  set protein(int? val) => _protein = val;

  void incrementProtein(int amount) => protein = protein + amount;

  bool hasProtein() => _protein != null;

  // "fat" field.
  int? _fat;
  int get fat => _fat ?? 0;
  set fat(int? val) => _fat = val;

  void incrementFat(int amount) => fat = fat + amount;

  bool hasFat() => _fat != null;

  static NutritionStruct fromMap(Map<String, dynamic> data) => NutritionStruct(
        day: castToType<int>(data['day']),
        carbs: castToType<int>(data['carbs']),
        protein: castToType<int>(data['protein']),
        fat: castToType<int>(data['fat']),
      );

  static NutritionStruct? maybeFromMap(dynamic data) => data is Map
      ? NutritionStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'day': _day,
        'carbs': _carbs,
        'protein': _protein,
        'fat': _fat,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'day': serializeParam(
          _day,
          ParamType.int,
        ),
        'carbs': serializeParam(
          _carbs,
          ParamType.int,
        ),
        'protein': serializeParam(
          _protein,
          ParamType.int,
        ),
        'fat': serializeParam(
          _fat,
          ParamType.int,
        ),
      }.withoutNulls;

  static NutritionStruct fromSerializableMap(Map<String, dynamic> data) =>
      NutritionStruct(
        day: deserializeParam(
          data['day'],
          ParamType.int,
          false,
        ),
        carbs: deserializeParam(
          data['carbs'],
          ParamType.int,
          false,
        ),
        protein: deserializeParam(
          data['protein'],
          ParamType.int,
          false,
        ),
        fat: deserializeParam(
          data['fat'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'NutritionStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NutritionStruct &&
        day == other.day &&
        carbs == other.carbs &&
        protein == other.protein &&
        fat == other.fat;
  }

  @override
  int get hashCode => const ListEquality().hash([day, carbs, protein, fat]);
}

NutritionStruct createNutritionStruct({
  int? day,
  int? carbs,
  int? protein,
  int? fat,
}) =>
    NutritionStruct(
      day: day,
      carbs: carbs,
      protein: protein,
      fat: fat,
    );
