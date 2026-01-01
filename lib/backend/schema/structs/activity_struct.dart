// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ActivityStruct extends BaseStruct {
  ActivityStruct({
    String? title,
    String? description,
  })  : _title = title,
        _description = description;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "description" field.
  String? _description;
  String get description => _description ?? '';
  set description(String? val) => _description = val;

  bool hasDescription() => _description != null;

  static ActivityStruct fromMap(Map<String, dynamic> data) => ActivityStruct(
        title: data['title'] as String?,
        description: data['description'] as String?,
      );

  static ActivityStruct? maybeFromMap(dynamic data) =>
      data is Map ? ActivityStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'description': _description,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'description': serializeParam(
          _description,
          ParamType.String,
        ),
      }.withoutNulls;

  static ActivityStruct fromSerializableMap(Map<String, dynamic> data) =>
      ActivityStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        description: deserializeParam(
          data['description'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'ActivityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ActivityStruct &&
        title == other.title &&
        description == other.description;
  }

  @override
  int get hashCode => const ListEquality().hash([title, description]);
}

ActivityStruct createActivityStruct({
  String? title,
  String? description,
}) =>
    ActivityStruct(
      title: title,
      description: description,
    );
