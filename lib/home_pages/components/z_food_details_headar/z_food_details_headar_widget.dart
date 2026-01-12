import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_pages/components/z_delete_food/z_delete_food_widget.dart';
import '/backend/schema/structs/index.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'z_food_details_headar_model.dart';
export 'z_food_details_headar_model.dart';

class ZFoodDetailsHeadarWidget extends StatefulWidget {
  const ZFoodDetailsHeadarWidget({
    super.key,
    required this.fromHistory,
    this.nutritionData,
  });

  final bool? fromHistory;
  final FoodNutritionStruct? nutritionData;

  @override
  State<ZFoodDetailsHeadarWidget> createState() =>
      _ZFoodDetailsHeadarWidgetState();
}

class _ZFoodDetailsHeadarWidgetState extends State<ZFoodDetailsHeadarWidget> {
  late ZFoodDetailsHeadarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ZFoodDetailsHeadarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            // Full-width background image
            Positioned.fill(
              child: Builder(
                builder: (context) {
                  // Show actual image if available, otherwise show placeholder
                  if (widget.nutritionData?.imageUrl != null &&
                      widget.nutritionData!.imageUrl.isNotEmpty) {
                    return Image.network(
                      widget.nutritionData!.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to placeholder if network image fails
                        return Image.asset(
                          'assets/images/food1.png',
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  } else {
                    // Show placeholder for text search
                    return Image.asset(
                      'assets/images/food1.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
            // Gradient overlay for better text visibility
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(6.0, 6.0, 6.0, 6.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlutterFlowIconButton(
                    borderColor: FlutterFlowTheme.of(context).transparent,
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
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget!.fromHistory ?? true)
                        Builder(
                          builder: (context) => Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 6.0, 0.0),
                            child: FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 22.0,
                              borderWidth: 1.0,
                              buttonSize: 44.0,
                              icon: Icon(
                                FFIcons.ktrash03,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 24.0,
                              ),
                              onPressed: () async {
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
                                      child: ZDeleteFoodWidget(
                                        mealId: widget.nutritionData?.mealId,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
