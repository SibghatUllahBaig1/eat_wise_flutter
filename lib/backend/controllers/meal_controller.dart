import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../backend_manager.dart';
import '/backend/schema/structs/index.dart';

/// Controller for managing meal tracking operations
class MealController extends ChangeNotifier {
  final BackendManager _backend = BackendManager();
  
  // Current meals for selected date
  List<Map<String, dynamic>> _meals = [];
  Map<String, dynamic>? _nutritionSummary;
  
  // Loading state
  bool _isLoading = false;
  bool _isSaving = false;
  
  // Error state
  String? _error;
  
  // Selected date
  DateTime _selectedDate = DateTime.now();
  
  // Getters
  List<Map<String, dynamic>> get meals => _meals;
  Map<String, dynamic>? get nutritionSummary => _nutritionSummary;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  DateTime get selectedDate => _selectedDate;
  
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  
  /// Load meals for the selected date
  Future<void> loadMeals() async {
    if (currentUserId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return;
    }
    
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _meals = await _backend.mealService.getMealsByDate(
        userId: currentUserId!,
        date: _selectedDate,
      );
      
      _nutritionSummary = await _backend.mealService.getDailyNutritionSummary(
        userId: currentUserId!,
        date: _selectedDate,
      );
      
      _error = null;
    } catch (e) {
      _error = 'Failed to load meals: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Add a new meal
  Future<String?> addMeal({
    required String type,
    required List<FoodStruct> foods,
    String? notes,
    String? imageUrl,
  }) async {
    if (currentUserId == null) {
      _error = 'User not authenticated';
      notifyListeners();
      return null;
    }
    
    _isSaving = true;
    _error = null;
    notifyListeners();
    
    try {
      // Convert FoodStruct to Map
      final foodMaps = foods.map((food) => {
        'title': food.title,
        'kcal': int.tryParse(food.kcal) ?? 0,
        'gram': int.tryParse(food.gram) ?? 0,
        'carbs': double.tryParse(food.carbs ?? '0') ?? 0.0,
        'protein': double.tryParse(food.protein ?? '0') ?? 0.0,
        'fat': double.tryParse(food.fat ?? '0') ?? 0.0,
      }).toList();
      
      final mealId = await _backend.mealService.addMeal(
        userId: currentUserId!,
        date: _selectedDate,
        type: type,
        foods: foodMaps,
        notes: notes,
        imageUrl: imageUrl,
      );
      
      // Reload meals after adding
      await loadMeals();
      
      return mealId;
    } catch (e) {
      _error = 'Failed to add meal: $e';
      debugPrint(_error);
      notifyListeners();
      return null;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Update an existing meal
  Future<bool> updateMeal({
    required String mealId,
    List<Map<String, dynamic>>? foods,
    String? notes,
    String? imageUrl,
  }) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.mealService.updateMeal(
        userId: currentUserId!,
        mealId: mealId,
        foods: foods,
        notes: notes,
        imageUrl: imageUrl,
      );
      
      // Reload meals after updating
      await loadMeals();
      
      return true;
    } catch (e) {
      _error = 'Failed to update meal: $e';
      debugPrint(_error);
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Delete a meal
  Future<bool> deleteMeal(String mealId) async {
    if (currentUserId == null) return false;
    
    _isSaving = true;
    notifyListeners();
    
    try {
      await _backend.mealService.deleteMeal(
        userId: currentUserId!,
        mealId: mealId,
      );
      
      // Reload meals after deleting
      await loadMeals();
      
      return true;
    } catch (e) {
      _error = 'Failed to delete meal: $e';
      debugPrint(_error);
      notifyListeners();
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  
  /// Change selected date and reload meals
  Future<void> changeDate(DateTime newDate) async {
    _selectedDate = newDate;
    notifyListeners();
    await loadMeals();
  }
  
  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

