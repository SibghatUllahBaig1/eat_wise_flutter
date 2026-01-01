import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_optionals_buttons/z_optionals_buttons_widget.dart';
import '/tracker/components/z_water_tracker_edit/z_water_tracker_edit_widget.dart';
import '/tracker/components/z_weight_tracker_edit/z_weight_tracker_edit_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_drinks_optionals_model.dart';
export 'z_drinks_optionals_model.dart';

class ZDrinksOptionalsWidget extends StatefulWidget {
  const ZDrinksOptionalsWidget({
    super.key,
    required this.trackerType,
  });

  final int? trackerType;

  @override
  State<ZDrinksOptionalsWidget> createState() => _ZDrinksOptionalsWidgetState();
}

class _ZDrinksOptionalsWidgetState extends State<ZDrinksOptionalsWidget> {
  late ZDrinksOptionalsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZDrinksOptionalsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 135.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: FlutterFlowTheme.of(context).shadow,
            offset: Offset(
              0.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget!.trackerType != 1)
            InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                Navigator.pop(context);
                if (widget!.trackerType == 0) {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: ZWaterTrackerEditWidget(),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                } else if (widget!.trackerType == 2) {
                  await showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Padding(
                        padding: MediaQuery.viewInsetsOf(context),
                        child: ZWeightTrackerEditWidget(),
                      );
                    },
                  ).then((value) => safeSetState(() {}));
                }
              },
              child: wrapWithModel(
                model: _model.zOptionalsButtonsModel1,
                updateCallback: () => safeSetState(() {}),
                child: ZOptionalsButtonsWidget(
                  icon: Icon(
                    FFIcons.kpencilMinus,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  text: 'Edit',
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
            ),
          Divider(
            height: 1.0,
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
            color: FlutterFlowTheme.of(context).divider,
          ),
          InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.pop(context);
            },
            child: wrapWithModel(
              model: _model.zOptionalsButtonsModel2,
              updateCallback: () => safeSetState(() {}),
              child: ZOptionalsButtonsWidget(
                icon: Icon(
                  FFIcons.ktrash04,
                  color: FlutterFlowTheme.of(context).error,
                  size: 24.0,
                ),
                text: 'Edit',
                color: FlutterFlowTheme.of(context).error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
