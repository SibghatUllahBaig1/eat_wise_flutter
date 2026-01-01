// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class DayOfTheWeekStruct extends BaseStruct {
  DayOfTheWeekStruct({
    String? day,
    String? abbreviated,
  })  : _day = day,
        _abbreviated = abbreviated;

  // "day" field.
  String? _day;
  String get day => _day ?? '';
  set day(String? val) => _day = val;

  bool hasDay() => _day != null;

  // "abbreviated" field.
  String? _abbreviated;
  String get abbreviated => _abbreviated ?? '';
  set abbreviated(String? val) => _abbreviated = val;

  bool hasAbbreviated() => _abbreviated != null;

  static DayOfTheWeekStruct fromMap(Map<String, dynamic> data) =>
      DayOfTheWeekStruct(
        day: data['day'] as String?,
        abbreviated: data['abbreviated'] as String?,
      );

  static DayOfTheWeekStruct? maybeFromMap(dynamic data) => data is Map
      ? DayOfTheWeekStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'day': _day,
        'abbreviated': _abbreviated,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'day': serializeParam(
          _day,
          ParamType.String,
        ),
        'abbreviated': serializeParam(
          _abbreviated,
          ParamType.String,
        ),
      }.withoutNulls;

  static DayOfTheWeekStruct fromSerializableMap(Map<String, dynamic> data) =>
      DayOfTheWeekStruct(
        day: deserializeParam(
          data['day'],
          ParamType.String,
          false,
        ),
        abbreviated: deserializeParam(
          data['abbreviated'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'DayOfTheWeekStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is DayOfTheWeekStruct &&
        day == other.day &&
        abbreviated == other.abbreviated;
  }

  @override
  int get hashCode => const ListEquality().hash([day, abbreviated]);
}

DayOfTheWeekStruct createDayOfTheWeekStruct({
  String? day,
  String? abbreviated,
}) =>
    DayOfTheWeekStruct(
      day: day,
      abbreviated: abbreviated,
    );
