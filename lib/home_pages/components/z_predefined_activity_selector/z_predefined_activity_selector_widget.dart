import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/data/predefined_activities.dart';
import 'package:flutter/material.dart';
import 'z_predefined_activity_selector_model.dart';
export 'z_predefined_activity_selector_model.dart';

/// Selector for predefined activities with icons
/// Returns a Map with 'name', 'iconName', and 'caloriesPerHour'
class ZPredefinedActivitySelectorWidget extends StatefulWidget {
  const ZPredefinedActivitySelectorWidget({super.key});

  @override
  State<ZPredefinedActivitySelectorWidget> createState() =>
      _ZPredefinedActivitySelectorWidgetState();
}

class _ZPredefinedActivitySelectorWidgetState
    extends State<ZPredefinedActivitySelectorWidget> {
  late ZPredefinedActivitySelectorModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZPredefinedActivitySelectorModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Activity',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: FlutterFlowTheme.of(context).secondaryText,
                      size: 24.0,
                    ),
                  ),
                ],
              ),
            ),
            
            Divider(height: 1.0),
            
            // Activity Grid
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 24.0),
                  child: Wrap(
                    spacing: 12.0,
                    runSpacing: 16.0,
                    alignment: WrapAlignment.start,
                    children: PredefinedActivities.activities.map((activity) {
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, {
                            'name': activity.name,
                            'iconName': activity.iconName,
                            'caloriesPerHour': activity.caloriesPerHour,
                          });
                        },
                        child: Container(
                          width: (MediaQuery.sizeOf(context).width - 68) / 4,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: (MediaQuery.sizeOf(context).width - 68) / 4,
                                height: (MediaQuery.sizeOf(context).width - 68) / 4,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  activity.icon,
                                  color: FlutterFlowTheme.of(context).primaryText,
                                  size: 32.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                activity.name,
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Readex Pro',
                                      fontSize: 11.0,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

