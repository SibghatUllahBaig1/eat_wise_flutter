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
import 'z_weight_card_model.dart';
export 'z_weight_card_model.dart';

class ZWeightCardWidget extends StatefulWidget {
  const ZWeightCardWidget({
    super.key,
    required this.weight,
    required this.time,
    bool? plus,
    required this.value,
  }) : this.plus = plus ?? false;

  final double? weight;
  final String? time;
  final bool plus;
  final double? value;

  @override
  State<ZWeightCardWidget> createState() => _ZWeightCardWidgetState();
}

class _ZWeightCardWidgetState extends State<ZWeightCardWidget> {
  late ZWeightCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZWeightCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 6.0, 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${valueOrDefault<String>(
                          widget!.weight?.toString(),
                          'null',
                        )} kg',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                      ),
                      Text(
                        valueOrDefault<String>(
                          widget!.time,
                          'null',
                        ),
                        style: FlutterFlowTheme.of(context).labelSmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelSmall
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .labelSmall
                                  .fontStyle,
                            ),
                      ),
                    ].divide(SizedBox(height: 4.0)),
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  if (widget!.plus) {
                    return Icon(
                      FFIcons.kcircleChevronUp,
                      color: FlutterFlowTheme.of(context).error,
                      size: 18.0,
                    );
                  } else {
                    return Icon(
                      FFIcons.kcircleChevronDown,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 18.0,
                    );
                  }
                },
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(4.0, 0.0, 6.0, 0.0),
                child: Text(
                  '${widget!.plus ? '+' : '-'}${widget!.value?.toString()} kg',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.inter(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        color: widget!.plus
                            ? FlutterFlowTheme.of(context).error
                            : FlutterFlowTheme.of(context).primary,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodySmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                ),
              ),
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
                            trackerType: 2,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
