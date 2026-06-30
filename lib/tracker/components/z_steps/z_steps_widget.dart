import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_drinks_optionals/z_drinks_optionals_widget.dart';
import 'dart:ui';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_steps_model.dart';
export 'z_steps_model.dart';

class ZStepsWidget extends StatefulWidget {
  const ZStepsWidget({
    super.key,
    required this.step,
    required this.burning,
    required this.distance,
    this.stepId,
    this.onDelete,
    this.embedded = false,
  });

  final int? step;
  final int? burning;
  final double? distance;
  final String? stepId;
  final Future<void> Function(String)? onDelete;
  final bool embedded;

  @override
  State<ZStepsWidget> createState() => _ZStepsWidgetState();
}

class _ZStepsWidgetState extends State<ZStepsWidget> {
  late ZStepsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZStepsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        widget.embedded ? 16.0 : 16.0,
        widget.embedded ? 14.0 : 16.0,
        widget.embedded ? 6.0 : 6.0,
        widget.embedded ? 14.0 : 16.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (widget.embedded)
            Container(
              width: 36.0,
              height: 36.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).stepAccent,
                borderRadius: BorderRadius.circular(8.0),
              ),
              alignment: Alignment.center,
              child: Icon(
                FFIcons.kstepIcon,
                color: FlutterFlowTheme.of(context).stepColor,
                size: 18.0,
              ),
            ),
          if (widget.embedded)
            SizedBox(width: 12.0),
          if (!widget.embedded)
            Icon(
              FFIcons.kstepIcon,
              color: FlutterFlowTheme.of(context).stepColor,
              size: 19.0,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  widget.embedded ? 0.0 : 4.0, 0.0, 0.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    valueOrDefault<String>(
                      widget.step?.toString(),
                      '0',
                    ),
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                          letterSpacing: 0.0,
                        ),
                  ),
                  if (widget.embedded)
                    Text(
                      'steps',
                      style: FlutterFlowTheme.of(context).labelSmall.override(
                            font: GoogleFonts.inter(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                ],
              ),
            ),
          ),
          Icon(
            FFIcons.kfireIcon2,
            color: FlutterFlowTheme.of(context).error,
            size: 20.0,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 8.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                widget.burning?.toString(),
                '0',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          Icon(
            FFIcons.kmapPin,
            color: FlutterFlowTheme.of(context).waterColor,
            size: 18.0,
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 8.0, 0.0),
            child: Text(
              valueOrDefault<String>(
                widget.distance?.toStringAsFixed(1),
                '0.0',
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.inter(),
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          if (widget.onDelete != null && widget.stepId != null)
            Builder(
              builder: (context) => FlutterFlowIconButton(
                borderRadius: 22.0,
                buttonSize: 44.0,
                fillColor: FlutterFlowTheme.of(context).transparent,
                icon: Icon(
                  FFIcons.kdotsVertical,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
                onPressed: () async {
                  await showAlignedDialog(
                    barrierColor: FlutterFlowTheme.of(context).transparent,
                    context: context,
                    isGlobal: false,
                    avoidOverflow: false,
                    targetAnchor: AlignmentDirectional(1.0, -1.0)
                        .resolve(Directionality.of(context)),
                    followerAnchor: AlignmentDirectional(1.0, -1.0)
                        .resolve(Directionality.of(context)),
                    builder: (dialogContext) {
                      return Material(
                        color: Colors.transparent,
                        child: ZDrinksOptionalsWidget(
                          trackerType: 1,
                          drinkId: widget.stepId,
                          onDelete: (String id) async {
                            await widget.onDelete!(id);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );

    if (widget.embedded) {
      return content;
    }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: content,
      ),
    );
  }
}
