import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/profile/components/remove_payment/remove_payment_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'credit_card_page_widget.dart' show CreditCardPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreditCardPageModel extends FlutterFlowModel<CreditCardPageWidget> {
  ///  Local state fields for this page.

  bool defaultCard = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Nickname widget.
  FocusNode? nicknameFocusNode;
  TextEditingController? nicknameTextController;
  String? Function(BuildContext, String?)? nicknameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nicknameFocusNode?.dispose();
    nicknameTextController?.dispose();
  }
}
