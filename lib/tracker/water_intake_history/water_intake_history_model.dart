import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_history_list/z_history_list_widget.dart';
import '/tracker/components/z_water_calendar/z_water_calendar_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'water_intake_history_widget.dart' show WaterIntakeHistoryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WaterIntakeHistoryModel
    extends FlutterFlowModel<WaterIntakeHistoryWidget> {
  ///  Local state fields for this page.

  int? pageItem = 0;

  bool calendar = false;

  int? selectedDay = 29;

  ///  State fields for stateful widgets in this page.

  // Model for zWaterCalendar component.
  late ZWaterCalendarModel zWaterCalendarModel;
  // Model for zHistoryList component.
  late ZHistoryListModel zHistoryListModel1;
  // Model for zHistoryList component.
  late ZHistoryListModel zHistoryListModel2;

  @override
  void initState(BuildContext context) {
    zWaterCalendarModel = createModel(context, () => ZWaterCalendarModel());
    zHistoryListModel1 = createModel(context, () => ZHistoryListModel());
    zHistoryListModel2 = createModel(context, () => ZHistoryListModel());
  }

  @override
  void dispose() {
    zWaterCalendarModel.dispose();
    zHistoryListModel1.dispose();
    zHistoryListModel2.dispose();
  }
}
