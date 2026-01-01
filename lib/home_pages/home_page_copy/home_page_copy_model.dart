import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_activities/z_activities_widget.dart';
import '/home_pages/components/z_home_calendar/z_home_calendar_widget.dart';
import '/home_pages/components/z_naw_bar/z_naw_bar_widget.dart';
import '/home_pages/components/z_nutrition/z_nutrition_widget.dart';
import '/home_pages/components/z_statistics/z_statistics_widget.dart';
import '/tracker/components/z_calendar/z_calendar_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'home_page_copy_widget.dart' show HomePageCopyWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageCopyModel extends FlutterFlowModel<HomePageCopyWidget> {
  ///  Local state fields for this page.

  DateTime? selectedDate;

  ///  State fields for stateful widgets in this page.

  // Model for zHomeCalendar component.
  late ZHomeCalendarModel zHomeCalendarModel;
  // Model for zStatistics component.
  late ZStatisticsModel zStatisticsModel;
  // Model for zNutrition component.
  late ZNutritionModel zNutritionModel;
  // Model for zActivities component.
  late ZActivitiesModel zActivitiesModel;
  // Model for zNawBar component.
  late ZNawBarModel zNawBarModel;

  @override
  void initState(BuildContext context) {
    zHomeCalendarModel = createModel(context, () => ZHomeCalendarModel());
    zStatisticsModel = createModel(context, () => ZStatisticsModel());
    zNutritionModel = createModel(context, () => ZNutritionModel());
    zActivitiesModel = createModel(context, () => ZActivitiesModel());
    zNawBarModel = createModel(context, () => ZNawBarModel());
  }

  @override
  void dispose() {
    zHomeCalendarModel.dispose();
    zStatisticsModel.dispose();
    zNutritionModel.dispose();
    zActivitiesModel.dispose();
    zNawBarModel.dispose();
  }
}
