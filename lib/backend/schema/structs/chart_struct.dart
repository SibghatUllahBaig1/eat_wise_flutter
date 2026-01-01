// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChartStruct extends BaseStruct {
  ChartStruct({
    ChartValuesStruct? calorie,
    ChartValuesStruct? water,
    ChartValuesStruct? step,
    ChartValuesStruct? weight,
  })  : _calorie = calorie,
        _water = water,
        _step = step,
        _weight = weight;

  // "calorie" field.
  ChartValuesStruct? _calorie;
  ChartValuesStruct get calorie => _calorie ?? ChartValuesStruct();
  set calorie(ChartValuesStruct? val) => _calorie = val;

  void updateCalorie(Function(ChartValuesStruct) updateFn) {
    updateFn(_calorie ??= ChartValuesStruct());
  }

  bool hasCalorie() => _calorie != null;

  // "water" field.
  ChartValuesStruct? _water;
  ChartValuesStruct get water => _water ?? ChartValuesStruct();
  set water(ChartValuesStruct? val) => _water = val;

  void updateWater(Function(ChartValuesStruct) updateFn) {
    updateFn(_water ??= ChartValuesStruct());
  }

  bool hasWater() => _water != null;

  // "step" field.
  ChartValuesStruct? _step;
  ChartValuesStruct get step => _step ?? ChartValuesStruct();
  set step(ChartValuesStruct? val) => _step = val;

  void updateStep(Function(ChartValuesStruct) updateFn) {
    updateFn(_step ??= ChartValuesStruct());
  }

  bool hasStep() => _step != null;

  // "weight" field.
  ChartValuesStruct? _weight;
  ChartValuesStruct get weight => _weight ?? ChartValuesStruct();
  set weight(ChartValuesStruct? val) => _weight = val;

  void updateWeight(Function(ChartValuesStruct) updateFn) {
    updateFn(_weight ??= ChartValuesStruct());
  }

  bool hasWeight() => _weight != null;

  static ChartStruct fromMap(Map<String, dynamic> data) => ChartStruct(
        calorie: data['calorie'] is ChartValuesStruct
            ? data['calorie']
            : ChartValuesStruct.maybeFromMap(data['calorie']),
        water: data['water'] is ChartValuesStruct
            ? data['water']
            : ChartValuesStruct.maybeFromMap(data['water']),
        step: data['step'] is ChartValuesStruct
            ? data['step']
            : ChartValuesStruct.maybeFromMap(data['step']),
        weight: data['weight'] is ChartValuesStruct
            ? data['weight']
            : ChartValuesStruct.maybeFromMap(data['weight']),
      );

  static ChartStruct? maybeFromMap(dynamic data) =>
      data is Map ? ChartStruct.fromMap(data.cast<String, dynamic>()) : null;

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

  static ChartStruct fromSerializableMap(Map<String, dynamic> data) =>
      ChartStruct(
        calorie: deserializeStructParam(
          data['calorie'],
          ParamType.DataStruct,
          false,
          structBuilder: ChartValuesStruct.fromSerializableMap,
        ),
        water: deserializeStructParam(
          data['water'],
          ParamType.DataStruct,
          false,
          structBuilder: ChartValuesStruct.fromSerializableMap,
        ),
        step: deserializeStructParam(
          data['step'],
          ParamType.DataStruct,
          false,
          structBuilder: ChartValuesStruct.fromSerializableMap,
        ),
        weight: deserializeStructParam(
          data['weight'],
          ParamType.DataStruct,
          false,
          structBuilder: ChartValuesStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'ChartStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ChartStruct &&
        calorie == other.calorie &&
        water == other.water &&
        step == other.step &&
        weight == other.weight;
  }

  @override
  int get hashCode => const ListEquality().hash([calorie, water, step, weight]);
}

ChartStruct createChartStruct({
  ChartValuesStruct? calorie,
  ChartValuesStruct? water,
  ChartValuesStruct? step,
  ChartValuesStruct? weight,
}) =>
    ChartStruct(
      calorie: calorie ?? ChartValuesStruct(),
      water: water ?? ChartValuesStruct(),
      step: step ?? ChartValuesStruct(),
      weight: weight ?? ChartValuesStruct(),
    );
