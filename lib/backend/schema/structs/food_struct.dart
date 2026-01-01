// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FoodStruct extends BaseStruct {
  FoodStruct({
    String? title,
    int? kcal,
    int? gram,
  })  : _title = title,
        _kcal = kcal,
        _gram = gram;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "kcal" field.
  int? _kcal;
  int get kcal => _kcal ?? 0;
  set kcal(int? val) => _kcal = val;

  void incrementKcal(int amount) => kcal = kcal + amount;

  bool hasKcal() => _kcal != null;

  // "gram" field.
  int? _gram;
  int get gram => _gram ?? 0;
  set gram(int? val) => _gram = val;

  void incrementGram(int amount) => gram = gram + amount;

  bool hasGram() => _gram != null;

  static FoodStruct fromMap(Map<String, dynamic> data) => FoodStruct(
        title: data['title'] as String?,
        kcal: castToType<int>(data['kcal']),
        gram: castToType<int>(data['gram']),
      );

  static FoodStruct? maybeFromMap(dynamic data) =>
      data is Map ? FoodStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'kcal': _kcal,
        'gram': _gram,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'kcal': serializeParam(
          _kcal,
          ParamType.int,
        ),
        'gram': serializeParam(
          _gram,
          ParamType.int,
        ),
      }.withoutNulls;

  static FoodStruct fromSerializableMap(Map<String, dynamic> data) =>
      FoodStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        kcal: deserializeParam(
          data['kcal'],
          ParamType.int,
          false,
        ),
        gram: deserializeParam(
          data['gram'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'FoodStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is FoodStruct &&
        title == other.title &&
        kcal == other.kcal &&
        gram == other.gram;
  }

  @override
  int get hashCode => const ListEquality().hash([title, kcal, gram]);
}

FoodStruct createFoodStruct({
  String? title,
  int? kcal,
  int? gram,
}) =>
    FoodStruct(
      title: title,
      kcal: kcal,
      gram: gram,
    );
