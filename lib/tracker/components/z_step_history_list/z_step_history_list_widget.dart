import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/tracker/components/z_steps/z_steps_widget.dart';
import '/backend/backend_manager.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_step_history_list_model.dart';
export 'z_step_history_list_model.dart';

class ZStepHistoryListWidget extends StatefulWidget {
  const ZStepHistoryListWidget({
    super.key,
    this.stepEntries,
    this.onDelete,
  });

  final List<Map<String, dynamic>>? stepEntries;
  final Future<void> Function(String)? onDelete;

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
    context.watch<FFAppState>();

    if (widget.stepEntries == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).stepColor,
          ),
        ),
      );
    }

    if (widget.stepEntries!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          'No step entries for this date',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(),
                color: FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: widget.stepEntries!
          .map((entry) {
            final steps = entry['steps'] as int? ?? 0;
            final calories = entry['calories'] as int? ?? 0;
            final distance = entry['distance'] as double? ?? 0.0;
            final stepId = entry['id'] as String;

            return ZStepsWidget(
              step: steps,
              burning: calories,
              distance: distance,
              stepId: stepId,
              onDelete: widget.onDelete!,
            );
          })
          .toList()
          .divide(SizedBox(height: 12.0)),
    );
  }
}
