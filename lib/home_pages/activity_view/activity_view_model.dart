import '/flutter_flow/flutter_flow_util.dart';
import 'activity_view_widget.dart' show ActivityViewWidget;
import 'package:flutter/material.dart';

class ActivityViewModel extends FlutterFlowModel<ActivityViewWidget> {
  ///  Local state fields for this page.

  String? activityId;
  String activityName = '';
  int? duration = 0;
  bool favorite = false;
  String iconName = 'sport2';
  int? caloriesBurned = 0;
  String? notes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}

