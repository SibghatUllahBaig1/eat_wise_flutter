import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend_manager.dart';

/// Controller for managing dashboard data and state
class DashboardController extends ChangeNotifier {
  final BackendManager _backend = BackendManager();
  
  // Dashboard data
  Map<String, dynamic>? _dashboardData;
  List<Map<String, dynamic>>? _nutritionChartData;
  List<Map<String, dynamic>>? _weightChartData;
  Map<String, dynamic>? _weeklySummary;
  
  // Loading states
  bool _isLoadingDashboard = false;
  bool _isLoadingCharts = false;
  
  // Error states
  String? _error;
  
  // Selected date for dashboard
  DateTime _selectedDate = DateTime.now();
  
  // Getters
  Map<String, dynamic>? get dashboardData => _dashboardData;
  List<Map<String, dynamic>>? get nutritionChartData => _nutritionChartData;
  List<Map<String, dynamic>>? get weightChartData => _weightChartData;
  Map<String, dynamic>? get weeklySummary => _weeklySummary;
  bool get isLoadingDashboard => _isLoadingDashboard;
  bool get isLoadingCharts => _isLoadingCharts;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  /// Load dashboard data for the selected date
  Future<void> loadDashboardData() async {
    if (currentUserId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }
    
    _isLoadingDashboard = true;
    _error = null;
    notifyListeners();
    
    try {
      _dashboardData = await _backend.getDashboardDataForDate(
        userId: currentUserId!,
        date: _selectedDate,
      );
      _error = null;
    } catch (e) {
      _error = 'Failed to load dashboard data: $e';
      debugPrint(_error);
    } finally {
      _isLoadingDashboard = false;
      notifyListeners();
    }
  }
  
  /// Load today's dashboard data
  Future<void> loadTodayDashboard() async {
    if (currentUserId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }
    
    _isLoadingDashboard = true;
    _error = null;
    notifyListeners();
    
    try {
      _dashboardData = await _backend.getTodayDashboardData(
        userId: currentUserId!,
      );
      _selectedDate = DateTime.now();
      _error = null;
    } catch (e) {
      _error = 'Failed to load dashboard data: $e';
      debugPrint(_error);
    } finally {
      _isLoadingDashboard = false;
      notifyListeners();
    }
  }
  
  /// Load nutrition chart data for the current month
  Future<void> loadNutritionChart() async {
    if (currentUserId == null) return;
    
    _isLoadingCharts = true;
    notifyListeners();
    
    try {
      _nutritionChartData = await _backend.getMonthlyNutritionChart(
        userId: currentUserId!,
        month: _selectedDate,
      );
    } catch (e) {
      debugPrint('Failed to load nutrition chart: $e');
    } finally {
      _isLoadingCharts = false;
      notifyListeners();
    }
  }
  
  /// Load weight progress chart data
  Future<void> loadWeightChart({int daysBack = 30}) async {
    if (currentUserId == null) return;
    
    _isLoadingCharts = true;
    notifyListeners();
    
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: daysBack));
      
      _weightChartData = await _backend.getWeightProgressChart(
        userId: currentUserId!,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      debugPrint('Failed to load weight chart: $e');
    } finally {
      _isLoadingCharts = false;
      notifyListeners();
    }
  }
  
  /// Load weekly summary
  Future<void> loadWeeklySummary() async {
    if (currentUserId == null) return;
    
    try {
      final startOfWeek = _selectedDate.subtract(
        Duration(days: _selectedDate.weekday - 1),
      );
      
      _weeklySummary = await _backend.getWeeklySummary(
        userId: currentUserId!,
        startDate: startOfWeek,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to load weekly summary: $e');
    }
  }
  
  /// Change selected date and reload dashboard
  Future<void> changeDate(DateTime newDate) async {
    _selectedDate = newDate;
    notifyListeners();
    await loadDashboardData();
  }
  
  /// Refresh all dashboard data
  Future<void> refreshAll() async {
    await Future.wait([
      loadDashboardData(),
      loadNutritionChart(),
      loadWeightChart(),
      loadWeeklySummary(),
    ]);
  }
  
  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

