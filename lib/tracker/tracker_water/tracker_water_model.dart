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
import '/backend/firestore/water_tracker_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'dart:async';

class TrackerWaterModel extends FlutterFlowModel<TrackerWaterWidget> {
  ///  Local state fields for this page.

  int? pageItem = 0;

  bool calendar = false;

  TrackerValueStruct? selectedDay;
  void updateSelectedDayStruct(Function(TrackerValueStruct) updateFn) {
    updateFn(selectedDay ??= TrackerValueStruct());
  }

  Map<String, dynamic>? waterIntakeData;
  List<Map<String, dynamic>> drinksList = [];

  /// Keep track of which date the streams are currently subscribed to.
  DateTime? _subscribedDate;

  ///  State fields for stateful widgets in this page.

  final WaterTrackerService _waterTrackerService = WaterTrackerService();
  StreamSubscription<Map<String, dynamic>?>? _waterIntakeSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? _drinksSubscription;

  // Model for zWaterCalendar component.
  late ZWaterCalendarModel zWaterCalendarModel;
  // Model for zHistoryList component.
  late ZHistoryListModel zHistoryListModel;

  void subscribeToWaterData(DateTime date, Function() updateCallback) {
    // Normalize to date-only to avoid resubscribing when only the time differs.
    final normalizedDate = DateTime(date.year, date.month, date.day);

    // If we're already subscribed to this date, do nothing.
    if (_subscribedDate != null &&
        _subscribedDate!.year == normalizedDate.year &&
        _subscribedDate!.month == normalizedDate.month &&
        _subscribedDate!.day == normalizedDate.day) {
      return;
    }

    _subscribedDate = normalizedDate;

    _waterIntakeSubscription?.cancel();
    _drinksSubscription?.cancel();

    _waterIntakeSubscription = _waterTrackerService
        .streamWaterIntake(userId: currentUserUid, date: normalizedDate)
        .listen((data) {
      waterIntakeData = data;
      updateCallback();
    });

    _drinksSubscription = _waterTrackerService
        .streamDrinksForDate(userId: currentUserUid, date: normalizedDate)
        .listen((drinks) {
      drinksList = drinks;
      updateCallback();
    });
  }

  Future<void> deleteDrink(String drinkId, DateTime date) async {
    try {
      await _waterTrackerService.deleteDrinkEntry(
        userId: currentUserUid,
        date: date,
        drinkId: drinkId,
      );
    } catch (e) {
      print('Error deleting drink: $e');
    }
  }

  Future<void> editDrink(String drinkId, int amount, String drinkType,
      String drinkIcon, DateTime date) async {
    try {
      await _waterTrackerService.updateDrinkEntry(
        userId: currentUserUid,
        date: date,
        drinkId: drinkId,
        amount: amount,
        drinkType: drinkType,
        drinkIcon: drinkIcon,
      );
    } catch (e) {
      print('Error editing drink: $e');
    }
  }

  @override
  void initState(BuildContext context) {
    zWaterCalendarModel = createModel(context, () => ZWaterCalendarModel());
    zHistoryListModel = createModel(context, () => ZHistoryListModel());
  }

  @override
  void dispose() {
    _waterIntakeSubscription?.cancel();
    _drinksSubscription?.cancel();
    zWaterCalendarModel.dispose();
    zHistoryListModel.dispose();
  }
}
