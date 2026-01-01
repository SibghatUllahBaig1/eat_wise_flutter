import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'date_selector_widget.dart' show DateSelectorWidget;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DateSelectorModel extends FlutterFlowModel<DateSelectorWidget> {
  ///  Local state fields for this component.

  String? day;

  String? month;

  String? year;

  ///  State fields for stateful widgets in this component.

  // State field(s) for days widget.
  CarouselSliderController? daysController;
  int daysCurrentIndex = 29;

  // State field(s) for months widget.
  CarouselSliderController? monthsController;
  int monthsCurrentIndex = 4;

  // State field(s) for years widget.
  CarouselSliderController? yearsController;
  int yearsCurrentIndex = 55;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
