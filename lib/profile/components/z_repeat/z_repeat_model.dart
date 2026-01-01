import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'z_repeat_widget.dart' show ZRepeatWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZRepeatModel extends FlutterFlowModel<ZRepeatWidget> {
  ///  Local state fields for this component.

  List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  void addToDays(String item) => days.add(item);
  void removeFromDays(String item) => days.remove(item);
  void removeAtIndexFromDays(int index) => days.removeAt(index);
  void insertAtIndexInDays(int index, String item) => days.insert(index, item);
  void updateDaysAtIndex(int index, Function(String) updateFn) =>
      days[index] = updateFn(days[index]);

  List<String> selectedDays = [];
  void addToSelectedDays(String item) => selectedDays.add(item);
  void removeFromSelectedDays(String item) => selectedDays.remove(item);
  void removeAtIndexFromSelectedDays(int index) => selectedDays.removeAt(index);
  void insertAtIndexInSelectedDays(int index, String item) =>
      selectedDays.insert(index, item);
  void updateSelectedDaysAtIndex(int index, Function(String) updateFn) =>
      selectedDays[index] = updateFn(selectedDays[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
