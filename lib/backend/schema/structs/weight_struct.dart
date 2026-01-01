// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WeightStruct extends BaseStruct {
  WeightStruct({
    String? unit,
    double? value,
  })  : _unit = unit,
        _value = value;

  // "unit" field.
  String? _unit;
  String get unit => _unit ?? '';
  set unit(String? val) => _unit = val;

  bool hasUnit() => _unit != null;

  // "value" field.
  double? _value;
  double get value => _value ?? 0.0;
  set value(double? val) => _value = val;

  void incrementValue(double amount) => value = value + amount;

  bool hasValue() => _value != null;

  static WeightStruct fromMap(Map<String, dynamic> data) => WeightStruct(
        unit: data['unit'] as String?,
        value: castToType<double>(data['value']),
      );

  static WeightStruct? maybeFromMap(dynamic data) =>
      data is Map ? WeightStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'unit': _unit,
        'value': _value,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'unit': serializeParam(
          _unit,
          ParamType.String,
        ),
        'value': serializeParam(
          _value,
          ParamType.double,
        ),
      }.withoutNulls;

  static WeightStruct fromSerializableMap(Map<String, dynamic> data) =>
      WeightStruct(
        unit: deserializeParam(
          data['unit'],
          ParamType.String,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'WeightStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is WeightStruct && unit == other.unit && value == other.value;
  }

  @override
  int get hashCode => const ListEquality().hash([unit, value]);
}

WeightStruct createWeightStruct({
  String? unit,
  double? value,
}) =>
    WeightStruct(
      unit: unit,
      value: value,
    );
