import '/backend/schema/structs/index.dart';
import '/buttons/text_text_right/text_text_right_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile/components/z_calorie_unit/z_calorie_unit_widget.dart';
import '/profile/components/z_meal_reminder/z_meal_reminder_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'calorie_counter_model.dart';
export 'calorie_counter_model.dart';

class CalorieCounterWidget extends StatefulWidget {
  const CalorieCounterWidget({super.key});

  static String routeName = 'CalorieCounter';
  static String routePath = '/calorieCounter';

  @override
  State<CalorieCounterWidget> createState() => _CalorieCounterWidgetState();
}

class _CalorieCounterWidgetState extends State<CalorieCounterWidget> {
  late CalorieCounterModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalorieCounterModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          title: Text(
            'Calorie Counter',
            style: FlutterFlowTheme.of(context).titleLarge.override(
                  font: GoogleFonts.inter(
                    fontWeight:
                        FlutterFlowTheme.of(context).titleLarge.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).titleLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).titleLarge.fontWeight,
                  fontStyle: FlutterFlowTheme.of(context).titleLarge.fontStyle,
                ),
          ),
          actions: [],
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
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: _model.loadCalorieData(),
                        builder: (context, snapshot) {
                          String displayValue = '0 kcal left';

                          if (snapshot.hasData) {
                            final data = snapshot.data!;
                            final caloriesLeft =
                                data['caloriesLeft'] as int? ?? 0;
                            final isExceeded =
                                data['isExceeded'] as bool? ?? false;

                            if (isExceeded) {
                              final caloriesExceeded =
                                  data['caloriesExceeded'] as int? ?? 0;
                              displayValue = '+$caloriesExceeded kcal over';
                            } else {
                              displayValue = '$caloriesLeft kcal left';
                            }
                          }

                          return InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed('EditProfile');
                            },
                            child: wrapWithModel(
                              model: _model.textTextRightModel1,
                              updateCallback: () => safeSetState(() {}),
                              child: TextTextRightWidget(
                                text: 'Calorie Goal',
                                value: displayValue,
                              ),
                            ),
                          );
                        },
                      ),
                      Builder(
                        builder: (context) => InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await showDialog(
                              barrierColor:
                                  FlutterFlowTheme.of(context).barrier,
                              context: context,
                              builder: (dialogContext) {
                                return Dialog(
                                  elevation: 0,
                                  insetPadding: EdgeInsets.zero,
                                  backgroundColor: Colors.transparent,
                                  alignment: AlignmentDirectional(0.0, 0.0)
                                      .resolve(Directionality.of(context)),
                                  child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(dialogContext).unfocus();
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    child: ZCalorieUnitWidget(),
                                  ),
                                );
                              },
                            );
                          },
                          child: wrapWithModel(
                            model: _model.textTextRightModel2,
                            updateCallback: () => safeSetState(() {}),
                            child: TextTextRightWidget(
                              text: 'Calorie Units',
                              value: FFAppState().trackerSettings.calorie.unit,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meal Logging Reminders',
                          style:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                        ),
                        SizedBox(height: 16.0),
                        ZMealReminderWidget(mealType: 'breakfast'),
                        Divider(
                          height: 24.0,
                          thickness: 1.0,
                          color: FlutterFlowTheme.of(context).divider,
                        ),
                        ZMealReminderWidget(mealType: 'lunch'),
                        Divider(
                          height: 24.0,
                          thickness: 1.0,
                          color: FlutterFlowTheme.of(context).divider,
                        ),
                        ZMealReminderWidget(mealType: 'dinner'),
                        Divider(
                          height: 24.0,
                          thickness: 1.0,
                          color: FlutterFlowTheme.of(context).divider,
                        ),
                        ZMealReminderWidget(mealType: 'snack'),
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
    );
  }
}
