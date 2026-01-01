// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class FilterStruct extends BaseStruct {
  FilterStruct({
    List<CategoryStruct>? categories,
    bool? favoriteOnly,
    double? energyValueStart,
    double? energyValueEnd,
  })  : _categories = categories,
        _favoriteOnly = favoriteOnly,
        _energyValueStart = energyValueStart,
        _energyValueEnd = energyValueEnd;

  // "categories" field.
  List<CategoryStruct>? _categories;
  List<CategoryStruct> get categories => _categories ?? const [];
  set categories(List<CategoryStruct>? val) => _categories = val;

  void updateCategories(Function(List<CategoryStruct>) updateFn) {
    updateFn(_categories ??= []);
  }

  bool hasCategories() => _categories != null;

  // "favorite_only" field.
  bool? _favoriteOnly;
  bool get favoriteOnly => _favoriteOnly ?? false;
  set favoriteOnly(bool? val) => _favoriteOnly = val;

  bool hasFavoriteOnly() => _favoriteOnly != null;

  // "energy_value_start" field.
  double? _energyValueStart;
  double get energyValueStart => _energyValueStart ?? 0.0;
  set energyValueStart(double? val) => _energyValueStart = val;

  void incrementEnergyValueStart(double amount) =>
      energyValueStart = energyValueStart + amount;

  bool hasEnergyValueStart() => _energyValueStart != null;

  // "energy_value_end" field.
  double? _energyValueEnd;
  double get energyValueEnd => _energyValueEnd ?? 0.0;
  set energyValueEnd(double? val) => _energyValueEnd = val;

  void incrementEnergyValueEnd(double amount) =>
      energyValueEnd = energyValueEnd + amount;

  bool hasEnergyValueEnd() => _energyValueEnd != null;

  static FilterStruct fromMap(Map<String, dynamic> data) => FilterStruct(
        categories: getStructList(
          data['categories'],
          CategoryStruct.fromMap,
        ),
        favoriteOnly: data['favorite_only'] as bool?,
        energyValueStart: castToType<double>(data['energy_value_start']),
        energyValueEnd: castToType<double>(data['energy_value_end']),
      );

  static FilterStruct? maybeFromMap(dynamic data) =>
      data is Map ? FilterStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'categories': _categories?.map((e) => e.toMap()).toList(),
        'favorite_only': _favoriteOnly,
        'energy_value_start': _energyValueStart,
        'energy_value_end': _energyValueEnd,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'categories': serializeParam(
          _categories,
          ParamType.DataStruct,
          isList: true,
        ),
        'favorite_only': serializeParam(
          _favoriteOnly,
          ParamType.bool,
        ),
        'energy_value_start': serializeParam(
          _energyValueStart,
          ParamType.double,
        ),
        'energy_value_end': serializeParam(
          _energyValueEnd,
          ParamType.double,
        ),
      }.withoutNulls;

  static FilterStruct fromSerializableMap(Map<String, dynamic> data) =>
      FilterStruct(
        categories: deserializeStructParam<CategoryStruct>(
          data['categories'],
          ParamType.DataStruct,
          true,
          structBuilder: CategoryStruct.fromSerializableMap,
        ),
        favoriteOnly: deserializeParam(
          data['favorite_only'],
          ParamType.bool,
          false,
        ),
        energyValueStart: deserializeParam(
          data['energy_value_start'],
          ParamType.double,
          false,
        ),
        energyValueEnd: deserializeParam(
          data['energy_value_end'],
          ParamType.double,
          false,
        ),
      );

  @override
  String toString() => 'FilterStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is FilterStruct &&
        listEquality.equals(categories, other.categories) &&
        favoriteOnly == other.favoriteOnly &&
        energyValueStart == other.energyValueStart &&
        energyValueEnd == other.energyValueEnd;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([categories, favoriteOnly, energyValueStart, energyValueEnd]);
}

FilterStruct createFilterStruct({
  bool? favoriteOnly,
  double? energyValueStart,
  double? energyValueEnd,
}) =>
    FilterStruct(
      favoriteOnly: favoriteOnly,
      energyValueStart: energyValueStart,
      energyValueEnd: energyValueEnd,
    );
