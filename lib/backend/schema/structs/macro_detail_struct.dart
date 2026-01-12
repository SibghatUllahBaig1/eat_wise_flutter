// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MacroDetailStruct extends BaseStruct {
  MacroDetailStruct({
    double? grams,
    double? percentage,
  })  : _grams = grams,
        _percentage = percentage;

  // "grams" field.
  double? _grams;
  double get grams => _grams ?? 0.0;
  set grams(double? val) => _grams = val;
  void incrementGrams(double amount) => grams = grams + amount;
  bool hasGrams() => _grams != null;

  // "percentage" field.
  double? _percentage;
  double get percentage => _percentage ?? 0.0;
  set percentage(double? val) => _percentage = val;
  void incrementPercentage(double amount) => percentage = percentage + amount;
  bool hasPercentage() => _percentage != null;

  static MacroDetailStruct fromMap(Map<String, dynamic> data) =>
      MacroDetailStruct(
        grams: castToType<double>(data['grams']),
        percentage: castToType<double>(data['percentage']),
      );

  static MacroDetailStruct? maybeFromMap(dynamic data) => data is Map
      ? MacroDetailStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'grams': _grams,
        'percentage': _percentage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'grams': serializeParam(_grams, ParamType.double),
        'percentage': serializeParam(_percentage, ParamType.double),
      }.withoutNulls;

  static MacroDetailStruct fromSerializableMap(Map<String, dynamic> data) =>
      MacroDetailStruct(
        grams: deserializeParam(data['grams'], ParamType.double, false),
        percentage: deserializeParam(data['percentage'], ParamType.double, false),
      );

  @override
  String toString() => 'MacroDetailStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MacroDetailStruct &&
        grams == other.grams &&
        percentage == other.percentage;
  }

  @override
  int get hashCode => const ListEquality().hash([grams, percentage]);
}

MacroDetailStruct createMacroDetailStruct({
  double? grams,
  double? percentage,
}) =>
    MacroDetailStruct(
      grams: grams,
      percentage: percentage,
    );

