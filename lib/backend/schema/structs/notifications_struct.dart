// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsStruct extends BaseStruct {
  NotificationsStruct({
    bool? mealtime,
    DateTime? breakfast,
    DateTime? lunch,
    DateTime? supper,
    DateTime? snack,
    bool? water,
    bool? checkYourProgress,
    List<DayOfTheWeekStruct>? dayOfTheWeek,
    DateTime? time,
    bool? fastingTime,
    bool? stagesOfFasting,
    bool? coachsAdvice,
  })  : _mealtime = mealtime,
        _breakfast = breakfast,
        _lunch = lunch,
        _supper = supper,
        _snack = snack,
        _water = water,
        _checkYourProgress = checkYourProgress,
        _dayOfTheWeek = dayOfTheWeek,
        _time = time,
        _fastingTime = fastingTime,
        _stagesOfFasting = stagesOfFasting,
        _coachsAdvice = coachsAdvice;

  // "mealtime" field.
  bool? _mealtime;
  bool get mealtime => _mealtime ?? false;
  set mealtime(bool? val) => _mealtime = val;

  bool hasMealtime() => _mealtime != null;

  // "breakfast" field.
  DateTime? _breakfast;
  DateTime? get breakfast => _breakfast;
  set breakfast(DateTime? val) => _breakfast = val;

  bool hasBreakfast() => _breakfast != null;

  // "lunch" field.
  DateTime? _lunch;
  DateTime? get lunch => _lunch;
  set lunch(DateTime? val) => _lunch = val;

  bool hasLunch() => _lunch != null;

  // "supper" field.
  DateTime? _supper;
  DateTime? get supper => _supper;
  set supper(DateTime? val) => _supper = val;

  bool hasSupper() => _supper != null;

  // "snack" field.
  DateTime? _snack;
  DateTime? get snack => _snack;
  set snack(DateTime? val) => _snack = val;

  bool hasSnack() => _snack != null;

  // "water" field.
  bool? _water;
  bool get water => _water ?? false;
  set water(bool? val) => _water = val;

  bool hasWater() => _water != null;

  // "checkYourProgress" field.
  bool? _checkYourProgress;
  bool get checkYourProgress => _checkYourProgress ?? false;
  set checkYourProgress(bool? val) => _checkYourProgress = val;

  bool hasCheckYourProgress() => _checkYourProgress != null;

  // "dayOfTheWeek" field.
  List<DayOfTheWeekStruct>? _dayOfTheWeek;
  List<DayOfTheWeekStruct> get dayOfTheWeek => _dayOfTheWeek ?? const [];
  set dayOfTheWeek(List<DayOfTheWeekStruct>? val) => _dayOfTheWeek = val;

  void updateDayOfTheWeek(Function(List<DayOfTheWeekStruct>) updateFn) {
    updateFn(_dayOfTheWeek ??= []);
  }

  bool hasDayOfTheWeek() => _dayOfTheWeek != null;

  // "time" field.
  DateTime? _time;
  DateTime? get time => _time;
  set time(DateTime? val) => _time = val;

  bool hasTime() => _time != null;

  // "fastingTime" field.
  bool? _fastingTime;
  bool get fastingTime => _fastingTime ?? false;
  set fastingTime(bool? val) => _fastingTime = val;

  bool hasFastingTime() => _fastingTime != null;

  // "stagesOfFasting" field.
  bool? _stagesOfFasting;
  bool get stagesOfFasting => _stagesOfFasting ?? false;
  set stagesOfFasting(bool? val) => _stagesOfFasting = val;

  bool hasStagesOfFasting() => _stagesOfFasting != null;

  // "coachsAdvice" field.
  bool? _coachsAdvice;
  bool get coachsAdvice => _coachsAdvice ?? false;
  set coachsAdvice(bool? val) => _coachsAdvice = val;

  bool hasCoachsAdvice() => _coachsAdvice != null;

  static NotificationsStruct fromMap(Map<String, dynamic> data) =>
      NotificationsStruct(
        mealtime: data['mealtime'] as bool?,
        breakfast: data['breakfast'] as DateTime?,
        lunch: data['lunch'] as DateTime?,
        supper: data['supper'] as DateTime?,
        snack: data['snack'] as DateTime?,
        water: data['water'] as bool?,
        checkYourProgress: data['checkYourProgress'] as bool?,
        dayOfTheWeek: getStructList(
          data['dayOfTheWeek'],
          DayOfTheWeekStruct.fromMap,
        ),
        time: data['time'] as DateTime?,
        fastingTime: data['fastingTime'] as bool?,
        stagesOfFasting: data['stagesOfFasting'] as bool?,
        coachsAdvice: data['coachsAdvice'] as bool?,
      );

  static NotificationsStruct? maybeFromMap(dynamic data) => data is Map
      ? NotificationsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'mealtime': _mealtime,
        'breakfast': _breakfast,
        'lunch': _lunch,
        'supper': _supper,
        'snack': _snack,
        'water': _water,
        'checkYourProgress': _checkYourProgress,
        'dayOfTheWeek': _dayOfTheWeek?.map((e) => e.toMap()).toList(),
        'time': _time,
        'fastingTime': _fastingTime,
        'stagesOfFasting': _stagesOfFasting,
        'coachsAdvice': _coachsAdvice,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'mealtime': serializeParam(
          _mealtime,
          ParamType.bool,
        ),
        'breakfast': serializeParam(
          _breakfast,
          ParamType.DateTime,
        ),
        'lunch': serializeParam(
          _lunch,
          ParamType.DateTime,
        ),
        'supper': serializeParam(
          _supper,
          ParamType.DateTime,
        ),
        'snack': serializeParam(
          _snack,
          ParamType.DateTime,
        ),
        'water': serializeParam(
          _water,
          ParamType.bool,
        ),
        'checkYourProgress': serializeParam(
          _checkYourProgress,
          ParamType.bool,
        ),
        'dayOfTheWeek': serializeParam(
          _dayOfTheWeek,
          ParamType.DataStruct,
          isList: true,
        ),
        'time': serializeParam(
          _time,
          ParamType.DateTime,
        ),
        'fastingTime': serializeParam(
          _fastingTime,
          ParamType.bool,
        ),
        'stagesOfFasting': serializeParam(
          _stagesOfFasting,
          ParamType.bool,
        ),
        'coachsAdvice': serializeParam(
          _coachsAdvice,
          ParamType.bool,
        ),
      }.withoutNulls;

  static NotificationsStruct fromSerializableMap(Map<String, dynamic> data) =>
      NotificationsStruct(
        mealtime: deserializeParam(
          data['mealtime'],
          ParamType.bool,
          false,
        ),
        breakfast: deserializeParam(
          data['breakfast'],
          ParamType.DateTime,
          false,
        ),
        lunch: deserializeParam(
          data['lunch'],
          ParamType.DateTime,
          false,
        ),
        supper: deserializeParam(
          data['supper'],
          ParamType.DateTime,
          false,
        ),
        snack: deserializeParam(
          data['snack'],
          ParamType.DateTime,
          false,
        ),
        water: deserializeParam(
          data['water'],
          ParamType.bool,
          false,
        ),
        checkYourProgress: deserializeParam(
          data['checkYourProgress'],
          ParamType.bool,
          false,
        ),
        dayOfTheWeek: deserializeStructParam<DayOfTheWeekStruct>(
          data['dayOfTheWeek'],
          ParamType.DataStruct,
          true,
          structBuilder: DayOfTheWeekStruct.fromSerializableMap,
        ),
        time: deserializeParam(
          data['time'],
          ParamType.DateTime,
          false,
        ),
        fastingTime: deserializeParam(
          data['fastingTime'],
          ParamType.bool,
          false,
        ),
        stagesOfFasting: deserializeParam(
          data['stagesOfFasting'],
          ParamType.bool,
          false,
        ),
        coachsAdvice: deserializeParam(
          data['coachsAdvice'],
          ParamType.bool,
          false,
        ),
      );

  @override
  String toString() => 'NotificationsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is NotificationsStruct &&
        mealtime == other.mealtime &&
        breakfast == other.breakfast &&
        lunch == other.lunch &&
        supper == other.supper &&
        snack == other.snack &&
        water == other.water &&
        checkYourProgress == other.checkYourProgress &&
        listEquality.equals(dayOfTheWeek, other.dayOfTheWeek) &&
        time == other.time &&
        fastingTime == other.fastingTime &&
        stagesOfFasting == other.stagesOfFasting &&
        coachsAdvice == other.coachsAdvice;
  }

  @override
  int get hashCode => const ListEquality().hash([
        mealtime,
        breakfast,
        lunch,
        supper,
        snack,
        water,
        checkYourProgress,
        dayOfTheWeek,
        time,
        fastingTime,
        stagesOfFasting,
        coachsAdvice
      ]);
}

NotificationsStruct createNotificationsStruct({
  bool? mealtime,
  DateTime? breakfast,
  DateTime? lunch,
  DateTime? supper,
  DateTime? snack,
  bool? water,
  bool? checkYourProgress,
  DateTime? time,
  bool? fastingTime,
  bool? stagesOfFasting,
  bool? coachsAdvice,
}) =>
    NotificationsStruct(
      mealtime: mealtime,
      breakfast: breakfast,
      lunch: lunch,
      supper: supper,
      snack: snack,
      water: water,
      checkYourProgress: checkYourProgress,
      time: time,
      fastingTime: fastingTime,
      stagesOfFasting: stagesOfFasting,
      coachsAdvice: coachsAdvice,
    );
