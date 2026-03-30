import '/flutter_flow/flutter_flow_util.dart';
import 'z_meal_reminder_widget.dart' show ZMealReminderWidget;
import 'package:flutter/material.dart';

class ZMealReminderModel extends FlutterFlowModel<ZMealReminderWidget> {
  /// Local state fields for this component.
  bool reminderEnabled = false;
  int hour = 7;
  int minute = 0;
  List<String> repeatDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
