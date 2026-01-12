// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NutrientStruct extends BaseStruct {
  NutrientStruct({
    double? mg,
    double? percentage,
  })  : _mg = mg,
        _percentage = percentage;

  // "mg" field.
  double? _mg;
  double get mg => _mg ?? 0.0;
  set mg(double? val) => _mg = val;
  void incrementMg(double amount) => mg = mg + amount;
  bool hasMg() => _mg != null;

  // "percentage" field.
  double? _percentage;
  double get percentage => _percentage ?? 0.0;
  set percentage(double? val) => _percentage = val;
  void incrementPercentage(double amount) => percentage = percentage + amount;
  bool hasPercentage() => _percentage != null;

  static NutrientStruct fromMap(Map<String, dynamic> data) => NutrientStruct(
        mg: castToType<double>(data['mg']),
        percentage: castToType<double>(data['percentage']),
      );

  static NutrientStruct? maybeFromMap(dynamic data) => data is Map
      ? NutrientStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mg': _mg,
        'percentage': _percentage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'mg': serializeParam(_mg, ParamType.double),
        'percentage': serializeParam(_percentage, ParamType.double),
      }.withoutNulls;

  static NutrientStruct fromSerializableMap(Map<String, dynamic> data) =>
      NutrientStruct(
        mg: deserializeParam(data['mg'], ParamType.double, false),
        percentage: deserializeParam(data['percentage'], ParamType.double, false),
      );

  @override
  String toString() => 'NutrientStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is NutrientStruct &&
        mg == other.mg &&
        percentage == other.percentage;
  }

  @override
  int get hashCode => const ListEquality().hash([mg, percentage]);
}

NutrientStruct createNutrientStruct({
  double? mg,
  double? percentage,
}) =>
    NutrientStruct(
      mg: mg,
      percentage: percentage,
    );

