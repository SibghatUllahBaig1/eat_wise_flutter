import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/backend_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'activity_view_model.dart';
export 'activity_view_model.dart';

class ActivityViewWidget extends StatefulWidget {
  const ActivityViewWidget({
    super.key,
    required this.activityData,
  });

  final Map<String, dynamic> activityData;

  static String routeName = 'ActivityView';
  static String routePath = '/activityView';

  @override
  State<ActivityViewWidget> createState() => _ActivityViewWidgetState();
}

class _ActivityViewWidgetState extends State<ActivityViewWidget> {
  late ActivityViewModel _model;
  final backend = BackendManager();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityViewModel());

    // Load activity data
    final data = widget.activityData;
    _model.activityId = data['id'] as String?;
    _model.activityName = data['activityName'] as String? ?? 'Unknown Activity';
    _model.duration = data['duration'] as int? ?? 0;
    _model.favorite = data['isFavorite'] as bool? ?? false;
    _model.iconName = data['iconName'] as String? ?? 'sport2';
    _model.caloriesBurned = data['caloriesBurned'] as int? ?? 0;
    _model.notes = data['notes'] as String?;
  }

  IconData _getActivityIcon(String? iconName) {
    if (iconName == null || iconName.isEmpty) return FFIcons.ksport2;

    switch (iconName) {
      case 'sport1':
        return FFIcons.ksport1;
      case 'sport2':
        return FFIcons.ksport2;
      case 'sport3':
        return FFIcons.ksport3;
      case 'sport4':
        return FFIcons.ksport4;
      case 'sport5':
        return FFIcons.ksport5;
      case 'sport6':
        return FFIcons.ksport6;
      case 'sport7':
        return FFIcons.ksport7;
      case 'sport8':
        return FFIcons.ksport8;
      case 'sport9':
        return FFIcons.ksport9;
      case 'sport10':
        return FFIcons.ksport10;
      case 'sport11':
        return FFIcons.ksport11;
      case 'sport12':
        return FFIcons.ksport12;
      case 'sport13':
        return FFIcons.ksport13;
      case 'sport14':
        return FFIcons.ksport14;
      case 'sport15':
        return FFIcons.ksport15;
      case 'sport16':
        return FFIcons.ksport16;
      case 'sport17':
        return FFIcons.ksport17;
      case 'sport19':
        return FFIcons.ksport19;
      case 'other':
        return FFIcons.kdotsHorizontal;
      default:
        return FFIcons.ksport2;
    }
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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
          actions: [
            // Delete button
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
                child: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 22.0,
                  borderWidth: 1.0,
                  buttonSize: 44.0,
                  icon: Icon(
                    FFIcons.ktrash,
                    color: FlutterFlowTheme.of(context).error,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    // Show confirmation dialog
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Activity'),
                        content: Text(
                            'Are you sure you want to delete this activity?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Delete',
                                style: TextStyle(
                                    color: FlutterFlowTheme.of(context).error)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && backend.currentUserId != null) {
                      try {
                        await backend.activityService.deleteActivity(
                          userId: backend.currentUserId!,
                          activityId: _model.activityId!,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Activity deleted successfully'),
                            backgroundColor:
                                FlutterFlowTheme.of(context).success,
                          ),
                        );

                        context.safePop();
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Failed to delete activity: ${e.toString()}'),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
            ),
          ),
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Activity icon and name
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Icon(
                          _getActivityIcon(_model.iconName),
                          color: FlutterFlowTheme.of(context).info,
                          size: 48.0,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _model.activityName,
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                '${_model.caloriesBurned} cal',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.inter(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Duration field (read-only)
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Duration (min)',
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                              font: GoogleFonts.inter(),
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            _model.duration.toString(),
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.inter(),
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Notes field (read-only)
                if (_model.notes != null && _model.notes!.isNotEmpty)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Note',
                          style:
                              FlutterFlowTheme.of(context).labelLarge.override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              _model.notes!,
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    font: GoogleFonts.inter(),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ]
                  .addToStart(SizedBox(height: 16.0))
                  .addToEnd(SizedBox(height: 24.0)),
            ),
          ),
        ),
      ),
    );
  }
}
