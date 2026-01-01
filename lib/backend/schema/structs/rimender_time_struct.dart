// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class RimenderTimeStruct extends BaseStruct {
  RimenderTimeStruct({
    String? hour,
    String? min,
    String? type,
  })  : _hour = hour,
        _min = min,
        _type = type;

  // "hour" field.
  String? _hour;
  String get hour => _hour ?? '';
  set hour(String? val) => _hour = val;

  bool hasHour() => _hour != null;

  // "min" field.
  String? _min;
  String get min => _min ?? '';
  set min(String? val) => _min = val;

  bool hasMin() => _min != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  static RimenderTimeStruct fromMap(Map<String, dynamic> data) =>
      RimenderTimeStruct(
        hour: data['hour'] as String?,
        min: data['min'] as String?,
        type: data['type'] as String?,
      );

  static RimenderTimeStruct? maybeFromMap(dynamic data) => data is Map
      ? RimenderTimeStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'hour': _hour,
        'min': _min,
        'type': _type,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'hour': serializeParam(
          _hour,
          ParamType.String,
        ),
        'min': serializeParam(
          _min,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
      }.withoutNulls;

  static RimenderTimeStruct fromSerializableMap(Map<String, dynamic> data) =>
      RimenderTimeStruct(
        hour: deserializeParam(
          data['hour'],
          ParamType.String,
          false,
        ),
        min: deserializeParam(
          data['min'],
          ParamType.String,
          false,
        ),
        type: deserializeParam(
          data['type'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'RimenderTimeStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is RimenderTimeStruct &&
        hour == other.hour &&
        min == other.min &&
        type == other.type;
  }

  @override
  int get hashCode => const ListEquality().hash([hour, min, type]);
}

RimenderTimeStruct createRimenderTimeStruct({
  String? hour,
  String? min,
  String? type,
}) =>
    RimenderTimeStruct(
      hour: hour,
      min: min,
      type: type,
    );
