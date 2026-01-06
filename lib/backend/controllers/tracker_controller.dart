import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend_manager.dart';

/// Controller for managing tracker data (water, steps, weight)
class TrackerController extends ChangeNotifier {
  final BackendManager _backend = BackendManager();
  
  // Tracker data
  Map<String, dynamic>? _waterData;
  Map<String, dynamic>? _stepData;
  Map<String, dynamic>? _latestWeight;
  List<Map<String, dynamic>> _weightHistory = [];
  
  // Loading states
  bool _isLoading = false;
  bool _isSaving = false;
  
  // Error state
  String? _error;
  
  // Selected date
  DateTime _selectedDate = DateTime.now();
  
  // Getters
  Map<String, dynamic>? get waterData => _waterData;
  Map<String, dynamic>? get stepData => _stepData;
  Map<String, dynamic>? get latestWeight => _latestWeight;
  List<Map<String, dynamic>> get weightHistory => _weightHistory;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  /// Load all tracker data for the selected date
  Future<void> loadTrackerData() async {
    if (currentUserId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final results = await Future.wait([
        _backend.waterTrackerService.getWaterIntake(
          userId: currentUserId!,
          date: _selectedDate,
        ),
        _backend.stepTrackerService.getStepCount(
          userId: currentUserId!,
          date: _selectedDate,
        ),
        _backend.weightTrackerService.getLatestWeight(
          userId: currentUserId!,
        ),
      ]);
      
      _waterData = results[0];
      _stepData = results[1];
      _latestWeight = results[2];
      _error = null;
    } catch (e) {
      _error = 'Failed to load tracker data: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Add water intake
  Future<bool> addWaterIntake({
    required int amount,
    int? goal,
  }) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.waterTrackerService.incrementWaterIntake(
        userId: currentUserId!,
        amount: amount,
        goal: goal,
      );
      
      // Reload water data
      _waterData = await _backend.waterTrackerService.getWaterIntake(
        userId: currentUserId!,
        date: _selectedDate,
      );
      
      return true;
    } catch (e) {
      _error = 'Failed to add water intake: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Reset water intake for the day
  Future<bool> resetWaterIntake() async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.waterTrackerService.addWaterIntake(
        userId: currentUserId!,
        date: _selectedDate,
        intake: 0,
        goal: _waterData?['goal'] ?? 2000,
      );
      
      // Reload water data
      _waterData = await _backend.waterTrackerService.getWaterIntake(
        userId: currentUserId!,
        date: _selectedDate,
      );
      
      return true;
    } catch (e) {
      _error = 'Failed to reset water intake: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Add step count
  Future<bool> addSteps({
    required int steps,
    int? goal,
  }) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.stepTrackerService.incrementStepCount(
        userId: currentUserId!,
        steps: steps,
        goal: goal,
      );
      
      // Reload step data
      _stepData = await _backend.stepTrackerService.getStepCount(
        userId: currentUserId!,
        date: _selectedDate,
      );
      
      return true;
    } catch (e) {
      _error = 'Failed to add steps: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Add weight entry
  Future<bool> addWeightEntry({
    required double weight,
    required String unit,
    String? notes,
  }) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.weightTrackerService.addWeightEntry(
        userId: currentUserId!,
        date: _selectedDate,
        weight: weight,
        unit: unit,
        notes: notes,
      );
      
      // Reload weight data
      _latestWeight = await _backend.weightTrackerService.getLatestWeight(
        userId: currentUserId!,
      );
      
      return true;
    } catch (e) {
      _error = 'Failed to add weight entry: $e';
      debugPrint(_error);
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Load weight history
  Future<void> loadWeightHistory({int daysBack = 30}) async {
    if (currentUserId == null) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: daysBack));
      
      _weightHistory = await _backend.weightTrackerService.getWeightHistory(
        userId: currentUserId!,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      debugPrint('Failed to load weight history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Change selected date and reload tracker data
  Future<void> changeDate(DateTime newDate) async {
    _selectedDate = newDate;
    notifyListeners();
    await loadTrackerData();
  }
  
  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

