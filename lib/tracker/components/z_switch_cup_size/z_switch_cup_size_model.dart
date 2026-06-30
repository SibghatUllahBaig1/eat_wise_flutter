import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'z_switch_cup_size_widget.dart' show ZSwitchCupSizeWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/backend/firestore/water_tracker_service.dart';
import '/backend/services/water_sync_helper.dart';
import '/auth/firebase_auth/auth_util.dart';

class ZSwitchCupSizeModel extends FlutterFlowModel<ZSwitchCupSizeWidget> {
  ///  Local state fields for this component.

  int? drinkAmount = 100;
  String? selectedDrinkType;
  String? selectedDrinkIcon;
  bool isLoading = false;

  final WaterTrackerService _waterTrackerService = WaterTrackerService();

  /// Add drink entry to Firestore
  Future<void> addDrink(BuildContext context, Function() setState) async {
    if (selectedDrinkType == null || selectedDrinkIcon == null) {
      return;
    }

    isLoading = true;
    setState();

    try {
      // Use the selected date from tracker state, or default to today
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();

      await _waterTrackerService.addDrinkEntry(
        userId: currentUserUid,
        date: selectedDate,
        amount: drinkAmount ?? 100,
        drinkType: selectedDrinkType!,
        drinkIcon: selectedDrinkIcon!,
      );

      await WaterSyncHelper.syncWaterForDate(
        userId: currentUserUid,
        date: selectedDate,
      );

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error adding drink: $e');
    } finally {
      isLoading = false;
      setState();
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
