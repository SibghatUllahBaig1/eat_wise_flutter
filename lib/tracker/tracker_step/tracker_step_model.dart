import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_step_calendar/z_step_calendar_widget.dart';
import '/tracker/components/z_step_history_list/z_step_history_list_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'tracker_step_widget.dart' show TrackerStepWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TrackerStepModel extends FlutterFlowModel<TrackerStepWidget> {
  ///  Local state fields for this page.

  bool play = false;

  ///  State fields for stateful widgets in this page.

  // Model for zStepCalendar component.
  late ZStepCalendarModel zStepCalendarModel;
  // Model for zStepHistoryList component.
  late ZStepHistoryListModel zStepHistoryListModel;

  @override
  void initState(BuildContext context) {
    zStepCalendarModel = createModel(context, () => ZStepCalendarModel());
    zStepHistoryListModel = createModel(context, () => ZStepHistoryListModel());
  }

  @override
  void dispose() {
    zStepCalendarModel.dispose();
    zStepHistoryListModel.dispose();
  }
}
