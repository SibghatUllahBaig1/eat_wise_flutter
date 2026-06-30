import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/tracker/components/z_steps/z_steps_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_step_history_list_model.dart';
export 'z_step_history_list_model.dart';

class ZStepHistoryListWidget extends StatefulWidget {
  const ZStepHistoryListWidget({
    super.key,
    this.stepEntries,
    this.onDelete,
    this.compact = false,
  });

  final List<Map<String, dynamic>>? stepEntries;
  final Future<void> Function(String)? onDelete;
  final bool compact;

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

  Widget _buildEmptyState(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    return SizedBox(
      width: double.infinity,
      height: widget.compact ? 168.0 : 200.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 56.0,
                height: 56.0,
                decoration: BoxDecoration(
                  color: theme.stepAccent,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  FFIcons.kstepIcon,
                  color: theme.stepColor,
                  size: 26.0,
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Text(
                  'No step entries for this date',
                  textAlign: TextAlign.center,
                  style: theme.titleSmall.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    letterSpacing: 0.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                child: Text(
                  'Steps appear here as you walk or add them manually',
                  textAlign: TextAlign.center,
                  style: theme.bodySmall.override(
                    font: GoogleFonts.inter(),
                    color: theme.secondaryText,
                    letterSpacing: 0.0,
                    lineHeight: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.compact ? 168.0 : 200.0,
      child: Center(
        child: SizedBox(
          width: 28.0,
          height: 28.0,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: FlutterFlowTheme.of(context).stepColor,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    if (widget.stepEntries == null) {
      return _buildLoadingState(context);
    }

    if (widget.stepEntries!.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.stepEntries!.length; i++) ...[
          if (widget.compact && i > 0)
            Divider(
              height: 1.0,
              thickness: 1.0,
              indent: 16.0,
              endIndent: 16.0,
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
          Builder(builder: (context) {
            final entry = widget.stepEntries![i];
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
              embedded: widget.compact,
            );
          }),
        ],
      ],
    );
  }
}
