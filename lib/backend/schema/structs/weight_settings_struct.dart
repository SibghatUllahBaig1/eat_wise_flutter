// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class WeightSettingsStruct extends BaseStruct {
  WeightSettingsStruct({
    int? currentWeight,
    int? goalWeight,
    String? weightUnit,
    String? heightUnit,
    bool? bmi,
    bool? reminder,
    List<String>? repeat,
    RimenderTimeStruct? reminderTime,
    String? ringtone,
    double? soundVolume,
    bool? vibration,
    bool? stopWhen100p,
    int? height,
  })  : _currentWeight = currentWeight,
        _goalWeight = goalWeight,
        _weightUnit = weightUnit,
        _heightUnit = heightUnit,
        _bmi = bmi,
        _reminder = reminder,
        _repeat = repeat,
        _reminderTime = reminderTime,
        _ringtone = ringtone,
        _soundVolume = soundVolume,
        _vibration = vibration,
        _stopWhen100p = stopWhen100p,
        _height = height;

  // "current_weight" field.
  int? _currentWeight;
  int get currentWeight => _currentWeight ?? 0;
  set currentWeight(int? val) => _currentWeight = val;

  void incrementCurrentWeight(int amount) =>
      currentWeight = currentWeight + amount;

  bool hasCurrentWeight() => _currentWeight != null;

  // "goal_weight" field.
  int? _goalWeight;
  int get goalWeight => _goalWeight ?? 0;
  set goalWeight(int? val) => _goalWeight = val;

  void incrementGoalWeight(int amount) => goalWeight = goalWeight + amount;

  bool hasGoalWeight() => _goalWeight != null;

  // "weight_unit" field.
  String? _weightUnit;
  String get weightUnit => _weightUnit ?? '';
  set weightUnit(String? val) => _weightUnit = val;

  bool hasWeightUnit() => _weightUnit != null;

  // "height_unit" field.
  String? _heightUnit;
  String get heightUnit => _heightUnit ?? '';
  set heightUnit(String? val) => _heightUnit = val;

  bool hasHeightUnit() => _heightUnit != null;

  // "bmi" field.
  bool? _bmi;
  bool get bmi => _bmi ?? false;
  set bmi(bool? val) => _bmi = val;

  bool hasBmi() => _bmi != null;

  // "reminder" field.
  bool? _reminder;
  bool get reminder => _reminder ?? false;
  set reminder(bool? val) => _reminder = val;

  bool hasReminder() => _reminder != null;

  // "repeat" field.
  List<String>? _repeat;
  List<String> get repeat => _repeat ?? const [];
  set repeat(List<String>? val) => _repeat = val;

  void updateRepeat(Function(List<String>) updateFn) {
    updateFn(_repeat ??= []);
  }

  bool hasRepeat() => _repeat != null;

  // "reminder_time" field.
  RimenderTimeStruct? _reminderTime;
  RimenderTimeStruct get reminderTime => _reminderTime ?? RimenderTimeStruct();
  set reminderTime(RimenderTimeStruct? val) => _reminderTime = val;

  void updateReminderTime(Function(RimenderTimeStruct) updateFn) {
    updateFn(_reminderTime ??= RimenderTimeStruct());
  }

  bool hasReminderTime() => _reminderTime != null;

  // "ringtone" field.
  String? _ringtone;
  String get ringtone => _ringtone ?? '';
  set ringtone(String? val) => _ringtone = val;

  bool hasRingtone() => _ringtone != null;

  // "sound_volume" field.
  double? _soundVolume;
  double get soundVolume => _soundVolume ?? 0.0;
  set soundVolume(double? val) => _soundVolume = val;

  void incrementSoundVolume(double amount) =>
      soundVolume = soundVolume + amount;

  bool hasSoundVolume() => _soundVolume != null;

  // "vibration" field.
  bool? _vibration;
  bool get vibration => _vibration ?? false;
  set vibration(bool? val) => _vibration = val;

  bool hasVibration() => _vibration != null;

  // "stop_when_100p" field.
  bool? _stopWhen100p;
  bool get stopWhen100p => _stopWhen100p ?? false;
  set stopWhen100p(bool? val) => _stopWhen100p = val;

  bool hasStopWhen100p() => _stopWhen100p != null;

  // "height" field.
  int? _height;
  int get height => _height ?? 0;
  set height(int? val) => _height = val;

  void incrementHeight(int amount) => height = height + amount;

  bool hasHeight() => _height != null;

  static WeightSettingsStruct fromMap(Map<String, dynamic> data) =>
      WeightSettingsStruct(
        currentWeight: castToType<int>(data['current_weight']),
        goalWeight: castToType<int>(data['goal_weight']),
        weightUnit: data['weight_unit'] as String?,
        heightUnit: data['height_unit'] as String?,
        bmi: data['bmi'] as bool?,
        reminder: data['reminder'] as bool?,
        repeat: getDataList(data['repeat']),
        reminderTime: data['reminder_time'] is RimenderTimeStruct
            ? data['reminder_time']
            : RimenderTimeStruct.maybeFromMap(data['reminder_time']),
        ringtone: data['ringtone'] as String?,
        soundVolume: castToType<double>(data['sound_volume']),
        vibration: data['vibration'] as bool?,
        stopWhen100p: data['stop_when_100p'] as bool?,
        height: castToType<int>(data['height']),
      );

  static WeightSettingsStruct? maybeFromMap(dynamic data) => data is Map
      ? WeightSettingsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'current_weight': _currentWeight,
        'goal_weight': _goalWeight,
        'weight_unit': _weightUnit,
        'height_unit': _heightUnit,
        'bmi': _bmi,
        'reminder': _reminder,
        'repeat': _repeat,
        'reminder_time': _reminderTime?.toMap(),
        'ringtone': _ringtone,
        'sound_volume': _soundVolume,
        'vibration': _vibration,
        'stop_when_100p': _stopWhen100p,
        'height': _height,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'current_weight': serializeParam(
          _currentWeight,
          ParamType.int,
        ),
        'goal_weight': serializeParam(
          _goalWeight,
          ParamType.int,
        ),
        'weight_unit': serializeParam(
          _weightUnit,
          ParamType.String,
        ),
        'height_unit': serializeParam(
          _heightUnit,
          ParamType.String,
        ),
        'bmi': serializeParam(
          _bmi,
          ParamType.bool,
        ),
        'reminder': serializeParam(
          _reminder,
          ParamType.bool,
        ),
        'repeat': serializeParam(
          _repeat,
          ParamType.String,
          isList: true,
        ),
        'reminder_time': serializeParam(
          _reminderTime,
          ParamType.DataStruct,
        ),
        'ringtone': serializeParam(
          _ringtone,
          ParamType.String,
        ),
        'sound_volume': serializeParam(
          _soundVolume,
          ParamType.double,
        ),
        'vibration': serializeParam(
          _vibration,
          ParamType.bool,
        ),
        'stop_when_100p': serializeParam(
          _stopWhen100p,
          ParamType.bool,
        ),
        'height': serializeParam(
          _height,
          ParamType.int,
        ),
      }.withoutNulls;

  static WeightSettingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      WeightSettingsStruct(
        currentWeight: deserializeParam(
          data['current_weight'],
          ParamType.int,
          false,
        ),
        goalWeight: deserializeParam(
          data['goal_weight'],
          ParamType.int,
          false,
        ),
        weightUnit: deserializeParam(
          data['weight_unit'],
          ParamType.String,
          false,
        ),
        heightUnit: deserializeParam(
          data['height_unit'],
          ParamType.String,
          false,
        ),
        bmi: deserializeParam(
          data['bmi'],
          ParamType.bool,
          false,
        ),
        reminder: deserializeParam(
          data['reminder'],
          ParamType.bool,
          false,
        ),
        repeat: deserializeParam<String>(
          data['repeat'],
          ParamType.String,
          true,
        ),
        reminderTime: deserializeStructParam(
          data['reminder_time'],
          ParamType.DataStruct,
          false,
          structBuilder: RimenderTimeStruct.fromSerializableMap,
        ),
        ringtone: deserializeParam(
          data['ringtone'],
          ParamType.String,
          false,
        ),
        soundVolume: deserializeParam(
          data['sound_volume'],
          ParamType.double,
          false,
        ),
        vibration: deserializeParam(
          data['vibration'],
          ParamType.bool,
          false,
        ),
        stopWhen100p: deserializeParam(
          data['stop_when_100p'],
          ParamType.bool,
          false,
        ),
        height: deserializeParam(
          data['height'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'WeightSettingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is WeightSettingsStruct &&
        currentWeight == other.currentWeight &&
        goalWeight == other.goalWeight &&
        weightUnit == other.weightUnit &&
        heightUnit == other.heightUnit &&
        bmi == other.bmi &&
        reminder == other.reminder &&
        listEquality.equals(repeat, other.repeat) &&
        reminderTime == other.reminderTime &&
        ringtone == other.ringtone &&
        soundVolume == other.soundVolume &&
        vibration == other.vibration &&
        stopWhen100p == other.stopWhen100p &&
        height == other.height;
  }

  @override
  int get hashCode => const ListEquality().hash([
        currentWeight,
        goalWeight,
        weightUnit,
        heightUnit,
        bmi,
        reminder,
        repeat,
        reminderTime,
        ringtone,
        soundVolume,
        vibration,
        stopWhen100p,
        height
      ]);
}

WeightSettingsStruct createWeightSettingsStruct({
  int? currentWeight,
  int? goalWeight,
  String? weightUnit,
  String? heightUnit,
  bool? bmi,
  bool? reminder,
  RimenderTimeStruct? reminderTime,
  String? ringtone,
  double? soundVolume,
  bool? vibration,
  bool? stopWhen100p,
  int? height,
}) =>
    WeightSettingsStruct(
      currentWeight: currentWeight,
      goalWeight: goalWeight,
      weightUnit: weightUnit,
      heightUnit: heightUnit,
      bmi: bmi,
      reminder: reminder,
      reminderTime: reminderTime ?? RimenderTimeStruct(),
      ringtone: ringtone,
      soundVolume: soundVolume,
      vibration: vibration,
      stopWhen100p: stopWhen100p,
      height: height,
    );
