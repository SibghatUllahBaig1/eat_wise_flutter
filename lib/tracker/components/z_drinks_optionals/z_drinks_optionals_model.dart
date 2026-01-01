import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_optionals_buttons/z_optionals_buttons_widget.dart';
import '/tracker/components/z_water_tracker_edit/z_water_tracker_edit_widget.dart';
import '/tracker/components/z_weight_tracker_edit/z_weight_tracker_edit_widget.dart';
import 'dart:ui';
import 'z_drinks_optionals_widget.dart' show ZDrinksOptionalsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZDrinksOptionalsModel extends FlutterFlowModel<ZDrinksOptionalsWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for zOptionalsButtons component.
  late ZOptionalsButtonsModel zOptionalsButtonsModel1;
  // Model for zOptionalsButtons component.
  late ZOptionalsButtonsModel zOptionalsButtonsModel2;

  @override
  void initState(BuildContext context) {
    zOptionalsButtonsModel1 =
        createModel(context, () => ZOptionalsButtonsModel());
    zOptionalsButtonsModel2 =
        createModel(context, () => ZOptionalsButtonsModel());
  }

  @override
  void dispose() {
    zOptionalsButtonsModel1.dispose();
    zOptionalsButtonsModel2.dispose();
  }
}
