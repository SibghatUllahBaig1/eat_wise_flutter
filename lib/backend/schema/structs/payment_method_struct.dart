// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentMethodStruct extends BaseStruct {
  PaymentMethodStruct({
    String? cardNumber,
    String? cardHolder,
    String? expireDate,
    int? cvc,
    String? cardNickname,
    String? type,
  })  : _cardNumber = cardNumber,
        _cardHolder = cardHolder,
        _expireDate = expireDate,
        _cvc = cvc,
        _cardNickname = cardNickname,
        _type = type;

  // "card_number" field.
  String? _cardNumber;
  String get cardNumber => _cardNumber ?? '';
  set cardNumber(String? val) => _cardNumber = val;

  bool hasCardNumber() => _cardNumber != null;

  // "card_holder" field.
  String? _cardHolder;
  String get cardHolder => _cardHolder ?? '';
  set cardHolder(String? val) => _cardHolder = val;

  bool hasCardHolder() => _cardHolder != null;

  // "expire_date" field.
  String? _expireDate;
  String get expireDate => _expireDate ?? '';
  set expireDate(String? val) => _expireDate = val;

  bool hasExpireDate() => _expireDate != null;

  // "cvc" field.
  int? _cvc;
  int get cvc => _cvc ?? 0;
  set cvc(int? val) => _cvc = val;

  void incrementCvc(int amount) => cvc = cvc + amount;

  bool hasCvc() => _cvc != null;

  // "card_nickname" field.
  String? _cardNickname;
  String get cardNickname => _cardNickname ?? '';
  set cardNickname(String? val) => _cardNickname = val;

  bool hasCardNickname() => _cardNickname != null;

  // "type" field.
  String? _type;
  String get type => _type ?? '';
  set type(String? val) => _type = val;

  bool hasType() => _type != null;

  static PaymentMethodStruct fromMap(Map<String, dynamic> data) =>
      PaymentMethodStruct(
        cardNumber: data['card_number'] as String?,
        cardHolder: data['card_holder'] as String?,
        expireDate: data['expire_date'] as String?,
        cvc: castToType<int>(data['cvc']),
        cardNickname: data['card_nickname'] as String?,
        type: data['type'] as String?,
      );

  static PaymentMethodStruct? maybeFromMap(dynamic data) => data is Map
      ? PaymentMethodStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'card_number': _cardNumber,
        'card_holder': _cardHolder,
        'expire_date': _expireDate,
        'cvc': _cvc,
        'card_nickname': _cardNickname,
        'type': _type,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'card_number': serializeParam(
          _cardNumber,
          ParamType.String,
        ),
        'card_holder': serializeParam(
          _cardHolder,
          ParamType.String,
        ),
        'expire_date': serializeParam(
          _expireDate,
          ParamType.String,
        ),
        'cvc': serializeParam(
          _cvc,
          ParamType.int,
        ),
        'card_nickname': serializeParam(
          _cardNickname,
          ParamType.String,
        ),
        'type': serializeParam(
          _type,
          ParamType.String,
        ),
      }.withoutNulls;

  static PaymentMethodStruct fromSerializableMap(Map<String, dynamic> data) =>
      PaymentMethodStruct(
        cardNumber: deserializeParam(
          data['card_number'],
          ParamType.String,
          false,
        ),
        cardHolder: deserializeParam(
          data['card_holder'],
          ParamType.String,
          false,
        ),
        expireDate: deserializeParam(
          data['expire_date'],
          ParamType.String,
          false,
        ),
        cvc: deserializeParam(
          data['cvc'],
          ParamType.int,
          false,
        ),
        cardNickname: deserializeParam(
          data['card_nickname'],
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
  String toString() => 'PaymentMethodStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is PaymentMethodStruct &&
        cardNumber == other.cardNumber &&
        cardHolder == other.cardHolder &&
        expireDate == other.expireDate &&
        cvc == other.cvc &&
        cardNickname == other.cardNickname &&
        type == other.type;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([cardNumber, cardHolder, expireDate, cvc, cardNickname, type]);
}

PaymentMethodStruct createPaymentMethodStruct({
  String? cardNumber,
  String? cardHolder,
  String? expireDate,
  int? cvc,
  String? cardNickname,
  String? type,
}) =>
    PaymentMethodStruct(
      cardNumber: cardNumber,
      cardHolder: cardHolder,
      expireDate: expireDate,
      cvc: cvc,
      cardNickname: cardNickname,
      type: type,
    );
