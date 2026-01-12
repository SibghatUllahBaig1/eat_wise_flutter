import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_activity_templates/z_activity_templates_widget.dart';
import 'dart:ui';
import '/index.dart';
import 'activity_history_widget.dart' show ActivityHistoryWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ActivityHistoryModel extends FlutterFlowModel<ActivityHistoryWidget> {
  List<Map<String, dynamic>> activities = [];
  int totalCaloriesBurned = 0;
  bool isLoading = false;

  // Daily goal field
  TextEditingController? dailyGoalController;
  FocusNode? dailyGoalFocusNode;

  @override
  void initState(BuildContext context) {
    dailyGoalController = TextEditingController();
    dailyGoalFocusNode = FocusNode();
  }

  @override
  void dispose() {
    dailyGoalController?.dispose();
    dailyGoalFocusNode?.dispose();
  }
}
