// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ChartValuesStruct extends BaseStruct {
  ChartValuesStruct({
    List<int>? xValues,
    List<int>? yValues,
  })  : _xValues = xValues,
        _yValues = yValues;

  // "xValues" field.
  List<int>? _xValues;
  List<int> get xValues => _xValues ?? const [];
  set xValues(List<int>? val) => _xValues = val;

  void updateXValues(Function(List<int>) updateFn) {
    updateFn(_xValues ??= []);
  }

  bool hasXValues() => _xValues != null;

  // "yValues" field.
  List<int>? _yValues;
  List<int> get yValues => _yValues ?? const [];
  set yValues(List<int>? val) => _yValues = val;

  void updateYValues(Function(List<int>) updateFn) {
    updateFn(_yValues ??= []);
  }

  bool hasYValues() => _yValues != null;

  static ChartValuesStruct fromMap(Map<String, dynamic> data) =>
      ChartValuesStruct(
        xValues: getDataList(data['xValues']),
        yValues: getDataList(data['yValues']),
      );

  static ChartValuesStruct? maybeFromMap(dynamic data) => data is Map
      ? ChartValuesStruct.fromMap(data.cast<String, dynamic>())
      : null;

  Map<String, dynamic> toMap() => {
        'xValues': _xValues,
        'yValues': _yValues,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'xValues': serializeParam(
          _xValues,
          ParamType.int,
          isList: true,
        ),
        'yValues': serializeParam(
          _yValues,
          ParamType.int,
          isList: true,
        ),
      }.withoutNulls;

  static ChartValuesStruct fromSerializableMap(Map<String, dynamic> data) =>
      ChartValuesStruct(
        xValues: deserializeParam<int>(
          data['xValues'],
          ParamType.int,
          true,
        ),
        yValues: deserializeParam<int>(
          data['yValues'],
          ParamType.int,
          true,
        ),
      );

  @override
  String toString() => 'ChartValuesStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    const listEquality = ListEquality();
    return other is ChartValuesStruct &&
        listEquality.equals(xValues, other.xValues) &&
        listEquality.equals(yValues, other.yValues);
  }

  @override
  int get hashCode => const ListEquality().hash([xValues, yValues]);
}

ChartValuesStruct createChartValuesStruct() => ChartValuesStruct();
