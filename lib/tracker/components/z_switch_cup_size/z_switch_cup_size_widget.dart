import '/components/paywall_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_switch_cup_size_model.dart';
export 'z_switch_cup_size_model.dart';

class ZSwitchCupSizeWidget extends StatefulWidget {
  const ZSwitchCupSizeWidget({super.key});

  @override
  State<ZSwitchCupSizeWidget> createState() => _ZSwitchCupSizeWidgetState();
}

class _ZSwitchCupSizeWidgetState extends State<ZSwitchCupSizeWidget> {
  late ZSwitchCupSizeModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZSwitchCupSizeModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 50.0, 6.0, 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FlutterFlowIconButton(
                    borderRadius: 22.0,
                    buttonSize: 44.0,
                    fillColor: FlutterFlowTheme.of(context).transparent,
                    icon: Icon(
                      FFIcons.kxClose,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 44.0, 0.0),
                      child: Text(
                        'Add Drink',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).titleLarge.override(
                              font: GoogleFonts.inter(),
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Picker Section
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                    child: Text(
                      'Drink Amount',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            font: GoogleFonts.inter(),
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 10.0, 24.0, 0.0),
                    child: Text(
                      'Select the amount of drink to add.',
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            font: GoogleFonts.inter(),
                            letterSpacing: 0.0,
                            lineHeight: 1.5,
                          ),
                    ),
                  ),
                  // Number Picker
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 24.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FlutterFlowIconButton(
                          borderRadius: 22.0,
                          buttonSize: 44.0,
                          icon: Icon(
                            FFIcons.kchevronLeft,
                            color: _model.canDecrementDrinkAmount
                                ? FlutterFlowTheme.of(context).primaryText
                                : FlutterFlowTheme.of(context).iconColor,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            if (_model.canDecrementDrinkAmount) {
                              _model.decrementDrinkAmount();
                              safeSetState(() {});
                            }
                          },
                        ),
                        Expanded(
                          child: Text(
                            '${_model.drinkAmount} mL',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .headlineSmall
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        FlutterFlowIconButton(
                          borderRadius: 22.0,
                          buttonSize: 44.0,
                          icon: Icon(
                            FFIcons.kchevronRight,
                            color: _model.canIncrementDrinkAmount
                                ? FlutterFlowTheme.of(context).primaryText
                                : FlutterFlowTheme.of(context).iconColor,
                            size: 24.0,
                          ),
                          onPressed: () async {
                            if (_model.canIncrementDrinkAmount) {
                              _model.incrementDrinkAmount();
                              safeSetState(() {});
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  // Divider with "Select Drink Type" text
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).divider,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              24.0, 0.0, 24.0, 0.0),
                          child: Text(
                            'Select Drink Type',
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: 100.0,
                            height: 1.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).divider,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Drink Types Grid
                  _buildDrinkTypesGrid(),
                ]
                    .addToStart(SizedBox(height: 16.0))
                    .addToEnd(SizedBox(height: 24.0)),
              ),
            ),
          ),
          // Add Button at bottom
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 24.0),
            child: FFButtonWidget(
              onPressed: _model.isLoading
                  ? null
                  : () async {
                      final hasAccess = await checkFeatureAccess(
                        context: context,
                        featureName: 'water_activity_tracking',
                        displayName: 'Water & Activity Tracking',
                      );
                      if (!hasAccess || !context.mounted) return;
                      await _model.addDrink(context, () => safeSetState(() {}));
                    },
              text: _model.isLoading ? 'Adding...' : 'Add Drink',
              options: FFButtonOptions(
                width: double.infinity,
                height: 50.0,
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                color: FlutterFlowTheme.of(context).primary,
                textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                      font: GoogleFonts.inter(),
                      color: Colors.white,
                      letterSpacing: 0.0,
                    ),
                elevation: 0.0,
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrinkTypesGrid() {
    final drinkTypes = [
      {'name': 'Water', 'icon': 'assets/images/drinks4.png'},
      {'name': 'Coffee', 'icon': 'assets/images/drinks1.png'},
      {'name': 'Tea', 'icon': 'assets/images/drinks3.png'},
      {'name': 'Juice', 'icon': 'assets/images/drinks2.png'},
      {'name': 'Sport Drink', 'icon': 'assets/images/drinks4.png'},
      {'name': 'Coconut Water', 'icon': 'assets/images/drinks5.png'},
      {'name': 'Smoothie', 'icon': 'assets/images/drinks6.png'},
      {'name': 'Chocolate Milk', 'icon': 'assets/images/drinks8.png'},
      {'name': 'Carbon', 'icon': 'assets/images/drinks12.png'},
      {'name': 'Soda', 'icon': 'assets/images/drinks7.png'},
      {'name': 'Wine', 'icon': 'assets/images/drinks9.png'},
      {'name': 'Bear', 'icon': 'assets/images/drinks10.png'},
      {'name': 'Other', 'icon': 'assets/images/drinks7.png'},
    ];

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 24.0),
      child: Wrap(
        spacing: 12.0,
        runSpacing: 16.0,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.none,
        children: drinkTypes.map((drink) {
          final isSelected = _model.selectedDrinkType == drink['name'];
          // Calculate item width: (screen width - left padding - right padding - 3 gaps) / 4 items
          final itemWidth =
              (MediaQuery.sizeOf(context).width - 32.0 - 36.0) / 4;
          return InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              _model.selectedDrinkType = drink['name'] as String;
              _model.selectedDrinkIcon = drink['icon'] as String;
              safeSetState(() {});
            },
            child: SizedBox(
              width: itemWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: itemWidth,
                    height: itemWidth,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.2)
                          : FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(12.0),
                      border: isSelected
                          ? Border.all(
                              color: FlutterFlowTheme.of(context).primary,
                              width: 2.0,
                            )
                          : null,
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          drink['icon'] as String,
                          fit: BoxFit.cover,
                          alignment: Alignment(0.0, 0.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                      drink['name'] as String,
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.inter(),
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
