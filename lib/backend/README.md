# EatWise Backend Implementation

## Overview

This directory contains the complete Firebase backend implementation for the EatWise nutrition tracking app. The backend is built using Firebase services including Firestore, Firebase Auth, and Firebase Storage.

## Architecture

### Service Layer Pattern

The backend follows a service layer pattern where each major feature has its own service class:

- **FirestoreService**: Base service with common Firestore operations
- **UserService**: User profile and settings management
- **MealService**: Meal tracking and nutrition logging
- **WaterTrackerService**: Water intake tracking
- **WeightTrackerService**: Weight tracking and progress
- **StepTrackerService**: Step count tracking
- **GoalsService**: Health and fitness goals management
- **RecipeService**: Recipe browsing and favorites

### Backend Manager

The `BackendManager` class provides a centralized access point to all services and includes helper methods for common operations like:

- User initialization
- Data synchronization
- Dashboard data aggregation

## Usage

### 1. Initialize Backend

```dart
import 'package:eat_wise/backend/backend_manager.dart';

final backend = BackendManager();
```

### 2. User Management

```dart
// Initialize user after authentication
await backend.initializeUserData(
  userId: userId,
  displayName: 'John Doe',
  email: 'john@example.com',
);

// Get user profile
final profile = await backend.userService.getUserProfile(userId);

// Update user settings
await backend.userService.updateUserSettings(
  userId: userId,
  darkMode: 'Dark',
  notifications: {'mealtime': true, 'water': true},
);
```

### 3. Meal Tracking

```dart
// Add a meal
final mealId = await backend.mealService.addMeal(
  userId: userId,
  date: DateTime.now(),
  type: 'breakfast',
  foods: [
    {'title': 'Oatmeal', 'kcal': 150, 'gram': 40, 'carbs': 27, 'protein': 5, 'fat': 3},
    {'title': 'Banana', 'kcal': 105, 'gram': 118, 'carbs': 27, 'protein': 1, 'fat': 0},
  ],
);

// Get today's meals
final meals = await backend.mealService.getMealsByDate(
  userId: userId,
  date: DateTime.now(),
);

// Get daily nutrition summary
final nutrition = await backend.mealService.getDailyNutritionSummary(
  userId: userId,
  date: DateTime.now(),
);
```

### 4. Water Tracking

```dart
// Add water intake
await backend.waterTrackerService.addWaterIntake(
  userId: userId,
  date: DateTime.now(),
  intake: 500, // ml
  goal: 2000, // ml
);

// Increment water intake
await backend.waterTrackerService.incrementWaterIntake(
  userId: userId,
  amount: 250, // ml
);

// Get today's water intake
final water = await backend.waterTrackerService.getWaterIntake(
  userId: userId,
  date: DateTime.now(),
);
```

### 5. Weight Tracking

```dart
// Add weight entry
final entryId = await backend.weightTrackerService.addWeightEntry(
  userId: userId,
  date: DateTime.now(),
  weight: 70.5,
  unit: 'kg',
);

// Get weight history
final history = await backend.weightTrackerService.getWeightHistory(
  userId: userId,
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now(),
);

// Get latest weight
final latest = await backend.weightTrackerService.getLatestWeight(
  userId: userId,
);
```

### 6. Step Tracking

```dart
// Add step count
await backend.stepTrackerService.addStepCount(
  userId: userId,
  date: DateTime.now(),
  steps: 5000,
  goal: 10000,
);

// Increment steps
await backend.stepTrackerService.incrementStepCount(
  userId: userId,
  steps: 100,
);
```

### 7. Goals Management

```dart
// Create a goal
final goalId = await backend.goalsService.createGoal(
  userId: userId,
  goalType: 'weight_loss',
  title: 'Lose 10 kg',
  targetValues: {'weight': 60.0},
  targetDate: DateTime.now().add(Duration(days: 90)),
);

// Get active goal
final activeGoal = await backend.goalsService.getActiveGoal(
  userId: userId,
);

// Update goal progress
await backend.goalsService.updateGoal(
  userId: userId,
  goalId: goalId,
  progress: 0.5,
);
```

### 8. Dashboard Data

```dart
// Get all today's data for dashboard
final dashboardData = await backend.getTodayDashboardData(
  userId: userId,
);

// Returns:
// {
//   'meals': [...],
//   'nutrition': {'calories': 1500, 'carbs': 180, 'protein': 80, 'fat': 50},
//   'water': {'intake': 1500, 'goal': 2000, 'progress': 0.75},
//   'steps': {'steps': 7500, 'goal': 10000, 'progress': 0.75},
//   'latestWeight': {'weight': 70.5, 'unit': 'kg'},
//   'activeGoal': {...},
//   'date': DateTime.now(),
// }
```

## Database Schema

See `firebase/DATABASE_SCHEMA.md` for complete database structure documentation.

## Security

All data is protected by Firebase Security Rules. See `firebase/firestore.rules` and `firebase/storage.rules`.

## Controllers

For easier UI integration, use the provided controllers:

- **DashboardController** - Manages dashboard data and analytics
- **MealController** - Handles meal tracking operations
- **TrackerController** - Manages water, steps, and weight tracking
- **SettingsController** - Handles user settings and preferences

See `INTEGRATION_GUIDE.md` for detailed usage examples.

## Authentication

Use `AuthHandler` for authentication and automatic data synchronization:

```dart
import '/backend/auth/auth_handler.dart';

final auth = AuthHandler();

// Sign in
await auth.signInWithEmailPassword(
  email: 'user@example.com',
  password: 'password',
);

// Sign up
await auth.signUpWithEmailPassword(
  email: 'user@example.com',
  password: 'password',
  displayName: 'John Doe',
);

// Sign out
await auth.signOut();
```

## Error Handling

All service methods throw exceptions with descriptive error messages. Always wrap service calls in try-catch blocks:

```dart
try {
  await backend.mealService.addMeal(...);
} catch (e) {
  print('Error adding meal: $e');
  // Show error to user
}
```

## Files Structure

```
lib/backend/
├── firestore/              # Firestore service layer
│   ├── firestore_service.dart
│   ├── user_service.dart
│   ├── meal_service.dart
│   ├── water_tracker_service.dart
│   ├── weight_tracker_service.dart
│   ├── step_tracker_service.dart
│   ├── goals_service.dart
│   ├── recipe_service.dart
│   ├── analytics_service.dart
│   ├── sync_service.dart
│   └── index.dart
├── controllers/            # UI state management
│   ├── dashboard_controller.dart
│   ├── meal_controller.dart
│   ├── tracker_controller.dart
│   └── settings_controller.dart
├── auth/                   # Authentication
│   └── auth_handler.dart
├── backend_manager.dart    # Central service access
├── README.md              # This file
└── INTEGRATION_GUIDE.md   # UI integration guide
```

