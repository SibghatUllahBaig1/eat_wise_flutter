import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'app_header_model.dart';
export 'app_header_model.dart';

/// Reusable EatWise logo header component
/// Displays the app logo and name consistently across all pages
class AppHeaderWidget extends StatefulWidget {
  const AppHeaderWidget({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
  });

  final bool showBackButton;
  final VoidCallback? onBackPressed;

  @override
  State<AppHeaderWidget> createState() => _AppHeaderWidgetState();
}

class _AppHeaderWidgetState extends State<AppHeaderWidget> {
  late AppHeaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AppHeaderModel());
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
        color: FlutterFlowTheme.of(context).primaryBackground,
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Color(0x0F000000),
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Back button (optional)
            if (widget.showBackButton)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
                child: InkWell(
                  onTap: widget.onBackPressed ?? () => context.pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                ),
              ),
            
            // Logo and app name
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo icon
                  Container(
                    width: 36.0,
                    height: 36.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                  
                  // App name
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'EatWise',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            fontFamily: 'Readex Pro',
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 24.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Spacer to balance back button if present
            if (widget.showBackButton)
              SizedBox(width: 36.0),
          ],
        ),
      ),
    );
  }
}

