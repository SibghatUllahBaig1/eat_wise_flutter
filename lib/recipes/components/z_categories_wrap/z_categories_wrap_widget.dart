import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_categories_wrap_model.dart';
export 'z_categories_wrap_model.dart';

class ZCategoriesWrapWidget extends StatefulWidget {
  const ZCategoriesWrapWidget({super.key});

  @override
  State<ZCategoriesWrapWidget> createState() => _ZCategoriesWrapWidgetState();
}

class _ZCategoriesWrapWidgetState extends State<ZCategoriesWrapWidget> {
  late ZCategoriesWrapModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZCategoriesWrapModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
      child: Builder(
        builder: (context) {
          final popularList =
              FFAppState().categories.popularCategories.toList();

          return Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            direction: Axis.horizontal,
            runAlignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            clipBehavior: Clip.none,
            children: List.generate(popularList.length, (popularListIndex) {
              final popularListItem = popularList[popularListIndex];
              return InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  context.pushNamed(
                    MealsWidget.routeName,
                    queryParameters: {
                      'meals': serializeParam(
                        'Breakfast',
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(0.0),
                          child: Image.network(
                            valueOrDefault<String>(
                              popularListItem.image,
                              'https://picsum.photos/seed/40/600',
                            ),
                            width: 26.0,
                            height: 26.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          valueOrDefault<String>(
                            popularListItem.title,
                            'Breakfast',
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
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
    );
  }
}
