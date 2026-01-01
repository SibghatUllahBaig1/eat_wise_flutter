// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class TrackerStruct extends BaseStruct {
  TrackerStruct({
    List<TrackerValueStruct>? step,
    List<TrackerValueStruct>? water,
    List<TrackerValueStruct>? weight,
    DateTime? currentDate,
    DateTime? selectedDate,
  })  : _step = step,
        _water = water,
        _weight = weight,
        _currentDate = currentDate,
        _selectedDate = selectedDate;

  // "step" field.
  List<TrackerValueStruct>? _step;
  List<TrackerValueStruct> get step => _step ?? const [];
  set step(List<TrackerValueStruct>? val) => _step = val;

  void updateStep(Function(List<TrackerValueStruct>) updateFn) {
    updateFn(_step ??= []);
  }

  bool hasStep() => _step != null;

  // "water" field.
  List<TrackerValueStruct>? _water;
  List<TrackerValueStruct> get water => _water ?? const [];
  set water(List<TrackerValueStruct>? val) => _water = val;

  void updateWater(Function(List<TrackerValueStruct>) updateFn) {
    updateFn(_water ??= []);
  }

  bool hasWater() => _water != null;

  // "weight" field.
  List<TrackerValueStruct>? _weight;
  List<TrackerValueStruct> get weight => _weight ?? const [];
  set weight(List<TrackerValueStruct>? val) => _weight = val;

  void updateWeight(Function(List<TrackerValueStruct>) updateFn) {
    updateFn(_weight ??= []);
  }

  bool hasWeight() => _weight != null;

  // "current_date" field.
  DateTime? _currentDate;
  DateTime? get currentDate => _currentDate;
  set currentDate(DateTime? val) => _currentDate = val;

  bool hasCurrentDate() => _currentDate != null;

  // "selected_date" field.
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(DateTime? val) => _selectedDate = val;

  bool hasSelectedDate() => _selectedDate != null;

  static TrackerStruct fromMap(Map<String, dynamic> data) => TrackerStruct(
        step: getStructList(
          data['step'],
          TrackerValueStruct.fromMap,
        ),
        water: getStructList(
          data['water'],
          TrackerValueStruct.fromMap,
        ),
        weight: getStructList(
          data['weight'],
          TrackerValueStruct.fromMap,
        ),
        currentDate: data['current_date'] as DateTime?,
        selectedDate: data['selected_date'] as DateTime?,
      );

  static TrackerStruct? maybeFromMap(dynamic data) =>
      data is Map ? TrackerStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'step': _step?.map((e) => e.toMap()).toList(),
        'water': _water?.map((e) => e.toMap()).toList(),
        'weight': _weight?.map((e) => e.toMap()).toList(),
        'current_date': _currentDate,
        'selected_date': _selectedDate,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'step': serializeParam(
          _step,
          ParamType.DataStruct,
          isList: true,
        ),
        'water': serializeParam(
          _water,
          ParamType.DataStruct,
          isList: true,
        ),
        'weight': serializeParam(
          _weight,
          ParamType.DataStruct,
          isList: true,
        ),
        'current_date': serializeParam(
          _currentDate,
          ParamType.DateTime,
        ),
        'selected_date': serializeParam(
          _selectedDate,
          ParamType.DateTime,
        ),
      }.withoutNulls;

  static TrackerStruct fromSerializableMap(Map<String, dynamic> data) =>
      TrackerStruct(
        step: deserializeStructParam<TrackerValueStruct>(
          data['step'],
          ParamType.DataStruct,
          true,
          structBuilder: TrackerValueStruct.fromSerializableMap,
        ),
        water: deserializeStructParam<TrackerValueStruct>(
          data['water'],
          ParamType.DataStruct,
          true,
          structBuilder: TrackerValueStruct.fromSerializableMap,
        ),
        weight: deserializeStructParam<TrackerValueStruct>(
          data['weight'],
          ParamType.DataStruct,
          true,
          structBuilder: TrackerValueStruct.fromSerializableMap,
        ),
        currentDate: deserializeParam(
          data['current_date'],
          ParamType.DateTime,
          false,
        ),
        selectedDate: deserializeParam(
          data['selected_date'],
          ParamType.DateTime,
          false,
        ),
      );

  @override
  String toString() => 'TrackerStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is TrackerStruct &&
        listEquality.equals(step, other.step) &&
        listEquality.equals(water, other.water) &&
        listEquality.equals(weight, other.weight) &&
        currentDate == other.currentDate &&
        selectedDate == other.selectedDate;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([step, water, weight, currentDate, selectedDate]);
}

TrackerStruct createTrackerStruct({
  DateTime? currentDate,
  DateTime? selectedDate,
}) =>
    TrackerStruct(
      currentDate: currentDate,
      selectedDate: selectedDate,
    );
