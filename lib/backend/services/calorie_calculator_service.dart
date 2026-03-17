import 'package:flutter/foundation.dart';

/// Service for calculating daily calorie goals using the Mifflin-St Jeor formula
class CalorieCalculatorService {
  /// Activity level multipliers for TDEE calculation
  static const Map<String, double> activityFactors = {
    'Sedentary': 1.2, // Little or no exercise
    'Lightly Active': 1.375, // Exercise 1-3 days/week
    'Moderately Active': 1.55, // Exercise 3-5 days/week
    'Very Active': 1.725, // Exercise 6-7 days/week
    'Extra Active': 1.9, // Very intense daily physical activity
  };

  /// Goal adjustments (calories to add/subtract from TDEE)
  static const int weightLossAdjustment = -400; // Subtract 400 calories
  static const int weightGainAdjustment = 400; // Add 400 calories
  static const int maintenanceAdjustment = 0; // No adjustment

  /// Calculate Basal Metabolic Rate (BMR) using Mifflin-St Jeor formula
  ///
  /// For Men: BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age_years) + 5
  /// For Women: BMR = (10 × weight_kg) + (6.25 × height_cm) − (5 × age_years) − 161
  ///
  /// Parameters:
  /// - [gender]: "Male", "Female", or "Other" (defaults to Female formula)
  /// - [age]: Age in years
  /// - [weightKg]: Weight in kilograms
  /// - [heightCm]: Height in centimeters
  ///
  /// Returns: BMR in kcal/day
  static double calculateBMR({
    required String gender,
    required int age,
    required double weightKg,
    required double heightCm,
  }) {
    if (age <= 0 || weightKg <= 0 || heightCm <= 0) {
      debugPrint('Invalid input for BMR calculation');
      return 0.0;
    }

    final double baseBMR = (10 * weightKg) + (6.25 * heightCm) - (5 * age);

    if (gender.toLowerCase() == 'male') {
      return baseBMR + 5;
    } else {
      // Default to female formula for "Female" and "Other"
      return baseBMR - 161;
    }
  }

  /// Calculate Total Daily Energy Expenditure (TDEE)
  ///
  /// TDEE = BMR × Activity_Factor
  ///
  /// Parameters:
  /// - [bmr]: Basal Metabolic Rate
  /// - [activityLevel]: Activity level string (must match keys in activityFactors)
  ///
  /// Returns: TDEE in kcal/day
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    final factor =
        activityFactors[activityLevel] ?? 1.2; // Default to Sedentary
    return bmr * factor;
  }

  /// Calculate daily calorie goal based on user's goal
  ///
  /// - Weight Loss: TDEE - 400
  /// - Maintenance: TDEE
  /// - Weight Gain: TDEE + 400
  ///
  /// Parameters:
  /// - [tdee]: Total Daily Energy Expenditure
  /// - [goal]: "Lose Weight", "Maintain Weight", or "Gain Weight"
  ///
  /// Returns: Daily calorie goal in kcal/day (rounded to nearest integer)
  static int calculateDailyCalorieGoal({
    required double tdee,
    required String goal,
  }) {
    int adjustment = maintenanceAdjustment;

    if (goal.toLowerCase().contains('lose')) {
      adjustment = weightLossAdjustment;
    } else if (goal.toLowerCase().contains('gain')) {
      adjustment = weightGainAdjustment;
    }

    return (tdee + adjustment).round();
  }

  /// Complete calculation: BMR → TDEE → Daily Calorie Goal
  ///
  /// This is the main method to use for calculating a user's daily calorie goal.
  ///
  /// Parameters:
  /// - [gender]: "Male", "Female", or "Other"
  /// - [age]: Age in years
  /// - [weightKg]: Weight in kilograms
  /// - [heightCm]: Height in centimeters
  /// - [activityLevel]: Activity level (see activityFactors keys)
  /// - [goal]: "Lose Weight", "Maintain Weight", or "Gain Weight"
  ///
  /// Returns: Map with 'bmr', 'tdee', and 'dailyCalories' keys
  static Map<String, dynamic> calculateCalorieGoal({
    required String gender,
    required int age,
    required double weightKg,
    required double heightCm,
    required String activityLevel,
    required String goal,
  }) {
    final bmr = calculateBMR(
      gender: gender,
      age: age,
      weightKg: weightKg,
      heightCm: heightCm,
    );

    final tdee = calculateTDEE(
      bmr: bmr,
      activityLevel: activityLevel,
    );

    final dailyCalories = calculateDailyCalorieGoal(
      tdee: tdee,
      goal: goal,
    );

    debugPrint('Calorie Calculation:');
    debugPrint(
        '  Gender: $gender, Age: $age, Weight: ${weightKg}kg, Height: ${heightCm}cm');
    debugPrint('  Activity: $activityLevel, Goal: $goal');
    debugPrint('  BMR: ${bmr.round()} kcal/day');
    debugPrint('  TDEE: ${tdee.round()} kcal/day');
    debugPrint('  Daily Calorie Goal: $dailyCalories kcal/day');

    return {
      'bmr': bmr.round(),
      'tdee': tdee.round(),
      'dailyCalories': dailyCalories,
    };
  }
}
