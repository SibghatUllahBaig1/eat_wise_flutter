// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TrackerSettingsStruct extends BaseStruct {
  TrackerSettingsStruct({
    SettingsStruct? calorie,
    SettingsStruct? water,
    SettingsStruct? step,
    WeightSettingsStruct? weight,
  })  : _calorie = calorie,
        _water = water,
        _step = step,
        _weight = weight;

  // "calorie" field.
  SettingsStruct? _calorie;
  SettingsStruct get calorie => _calorie ?? SettingsStruct();
  set calorie(SettingsStruct? val) => _calorie = val;

  void updateCalorie(Function(SettingsStruct) updateFn) {
    updateFn(_calorie ??= SettingsStruct());
  }

  bool hasCalorie() => _calorie != null;

  // "water" field.
  SettingsStruct? _water;
  SettingsStruct get water => _water ?? SettingsStruct();
  set water(SettingsStruct? val) => _water = val;

  void updateWater(Function(SettingsStruct) updateFn) {
    updateFn(_water ??= SettingsStruct());
  }

  bool hasWater() => _water != null;

  // "step" field.
  SettingsStruct? _step;
  SettingsStruct get step => _step ?? SettingsStruct();
  set step(SettingsStruct? val) => _step = val;

  void updateStep(Function(SettingsStruct) updateFn) {
    updateFn(_step ??= SettingsStruct());
  }

  bool hasStep() => _step != null;

  // "weight" field.
  WeightSettingsStruct? _weight;
  WeightSettingsStruct get weight => _weight ?? WeightSettingsStruct();
  set weight(WeightSettingsStruct? val) => _weight = val;

  void updateWeight(Function(WeightSettingsStruct) updateFn) {
    updateFn(_weight ??= WeightSettingsStruct());
  }

  bool hasWeight() => _weight != null;

  static TrackerSettingsStruct fromMap(Map<String, dynamic> data) =>
      TrackerSettingsStruct(
        calorie: data['calorie'] is SettingsStruct
            ? data['calorie']
            : SettingsStruct.maybeFromMap(data['calorie']),
        water: data['water'] is SettingsStruct
            ? data['water']
            : SettingsStruct.maybeFromMap(data['water']),
        step: data['step'] is SettingsStruct
            ? data['step']
            : SettingsStruct.maybeFromMap(data['step']),
        weight: data['weight'] is WeightSettingsStruct
            ? data['weight']
            : WeightSettingsStruct.maybeFromMap(data['weight']),
      );

  static TrackerSettingsStruct? maybeFromMap(dynamic data) => data is Map
      ? TrackerSettingsStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'calorie': _calorie?.toMap(),
        'water': _water?.toMap(),
        'step': _step?.toMap(),
        'weight': _weight?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'calorie': serializeParam(
          _calorie,
          ParamType.DataStruct,
        ),
        'water': serializeParam(
          _water,
          ParamType.DataStruct,
        ),
        'step': serializeParam(
          _step,
          ParamType.DataStruct,
        ),
        'weight': serializeParam(
          _weight,
          ParamType.DataStruct,
        ),
      }.withoutNulls;

  static TrackerSettingsStruct fromSerializableMap(Map<String, dynamic> data) =>
      TrackerSettingsStruct(
        calorie: deserializeStructParam(
          data['calorie'],
          ParamType.DataStruct,
          false,
          structBuilder: SettingsStruct.fromSerializableMap,
        ),
        water: deserializeStructParam(
          data['water'],
          ParamType.DataStruct,
          false,
          structBuilder: SettingsStruct.fromSerializableMap,
        ),
        step: deserializeStructParam(
          data['step'],
          ParamType.DataStruct,
          false,
          structBuilder: SettingsStruct.fromSerializableMap,
        ),
        weight: deserializeStructParam(
          data['weight'],
          ParamType.DataStruct,
          false,
          structBuilder: WeightSettingsStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'TrackerSettingsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is TrackerSettingsStruct &&
        calorie == other.calorie &&
        water == other.water &&
        step == other.step &&
        weight == other.weight;
  }

  @override
  int get hashCode => const ListEquality().hash([calorie, water, step, weight]);
}

TrackerSettingsStruct createTrackerSettingsStruct({
  SettingsStruct? calorie,
  SettingsStruct? water,
  SettingsStruct? step,
  WeightSettingsStruct? weight,
}) =>
    TrackerSettingsStruct(
      calorie: calorie ?? SettingsStruct(),
      water: water ?? SettingsStruct(),
      step: step ?? SettingsStruct(),
      weight: weight ?? WeightSettingsStruct(),
    );
