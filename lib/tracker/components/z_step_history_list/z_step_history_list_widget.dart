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
  const ZStepHistoryListWidget({super.key});

  @override
  State<ZStepHistoryListWidget> createState() => _ZStepHistoryListWidgetState();
}

class _ZStepHistoryListWidgetState extends State<ZStepHistoryListWidget> {
  late ZStepHistoryListModel _model;
  final backend = BackendManager();
  List<Map<String, dynamic>> _stepEntries = [];
  bool _isLoading = true;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZStepHistoryListModel());

    // Load step entries when component loads
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadStepEntries();
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  /// Load step entries from Firestore
  Future<void> _loadStepEntries() async {
    if (currentUserUid.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final selectedDate = FFAppState().tracker.selectedDate ?? DateTime.now();

      final entries = await backend.stepTrackerService.getStepsForDate(
        userId: currentUserUid,
        date: selectedDate,
      );

      setState(() {
        _stepEntries = entries;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading step entries: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    if (_isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).stepColor,
          ),
        ),
      );
    }

    if (_stepEntries.isEmpty) {
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
      children: _stepEntries
          .map((entry) {
            final steps = entry['steps'] as int? ?? 0;
            final duration = entry['duration'] as int? ?? 0;
            final calories = entry['calories'] as int? ?? 0;
            final distance = entry['distance'] as double? ?? 0.0;

            // Format duration as "Xm"
            final timeStr = '${duration}m';

            return ZStepsWidget(
              step: steps,
              time: timeStr,
              burning: calories,
              distance: distance,
            );
          })
          .toList()
          .divide(SizedBox(height: 12.0)),
    );
  }
}
