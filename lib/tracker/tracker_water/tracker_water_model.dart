import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/z_daily_water_goal/z_daily_water_goal_widget.dart';
import '/tracker/components/z_history_list/z_history_list_widget.dart';
import '/tracker/components/z_switch_cup_size/z_switch_cup_size_widget.dart';
import '/tracker/components/z_water_calendar/z_water_calendar_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'tracker_water_widget.dart' show TrackerWaterWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrackerWaterModel extends FlutterFlowModel<TrackerWaterWidget> {
  ///  Local state fields for this page.

  int? pageItem = 0;

  bool calendar = false;

  TrackerValueStruct? selectedDay;
  void updateSelectedDayStruct(Function(TrackerValueStruct) updateFn) {
    updateFn(selectedDay ??= TrackerValueStruct());
  }

  ///  State fields for stateful widgets in this page.

  // Model for zWaterCalendar component.
  late ZWaterCalendarModel zWaterCalendarModel;
  // Model for zHistoryList component.
  late ZHistoryListModel zHistoryListModel;

  @override
  void initState(BuildContext context) {
    zWaterCalendarModel = createModel(context, () => ZWaterCalendarModel());
    zHistoryListModel = createModel(context, () => ZHistoryListModel());
  }

  @override
  void dispose() {
    zWaterCalendarModel.dispose();
    zHistoryListModel.dispose();
  }
}
