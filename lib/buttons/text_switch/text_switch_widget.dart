import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'text_switch_model.dart';
export 'text_switch_model.dart';

class TextSwitchWidget extends StatefulWidget {
  const TextSwitchWidget({
    super.key,
    bool? switchBoolean,
    required this.text,
  }) : this.switchBoolean = switchBoolean ?? false;

  final bool switchBoolean;
  final String? text;

  @override
  State<TextSwitchWidget> createState() => _TextSwitchWidgetState();
}

class _TextSwitchWidgetState extends State<TextSwitchWidget> {
  late TextSwitchModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TextSwitchModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 15.0, 20.0),
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
          ),
          Container(
            width: 48.0,
            height: 28.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: valueOrDefault<Color>(
                      widget!.switchBoolean
                          ? FlutterFlowTheme.of(context).primary
                          : FlutterFlowTheme.of(context).divider,
                      FlutterFlowTheme.of(context).divider,
                    ),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(
                      valueOrDefault<double>(
                        widget!.switchBoolean ? 1.0 : -1.0,
                        0.0,
                      ),
                      0.0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 2.0, 0.0),
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).info,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 4.0,
                            color: Color(0x0E000000),
                            offset: Offset(
                              widget!.switchBoolean ? -1.0 : 1.0,
                              0.0,
                            ),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
