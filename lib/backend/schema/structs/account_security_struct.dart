// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class AccountSecurityStruct extends BaseStruct {
  AccountSecurityStruct({
    bool? biometricId,
    bool? faceId,
    bool? smsAuthenticator,
    bool? googleAuthenticator,
  })  : _biometricId = biometricId,
        _faceId = faceId,
        _smsAuthenticator = smsAuthenticator,
        _googleAuthenticator = googleAuthenticator;

  // "biometric_id" field.
  bool? _biometricId;
  bool get biometricId => _biometricId ?? false;
  set biometricId(bool? val) => _biometricId = val;

  bool hasBiometricId() => _biometricId != null;

  // "face_id" field.
  bool? _faceId;
  bool get faceId => _faceId ?? false;
  set faceId(bool? val) => _faceId = val;

  bool hasFaceId() => _faceId != null;

  // "sms_authenticator" field.
  bool? _smsAuthenticator;
  bool get smsAuthenticator => _smsAuthenticator ?? false;
  set smsAuthenticator(bool? val) => _smsAuthenticator = val;

  bool hasSmsAuthenticator() => _smsAuthenticator != null;

  // "google_authenticator" field.
  bool? _googleAuthenticator;
  bool get googleAuthenticator => _googleAuthenticator ?? false;
  set googleAuthenticator(bool? val) => _googleAuthenticator = val;

  bool hasGoogleAuthenticator() => _googleAuthenticator != null;

  static AccountSecurityStruct fromMap(Map<String, dynamic> data) =>
      AccountSecurityStruct(
        biometricId: data['biometric_id'] as bool?,
        faceId: data['face_id'] as bool?,
        smsAuthenticator: data['sms_authenticator'] as bool?,
        googleAuthenticator: data['google_authenticator'] as bool?,
      );

  static AccountSecurityStruct? maybeFromMap(dynamic data) => data is Map
      ? AccountSecurityStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'biometric_id': _biometricId,
        'face_id': _faceId,
        'sms_authenticator': _smsAuthenticator,
        'google_authenticator': _googleAuthenticator,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'biometric_id': serializeParam(
          _biometricId,
          ParamType.bool,
        ),
        'face_id': serializeParam(
          _faceId,
          ParamType.bool,
        ),
        'sms_authenticator': serializeParam(
          _smsAuthenticator,
          ParamType.bool,
        ),
        'google_authenticator': serializeParam(
          _googleAuthenticator,
          ParamType.bool,
        ),
      }.withoutNulls;

  static AccountSecurityStruct fromSerializableMap(Map<String, dynamic> data) =>
      AccountSecurityStruct(
        biometricId: deserializeParam(
          data['biometric_id'],
          ParamType.bool,
          false,
        ),
        faceId: deserializeParam(
          data['face_id'],
          ParamType.bool,
          false,
        ),
        smsAuthenticator: deserializeParam(
          data['sms_authenticator'],
          ParamType.bool,
          false,
        ),
        googleAuthenticator: deserializeParam(
          data['google_authenticator'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'AccountSecurityStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is AccountSecurityStruct &&
        biometricId == other.biometricId &&
        faceId == other.faceId &&
        smsAuthenticator == other.smsAuthenticator &&
        googleAuthenticator == other.googleAuthenticator;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([biometricId, faceId, smsAuthenticator, googleAuthenticator]);
}

AccountSecurityStruct createAccountSecurityStruct({
  bool? biometricId,
  bool? faceId,
  bool? smsAuthenticator,
  bool? googleAuthenticator,
}) =>
    AccountSecurityStruct(
      biometricId: biometricId,
      faceId: faceId,
      smsAuthenticator: smsAuthenticator,
      googleAuthenticator: googleAuthenticator,
    );
