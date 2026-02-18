import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'eatwise_logo_header_model.dart';
export 'eatwise_logo_header_model.dart';

/// Reusable EatWise logo header component
/// 
/// This component displays the EatWise logo with customizable options:
/// - Logo image (defaults to assets/images/custom-images/logo.png)
/// - Height (defaults to 32.0)
/// - Alignment (defaults to center)
/// - Show text alongside logo (defaults to false)
/// - Custom text style
class EatwiseLogoHeaderWidget extends StatefulWidget {
  const EatwiseLogoHeaderWidget({
    super.key,
    this.height = 32.0,
    this.alignment = Alignment.center,
    this.showText = false,
    this.logoPath = 'assets/images/custom-images/logo.png',
    this.textStyle,
  });

  final double height;
  final Alignment alignment;
  final bool showText;
  final String logoPath;
  final TextStyle? textStyle;

  @override
  State<EatwiseLogoHeaderWidget> createState() =>
      _EatwiseLogoHeaderWidgetState();
}

class _EatwiseLogoHeaderWidgetState extends State<EatwiseLogoHeaderWidget> {
  late EatwiseLogoHeaderModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EatwiseLogoHeaderModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showText) {
      // Logo with text
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(0.0),
            child: Image.asset(
              widget.logoPath,
              height: widget.height,
              fit: BoxFit.contain,
              alignment: widget.alignment,
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 0.0, 0.0),
            child: Text(
              'EatWise',
              style: widget.textStyle ??
                  FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                        ),
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 24.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
            ),
          ),
        ],
      );
    } else {
      // Logo only
      return ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: Image.asset(
          widget.logoPath,
          height: widget.height,
          fit: BoxFit.contain,
          alignment: widget.alignment,
        ),
      );
    }
  }
}

