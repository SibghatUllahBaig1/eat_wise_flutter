// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MineralsStruct extends BaseStruct {
  MineralsStruct({
    NutrientStruct? calcium,
    NutrientStruct? iron,
    NutrientStruct? potassium,
    NutrientStruct? magnesium,
    NutrientStruct? phosphorus,
    NutrientStruct? zinc,
    NutrientStruct? copper,
    NutrientStruct? selenium,
  })  : _calcium = calcium,
        _iron = iron,
        _potassium = potassium,
        _magnesium = magnesium,
        _phosphorus = phosphorus,
        _zinc = zinc,
        _copper = copper,
        _selenium = selenium;

  // "calcium" field.
  NutrientStruct? _calcium;
  NutrientStruct get calcium => _calcium ?? NutrientStruct();
  set calcium(NutrientStruct? val) => _calcium = val;
  void updateCalcium(Function(NutrientStruct) updateFn) {
    updateFn(_calcium ??= NutrientStruct());
  }

  bool hasCalcium() => _calcium != null;

  // "iron" field.
  NutrientStruct? _iron;
  NutrientStruct get iron => _iron ?? NutrientStruct();
  set iron(NutrientStruct? val) => _iron = val;
  void updateIron(Function(NutrientStruct) updateFn) {
    updateFn(_iron ??= NutrientStruct());
  }

  bool hasIron() => _iron != null;

  // "potassium" field.
  NutrientStruct? _potassium;
  NutrientStruct get potassium => _potassium ?? NutrientStruct();
  set potassium(NutrientStruct? val) => _potassium = val;
  void updatePotassium(Function(NutrientStruct) updateFn) {
    updateFn(_potassium ??= NutrientStruct());
  }

  bool hasPotassium() => _potassium != null;

  // "magnesium" field.
  NutrientStruct? _magnesium;
  NutrientStruct get magnesium => _magnesium ?? NutrientStruct();
  set magnesium(NutrientStruct? val) => _magnesium = val;
  void updateMagnesium(Function(NutrientStruct) updateFn) {
    updateFn(_magnesium ??= NutrientStruct());
  }

  bool hasMagnesium() => _magnesium != null;

  // "phosphorus" field.
  NutrientStruct? _phosphorus;
  NutrientStruct get phosphorus => _phosphorus ?? NutrientStruct();
  set phosphorus(NutrientStruct? val) => _phosphorus = val;
  void updatePhosphorus(Function(NutrientStruct) updateFn) {
    updateFn(_phosphorus ??= NutrientStruct());
  }

  bool hasPhosphorus() => _phosphorus != null;

  // "zinc" field.
  NutrientStruct? _zinc;
  NutrientStruct get zinc => _zinc ?? NutrientStruct();
  set zinc(NutrientStruct? val) => _zinc = val;
  void updateZinc(Function(NutrientStruct) updateFn) {
    updateFn(_zinc ??= NutrientStruct());
  }

  bool hasZinc() => _zinc != null;

  // "copper" field.
  NutrientStruct? _copper;
  NutrientStruct get copper => _copper ?? NutrientStruct();
  set copper(NutrientStruct? val) => _copper = val;
  void updateCopper(Function(NutrientStruct) updateFn) {
    updateFn(_copper ??= NutrientStruct());
  }

  bool hasCopper() => _copper != null;

  // "selenium" field.
  NutrientStruct? _selenium;
  NutrientStruct get selenium => _selenium ?? NutrientStruct();
  set selenium(NutrientStruct? val) => _selenium = val;
  void updateSelenium(Function(NutrientStruct) updateFn) {
    updateFn(_selenium ??= NutrientStruct());
  }

  bool hasSelenium() => _selenium != null;

  static MineralsStruct fromMap(Map<String, dynamic> data) => MineralsStruct(
        calcium: NutrientStruct.maybeFromMap(data['calcium']),
        iron: NutrientStruct.maybeFromMap(data['iron']),
        potassium: NutrientStruct.maybeFromMap(data['potassium']),
        magnesium: NutrientStruct.maybeFromMap(data['magnesium']),
        phosphorus: NutrientStruct.maybeFromMap(data['phosphorus']),
        zinc: NutrientStruct.maybeFromMap(data['zinc']),
        copper: NutrientStruct.maybeFromMap(data['copper']),
        selenium: NutrientStruct.maybeFromMap(data['selenium']),
      );

  static MineralsStruct? maybeFromMap(dynamic data) =>
      data is Map ? MineralsStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'calcium': _calcium?.toMap(),
        'iron': _iron?.toMap(),
        'potassium': _potassium?.toMap(),
        'magnesium': _magnesium?.toMap(),
        'phosphorus': _phosphorus?.toMap(),
        'zinc': _zinc?.toMap(),
        'copper': _copper?.toMap(),
        'selenium': _selenium?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'calcium': serializeParam(_calcium, ParamType.DataStruct),
        'iron': serializeParam(_iron, ParamType.DataStruct),
        'potassium': serializeParam(_potassium, ParamType.DataStruct),
        'magnesium': serializeParam(_magnesium, ParamType.DataStruct),
        'phosphorus': serializeParam(_phosphorus, ParamType.DataStruct),
        'zinc': serializeParam(_zinc, ParamType.DataStruct),
        'copper': serializeParam(_copper, ParamType.DataStruct),
        'selenium': serializeParam(_selenium, ParamType.DataStruct),
      }.withoutNulls;

  static MineralsStruct fromSerializableMap(Map<String, dynamic> data) =>
      MineralsStruct(
        calcium: deserializeStructParam(
            data['calcium'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        iron: deserializeStructParam(data['iron'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        potassium: deserializeStructParam(
            data['potassium'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        magnesium: deserializeStructParam(
            data['magnesium'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        phosphorus: deserializeStructParam(
            data['phosphorus'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        zinc: deserializeStructParam(data['zinc'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        copper: deserializeStructParam(
            data['copper'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
        selenium: deserializeStructParam(
            data['selenium'], ParamType.DataStruct, false,
            structBuilder: NutrientStruct.fromSerializableMap),
      );

  @override
  String toString() => 'MineralsStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MineralsStruct &&
        calcium == other.calcium &&
        iron == other.iron &&
        potassium == other.potassium &&
        magnesium == other.magnesium &&
        phosphorus == other.phosphorus &&
        zinc == other.zinc &&
        copper == other.copper &&
        selenium == other.selenium;
  }

  @override
  int get hashCode => const ListEquality().hash([
        calcium,
        iron,
        potassium,
        magnesium,
        phosphorus,
        zinc,
        copper,
        selenium
      ]);
}

MineralsStruct createMineralsStruct({
  NutrientStruct? calcium,
  NutrientStruct? iron,
  NutrientStruct? potassium,
  NutrientStruct? magnesium,
  NutrientStruct? phosphorus,
  NutrientStruct? zinc,
  NutrientStruct? copper,
  NutrientStruct? selenium,
}) =>
    MineralsStruct(
      calcium: calcium,
      iron: iron,
      potassium: potassium,
      magnesium: magnesium,
      phosphorus: phosphorus,
      zinc: zinc,
      copper: copper,
      selenium: selenium,
    );
