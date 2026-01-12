import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import '/backend/backend_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_activity_templates_content_model.dart';
export 'z_activity_templates_content_model.dart';

class ZActivityTemplatesContentWidget extends StatefulWidget {
  const ZActivityTemplatesContentWidget({
    super.key,
    this.filterType = 'recent', // 'recent', 'favorites', 'personal'
    this.searchQuery = '',
  });

  final String filterType;
  final String searchQuery;

  @override
  State<ZActivityTemplatesContentWidget> createState() =>
      _ZActivityTemplatesContentWidgetState();
}

class _ZActivityTemplatesContentWidgetState
    extends State<ZActivityTemplatesContentWidget> {
  late ZActivityTemplatesContentModel _model;
  final backend = BackendManager();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZActivityTemplatesContentModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Stream<List<Map<String, dynamic>>> _getActivitiesStream() {
    if (backend.currentUserId == null) {
      return Stream.value([]);
    }

    final userId = backend.currentUserId!;

    // Base query
    Query query = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('activities');

    // Apply filters based on type
    if (widget.filterType == 'personal') {
      query = query.where('activityType', whereIn: ['custom', 'quick_log']);
    } else if (widget.filterType == 'favorites') {
      query = query.where('isFavorite', isEqualTo: true);
    }

    // Order by date
    query = query.orderBy('date', descending: true).limit(50);

    return query.snapshots().map((snapshot) {
      var activities = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;

        // Convert Timestamp to DateTime
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate();
        }

        return data;
      }).toList();

      // Apply search filter
      if (widget.searchQuery.isNotEmpty) {
        final searchLower = widget.searchQuery.toLowerCase();
        activities = activities.where((activity) {
          final name =
              (activity['activityName'] as String? ?? '').toLowerCase();
          return name.contains(searchLower);
        }).toList();
      }

      return activities;
    });
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

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    final activityName =
        activity['activityName'] as String? ?? 'Unknown Activity';
    final calories = activity['caloriesBurned'] as int? ?? 0;
    final duration = activity['duration'] as int? ?? 0;
    final iconName = activity['iconName'] as String?;

    // Get the icon using the helper function
    IconData activityIcon = _getActivityIcon(iconName);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityDetailsWidget(
                activityData: activity,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Icon(
                    activityIcon,
                    color: FlutterFlowTheme.of(context).info,
                    size: 32.0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activityName,
                          style:
                              FlutterFlowTheme.of(context).titleSmall.override(
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
                                    lineHeight: 1.0,
                                  ),
                        ),
                        Text(
                          '$calories kcal, $duration min',
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                    lineHeight: 1.0,
                                  ),
                        ),
                      ].divide(SizedBox(height: 12.0)),
                    ),
                  ),
                ),
                Icon(
                  FFIcons.kchevronRight,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _getActivitiesStream(),
      builder: (context, snapshot) {
        // Show loading indicator
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(
                color: FlutterFlowTheme.of(context).primary,
              ),
            ),
          );
        }

        // Show error message
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text(
                'Error loading activities',
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ),
          );
        }

        final activities = snapshot.data ?? [];

        // Show empty state
        if (activities.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    FFIcons.krun,
                    size: 64.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    widget.searchQuery.isNotEmpty
                        ? 'No activities found'
                        : 'No activities yet',
                    style: FlutterFlowTheme.of(context).titleMedium.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    widget.searchQuery.isNotEmpty
                        ? 'Try a different search term'
                        : 'Start logging your activities',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show activities list
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: activities
                .map((activity) => _buildActivityItem(activity))
                .toList()
                .divide(SizedBox(height: 12.0))
                .addToStart(SizedBox(height: 16.0))
                .addToEnd(SizedBox(height: 24.0)),
          ),
        );
      },
    );
  }
}
