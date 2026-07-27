import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/backend/api_requests/food_analysis_service.dart';
import '/backend/schema/structs/index.dart';
import '/recipes/components/recipe_image_widget.dart';
import '/components/paywall_widget.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'food_capture_model.dart';
export 'food_capture_model.dart';

enum CaptureMode { CAMERA, TEXT, RECENTS }

class FoodCaptureWidget extends StatefulWidget {
  const FoodCaptureWidget({super.key});

  static const String routeName = 'FoodCapture';
  static const String routePath = '/foodCapture';

  @override
  State<FoodCaptureWidget> createState() => _FoodCaptureWidgetState();
}

class _FoodCaptureWidgetState extends State<FoodCaptureWidget> {
  late FoodCaptureModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAnalyzing = false;

  Future<void> _analyzeFood() async {
    FocusScope.of(context).unfocus();
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;

    final hasAccess = await checkFeatureAccess(
      context: context,
      featureName: 'ai_food_analysis',
      displayName: 'AI Food Analysis',
    );
    if (!hasAccess || !mounted) return;

    setState(() => _isAnalyzing = true);
    try {
      FoodNutritionStruct nutritionData;

      if (_model.captureMode == CaptureMode.CAMERA) {
        if (_model.uploadedLocalFile.bytes == null ||
            _model.uploadedLocalFile.bytes!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please capture or select an image first'),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
          return;
        }

        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp_food_image.jpg');
        await tempFile.writeAsBytes(_model.uploadedLocalFile.bytes!);

        nutritionData = await FoodAnalysisService.analyzeFromImage(
          tempFile.path,
        );
      } else {
        final foodDescription = _model.textController?.text.trim() ?? '';
        if (foodDescription.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Please enter a food description'),
              backgroundColor: FlutterFlowTheme.of(context).error,
            ),
          );
          return;
        }

        nutritionData = await FoodAnalysisService.analyzeFromText(
          foodDescription,
        );
      }

      if (!mounted) return;

      if (!_isRecognizedFood(nutritionData)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_unrecognizedFoodMessage()),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(seconds: 5),
          ),
        );
        return;
      }

      context.pushNamed(
        'FoodDetails',
        extra: <String, dynamic>{
          'nutritionData': nutritionData,
        },
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyAnalysisError(e)),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodCaptureModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();

    // Load recent meals
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _model.loadRecentMeals();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Add Food',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Mode Toggle
                Container(
                  width: double.infinity,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _model.captureMode = CaptureMode.CAMERA;
                            });
                          },
                          child: Container(
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: _model.captureMode == CaptureMode.CAMERA
                                  ? FlutterFlowTheme.of(context).primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Center(
                              child: Text(
                                'Camera',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: _model.captureMode ==
                                              CaptureMode.CAMERA
                                          ? Colors.white
                                          : FlutterFlowTheme.of(context)
                                              .primaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _model.captureMode = CaptureMode.TEXT;
                            });
                          },
                          child: Container(
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: _model.captureMode == CaptureMode.TEXT
                                  ? FlutterFlowTheme.of(context).primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Center(
                              child: Text(
                                'Text',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color:
                                          _model.captureMode == CaptureMode.TEXT
                                              ? Colors.white
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              _model.captureMode = CaptureMode.RECENTS;
                            });
                          },
                          child: Container(
                            height: 60.0,
                            decoration: BoxDecoration(
                              color: _model.captureMode == CaptureMode.RECENTS
                                  ? FlutterFlowTheme.of(context).primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Center(
                              child: Text(
                                'Recents',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: _model.captureMode ==
                                              CaptureMode.RECENTS
                                          ? Colors.white
                                          : FlutterFlowTheme.of(context)
                                              .primaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.0),
                // Content based on mode
                if (_model.captureMode == CaptureMode.CAMERA)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_model.uploadedFileUrl == null ||
                            _model.uploadedFileUrl == '')
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                size: 80.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                'Take a photo of your food',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              SizedBox(height: 24.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FFButtonWidget(
                                    onPressed: () async {
                                      final selectedMedia =
                                          await selectMediaWithSourceBottomSheet(
                                        context: context,
                                        allowPhoto: true,
                                      );
                                      if (selectedMedia != null &&
                                          selectedMedia.every((m) =>
                                              validateFileFormat(
                                                  m.storagePath, context))) {
                                        setState(() =>
                                            _model.isDataUploading = true);
                                        var selectedUploadedFiles =
                                            <FFUploadedFile>[];

                                        try {
                                          selectedUploadedFiles = selectedMedia
                                              .map((m) => FFUploadedFile(
                                                    name: m.storagePath
                                                        .split('/')
                                                        .last,
                                                    bytes: m.bytes,
                                                    height:
                                                        m.dimensions?.height,
                                                    width: m.dimensions?.width,
                                                    blurHash: m.blurHash,
                                                  ))
                                              .toList();
                                        } finally {
                                          _model.isDataUploading = false;
                                        }
                                        if (selectedUploadedFiles.length ==
                                            selectedMedia.length) {
                                          setState(() {
                                            _model.uploadedLocalFile =
                                                selectedUploadedFiles.first;
                                            _model.uploadedFileUrl =
                                                'local_file';
                                          });
                                        } else {
                                          setState(() {});
                                          return;
                                        }
                                      }
                                    },
                                    text: 'Take Photo',
                                    icon: Icon(
                                      Icons.camera_alt,
                                      size: 15.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 50.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 0.0, 24.0, 0.0),
                                      iconPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              0.0, 0.0, 0.0, 0.0),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: Colors.white,
                                            letterSpacing: 0.0,
                                          ),
                                      elevation: 3.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        if (_model.uploadedFileUrl != null &&
                            _model.uploadedFileUrl != '')
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.memory(
                                  _model.uploadedLocalFile.bytes!,
                                  width: 300.0,
                                  height: 300.0,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              FFButtonWidget(
                                onPressed: () async {
                                  setState(() {
                                    _model.uploadedFileUrl = null;
                                    _model.uploadedLocalFile = FFUploadedFile(
                                        bytes: Uint8List.fromList([]));
                                  });
                                },
                                text: 'Retake Photo',
                                icon: Icon(
                                  Icons.refresh,
                                  size: 15.0,
                                ),
                                options: FFButtonOptions(
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).secondary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                if (_model.captureMode == CaptureMode.TEXT)
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        TextFormField(
                          controller: _model.textController,
                          focusNode: _model.textFieldFocusNode,
                          autofocus: true,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: 'Describe your food...',
                            labelStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                ),
                            hintText: 'e.g., Grilled chicken breast with rice',
                            hintStyle: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).primary,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: FlutterFlowTheme.of(context).error,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                          maxLines: 5,
                          validator: _model.textControllerValidator
                              .asValidator(context),
                        ),
                      ],
                    ),
                  ),
                // Recents Tab Content
                if (_model.captureMode == CaptureMode.RECENTS)
                  Expanded(
                    child: _model.isLoadingRecents
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _model.recentMeals.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      size: 80.0,
                                    ),
                                    SizedBox(height: 16.0),
                                    Text(
                                      'No recent meals with images',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'Start capturing food images to see them here',
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            fontFamily: 'Readex Pro',
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12.0,
                                  mainAxisSpacing: 12.0,
                                  childAspectRatio: 0.85,
                                ),
                                itemCount: _model.recentMeals.length,
                                itemBuilder: (context, index) {
                                  final meal = _model.recentMeals[index];
                                  final imageUrl = meal['imageUrl'] as String?;
                                  final date = meal['date'] as DateTime?;
                                  final totalCalories =
                                      meal['totalCalories'] as int? ?? 0;
                                  final foods =
                                      meal['foods'] as List<dynamic>? ?? [];
                                  final foodName = foods.isNotEmpty
                                      ? (foods[0] as Map<String, dynamic>)[
                                              'title'] as String? ??
                                          'Unknown'
                                      : 'Unknown';

                                  return InkWell(
                                    onTap: () async {
                                      // Navigate to food details with this meal's data
                                      if (foods.isNotEmpty) {
                                        final food =
                                            foods[0] as Map<String, dynamic>;
                                        final grams =
                                            (food['gram'] as num? ?? 0)
                                                .toDouble();
                                        final carbsGrams =
                                            (food['carbs'] as num? ?? 0)
                                                .toDouble();
                                        final proteinGrams =
                                            (food['protein'] as num? ?? 0)
                                                .toDouble();
                                        final fatGrams =
                                            (food['fat'] as num? ?? 0)
                                                .toDouble();
                                        final foodCalories =
                                            (food['kcal'] as num? ??
                                                    totalCalories)
                                                .toDouble();

                                        // Calculate macro percentages from kcal
                                        final totalMacroKcal =
                                            (carbsGrams * 4) +
                                                (proteinGrams * 4) +
                                                (fatGrams * 9);
                                        final carbsPercent = totalMacroKcal > 0
                                            ? (carbsGrams *
                                                    4 /
                                                    totalMacroKcal) *
                                                100
                                            : 0.0;
                                        final proteinPercent =
                                            totalMacroKcal > 0
                                                ? (proteinGrams *
                                                        4 /
                                                        totalMacroKcal) *
                                                    100
                                                : 0.0;
                                        final fatPercent = totalMacroKcal > 0
                                            ? (fatGrams * 9 / totalMacroKcal) *
                                                100
                                            : 0.0;

                                        final nutritionData =
                                            FoodNutritionStruct(
                                          foodName: food['title'] as String? ??
                                              'Unknown',
                                          grams: grams,
                                          calories: foodCalories,
                                          macros: MacrosStruct(
                                            carbs: MacroDetailStruct(
                                              grams: carbsGrams,
                                              percentage: carbsPercent,
                                            ),
                                            protein: MacroDetailStruct(
                                              grams: proteinGrams,
                                              percentage: proteinPercent,
                                            ),
                                            fat: MacroDetailStruct(
                                              grams: fatGrams,
                                              percentage: fatPercent,
                                            ),
                                          ),
                                          cholesterol:
                                              NutrientStruct.maybeFromMap(
                                                  food['cholesterol']),
                                          sodium: NutrientStruct.maybeFromMap(
                                              food['sodium']),
                                          minerals: MineralsStruct.maybeFromMap(
                                              food['minerals']),
                                          imageUrl: imageUrl,
                                          // No mealId: ensures a new meal is created (not an update)
                                        );

                                        context.pushNamed(
                                          'FoodDetails',
                                          queryParameters: {
                                            'fromHistory': serializeParam(
                                              true,
                                              ParamType.bool,
                                            ),
                                            'nutritionData': serializeParam(
                                              nutritionData,
                                              ParamType.DataStruct,
                                            ),
                                          }.withoutNulls,
                                        );
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 4.0,
                                            color: Color(0x1A000000),
                                            offset: Offset(0.0, 2.0),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Image
                                          ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12.0),
                                              topRight: Radius.circular(12.0),
                                            ),
                                            child: RemoteImageWidget(
                                              imageUrl: imageUrl,
                                              width: double.infinity,
                                              height: 120.0,
                                              fit: BoxFit.cover,
                                              errorWidget: Container(
                                                width: double.infinity,
                                                height: 120.0,
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .alternate,
                                                child: Icon(
                                                  Icons.image_not_supported,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                  size: 40.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Details
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  foodName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                                SizedBox(height: 4.0),
                                                Text(
                                                  '$totalCalories kcal',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        fontFamily:
                                                            'Readex Pro',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                                if (date != null)
                                                  Text(
                                                    DateFormat('MMM d, yyyy')
                                                        .format(date),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodySmall
                                                        .override(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 11.0,
                                                          letterSpacing: 0.0,
                                                        ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                // Analyze Button
                if (_model.captureMode != CaptureMode.RECENTS)
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: _isAnalyzing ? null : _analyzeFood,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              FlutterFlowTheme.of(context).primary,
                          foregroundColor: Colors.white,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: _isAnalyzing
                            ? const SizedBox(
                                width: 23.0,
                                height: 23.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Analyze Food',
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Returns false when the API could not identify a real food item.
bool _isRecognizedFood(FoodNutritionStruct data) {
  final name = data.foodName.trim().toLowerCase();
  if (name.isEmpty) return false;

  const invalidNames = {
    'unknown',
    'unidentified',
    'not identified',
    'not recognized',
    'unrecognizable',
    'n/a',
    'na',
    'none',
    'food item',
    'food',
  };
  if (invalidNames.contains(name)) return false;

  if (data.grams <= 0) return false;

  final carbs = data.macros.carbs.grams;
  final protein = data.macros.protein.grams;
  final fat = data.macros.fat.grams;
  if (data.calories <= 0 && carbs <= 0 && protein <= 0 && fat <= 0) {
    return false;
  }

  if (data.hasConfidence() && data.confidence < 0.25) return false;

  return true;
}

String _unrecognizedFoodMessage() {
  return 'We couldn\'t identify that food. '
      'Try describing it more clearly — for example, "grilled chicken breast" '
      'or "1 cup cooked rice".';
}

/// Formats analysis errors for display only — does not change analysis logic.
String _friendlyAnalysisError(Object error) {
  final raw = error.toString();
  final lower = raw.toLowerCase();

  final noMatch = RegExp(
    r"No food found matching:\s*(.+)",
    caseSensitive: false,
  ).firstMatch(raw);
  if (noMatch != null) {
    final name =
        noMatch.group(1)?.trim().replaceAll(RegExp(r'[)}\]]+$'), '');
    if (name != null && name.isNotEmpty) {
      return 'We couldn\'t find nutrition info for "$name". '
          'Try a clearer description — for example, "grilled chicken breast" '
          'or "1 cup cooked rice".';
    }
  }

  if (lower.contains('no food found matching')) {
    return 'We couldn\'t find nutrition info for that food. '
        'Try a clearer description with the food name and portion size.';
  }
  if (lower.contains('timeout') || lower.contains('timed out')) {
    return 'This is taking longer than usual. Check your connection and try again.';
  }
  if (lower.contains('socket') ||
      lower.contains('network') ||
      lower.contains('connection')) {
    return 'Couldn\'t connect. Please check your internet and try again.';
  }

  return 'We couldn\'t analyze this food. '
      'Try a clearer photo or a more specific description.';
}
