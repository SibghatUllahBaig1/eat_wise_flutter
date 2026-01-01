import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'icon_text_right_model.dart';
export 'icon_text_right_model.dart';

class IconTextRightWidget extends StatefulWidget {
  const IconTextRightWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.textColor,
  });

  final Widget? icon;
  final String? text;
  final Color? textColor;

  @override
  State<IconTextRightWidget> createState() => _IconTextRightWidgetState();
}

class _IconTextRightWidgetState extends State<IconTextRightWidget> {
  late IconTextRightModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IconTextRightModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 12.0, 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          widget!.icon!,
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
              child: Text(
                valueOrDefault<String>(
                  widget!.text,
                  'null',
                ),
                style: FlutterFlowTheme.of(context).bodyLarge.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                      color: widget!.textColor,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                    ),
              ),
            ),
          ),
          Icon(
            FFIcons.kchevronRight,
            color: widget!.textColor,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
