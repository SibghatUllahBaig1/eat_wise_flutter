import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_notification_card/z_notification_card_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'notification_widget.dart' show NotificationWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationModel extends FlutterFlowModel<NotificationWidget> {
  ///  Local state fields for this page.

  int? quantity = 1;

  bool favorite = false;

  ///  State fields for stateful widgets in this page.

  // Model for zNotificationCard component.
  late ZNotificationCardModel zNotificationCardModel1;
  // Model for zNotificationCard component.
  late ZNotificationCardModel zNotificationCardModel2;
  // Model for zNotificationCard component.
  late ZNotificationCardModel zNotificationCardModel3;
  // Model for zNotificationCard component.
  late ZNotificationCardModel zNotificationCardModel4;
  // Model for zNotificationCard component.
  late ZNotificationCardModel zNotificationCardModel5;

  @override
  void initState(BuildContext context) {
    zNotificationCardModel1 =
        createModel(context, () => ZNotificationCardModel());
    zNotificationCardModel2 =
        createModel(context, () => ZNotificationCardModel());
    zNotificationCardModel3 =
        createModel(context, () => ZNotificationCardModel());
    zNotificationCardModel4 =
        createModel(context, () => ZNotificationCardModel());
    zNotificationCardModel5 =
        createModel(context, () => ZNotificationCardModel());
  }

  @override
  void dispose() {
    zNotificationCardModel1.dispose();
    zNotificationCardModel2.dispose();
    zNotificationCardModel3.dispose();
    zNotificationCardModel4.dispose();
    zNotificationCardModel5.dispose();
  }
}
