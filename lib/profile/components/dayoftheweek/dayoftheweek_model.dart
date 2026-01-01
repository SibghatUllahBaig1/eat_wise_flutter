import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'dayoftheweek_widget.dart' show DayoftheweekWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DayoftheweekModel extends FlutterFlowModel<DayoftheweekWidget> {
  ///  Local state fields for this component.

  List<DayOfTheWeekStruct> selectedDays = [];
  void addToSelectedDays(DayOfTheWeekStruct item) => selectedDays.add(item);
  void removeFromSelectedDays(DayOfTheWeekStruct item) =>
      selectedDays.remove(item);
  void removeAtIndexFromSelectedDays(int index) => selectedDays.removeAt(index);
  void insertAtIndexInSelectedDays(int index, DayOfTheWeekStruct item) =>
      selectedDays.insert(index, item);
  void updateSelectedDaysAtIndex(
          int index, Function(DayOfTheWeekStruct) updateFn) =>
      selectedDays[index] = updateFn(selectedDays[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
