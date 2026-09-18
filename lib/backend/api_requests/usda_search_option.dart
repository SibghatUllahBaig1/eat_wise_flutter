/// A USDA food search hit shown in the manual text picker.
class UsdaSearchOption {
  const UsdaSearchOption({
    required this.fdcId,
    required this.description,
    required this.dataType,
    this.brandName,
  });

  final int fdcId;
  final String description;
  final String dataType;
  final String? brandName;

  String get subtitle {
    final parts = <String>[dataType];
    if (brandName != null && brandName!.trim().isNotEmpty) {
      parts.add(brandName!.trim());
    }
    return parts.join(' · ');
  }

  factory UsdaSearchOption.fromMap(Map<String, dynamic> map) {
    return UsdaSearchOption(
      fdcId: map['fdcId'] as int,
      description: (map['description'] as String?) ?? '',
      dataType: (map['dataType'] as String?) ?? '',
      brandName: map['brandName'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'fdcId': fdcId,
        'description': description,
        'dataType': dataType,
        if (brandName != null && brandName!.isNotEmpty) 'brandName': brandName,
      };
}

/// Raw USDA search hits split by reference vs general data types.
class UsdaPickerSearchBuckets {
  const UsdaPickerSearchBuckets({
    this.reference = const [],
    this.general = const [],
  });

  final List<Map<String, dynamic>> reference;
  final List<Map<String, dynamic>> general;
}

/// Ranked USDA options with an AI-recommended default selection for text mode.
class UsdaTextPickerResult {
  const UsdaTextPickerResult({
    this.referenceOptions = const [],
    this.generalOptions = const [],
    this.selectedFdcId,
  });

  final List<UsdaSearchOption> referenceOptions;
  final List<UsdaSearchOption> generalOptions;
  final int? selectedFdcId;

  List<UsdaSearchOption> get allOptions =>
      [...referenceOptions, ...generalOptions];

  bool get isEmpty => referenceOptions.isEmpty && generalOptions.isEmpty;
}
