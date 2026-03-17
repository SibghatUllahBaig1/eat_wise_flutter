import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/home_pages/components/z_activity_templates_content/z_activity_templates_content_widget.dart';
import 'z_activity_templates_widget.dart' show ZActivityTemplatesWidget;
import 'package:flutter/material.dart';

class ZActivityTemplatesModel
    extends FlutterFlowModel<ZActivityTemplatesWidget> {
  ///  Local state fields for this component.

  int? filter = 0;

  int? quantity = 0;

  FoodStruct? selectedFood;
  void updateSelectedFoodStruct(Function(FoodStruct) updateFn) {
    updateFn(selectedFood ??= FoodStruct());
  }

  ///  State fields for stateful widgets in this component.

  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // Model for zActivityTemplatesContent component.
  late ZActivityTemplatesContentModel zActivityTemplatesContentModel3;
  // Model for zActivityTemplatesContent component.
  late ZActivityTemplatesContentModel zActivityTemplatesContentModel4;

  @override
  void initState(BuildContext context) {
    zActivityTemplatesContentModel3 =
        createModel(context, () => ZActivityTemplatesContentModel());
    zActivityTemplatesContentModel4 =
        createModel(context, () => ZActivityTemplatesContentModel());
  }

  @override
  void dispose() {
    zActivityTemplatesContentModel3.dispose();
    zActivityTemplatesContentModel4.dispose();
  }
}
