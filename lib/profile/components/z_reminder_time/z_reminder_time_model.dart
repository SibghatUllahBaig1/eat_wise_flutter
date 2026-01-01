import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:carousel_slider/carousel_slider.dart';
import 'z_reminder_time_widget.dart' show ZReminderTimeWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZReminderTimeModel extends FlutterFlowModel<ZReminderTimeWidget> {
  ///  Local state fields for this component.

  String hour = '00';

  String min = '00';

  String type = 'AM';

  List<String> typeList = ['AM', 'PM'];
  void addToTypeList(String item) => typeList.add(item);
  void removeFromTypeList(String item) => typeList.remove(item);
  void removeAtIndexFromTypeList(int index) => typeList.removeAt(index);
  void insertAtIndexInTypeList(int index, String item) =>
      typeList.insert(index, item);
  void updateTypeListAtIndex(int index, Function(String) updateFn) =>
      typeList[index] = updateFn(typeList[index]);

  int? hourIndex = 0;

  int? minIndex;

  int? typeIndex;

  ///  State fields for stateful widgets in this component.

  // State field(s) for CarouselHour widget.
  CarouselSliderController? carouselHourController;
  int carouselHourCurrentIndex = 0;

  // State field(s) for CarouselMin widget.
  CarouselSliderController? carouselMinController;
  int carouselMinCurrentIndex = 0;

  // State field(s) for CarouselType widget.
  CarouselSliderController? carouselTypeController;
  int carouselTypeCurrentIndex = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
