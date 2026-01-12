import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/tracker/components/z_drinks_optionals/z_drinks_optionals_widget.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'z_history_list_model.dart';
export 'z_history_list_model.dart';

class ZHistoryListWidget extends StatefulWidget {
  const ZHistoryListWidget({
    super.key,
    this.drinksList = const [],
    this.onDelete,
    this.onEdit,
  });

  final List<Map<String, dynamic>> drinksList;
  final Function(String)? onDelete;
  final Function(
      String drinkId, int amount, String drinkType, String drinkIcon)? onEdit;

  @override
  State<ZHistoryListWidget> createState() => _ZHistoryListWidgetState();
}

class _ZHistoryListWidgetState extends State<ZHistoryListWidget> {
  late ZHistoryListModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZHistoryListModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildDrinkIcon(String iconName) {
    // Map icon names to FFIcons
    final iconMap = {
      'cup8': FFIcons.kcup8,
      'cup4': FFIcons.kcup4,
      'cup9': FFIcons.kcup9,
      'cup1': FFIcons.kcup1,
      'cup2': FFIcons.kcup2,
      'cup3': FFIcons.kcup3,
      'cup5': FFIcons.kcup5,
      'cup6': FFIcons.kcup6,
      'cup7': FFIcons.kcup7,
      'cup10': FFIcons.kcup10,
    };

    // Check if it's an asset image
    if (iconName.startsWith('assets/') || iconName.startsWith('drinks')) {
      final assetPath =
          iconName.startsWith('assets/') ? iconName : 'assets/images/$iconName';
      return Padding(
        padding: EdgeInsets.all(12.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Image.asset(
            assetPath,
            width: 64.0,
            height: 64.0,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                FFIcons.kcup8,
                color: FlutterFlowTheme.of(context).waterColor,
                size: 32.0,
              );
            },
          ),
        ),
      );
    }

    // Otherwise use icon
    return Icon(
      iconMap[iconName] ?? FFIcons.kcup8,
      color: FlutterFlowTheme.of(context).waterColor,
      size: 32.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.drinksList.isEmpty) {
      return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'No drinks recorded yet',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: widget.drinksList.length,
        separatorBuilder: (context, index) => SizedBox(height: 12.0),
        itemBuilder: (context, index) {
          final drink = widget.drinksList[index];
          final drinkId = drink['id'] as String? ?? '';
          final amount = drink['amount'] as int? ?? 0;
          final drinkType = drink['drinkType'] as String? ?? 'Water';
          final drinkIcon = drink['drinkIcon'] as String? ?? 'cup8';
          final timestamp = drink['timestamp'] as DateTime?;
          final timeString =
              timestamp != null ? dateTimeFormat("jm", timestamp) : '';

          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 0.0, 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 64.0,
                    height: 64.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: _buildDrinkIcon(drinkIcon),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            drinkType,
                            style: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
                                ),
                          ),
                          Text(
                            timeString,
                            style: FlutterFlowTheme.of(context)
                                .labelSmall
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelSmall
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelSmall
                                      .fontStyle,
                                ),
                          ),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                    child: Text(
                      '$amount mL',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
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
                          ),
                    ),
                  ),
                  Builder(
                    builder: (context) => Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 6.0, 0.0),
                      child: FlutterFlowIconButton(
                        borderRadius: 22.0,
                        buttonSize: 44.0,
                        fillColor: FlutterFlowTheme.of(context).transparent,
                        icon: Icon(
                          FFIcons.kdotsVertical,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          await showAlignedDialog(
                            barrierColor:
                                FlutterFlowTheme.of(context).transparent,
                            context: context,
                            isGlobal: false,
                            avoidOverflow: false,
                            targetAnchor: AlignmentDirectional(1.0, -1.0)
                                .resolve(Directionality.of(context)),
                            followerAnchor: AlignmentDirectional(1.0, -1.0)
                                .resolve(Directionality.of(context)),
                            builder: (dialogContext) {
                              return Material(
                                color: Colors.transparent,
                                child: ZDrinksOptionalsWidget(
                                  trackerType: 0,
                                  drinkId: drinkId,
                                  onDelete: widget.onDelete,
                                  onEdit: widget.onEdit,
                                  amount: amount,
                                  drinkType: drinkType,
                                  drinkIcon: drinkIcon,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
