// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OnboardingReviewsStruct extends BaseStruct {
  OnboardingReviewsStruct({
    String? title,
    String? content,
  })  : _title = title,
        _content = content;

  // "title" field.
  String? _title;
  String get title => _title ?? '';
  set title(String? val) => _title = val;

  bool hasTitle() => _title != null;

  // "content" field.
  String? _content;
  String get content => _content ?? '';
  set content(String? val) => _content = val;

  bool hasContent() => _content != null;

  static OnboardingReviewsStruct fromMap(Map<String, dynamic> data) =>
      OnboardingReviewsStruct(
        title: data['title'] as String?,
        content: data['content'] as String?,
      );

  static OnboardingReviewsStruct? maybeFromMap(dynamic data) => data is Map
      ? OnboardingReviewsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'title': _title,
        'content': _content,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'title': serializeParam(
          _title,
          ParamType.String,
        ),
        'content': serializeParam(
          _content,
          ParamType.String,
        ),
      }.withoutNulls;

  static OnboardingReviewsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      OnboardingReviewsStruct(
        title: deserializeParam(
          data['title'],
          ParamType.String,
          false,
        ),
        content: deserializeParam(
          data['content'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'OnboardingReviewsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is OnboardingReviewsStruct &&
        title == other.title &&
        content == other.content;
  }

  @override
  int get hashCode => const ListEquality().hash([title, content]);
}

OnboardingReviewsStruct createOnboardingReviewsStruct({
  String? title,
  String? content,
}) =>
    OnboardingReviewsStruct(
      title: title,
      content: content,
    );
