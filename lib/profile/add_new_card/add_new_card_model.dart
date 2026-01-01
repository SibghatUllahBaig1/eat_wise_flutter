import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'add_new_card_widget.dart' show AddNewCardWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class AddNewCardModel extends FlutterFlowModel<AddNewCardWidget> {
  ///  Local state fields for this page.

  bool unknownCard = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for CardNumber widget.
  FocusNode? cardNumberFocusNode;
  TextEditingController? cardNumberTextController;
  late MaskTextInputFormatter cardNumberMask;
  String? Function(BuildContext, String?)? cardNumberTextControllerValidator;
  String? _cardNumberTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 19) {
      return 'Requires at least 19 characters.';
    }
    if (val.length > 23) {
      return 'Maximum 23 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for ExpireDate widget.
  FocusNode? expireDateFocusNode;
  TextEditingController? expireDateTextController;
  late MaskTextInputFormatter expireDateMask;
  String? Function(BuildContext, String?)? expireDateTextControllerValidator;
  String? _expireDateTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 5) {
      return 'Requires at least 5 characters.';
    }
    if (val.length > 5) {
      return 'Maximum 5 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for CVC widget.
  FocusNode? cvcFocusNode;
  TextEditingController? cvcTextController;
  late MaskTextInputFormatter cvcMask;
  String? Function(BuildContext, String?)? cvcTextControllerValidator;
  String? _cvcTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 3) {
      return 'Requires at least 3 characters.';
    }
    if (val.length > 4) {
      return 'Maximum 4 characters allowed, currently ${val.length}.';
    }

    return null;
  }

  // State field(s) for CardHolder widget.
  FocusNode? cardHolderFocusNode;
  TextEditingController? cardHolderTextController;
  String? Function(BuildContext, String?)? cardHolderTextControllerValidator;
  String? _cardHolderTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    cardNumberTextControllerValidator = _cardNumberTextControllerValidator;
    expireDateTextControllerValidator = _expireDateTextControllerValidator;
    cvcTextControllerValidator = _cvcTextControllerValidator;
    cardHolderTextControllerValidator = _cardHolderTextControllerValidator;
  }

  @override
  void dispose() {
    cardNumberFocusNode?.dispose();
    cardNumberTextController?.dispose();

    expireDateFocusNode?.dispose();
    expireDateTextController?.dispose();

    cvcFocusNode?.dispose();
    cvcTextController?.dispose();

    cardHolderFocusNode?.dispose();
    cardHolderTextController?.dispose();
  }
}
