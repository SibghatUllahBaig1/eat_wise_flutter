import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_search/z_search_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'z_filter_widget.dart' show ZFilterWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ZFilterModel extends FlutterFlowModel<ZFilterWidget> {
  ///  Local state fields for this component.

  List<CategoryStruct> selectedCategories = [];
  void addToSelectedCategories(CategoryStruct item) =>
      selectedCategories.add(item);
  void removeFromSelectedCategories(CategoryStruct item) =>
      selectedCategories.remove(item);
  void removeAtIndexFromSelectedCategories(int index) =>
      selectedCategories.removeAt(index);
  void insertAtIndexInSelectedCategories(int index, CategoryStruct item) =>
      selectedCategories.insert(index, item);
  void updateSelectedCategoriesAtIndex(
          int index, Function(CategoryStruct) updateFn) =>
      selectedCategories[index] = updateFn(selectedCategories[index]);

  bool favoriesOnly = false;

  double? start;

  double? end;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
