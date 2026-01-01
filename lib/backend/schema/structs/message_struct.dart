// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MessageStruct extends BaseStruct {
  MessageStruct({
    String? message,
    DateTime? timeStamp,
    bool? seen,
    String? image,
    bool? userMessage,
  })  : _message = message,
        _timeStamp = timeStamp,
        _seen = seen,
        _image = image,
        _userMessage = userMessage;

  // "message" field.
  String? _message;
  String get message => _message ?? '';
  set message(String? val) => _message = val;

  bool hasMessage() => _message != null;

  // "time_stamp" field.
  DateTime? _timeStamp;
  DateTime? get timeStamp => _timeStamp;
  set timeStamp(DateTime? val) => _timeStamp = val;

  bool hasTimeStamp() => _timeStamp != null;

  // "seen" field.
  bool? _seen;
  bool get seen => _seen ?? false;
  set seen(bool? val) => _seen = val;

  bool hasSeen() => _seen != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  set image(String? val) => _image = val;

  bool hasImage() => _image != null;

  // "user_message" field.
  bool? _userMessage;
  bool get userMessage => _userMessage ?? false;
  set userMessage(bool? val) => _userMessage = val;

  bool hasUserMessage() => _userMessage != null;

  static MessageStruct fromMap(Map<String, dynamic> data) => MessageStruct(
        message: data['message'] as String?,
        timeStamp: data['time_stamp'] as DateTime?,
        seen: data['seen'] as bool?,
        image: data['image'] as String?,
        userMessage: data['user_message'] as bool?,
      );

  static MessageStruct? maybeFromMap(dynamic data) =>
      data is Map ? MessageStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'message': _message,
        'time_stamp': _timeStamp,
        'seen': _seen,
        'image': _image,
        'user_message': _userMessage,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'message': serializeParam(
          _message,
          ParamType.String,
        ),
        'time_stamp': serializeParam(
          _timeStamp,
          ParamType.DateTime,
        ),
        'seen': serializeParam(
          _seen,
          ParamType.bool,
        ),
        'image': serializeParam(
          _image,
          ParamType.String,
        ),
        'user_message': serializeParam(
          _userMessage,
          ParamType.bool,
        ),
      }.withoutNulls;

  static MessageStruct fromSerializableMap(Map<String, dynamic> data) =>
      MessageStruct(
        message: deserializeParam(
          data['message'],
          ParamType.String,
          false,
        ),
        timeStamp: deserializeParam(
          data['time_stamp'],
          ParamType.DateTime,
          false,
        ),
        seen: deserializeParam(
          data['seen'],
          ParamType.bool,
          false,
        ),
        image: deserializeParam(
          data['image'],
          ParamType.String,
          false,
        ),
        userMessage: deserializeParam(
          data['user_message'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'MessageStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MessageStruct &&
        message == other.message &&
        timeStamp == other.timeStamp &&
        seen == other.seen &&
        image == other.image &&
        userMessage == other.userMessage;
  }

  @override
  int get hashCode =>
      const ListEquality().hash([message, timeStamp, seen, image, userMessage]);
}

MessageStruct createMessageStruct({
  String? message,
  DateTime? timeStamp,
  bool? seen,
  String? image,
  bool? userMessage,
}) =>
    MessageStruct(
      message: message,
      timeStamp: timeStamp,
      seen: seen,
      image: image,
      userMessage: userMessage,
    );
