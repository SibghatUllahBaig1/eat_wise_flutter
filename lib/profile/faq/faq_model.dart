import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/faq2/faq2_widget.dart';
import 'dart:ui';
import 'faq_widget.dart' show FaqWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FaqModel extends FlutterFlowModel<FaqWidget> {
  ///  Local state fields for this page.

  bool mealtime = false;

  ///  State fields for stateful widgets in this page.

  // Model for FAQ2 component.
  late Faq2Model faq2Model1;
  // Model for FAQ2 component.
  late Faq2Model faq2Model2;
  // Model for FAQ2 component.
  late Faq2Model faq2Model3;
  // Model for FAQ2 component.
  late Faq2Model faq2Model4;
  // Model for FAQ2 component.
  late Faq2Model faq2Model5;
  // Model for FAQ2 component.
  late Faq2Model faq2Model6;
  // Model for FAQ2 component.
  late Faq2Model faq2Model7;
  // Model for FAQ2 component.
  late Faq2Model faq2Model8;
  // Model for FAQ2 component.
  late Faq2Model faq2Model9;
  // Model for FAQ2 component.
  late Faq2Model faq2Model10;

  @override
  void initState(BuildContext context) {
    faq2Model1 = createModel(context, () => Faq2Model());
    faq2Model2 = createModel(context, () => Faq2Model());
    faq2Model3 = createModel(context, () => Faq2Model());
    faq2Model4 = createModel(context, () => Faq2Model());
    faq2Model5 = createModel(context, () => Faq2Model());
    faq2Model6 = createModel(context, () => Faq2Model());
    faq2Model7 = createModel(context, () => Faq2Model());
    faq2Model8 = createModel(context, () => Faq2Model());
    faq2Model9 = createModel(context, () => Faq2Model());
    faq2Model10 = createModel(context, () => Faq2Model());
  }

  @override
  void dispose() {
    faq2Model1.dispose();
    faq2Model2.dispose();
    faq2Model3.dispose();
    faq2Model4.dispose();
    faq2Model5.dispose();
    faq2Model6.dispose();
    faq2Model7.dispose();
    faq2Model8.dispose();
    faq2Model9.dispose();
    faq2Model10.dispose();
  }
}
