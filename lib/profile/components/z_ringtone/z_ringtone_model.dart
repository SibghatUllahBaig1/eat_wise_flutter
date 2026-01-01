import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'z_ringtone_widget.dart' show ZRingtoneWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZRingtoneModel extends FlutterFlowModel<ZRingtoneWidget> {
  ///  Local state fields for this component.

  List<String> ringtone = [
    'Asteroid',
    'Atomic Bell',
    'Beep Once',
    'Beep-Beep',
    'Chime Time',
    'Comet',
    'Cosmos',
    'Nuptune',
    'Orbit',
    'Outer Bell'
  ];
  void addToRingtone(String item) => ringtone.add(item);
  void removeFromRingtone(String item) => ringtone.remove(item);
  void removeAtIndexFromRingtone(int index) => ringtone.removeAt(index);
  void insertAtIndexInRingtone(int index, String item) =>
      ringtone.insert(index, item);
  void updateRingtoneAtIndex(int index, Function(String) updateFn) =>
      ringtone[index] = updateFn(ringtone[index]);

  String? selectedRingtone;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
