// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class MacrosStruct extends BaseStruct {
  MacrosStruct({
    MacroDetailStruct? carbs,
    MacroDetailStruct? protein,
    MacroDetailStruct? fat,
  })  : _carbs = carbs,
        _protein = protein,
        _fat = fat;

  // "carbs" field.
  MacroDetailStruct? _carbs;
  MacroDetailStruct get carbs => _carbs ?? MacroDetailStruct();
  set carbs(MacroDetailStruct? val) => _carbs = val;
  void updateCarbs(Function(MacroDetailStruct) updateFn) {
    updateFn(_carbs ??= MacroDetailStruct());
  }
  bool hasCarbs() => _carbs != null;

  // "protein" field.
  MacroDetailStruct? _protein;
  MacroDetailStruct get protein => _protein ?? MacroDetailStruct();
  set protein(MacroDetailStruct? val) => _protein = val;
  void updateProtein(Function(MacroDetailStruct) updateFn) {
    updateFn(_protein ??= MacroDetailStruct());
  }
  bool hasProtein() => _protein != null;

  // "fat" field.
  MacroDetailStruct? _fat;
  MacroDetailStruct get fat => _fat ?? MacroDetailStruct();
  set fat(MacroDetailStruct? val) => _fat = val;
  void updateFat(Function(MacroDetailStruct) updateFn) {
    updateFn(_fat ??= MacroDetailStruct());
  }
  bool hasFat() => _fat != null;

  static MacrosStruct fromMap(Map<String, dynamic> data) => MacrosStruct(
        carbs: MacroDetailStruct.maybeFromMap(data['carbs']),
        protein: MacroDetailStruct.maybeFromMap(data['protein']),
        fat: MacroDetailStruct.maybeFromMap(data['fat']),
      );

  static MacrosStruct? maybeFromMap(dynamic data) =>
      data is Map ? MacrosStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'carbs': _carbs?.toMap(),
        'protein': _protein?.toMap(),
        'fat': _fat?.toMap(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'carbs': serializeParam(_carbs, ParamType.DataStruct),
        'protein': serializeParam(_protein, ParamType.DataStruct),
        'fat': serializeParam(_fat, ParamType.DataStruct),
      }.withoutNulls;

  static MacrosStruct fromSerializableMap(Map<String, dynamic> data) =>
      MacrosStruct(
        carbs: deserializeStructParam(data['carbs'], ParamType.DataStruct, false, structBuilder: MacroDetailStruct.fromSerializableMap),
        protein: deserializeStructParam(data['protein'], ParamType.DataStruct, false, structBuilder: MacroDetailStruct.fromSerializableMap),
        fat: deserializeStructParam(data['fat'], ParamType.DataStruct, false, structBuilder: MacroDetailStruct.fromSerializableMap),
      );

  @override
  String toString() => 'MacrosStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is MacrosStruct &&
        carbs == other.carbs &&
        protein == other.protein &&
        fat == other.fat;
  }

  @override
  int get hashCode => const ListEquality().hash([carbs, protein, fat]);
}

MacrosStruct createMacrosStruct({
  MacroDetailStruct? carbs,
  MacroDetailStruct? protein,
  MacroDetailStruct? fat,
}) =>
    MacrosStruct(
      carbs: carbs,
      protein: protein,
      fat: fat,
    );

