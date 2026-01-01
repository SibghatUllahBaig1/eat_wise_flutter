// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class OnboardingQuationsStruct extends BaseStruct {
  OnboardingQuationsStruct({
    String? question,
    List<String>? answerOptions,
  })  : _question = question,
        _answerOptions = answerOptions;

  // "question" field.
  String? _question;
  String get question => _question ?? '';
  set question(String? val) => _question = val;

  bool hasQuestion() => _question != null;

  // "answer_options" field.
  List<String>? _answerOptions;
  List<String> get answerOptions => _answerOptions ?? const [];
  set answerOptions(List<String>? val) => _answerOptions = val;

  void updateAnswerOptions(Function(List<String>) updateFn) {
    updateFn(_answerOptions ??= []);
  }

  bool hasAnswerOptions() => _answerOptions != null;

  static OnboardingQuationsStruct fromMap(Map<String, dynamic> data) =>
      OnboardingQuationsStruct(
        question: data['question'] as String?,
        answerOptions: getDataList(data['answer_options']),
      );

  static OnboardingQuationsStruct? maybeFromMap(dynamic data) => data is Map
      ? OnboardingQuationsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'question': _question,
        'answer_options': _answerOptions,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'question': serializeParam(
          _question,
          ParamType.String,
        ),
        'answer_options': serializeParam(
          _answerOptions,
          ParamType.String,
          isList: true,
        ),
      }.withoutNulls;

  static OnboardingQuationsStruct fromSerializableMap(
          Map<String, dynamic> data) =>
      OnboardingQuationsStruct(
        question: deserializeParam(
          data['question'],
          ParamType.String,
          false,
        ),
        answerOptions: deserializeParam<String>(
          data['answer_options'],
          ParamType.String,
          true,
        ),
      );

  @override
  String toString() => 'OnboardingQuationsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is OnboardingQuationsStruct &&
        question == other.question &&
        listEquality.equals(answerOptions, other.answerOptions);
  }

  @override
  int get hashCode => const ListEquality().hash([question, answerOptions]);
}

OnboardingQuationsStruct createOnboardingQuationsStruct({
  String? question,
}) =>
    OnboardingQuationsStruct(
      question: question,
    );
