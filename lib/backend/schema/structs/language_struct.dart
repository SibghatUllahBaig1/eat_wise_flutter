// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class LanguageStruct extends BaseStruct {
  LanguageStruct({
    String? language,
    String? flag,
    String? langCode,
  })  : _language = language,
        _flag = flag,
        _langCode = langCode;

  // "language" field.
  String? _language;
  String get language => _language ?? '';
  set language(String? val) => _language = val;

  bool hasLanguage() => _language != null;

  // "flag" field.
  String? _flag;
  String get flag => _flag ?? '';
  set flag(String? val) => _flag = val;

  bool hasFlag() => _flag != null;

  // "lang_code" field.
  String? _langCode;
  String get langCode => _langCode ?? '';
  set langCode(String? val) => _langCode = val;

  bool hasLangCode() => _langCode != null;

  static LanguageStruct fromMap(Map<String, dynamic> data) => LanguageStruct(
        language: data['language'] as String?,
        flag: data['flag'] as String?,
        langCode: data['lang_code'] as String?,
      );

  static LanguageStruct? maybeFromMap(dynamic data) =>
      data is Map ? LanguageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'language': _language,
        'flag': _flag,
        'lang_code': _langCode,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'language': serializeParam(
          _language,
          ParamType.String,
        ),
        'flag': serializeParam(
          _flag,
          ParamType.String,
        ),
        'lang_code': serializeParam(
          _langCode,
          ParamType.String,
        ),
      }.withoutNulls;

  static LanguageStruct fromSerializableMap(Map<String, dynamic> data) =>
      LanguageStruct(
        language: deserializeParam(
          data['language'],
          ParamType.String,
          false,
        ),
        flag: deserializeParam(
          data['flag'],
          ParamType.String,
          false,
        ),
        langCode: deserializeParam(
          data['lang_code'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'LanguageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is LanguageStruct &&
        language == other.language &&
        flag == other.flag &&
        langCode == other.langCode;
  }

  @override
  int get hashCode => const ListEquality().hash([language, flag, langCode]);
}

LanguageStruct createLanguageStruct({
  String? language,
  String? flag,
  String? langCode,
}) =>
    LanguageStruct(
      language: language,
      flag: flag,
      langCode: langCode,
    );
