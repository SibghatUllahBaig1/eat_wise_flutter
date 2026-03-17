import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/recipes/components/z_search/z_search_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_filter_model.dart';
export 'z_filter_model.dart';

class ZFilterWidget extends StatefulWidget {
  const ZFilterWidget({super.key});

  @override
  State<ZFilterWidget> createState() => _ZFilterWidgetState();
}

class _ZFilterWidgetState extends State<ZFilterWidget> {
  late ZFilterModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZFilterModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.start = FFAppState().filter.energyValueStart;
      _model.end = FFAppState().filter.energyValueEnd;
      _model.favoriesOnly = FFAppState().filter.favoriteOnly;
      _model.selectedCategories =
          FFAppState().filter.categories.toList().cast<CategoryStruct>();
      safeSetState(() {});
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(6.0, 50.0, 6.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                FlutterFlowIconButton(
                  borderRadius: 22.0,
                  buttonSize: 44.0,
                  icon: Icon(
                    FFIcons.karrowLeft,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Filter',
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                          font: GoogleFonts.inter(
                            fontWeight: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleLarge
                                .fontStyle,
                          ),
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleLarge
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleLarge.fontStyle,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                    child: Text(
                      'Popular Filters',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .fontStyle,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedCategories
                                .contains(CategoryStruct(
                              title: 'Breakfast',
                              image:
                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/axwh2t6250zk/breakfast.png',
                            ))) {
                              _model
                                  .removeFromSelectedCategories(CategoryStruct(
                                title: 'Breakfast',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/axwh2t6250zk/breakfast.png',
                              ));
                              safeSetState(() {});
                            } else {
                              _model.addToSelectedCategories(CategoryStruct(
                                title: 'Breakfast',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/axwh2t6250zk/breakfast.png',
                              ));
                              safeSetState(() {});
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 98.0,
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(CategoryStruct(
                                      title: 'Breakfast',
                                      image:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/axwh2t6250zk/breakfast.png',
                                    ))
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/dishes1.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'Breakfast',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedCategories
                                .contains(CategoryStruct(
                              title: 'Lunch',
                              image:
                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/t3giuq4k13z3/lunch.png',
                            ))) {
                              _model
                                  .removeFromSelectedCategories(CategoryStruct(
                                title: 'Lunch',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/t3giuq4k13z3/lunch.png',
                              ));
                              safeSetState(() {});
                            } else {
                              _model.addToSelectedCategories(CategoryStruct(
                                title: 'Lunch',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/t3giuq4k13z3/lunch.png',
                              ));
                              safeSetState(() {});
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 98.0,
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(CategoryStruct(
                                      title: 'Lunch',
                                      image:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/t3giuq4k13z3/lunch.png',
                                    ))
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/dishes2.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'Lunch',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedCategories
                                .contains(CategoryStruct(
                              title: 'Dinner',
                              image:
                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/neusbl4hhgc8/dinner.png',
                            ))) {
                              _model
                                  .removeFromSelectedCategories(CategoryStruct(
                                title: 'Dinner',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/neusbl4hhgc8/dinner.png',
                              ));
                              safeSetState(() {});
                            } else {
                              _model.addToSelectedCategories(CategoryStruct(
                                title: 'Dinner',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/neusbl4hhgc8/dinner.png',
                              ));
                              safeSetState(() {});
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 98.0,
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(CategoryStruct(
                                      title: 'Dinner',
                                      image:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/neusbl4hhgc8/dinner.png',
                                    ))
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/dishes3.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'Dinner',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedCategories
                                .contains(CategoryStruct(
                              title: 'Vegan',
                              image:
                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/x6hcwh2qhtxp/diet4.png',
                            ))) {
                              _model
                                  .removeFromSelectedCategories(CategoryStruct(
                                title: 'Vegan',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/x6hcwh2qhtxp/diet4.png',
                              ));
                              safeSetState(() {});
                            } else {
                              _model.addToSelectedCategories(CategoryStruct(
                                title: 'Vegan',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/x6hcwh2qhtxp/diet4.png',
                              ));
                              safeSetState(() {});
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 98.0,
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(CategoryStruct(
                                      title: 'Vegan',
                                      image:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/x6hcwh2qhtxp/diet4.png',
                                    ))
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/dishes4.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'Vegan',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedCategories
                                .contains(CategoryStruct(
                              title: 'High Protein',
                              image:
                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/syp4y1c9myy8/diet5.png',
                            ))) {
                              _model
                                  .removeFromSelectedCategories(CategoryStruct(
                                title: 'High Protein',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/syp4y1c9myy8/diet5.png',
                              ));
                              safeSetState(() {});
                            } else {
                              _model.addToSelectedCategories(CategoryStruct(
                                title: 'High Protein',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/syp4y1c9myy8/diet5.png',
                              ));
                              safeSetState(() {});
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 98.0,
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(CategoryStruct(
                                      title: 'High Protein',
                                      image:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/syp4y1c9myy8/diet5.png',
                                    ))
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/dishes5.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'High Protein',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedCategories
                                .contains(CategoryStruct(
                              title: 'Low Carb',
                              image:
                                  'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/anefufgit0bj/diet6.png',
                            ))) {
                              _model
                                  .removeFromSelectedCategories(CategoryStruct(
                                title: 'Low Carb',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/anefufgit0bj/diet6.png',
                              ));
                              safeSetState(() {});
                            } else {
                              _model.addToSelectedCategories(CategoryStruct(
                                title: 'Low Carb',
                                image:
                                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/anefufgit0bj/diet6.png',
                              ));
                              safeSetState(() {});
                            }
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 98.0,
                                height: 72.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(CategoryStruct(
                                      title: 'Low Carb',
                                      image:
                                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/anefufgit0bj/diet6.png',
                                    ))
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/dishes6.png',
                                    width: 50.0,
                                    height: 50.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Text(
                                  'Low Carb',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                    child: Container(
                      height: 64.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 16.0, 0.0),
                                child: Text(
                                  'Favorites Only',
                                  style: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (_model.favoriesOnly) {
                                  _model.favoriesOnly = false;
                                  safeSetState(() {});
                                } else {
                                  _model.favoriesOnly = true;
                                  safeSetState(() {});
                                }
                              },
                              child: Container(
                                width: 48.0,
                                height: 28.0,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        color: valueOrDefault<Color>(
                                          _model.favoriesOnly
                                              ? FlutterFlowTheme.of(context)
                                                  .primary
                                              : FlutterFlowTheme.of(context)
                                                  .divider,
                                          FlutterFlowTheme.of(context).divider,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional(
                                          valueOrDefault<double>(
                                            _model.favoriesOnly ? 1.0 : -1.0,
                                            0.0,
                                          ),
                                          0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            2.0, 0.0, 2.0, 0.0),
                                        child: Container(
                                          width: 24.0,
                                          height: 24.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .info,
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 4.0,
                                                color: Color(0x0E000000),
                                                offset: Offset(
                                                  _model.favoriesOnly
                                                      ? -1.0
                                                      : 1.0,
                                                  0.0,
                                                ),
                                              )
                                            ],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                      child: Text(
                        'Energy Value',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              _model.start?.toString(),
                              '0',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                          Text(
                            valueOrDefault<String>(
                              _model.end?.toString(),
                              '700',
                            ),
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      child: custom_widgets.SliderWidget(
                        width: double.infinity,
                        height: 50.0,
                        min: 0.0,
                        max: 700.0,
                        start: FFAppState().filter.energyValueStart,
                        end: FFAppState().filter.energyValueEnd,
                        divisions: 7,
                        textColor: FlutterFlowTheme.of(context).primaryText,
                        sliderColor: FlutterFlowTheme.of(context).primary,
                        thumbColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                        inactiveTrackColor:
                            FlutterFlowTheme.of(context).divider,
                        showLabels: false,
                        minLabel: '\$',
                        maxLabel: '\$',
                        labelFontSize: 16.0,
                        valueFontSize: 16.0,
                        isEnabled: true,
                        showRangeLabels: false,
                        onChanged: (start, end) async {
                          _model.start = start;
                          _model.end = end;
                          safeSetState(() {});
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                    child: Text(
                      'Meals',
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
                            lineHeight: 1.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final mealsList =
                            FFAppState().categories.meals.toList();

                        return Wrap(
                          spacing: 12.0,
                          runSpacing: 12.0,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          clipBehavior: Clip.none,
                          children:
                              List.generate(mealsList.length, (mealsListIndex) {
                            final mealsListItem = mealsList[mealsListIndex];
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (_model.selectedCategories
                                    .contains(mealsListItem)) {
                                  _model.removeFromSelectedCategories(
                                      mealsListItem);
                                  safeSetState(() {});
                                } else {
                                  _model.addToSelectedCategories(mealsListItem);
                                  safeSetState(() {});
                                }
                              },
                              child: Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(mealsListItem)
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0.0),
                                          bottomRight: Radius.circular(0.0),
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                        child: Image.network(
                                          valueOrDefault<String>(
                                            mealsListItem.image,
                                            'https://picsum.photos/seed/184/600',
                                          ),
                                          width: 24.0,
                                          height: 24.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          mealsListItem.title,
                                          'Breakfast',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: valueOrDefault<Color>(
                                                _model.selectedCategories
                                                        .contains(mealsListItem)
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .info
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                    child: Text(
                      'Diets',
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
                            lineHeight: 1.0,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final dietsList =
                            FFAppState().categories.diets.toList();

                        return Wrap(
                          spacing: 12.0,
                          runSpacing: 12.0,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          clipBehavior: Clip.none,
                          children:
                              List.generate(dietsList.length, (dietsListIndex) {
                            final dietsListItem = dietsList[dietsListIndex];
                            return InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                if (_model.selectedCategories
                                    .contains(dietsListItem)) {
                                  _model.removeFromSelectedCategories(
                                      dietsListItem);
                                  safeSetState(() {});
                                } else {
                                  _model.addToSelectedCategories(dietsListItem);
                                  safeSetState(() {});
                                }
                              },
                              child: Container(
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: valueOrDefault<Color>(
                                    _model.selectedCategories
                                            .contains(dietsListItem)
                                        ? FlutterFlowTheme.of(context).primary
                                        : FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                    FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(0.0),
                                          bottomRight: Radius.circular(0.0),
                                          topLeft: Radius.circular(0.0),
                                          topRight: Radius.circular(0.0),
                                        ),
                                        child: Image.network(
                                          valueOrDefault<String>(
                                            dietsListItem.image,
                                            'https://picsum.photos/seed/184/600',
                                          ),
                                          width: 24.0,
                                          height: 24.0,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Text(
                                        valueOrDefault<String>(
                                          dietsListItem.title,
                                          'Vegetarian',
                                        ),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight: FontWeight.normal,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: valueOrDefault<Color>(
                                                _model.selectedCategories
                                                        .contains(dietsListItem)
                                                    ? FlutterFlowTheme.of(
                                                            context)
                                                        .info
                                                    : FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                FlutterFlowTheme.of(context)
                                                    .secondaryBackground,
                                              ),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ]
                    .addToStart(SizedBox(height: 12.0))
                    .addToEnd(SizedBox(height: 24.0)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if ((_model.selectedCategories.isNotEmpty) ||
                    _model.favoriesOnly ||
                    (_model.start! > 0.0) ||
                    (_model.end! < 700.0))
                  Expanded(
                    child: FFButtonWidget(
                      onPressed: () async {
                        _model.selectedCategories = [];
                        _model.favoriesOnly = false;
                        safeSetState(() {});
                      },
                      text: 'Clear',
                      options: FFButtonOptions(
                        height: 50.0,
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: FlutterFlowTheme.of(context).accent1,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                        elevation: 0.0,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                Expanded(
                  child: FFButtonWidget(
                    onPressed: () async {
                      FFAppState().updateFilterStruct(
                        (e) => e
                          ..categories = _model.selectedCategories.toList()
                          ..favoriteOnly = _model.favoriesOnly
                          ..energyValueStart = _model.start
                          ..energyValueEnd = _model.end,
                      );
                      _model.updatePage(() {});
                      if ((_model.start! > 0.0) || (_model.end! < 700.0)) {
                        FFAppState().updateFilterStruct(
                          (e) => e
                            ..updateCategories(
                              (e) => e.add(CategoryStruct(
                                title:
                                    '${_model.start?.toString()}-${_model.end?.toString()} kcal',
                                image: () {
                                  if (_model.start == 100.0) {
                                    return 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/plc4905l1e8q/energy1.png';
                                  } else if (_model.start == 200.0) {
                                    return 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/f89co5s8t6yg/energy2.png';
                                  } else if (_model.start == 300.0) {
                                    return 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/snnmd2p6lq9y/energy7.png';
                                  } else if (_model.start == 400.0) {
                                    return 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/97qa06dqxnlp/energy3.png';
                                  } else if (_model.start == 500.0) {
                                    return 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/7ri9qx2xexda/energy5.png';
                                  } else if (_model.start == 600.0) {
                                    return 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/4fpzx1q86zbn/energy8.png';
                                  } else {
                                    return 'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/kalorik-2mhem5/assets/dzzndgldpzz9/energy6.png';
                                  }
                                }(),
                              )),
                            ),
                        );
                        _model.updatePage(() {});
                      }
                      Navigator.pop(context);
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: false,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.viewInsetsOf(context),
                            child: ZSearchWidget(),
                          );
                        },
                      ).then((value) => safeSetState(() {}));
                    },
                    text: 'Apply',
                    options: FFButtonOptions(
                      height: 50.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).info,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ].divide(SizedBox(
                  width: (_model.selectedCategories.isNotEmpty) ||
                          _model.favoriesOnly ||
                          (_model.start! > 0.0) ||
                          (_model.end! < 700.0)
                      ? 12.0
                      : 0.0)),
            ),
          ),
        ],
      ),
    );
  }
}
