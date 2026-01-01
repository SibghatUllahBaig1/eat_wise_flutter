import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_weight_card/z_weight_card_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'weight_intake_history_model.dart';
export 'weight_intake_history_model.dart';

class WeightIntakeHistoryWidget extends StatefulWidget {
  const WeightIntakeHistoryWidget({super.key});

  static String routeName = 'WeightIntakeHistory';
  static String routePath = '/weightIntakeHistory';

  @override
  State<WeightIntakeHistoryWidget> createState() =>
      _WeightIntakeHistoryWidgetState();
}

class _WeightIntakeHistoryWidgetState extends State<WeightIntakeHistoryWidget> {
  late WeightIntakeHistoryModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WeightIntakeHistoryModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 22.0,
              borderWidth: 1.0,
              buttonSize: 44.0,
              icon: Icon(
                FFIcons.karrowLeft,
                color: FlutterFlowTheme.of(context).primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                context.pop();
              },
            ),
          ),
          title: Text(
            'Weight Intake History',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              wrapWithModel(
                model: _model.zWeightCardModel1,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.5,
                  time: 'Yesterday, Apr 28, 2025',
                  plus: false,
                  value: 0.2,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel2,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.7,
                  time: 'Apr 27, 2025',
                  plus: true,
                  value: 0.2,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel3,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.5,
                  time: 'Apr 26, 2025',
                  plus: false,
                  value: 0.2,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel4,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.7,
                  time: 'Apr 25, 2025',
                  plus: true,
                  value: 0.2,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel5,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.5,
                  time: 'Apr 24, 2025',
                  plus: false,
                  value: 0.3,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel6,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.0,
                  time: 'Apr 23, 2025',
                  plus: false,
                  value: 0.5,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel7,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.2,
                  time: 'Apr 22, 2025',
                  plus: true,
                  value: 0.2,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel8,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 77.9,
                  time: 'Apr 21, 2025',
                  plus: false,
                  value: 0.3,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel9,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 77.9,
                  time: 'Apr 20, 2025',
                  plus: false,
                  value: 0.0,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel10,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 78.1,
                  time: 'Apr 19, 2025',
                  plus: true,
                  value: 0.2,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel11,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 77.7,
                  time: 'Apr 18, 2025',
                  plus: false,
                  value: 0.4,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel12,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 77.2,
                  time: 'Apr 17, 2025',
                  plus: false,
                  value: 0.5,
                ),
              ),
              wrapWithModel(
                model: _model.zWeightCardModel13,
                updateCallback: () => safeSetState(() {}),
                child: ZWeightCardWidget(
                  weight: 76.9,
                  time: 'Apr 16, 2025',
                  plus: false,
                  value: 0.6,
                ),
              ),
            ]
                .divide(SizedBox(height: 12.0))
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
