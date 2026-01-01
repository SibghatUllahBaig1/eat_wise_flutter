import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'text_right_model.dart';
export 'text_right_model.dart';

class TextRightWidget extends StatefulWidget {
  const TextRightWidget({
    super.key,
    required this.text,
  });

  final String? text;

  @override
  State<TextRightWidget> createState() => _TextRightWidgetState();
}

class _TextRightWidgetState extends State<TextRightWidget> {
  late TextRightModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TextRightModel());
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
          Expanded(
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
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).titleSmall.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleSmall.fontStyle,
                  ),
            ),
          ),
          Icon(
            FFIcons.kchevronRight,
            color: FlutterFlowTheme.of(context).primaryText,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
