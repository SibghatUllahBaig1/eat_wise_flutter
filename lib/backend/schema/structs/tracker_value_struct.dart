// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TrackerValueStruct extends BaseStruct {
  TrackerValueStruct({
    double? progress,
    int? value,
    String? unit,
    DateTime? date,
  })  : _progress = progress,
        _value = value,
        _unit = unit,
        _date = date;

  // "progress" field.
  double? _progress;
  double get progress => _progress ?? 0.0;
  set progress(double? val) => _progress = val;

  void incrementProgress(double amount) => progress = progress + amount;

  bool hasProgress() => _progress != null;

  // "value" field.
  int? _value;
  int get value => _value ?? 0;
  set value(int? val) => _value = val;

  void incrementValue(int amount) => value = value + amount;

  bool hasValue() => _value != null;

  // "unit" field.
  String? _unit;
  String get unit => _unit ?? '';
  set unit(String? val) => _unit = val;

  bool hasUnit() => _unit != null;

  // "date" field.
  DateTime? _date;
  DateTime? get date => _date;
  set date(DateTime? val) => _date = val;

  bool hasDate() => _date != null;

  static TrackerValueStruct fromMap(Map<String, dynamic> data) =>
      TrackerValueStruct(
        progress: castToType<double>(data['progress']),
        value: castToType<int>(data['value']),
        unit: data['unit'] as String?,
        date: data['date'] as DateTime?,
      );

  static TrackerValueStruct? maybeFromMap(dynamic data) => data is Map
      ? TrackerValueStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'progress': _progress,
        'value': _value,
        'unit': _unit,
        'date': _date,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'progress': serializeParam(
          _progress,
          ParamType.double,
        ),
        'value': serializeParam(
          _value,
          ParamType.int,
        ),
        'unit': serializeParam(
          _unit,
          ParamType.String,
        ),
        'date': serializeParam(
          _date,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static TrackerValueStruct fromSerializableMap(Map<String, dynamic> data) =>
      TrackerValueStruct(
        progress: deserializeParam(
          data['progress'],
          ParamType.double,
          false,
        ),
        value: deserializeParam(
          data['value'],
          ParamType.int,
          false,
        ),
        unit: deserializeParam(
          data['unit'],
          ParamType.String,
          false,
        ),
        date: deserializeParam(
          data['date'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'TrackerValueStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TrackerValueStruct &&
        progress == other.progress &&
        value == other.value &&
        unit == other.unit &&
        date == other.date;
  }

  @override
  int get hashCode => const ListEquality().hash([progress, value, unit, date]);
}

TrackerValueStruct createTrackerValueStruct({
  double? progress,
  int? value,
  String? unit,
  DateTime? date,
}) =>
    TrackerValueStruct(
      progress: progress,
      value: value,
      unit: unit,
      date: date,
    );
