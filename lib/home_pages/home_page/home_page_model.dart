import '/flutter_flow/flutter_flow_util.dart';
import '/home_pages/components/z_home_calendar/z_home_calendar_widget.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/home_pages/components/z_nutrition/z_nutrition_widget.dart';
import '/home_pages/components/z_statistics/z_statistics_widget.dart';
import '/tracker/components/z_step_tracker/z_step_tracker_widget.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  DateTime? selectedDate;

  ///  State fields for stateful widgets in this page.

  // Model for zHomeCalendar component.
  late ZHomeCalendarModel zHomeCalendarModel;
  // Model for zStatistics component.
  late ZStatisticsModel zStatisticsModel;
  // Model for zNutrition component.
  late ZNutritionModel zNutritionModel;
  // Model for zStepTracker component.
  late ZStepTrackerModel zStepTrackerModel;
  // Model for zNawBar component.
  late ZNawBarModel zNawBarModel;

  @override
  void initState(BuildContext context) {
    zHomeCalendarModel = createModel(context, () => ZHomeCalendarModel());
    zStatisticsModel = createModel(context, () => ZStatisticsModel());
    zNutritionModel = createModel(context, () => ZNutritionModel());
    zStepTrackerModel = createModel(context, () => ZStepTrackerModel());
    zNawBarModel = createModel(context, () => ZNawBarModel());
  }

  @override
  void dispose() {
    zHomeCalendarModel.dispose();
    zStatisticsModel.dispose();
    zNutritionModel.dispose();
    zStepTrackerModel.dispose();
    zNawBarModel.dispose();
  }
}
