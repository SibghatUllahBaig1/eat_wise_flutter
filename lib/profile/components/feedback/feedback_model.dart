import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'feedback_widget.dart' show FeedbackWidget;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FeedbackModel extends FlutterFlowModel<FeedbackWidget> {
  ///  Local state fields for this component.

  List<String> types = [
    'Bug Report',
    'Feature Request',
    'General Feedback',
    'Design/UI Feedback',
    'Performance Issues'
  ];
  void addToTypes(String item) => types.add(item);
  void removeFromTypes(String item) => types.remove(item);
  void removeAtIndexFromTypes(int index) => types.removeAt(index);
  void insertAtIndexInTypes(int index, String item) =>
      types.insert(index, item);
  void updateTypesAtIndex(int index, Function(String) updateFn) =>
      types[index] = updateFn(types[index]);

  String? selectedType;

  ///  State fields for stateful widgets in this component.

  // State field(s) for RatingBar widget.
  double? ratingBarValue;
  // State field(s) for Comment widget.
  FocusNode? commentFocusNode;
  TextEditingController? commentTextController;
  String? Function(BuildContext, String?)? commentTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    commentFocusNode?.dispose();
    commentTextController?.dispose();
  }
}
