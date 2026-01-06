# Backend Integration Guide

This guide explains how to integrate the Firebase backend with the EatWise Flutter app UI.

## Overview

The backend is organized into three layers:
1. **Services** - Direct Firestore operations (`lib/backend/firestore/`)
2. **Backend Manager** - Centralized service access (`lib/backend/backend_manager.dart`)
3. **Controllers** - UI state management (`lib/backend/controllers/`)

## Quick Start

### 1. Initialize Backend on App Start

In your `main.dart` or app initialization:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'backend/backend_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(MyApp());
}
```

### 2. Initialize User Data After Authentication

After successful login/signup:

```dart
import 'backend/backend_manager.dart';

final backend = BackendManager();
final user = FirebaseAuth.instance.currentUser;

if (user != null) {
  await backend.initializeUserData(
    userId: user.uid,
    displayName: user.displayName,
    email: user.email,
    photoUrl: user.photoURL,
  );
  
  // Sync app state to Firestore
  await backend.syncService.syncUserProfile(userId: user.uid);
  await backend.syncService.syncUserSettings(userId: user.uid);
}
```

### 3. Load User Data on App Start

When app starts and user is already authenticated:

```dart
final backend = BackendManager();
final user = FirebaseAuth.instance.currentUser;

if (user != null) {
  // Load data from Firestore to app state
  await backend.syncService.fullSync(userId: user.uid);
}
```

## Using Controllers in UI

### Dashboard Integration

**File**: `lib/home_pages/home_page/home_page_widget.dart`

```dart
import 'package:provider/provider.dart';
import '/backend/controllers/dashboard_controller.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late DashboardController _dashboardController;
  
  @override
  void initState() {
    super.initState();
    _dashboardController = DashboardController();
    _loadData();
  }
  
  Future<void> _loadData() async {
    await _dashboardController.loadTodayDashboard();
    await _dashboardController.loadNutritionChart();
  }
  
  @override
  void dispose() {
    _dashboardController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _dashboardController,
      child: Consumer<DashboardController>(
        builder: (context, controller, child) {
          if (controller.isLoadingDashboard) {
            return CircularProgressIndicator();
          }
          
          final data = controller.dashboardData;
          if (data == null) {
            return Text('No data available');
          }
          
          return Column(
            children: [
              // Display nutrition data
              Text('Calories: ${data['nutrition']?['calories'] ?? 0}'),
              
              // Display water intake
              Text('Water: ${data['water']?['intake'] ?? 0} ml'),
              
              // Display steps
              Text('Steps: ${data['steps']?['steps'] ?? 0}'),
              
              // Refresh button
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => controller.refreshAll(),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

### Statistics Widget Integration

**File**: `lib/home_pages/components/z_statistics/z_statistics_widget.dart`

Update the widget to use real data from the controller:

```dart
import 'package:provider/provider.dart';
import '/backend/controllers/dashboard_controller.dart';

// In the build method:
Consumer<DashboardController>(
  builder: (context, controller, child) {
    final nutrition = controller.dashboardData?['nutrition'];
    final calorieGoal = 2000; // Get from user profile
    final consumed = nutrition?['calories'] ?? 0;
    final progress = consumed / calorieGoal;
    
    return SemiCircleProgress(
      progress: progress.clamp(0.0, 1.0),
      progressColor: FlutterFlowTheme.of(context).primary,
      // ... other properties
    );
  },
)
```

### Nutrition Widget Integration

**File**: `lib/home_pages/components/z_nutrition/z_nutrition_widget.dart`

```dart
import '/backend/controllers/meal_controller.dart';

class _ZNutritionWidgetState extends State<ZNutritionWidget> {
  late MealController _mealController;
  
  @override
  void initState() {
    super.initState();
    _mealController = MealController();
    _mealController.loadMeals();
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _mealController,
      child: Consumer<MealController>(
        builder: (context, controller, child) {
          final meals = controller.meals;
          final nutrition = controller.nutritionSummary;
          
          return Column(
            children: [
              // Display meals by type
              _buildMealSection('Breakfast', meals, 'breakfast'),
              _buildMealSection('Lunch', meals, 'lunch'),
              _buildMealSection('Dinner', meals, 'dinner'),
              _buildMealSection('Snack', meals, 'snack'),
              
              // Display nutrition summary
              Text('Total Calories: ${nutrition?['calories'] ?? 0}'),
              Text('Carbs: ${nutrition?['carbs'] ?? 0}g'),
              Text('Protein: ${nutrition?['protein'] ?? 0}g'),
              Text('Fat: ${nutrition?['fat'] ?? 0}g'),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildMealSection(String title, List meals, String type) {
    final mealsByType = meals.where((m) => m['type'] == type).toList();
    // Build UI for meals
  }
}
```

### Tracker Integration

**File**: `lib/tracker/tracker_water/tracker_water_widget.dart`

```dart
import '/backend/controllers/tracker_controller.dart';

class _TrackerWaterWidgetState extends State<TrackerWaterWidget> {
  late TrackerController _trackerController;
  
  @override
  void initState() {
    super.initState();
    _trackerController = TrackerController();
    _trackerController.loadTrackerData();
  }
  
  Future<void> _addWater(int amount) async {
    final success = await _trackerController.addWaterIntake(
      amount: amount,
      goal: 2000,
    );
    
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Water intake added!')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _trackerController,
      child: Consumer<TrackerController>(
        builder: (context, controller, child) {
          final water = controller.waterData;
          final intake = water?['intake'] ?? 0;
          final goal = water?['goal'] ?? 2000;
          final progress = intake / goal;
          
          return Column(
            children: [
              Text('$intake / $goal ml'),
              LinearProgressIndicator(value: progress),
              
              // Add water buttons
              ElevatedButton(
                onPressed: () => _addWater(250),
                child: Text('Add 250ml'),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

## Direct Service Usage (Without Controllers)

If you prefer to use services directly without controllers:

```dart
import '/backend/backend_manager.dart';

final backend = BackendManager();
final userId = backend.currentUserId;

if (userId != null) {
  // Add a meal
  await backend.mealService.addMeal(
    userId: userId,
    date: DateTime.now(),
    type: 'breakfast',
    foods: [
      {'title': 'Oatmeal', 'kcal': 150, 'gram': 40},
    ],
  );
  
  // Add water
  await backend.waterTrackerService.incrementWaterIntake(
    userId: userId,
    amount: 250,
  );
  
  // Get dashboard data
  final dashboard = await backend.getTodayDashboardData(userId: userId);
}
```

## Next Steps

1. Replace hardcoded data in UI widgets with controller data
2. Add error handling and loading states
3. Implement real-time updates using Firestore streams
4. Add offline support with local caching
5. Implement Cloud Functions for automated tasks

See `README.md` for complete API documentation.

