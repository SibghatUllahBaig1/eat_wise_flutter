import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'food_capture_widget.dart' show FoodCaptureWidget, CaptureMode;
import 'package:flutter/material.dart';
import '/backend/backend_manager.dart';
import '/backend/api_requests/usda_search_option.dart';
import '/auth/firebase_auth/auth_util.dart';

class FoodCaptureModel extends FlutterFlowModel<FoodCaptureWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for capture mode
  CaptureMode captureMode = CaptureMode.CAMERA;

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  // State field(s) for uploaded file
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String? uploadedFileUrl;

  // State field(s) for recent meals
  bool isLoadingRecents = false;
  List<Map<String, dynamic>> recentMeals = [];
  final BackendManager _backend = BackendManager();

  // Text mode USDA manual picker
  bool isSearchingUsda = false;
  bool hasSearched = false;
  String lastSearchQuery = '';
  List<UsdaSearchOption> usdaReferenceOptions = [];
  List<UsdaSearchOption> usdaGeneralOptions = [];
  int? selectedFdcId;

  List<UsdaSearchOption> get usdaSearchResults =>
      [...usdaReferenceOptions, ...usdaGeneralOptions];

  bool get hasUsdaSearchResults =>
      usdaReferenceOptions.isNotEmpty || usdaGeneralOptions.isNotEmpty;

  UsdaSearchOption? get selectedUsdaOption {
    if (selectedFdcId == null) return null;
    for (final option in usdaSearchResults) {
      if (option.fdcId == selectedFdcId) return option;
    }
    return null;
  }

  void clearTextSearchState() {
    isSearchingUsda = false;
    hasSearched = false;
    lastSearchQuery = '';
    usdaReferenceOptions = [];
    usdaGeneralOptions = [];
    selectedFdcId = null;
  }

  void selectUsdaOption(int fdcId) {
    selectedFdcId = fdcId;
  }

  void onTextInputChanged(String currentText) {
    if (hasSearched && currentText.trim() != lastSearchQuery) {
      clearTextSearchState();
    }
  }

  /// Load recent meals with images
  Future<void> loadRecentMeals() async {
    if (currentUserUid.isEmpty) return;

    isLoadingRecents = true;

    try {
      // Get meals from the last 30 days
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: 30));

      final meals = await _backend.mealService.getMealsByDateRange(
        userId: currentUserUid,
        startDate: startDate,
        endDate: endDate,
      );

      // Filter meals that have images and limit to 30
      recentMeals = meals
          .where((meal) => meal['imageUrl'] != null && meal['imageUrl'] != '')
          .take(30)
          .toList();
    } catch (e) {
      print('Error loading recent meals: $e');
      recentMeals = [];
    } finally {
      isLoadingRecents = false;
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
