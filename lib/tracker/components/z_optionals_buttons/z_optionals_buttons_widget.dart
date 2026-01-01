import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_optionals_buttons_model.dart';
export 'z_optionals_buttons_model.dart';

class ZOptionalsButtonsWidget extends StatefulWidget {
  const ZOptionalsButtonsWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  final Widget? icon;
  final String? text;
  final Color? color;

  @override
  State<ZOptionalsButtonsWidget> createState() =>
      _ZOptionalsButtonsWidgetState();
}

class _ZOptionalsButtonsWidgetState extends State<ZOptionalsButtonsWidget> {
  late ZOptionalsButtonsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZOptionalsButtonsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget!.icon!,
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                widget!.text,
                'null',
              ),
              style: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.inter(
                      fontWeight:
                          FlutterFlowTheme.of(context).titleSmall.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    ),
                    color: widget!.color,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                    lineHeight: 1.0,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
