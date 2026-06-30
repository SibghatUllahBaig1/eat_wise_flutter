import '/backend/utils/unit_format_helper.dart';
import '/backend/services/weight_sync_helper.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/schema/structs/index.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_b_m_i_tracker_edit_model.dart';
export 'z_b_m_i_tracker_edit_model.dart';

class ZBMITrackerEditWidget extends StatefulWidget {
  const ZBMITrackerEditWidget({super.key});

  @override
  State<ZBMITrackerEditWidget> createState() => _ZBMITrackerEditWidgetState();
}

class _ZBMITrackerEditWidgetState extends State<ZBMITrackerEditWidget> {
  late ZBMITrackerEditModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  void _populateFields() {
    final heightUnit = FFAppState().trackerSettings.weight.heightUnit;
    final weightUnit = FFAppState().trackerSettings.weight.weightUnit;
    var heightCm = FFAppState().trackerSettings.weight.height.toDouble();
    if (heightCm <= 0 && FFAppState().userProfile.heightCm > 0) {
      heightCm = FFAppState().userProfile.heightCm;
    }

    if (UnitFormatHelper.isFt(heightUnit)) {
      final imperial = UnitFormatHelper.cmToFeetInches(heightCm);
      _model.textController1!.text =
          heightCm > 0 ? '${imperial.feet}' : '';
      _model.heightInchesController!.text =
          heightCm > 0 ? '${imperial.inches}' : '';
    } else {
      _model.textController1!.text =
          UnitFormatHelper.formatHeightCmForInput(heightCm);
      _model.heightInchesController!.text = '';
    }

    final latestKg = WeightSyncHelper.resolveCurrentWeightKg();
    _model.textController2!.text = latestKg > 0
        ? UnitFormatHelper.formatWeightForInput(latestKg, weightUnit)
        : '';
  }

  double? _parseHeightCm() {
    final heightUnit = FFAppState().trackerSettings.weight.heightUnit;
    if (UnitFormatHelper.isFt(heightUnit)) {
      return UnitFormatHelper.parseFeetInchesInput(
        _model.textController1?.text ?? '',
        _model.heightInchesController?.text ?? '',
      );
    }
    return UnitFormatHelper.parseHeightInput(
      _model.textController1?.text ?? '',
      heightUnit,
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZBMITrackerEditModel());

    _model.textController1 ??= TextEditingController();
    _model.textFieldFocusNode1 ??= FocusNode();
    _model.heightInchesController ??= TextEditingController();
    _model.heightInchesFocusNode ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _populateFields();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  InputDecoration _bmiFieldDecoration(BuildContext context) => InputDecoration(
        isDense: true,
        hintText: '0',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0x00000000), width: 1.0),
          borderRadius: BorderRadius.circular(12.0),
        ),
        contentPadding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 8.0, 0.0),
      );

  TextStyle _bmiValueStyle(BuildContext context) =>
      FlutterFlowTheme.of(context).displayMedium.override(
            font: GoogleFonts.inter(fontWeight: FontWeight.w600),
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
            lineHeight: 1.0,
          );

  Widget _unitSuffix(BuildContext context, String label) => Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 3.0),
        child: Text(
          label,
          style: FlutterFlowTheme.of(context).bodyLarge.override(
                font: GoogleFonts.inter(),
                letterSpacing: 0.0,
              ),
        ),
      );

  Widget _buildHeightRow(BuildContext context, String heightUnit) {
    if (UnitFormatHelper.isFt(heightUnit)) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: 80.0,
            child: TextFormField(
              controller: _model.textController1,
              focusNode: _model.textFieldFocusNode1,
              decoration: _bmiFieldDecoration(context),
              style: _bmiValueStyle(context),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
            ),
          ),
          _unitSuffix(context, 'ft'),
          SizedBox(width: 8.0),
          SizedBox(
            width: 80.0,
            child: TextFormField(
              controller: _model.heightInchesController,
              focusNode: _model.heightInchesFocusNode,
              decoration: _bmiFieldDecoration(context),
              style: _bmiValueStyle(context),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
            ),
          ),
          _unitSuffix(context, 'in'),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 145.0,
          child: TextFormField(
            controller: _model.textController1,
            focusNode: _model.textFieldFocusNode1,
            decoration: _bmiFieldDecoration(context),
            style: _bmiValueStyle(context),
            textAlign: TextAlign.end,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        _unitSuffix(context, 'cm'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final heightUnit = FFAppState().trackerSettings.weight.heightUnit;
    final weightUnit = FFAppState().trackerSettings.weight.weightUnit;

    return Align(
      alignment: AlignmentDirectional(0.0, 1.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
              child: Text(
                'Edit BMI',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.inter(),
                      letterSpacing: 0.0,
                    ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 0.0),
              child: Container(
                width: double.infinity,
                height: 88.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: _buildHeightRow(context, heightUnit),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
              child: Container(
                width: double.infinity,
                height: 88.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 120.0,
                      child: TextFormField(
                        controller: _model.textController2,
                        focusNode: _model.textFieldFocusNode2,
                        decoration: _bmiFieldDecoration(context),
                        style: _bmiValueStyle(context),
                        textAlign: TextAlign.end,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                      ),
                    ),
                    _unitSuffix(
                      context,
                      UnitFormatHelper.weightUnitLabel(weightUnit),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 32.0, 16.0, 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async => Navigator.pop(context),
                      text: 'Cancel',
                      options: FFButtonOptions(
                        height: 50.0,
                        color: FlutterFlowTheme.of(context).divider,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(font: GoogleFonts.inter()),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        final heightCm = _parseHeightCm();
                        final weightKg = UnitFormatHelper.parseWeightInput(
                          _model.textController2?.text ?? '',
                          weightUnit,
                        );

                        if (heightCm != null &&
                            UnitFormatHelper.isValidHeightCm(heightCm)) {
                          FFAppState().updateTrackerSettingsStruct(
                            (e) => e
                              ..updateWeight(
                                  (w) => w..height = heightCm.round()),
                          );
                        }

                        if (weightKg != null &&
                            UnitFormatHelper.isValidWeightKg(weightKg)) {
                          final userId = currentUserUid;
                          if (userId.isNotEmpty) {
                            await WeightSyncHelper.recordWeight(
                              userId: userId,
                              weightKg: weightKg,
                              date: DateTime.now(),
                            );
                          } else {
                            WeightSyncHelper.upsertLocalWeightEntry(
                              date: DateTime.now(),
                              weightKg: weightKg,
                            );
                            WeightSyncHelper.propagateCanonicalCurrentWeight();
                          }
                        }

                        if (context.mounted) Navigator.pop(context);
                      },
                      text: 'Save',
                      options: FFButtonOptions(
                        height: 50.0,
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle: FlutterFlowTheme.of(context)
                            .titleSmall
                            .override(
                              font: GoogleFonts.inter(),
                              color: FlutterFlowTheme.of(context).info,
                            ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ].divide(SizedBox(width: 12.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
