import '/backend/utils/date_utils.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/backend/backend_manager.dart';
import '/home_pages/components/z_activity_date_calendar/z_activity_date_calendar_widget.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'activity_details_model.dart';
export 'activity_details_model.dart';

class ActivityDetailsWidget extends StatefulWidget {
  const ActivityDetailsWidget({
    super.key,
    this.activityData,
  });

  final Map<String, dynamic>? activityData;

  static String routeName = 'ActivityDetails';
  static String routePath = '/activityDetails';

  @override
  State<ActivityDetailsWidget> createState() => _ActivityDetailsWidgetState();
}

class _ActivityDetailsWidgetState extends State<ActivityDetailsWidget> {
  late ActivityDetailsModel _model;
  final backend = BackendManager();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ActivityDetailsModel());
    _model.logDate = normalizeToDate(
      FFAppState().tracker.selectedDate ??
          FFAppState().tracker.currentDate ??
          DateTime.now(),
    );

    // Prefill form if using template (activityData passed but will be used to create new activity)
    if (widget.activityData != null) {
      final data = widget.activityData!;
      final isPredefinedTemplate =
          data['isPredefinedTemplate'] as bool? ?? false;
      // Keep activityId so favorite button can update the template
      _model.activityId = data['id'] as String?;
      _model.activityName = data['activityName'] as String? ?? '';
      _model.duration = data['duration'] as int? ?? 0;
      _model.favorite = data['isFavorite'] as bool? ?? false;
      _model.iconName = data['iconName'] as String? ?? 'sport2';
      _model.caloriesBurned = data['caloriesBurned'] as int? ?? 0;

      // For predefined templates, use caloriesPerHour to set baseCaloriesPerMinute
      if (isPredefinedTemplate && data['caloriesPerHour'] != null) {
        final caloriesPerHour = data['caloriesPerHour'] as int;
        if (caloriesPerHour > 0) {
          _model.baseCaloriesPerMinute = caloriesPerHour / 60.0;
        }
      } else if (_model.duration != null &&
          _model.duration! > 0 &&
          _model.caloriesBurned != null) {
        // Calculate and store the base calories per minute from logged activity
        _model.baseCaloriesPerMinute =
            _model.caloriesBurned! / _model.duration!;
      }

      _model.textController1 ??= TextEditingController(
        text: (data['duration'] as int?)?.toString() ?? '',
      );
      _model.textFieldFocusNode1 ??= FocusNode();

      _model.textController2 ??= TextEditingController(
        text: data['notes'] as String? ?? '',
      );
      _model.textFieldFocusNode2 ??= FocusNode();
    } else {
      _model.textController1 ??= TextEditingController();
      _model.textFieldFocusNode1 ??= FocusNode();

      _model.textController2 ??= TextEditingController();
      _model.textFieldFocusNode2 ??= FocusNode();
    }
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
            if (_model.activityId != null)
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 6.0),
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
                          title: Text('Delete Template'),
                          content: Text(
                              'Are you sure you want to delete this template?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text('Delete',
                                  style: TextStyle(
                                      color:
                                          FlutterFlowTheme.of(context).error)),
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
                              content: Text('Template deleted successfully'),
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
                                  'Failed to delete template: ${e.toString()}'),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).error,
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 6.0, 6.0),
                child: Builder(
                  builder: (context) {
                    if (_model.favorite) {
                      return FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 22.0,
                        borderWidth: 1.0,
                        buttonSize: 44.0,
                        icon: Icon(
                          FFIcons.kheartFilled,
                          color: FlutterFlowTheme.of(context).error,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          _model.favorite = false;
                          safeSetState(() {});

                          // Update in Firestore if editing existing activity
                          if (_model.activityId != null &&
                              backend.currentUserId != null) {
                            try {
                              await backend.activityService.toggleFavorite(
                                userId: backend.currentUserId!,
                                activityId: _model.activityId!,
                                isFavorite: false,
                              );
                            } catch (e) {
                              // Silently fail or show error
                            }
                          }
                        },
                      );
                    } else {
                      return FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 22.0,
                        borderWidth: 1.0,
                        buttonSize: 44.0,
                        icon: Icon(
                          FFIcons.kheart,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          _model.favorite = true;
                          safeSetState(() {});

                          // Update in Firestore if editing existing activity
                          if (_model.activityId != null &&
                              backend.currentUserId != null) {
                            try {
                              await backend.activityService.toggleFavorite(
                                userId: backend.currentUserId!,
                                activityId: _model.activityId!,
                                isFavorite: true,
                              );
                            } catch (e) {
                              // Silently fail or show error
                            }
                          }
                        },
                      );
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
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 16.0, 16.0, 24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 64.0,
                                    height: 64.0,
                                    decoration: BoxDecoration(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Icon(
                                      _getActivityIcon(_model.iconName),
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 44.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _model.activityName.isNotEmpty
                                              ? _model.activityName
                                              : 'Unknown Activity',
                                          style: FlutterFlowTheme.of(context)
                                              .titleLarge
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .titleLarge
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .titleLarge
                                                        .fontStyle,
                                              ),
                                        ),
                                        Text(
                                          '${_model.caloriesBurned ?? 0} kcal',
                                          style: FlutterFlowTheme.of(context)
                                              .labelLarge
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .labelLarge
                                                          .fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .labelLarge
                                                        .fontStyle,
                                                lineHeight: 1.0,
                                              ),
                                        ),
                                      ].divide(SizedBox(height: 10.0)),
                                    ),
                                  ),
                                ].divide(SizedBox(width: 16.0)),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: ZActivityDateCalendarWidget(
                                  initialSelectedDate: _model.logDate,
                                  onDateSelected: (date) {
                                    _model.logDate = date;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 24.0, 0.0, 0.0),
                                child: Text(
                                  'Duration (min)',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.textController1,
                                    focusNode: _model.textFieldFocusNode1,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textController1',
                                      Duration(milliseconds: 0),
                                      () async {
                                        _model.duration = int.tryParse(
                                            _model.textController1.text);
                                        // Recalculate calories when duration changes using the template's base rate
                                        if (_model.duration != null &&
                                            _model.duration! > 0 &&
                                            _model.baseCaloriesPerMinute !=
                                                null) {
                                          _model.caloriesBurned = (_model
                                                      .duration! *
                                                  _model.baseCaloriesPerMinute!)
                                              .round();
                                        }
                                        safeSetState(() {});
                                      },
                                    ),
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                          ),
                                      hintText: 'Duration (min)',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor:
                                          FlutterFlowTheme.of(context).divider,
                                      contentPadding: EdgeInsets.all(16.0),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    validator: _model.textController1Validator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 16.0, 0.0, 0.0),
                                child: Text(
                                  'Note',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                        lineHeight: 1.0,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  child: TextFormField(
                                    controller: _model.textController2,
                                    focusNode: _model.textFieldFocusNode2,
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                          ),
                                      hintText: 'Note',
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelLarge
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .labelLarge
                                                      .fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelLarge
                                                    .fontStyle,
                                          ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0x00000000),
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 1.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      filled: true,
                                      fillColor:
                                          FlutterFlowTheme.of(context).divider,
                                      contentPadding: EdgeInsets.all(16.0),
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyLarge
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyLarge
                                                  .fontStyle,
                                        ),
                                    maxLines: 6,
                                    minLines: 1,
                                    maxLength: 500,
                                    cursorColor: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    validator: _model.textController2Validator
                                        .asValidator(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                      .addToStart(SizedBox(height: 16.0))
                      .addToEnd(SizedBox(height: 24.0)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: FFButtonWidget(
                onPressed: () async {
                  // Validate inputs
                  final duration =
                      int.tryParse(_model.textController1.text.trim());

                  if (duration == null || duration <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please enter a valid duration'),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    return;
                  }

                  if (backend.currentUserId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please sign in to add activities'),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                    return;
                  }

                  try {
                    final notes = _model.textController2.text.trim();
                    // Use the calculated calories from the model (based on template's rate)
                    final calories = _model.caloriesBurned ?? 0;

                    // Log for the date selected on this screen.
                    final selectedDate = _model.effectiveLogDate;

                    // Add new activity history entry (don't inherit favorite status from template)
                    await backend.activityService.addActivity(
                      userId: backend.currentUserId!,
                      date: selectedDate,
                      activityType: 'template',
                      activityName: _model.activityName.isNotEmpty
                          ? _model.activityName
                          : 'Activity',
                      duration: duration,
                      caloriesBurned: calories,
                      notes: notes.isNotEmpty ? notes : null,
                      iconName: _model.iconName,
                      isFavorite: false,
                    );

                    if (!context.mounted) return;

                    // Navigate back to activity history screen
                    // Pop the activity details screen and the bottom sheet, then navigate to activity history
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    // Navigate to activity history screen with the selected date
                    context.pushNamed(
                      'ActivityHistory',
                      queryParameters: {
                        'selectedDate': serializeParam(
                          selectedDate,
                          ParamType.DateTime,
                        ),
                      }.withoutNulls,
                    );

                    // Show success message after navigation
                    Future.delayed(Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Activity added successfully!'),
                            backgroundColor:
                                FlutterFlowTheme.of(context).success,
                          ),
                        );
                      }
                    });
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Failed to add activity: ${e.toString()}'),
                        backgroundColor: FlutterFlowTheme.of(context).error,
                      ),
                    );
                  }
                },
                text: 'Add',
                icon: Icon(
                  FFIcons.kplus,
                  size: 20.0,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  iconColor: FlutterFlowTheme.of(context).info,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.inter(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).info,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
