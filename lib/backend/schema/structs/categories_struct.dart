// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CategoriesStruct extends BaseStruct {
  CategoriesStruct({
    List<CategoryStruct>? meals,
    List<CategoryStruct>? diets,
    List<CategoryStruct>? energy,
    List<CategoryStruct>? popularCategories,
  })  : _meals = meals,
        _diets = diets,
        _energy = energy,
        _popularCategories = popularCategories;

  // "meals" field.
  List<CategoryStruct>? _meals;
  List<CategoryStruct> get meals => _meals ?? const [];
  set meals(List<CategoryStruct>? val) => _meals = val;

  void updateMeals(Function(List<CategoryStruct>) updateFn) {
    updateFn(_meals ??= []);
  }

  bool hasMeals() => _meals != null;

  // "diets" field.
  List<CategoryStruct>? _diets;
  List<CategoryStruct> get diets => _diets ?? const [];
  set diets(List<CategoryStruct>? val) => _diets = val;

  void updateDiets(Function(List<CategoryStruct>) updateFn) {
    updateFn(_diets ??= []);
  }

  bool hasDiets() => _diets != null;

  // "energy" field.
  List<CategoryStruct>? _energy;
  List<CategoryStruct> get energy => _energy ?? const [];
  set energy(List<CategoryStruct>? val) => _energy = val;

  void updateEnergy(Function(List<CategoryStruct>) updateFn) {
    updateFn(_energy ??= []);
  }

  bool hasEnergy() => _energy != null;

  // "popular_categories" field.
  List<CategoryStruct>? _popularCategories;
  List<CategoryStruct> get popularCategories => _popularCategories ?? const [];
  set popularCategories(List<CategoryStruct>? val) => _popularCategories = val;

  void updatePopularCategories(Function(List<CategoryStruct>) updateFn) {
    updateFn(_popularCategories ??= []);
  }

  bool hasPopularCategories() => _popularCategories != null;

  static CategoriesStruct fromMap(Map<String, dynamic> data) =>
      CategoriesStruct(
        meals: getStructList(
          data['meals'],
          CategoryStruct.fromMap,
        ),
        diets: getStructList(
          data['diets'],
          CategoryStruct.fromMap,
        ),
        energy: getStructList(
          data['energy'],
          CategoryStruct.fromMap,
        ),
        popularCategories: getStructList(
          data['popular_categories'],
          CategoryStruct.fromMap,
        ),
      );

  static CategoriesStruct? maybeFromMap(dynamic data) => data is Map
      ? CategoriesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'meals': _meals?.map((e) => e.toMap()).toList(),
        'diets': _diets?.map((e) => e.toMap()).toList(),
        'energy': _energy?.map((e) => e.toMap()).toList(),
        'popular_categories':
            _popularCategories?.map((e) => e.toMap()).toList(),
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'meals': serializeParam(
          _meals,
          ParamType.DataStruct,
          isList: true,
        ),
        'diets': serializeParam(
          _diets,
          ParamType.DataStruct,
          isList: true,
        ),
        'energy': serializeParam(
          _energy,
          ParamType.DataStruct,
          isList: true,
        ),
        'popular_categories': serializeParam(
          _popularCategories,
          ParamType.DataStruct,
          isList: true,
        ),
      }.withoutNulls;

  static CategoriesStruct fromSerializableMap(Map<String, dynamic> data) =>
      CategoriesStruct(
        meals: deserializeStructParam<CategoryStruct>(
          data['meals'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoryStruct.fromSerializableMap,
        ),
        diets: deserializeStructParam<CategoryStruct>(
          data['diets'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoryStruct.fromSerializableMap,
        ),
        energy: deserializeStructParam<CategoryStruct>(
          data['energy'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoryStruct.fromSerializableMap,
        ),
        popularCategories: deserializeStructParam<CategoryStruct>(
          data['popular_categories'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoryStruct.fromSerializableMap,
        ),
      );

  @override
  String toString() => 'CategoriesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is CategoriesStruct &&
        listEquality.equals(meals, other.meals) &&
        listEquality.equals(diets, other.diets) &&
        listEquality.equals(energy, other.energy) &&
        listEquality.equals(popularCategories, other.popularCategories);
  }

  @override
  int get hashCode =>
      const ListEquality().hash([meals, diets, energy, popularCategories]);
}

CategoriesStruct createCategoriesStruct() => CategoriesStruct();
