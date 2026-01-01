import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_steps/z_steps_widget.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_step_history_list_model.dart';
export 'z_step_history_list_model.dart';

class ZStepHistoryListWidget extends StatefulWidget {
  const ZStepHistoryListWidget({super.key});

  @override
  State<ZStepHistoryListWidget> createState() => _ZStepHistoryListWidgetState();
}

class _ZStepHistoryListWidgetState extends State<ZStepHistoryListWidget> {
  late ZStepHistoryListModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZStepHistoryListModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        wrapWithModel(
          model: _model.zStepsModel1,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 850,
            time: '8m',
            burning: 40,
            distance: 0.7,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel2,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 950,
            time: '9m',
            burning: 45,
            distance: 0.8,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel3,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 1200,
            time: '12m',
            burning: 60,
            distance: 1.0,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel4,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 900,
            time: '8m',
            burning: 60,
            distance: 0.5,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel5,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 1000,
            time: '11m',
            burning: 55,
            distance: 1.0,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel6,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 400,
            time: '5m',
            burning: 30,
            distance: 0.3,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel7,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 2000,
            time: '18m',
            burning: 45,
            distance: 1.7,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel8,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 1200,
            time: '12m',
            burning: 60,
            distance: 1.1,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel9,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 1350,
            time: '9m',
            burning: 55,
            distance: 1.1,
          ),
        ),
        wrapWithModel(
          model: _model.zStepsModel10,
          updateCallback: () => safeSetState(() {}),
          child: ZStepsWidget(
            step: 1050,
            time: '10m',
            burning: 65,
            distance: 1.0,
          ),
        ),
      ].divide(SizedBox(height: 12.0)),
    );
  }
}
