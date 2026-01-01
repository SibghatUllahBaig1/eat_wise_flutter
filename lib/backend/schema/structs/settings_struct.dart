// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class SettingsStruct extends BaseStruct {
  SettingsStruct({
    int? goal,
    String? unit,
    bool? reminder,
    List<String>? repeat,
    RimenderTimeStruct? reminderTime,
    String? ringtone,
    double? soundVolume,
    bool? vibration,
    bool? stopWhen100p,
  })  : _goal = goal,
        _unit = unit,
        _reminder = reminder,
        _repeat = repeat,
        _reminderTime = reminderTime,
        _ringtone = ringtone,
        _soundVolume = soundVolume,
        _vibration = vibration,
        _stopWhen100p = stopWhen100p;

  // "goal" field.
  int? _goal;
  int get goal => _goal ?? 0;
  set goal(int? val) => _goal = val;

  void incrementGoal(int amount) => goal = goal + amount;

  bool hasGoal() => _goal != null;

  // "unit" field.
  String? _unit;
  String get unit => _unit ?? '';
  set unit(String? val) => _unit = val;

  bool hasUnit() => _unit != null;

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

  static SettingsStruct fromMap(Map<String, dynamic> data) => SettingsStruct(
        goal: castToType<int>(data['goal']),
        unit: data['unit'] as String?,
        reminder: data['reminder'] as bool?,
        repeat: getDataList(data['repeat']),
        reminderTime: data['reminder_time'] is RimenderTimeStruct
            ? data['reminder_time']
            : RimenderTimeStruct.maybeFromMap(data['reminder_time']),
        ringtone: data['ringtone'] as String?,
        soundVolume: castToType<double>(data['sound_volume']),
        vibration: data['vibration'] as bool?,
        stopWhen100p: data['stop_when_100p'] as bool?,
      );

  static SettingsStruct? maybeFromMap(dynamic data) =>
      data is Map ? SettingsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'goal': _goal,
        'unit': _unit,
        'reminder': _reminder,
        'repeat': _repeat,
        'reminder_time': _reminderTime?.toMap(),
        'ringtone': _ringtone,
        'sound_volume': _soundVolume,
        'vibration': _vibration,
        'stop_when_100p': _stopWhen100p,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'goal': serializeParam(
          _goal,
          ParamType.int,
        ),
        'unit': serializeParam(
          _unit,
          ParamType.String,
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
      }.withoutNulls;

  static SettingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      SettingsStruct(
        goal: deserializeParam(
          data['goal'],
          ParamType.int,
          false,
        ),
        unit: deserializeParam(
          data['unit'],
          ParamType.String,
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
      );

  @override
  String toString() => 'SettingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is SettingsStruct &&
        goal == other.goal &&
        unit == other.unit &&
        reminder == other.reminder &&
        listEquality.equals(repeat, other.repeat) &&
        reminderTime == other.reminderTime &&
        ringtone == other.ringtone &&
        soundVolume == other.soundVolume &&
        vibration == other.vibration &&
        stopWhen100p == other.stopWhen100p;
  }

  @override
  int get hashCode => const ListEquality().hash([
        goal,
        unit,
        reminder,
        repeat,
        reminderTime,
        ringtone,
        soundVolume,
        vibration,
        stopWhen100p
      ]);
}

SettingsStruct createSettingsStruct({
  int? goal,
  String? unit,
  bool? reminder,
  RimenderTimeStruct? reminderTime,
  String? ringtone,
  double? soundVolume,
  bool? vibration,
  bool? stopWhen100p,
}) =>
    SettingsStruct(
      goal: goal,
      unit: unit,
      reminder: reminder,
      reminderTime: reminderTime ?? RimenderTimeStruct(),
      ringtone: ringtone,
      soundVolume: soundVolume,
      vibration: vibration,
      stopWhen100p: stopWhen100p,
    );
