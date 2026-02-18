import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_icons.dart';

/// Predefined activity data with calorie ranges
class PredefinedActivity {
  final String name;
  final String iconName;
  final IconData icon;
  final int caloriesPerHour; // Midpoint of the range

  const PredefinedActivity({
    required this.name,
    required this.iconName,
    required this.icon,
    required this.caloriesPerHour,
  });
}

/// List of 12 predefined activities + "Other" option
class PredefinedActivities {
  static const List<PredefinedActivity> activities = [
    PredefinedActivity(
      name: 'Running',
      iconName: 'sport1',
      icon: FFIcons.ksport1,
      caloriesPerHour: 700, // Range: 600-800
    ),
    PredefinedActivity(
      name: 'Cycling',
      iconName: 'sport2',
      icon: FFIcons.ksport2,
      caloriesPerHour: 550, // Range: 400-700
    ),
    PredefinedActivity(
      name: 'Swimming',
      iconName: 'swimming',
      icon: FFIcons.kswimming,
      caloriesPerHour: 600, // Range: 500-700
    ),
    PredefinedActivity(
      name: 'Bowling',
      iconName: 'sport3',
      icon: FFIcons.ksport3,
      caloriesPerHour: 275, // Range: 200-350
    ),
    PredefinedActivity(
      name: 'Fishing',
      iconName: 'sport4',
      icon: FFIcons.ksport4,
      caloriesPerHour: 225, // Range: 150-300
    ),
    PredefinedActivity(
      name: 'Basketball',
      iconName: 'sport5',
      icon: FFIcons.ksport5,
      caloriesPerHour: 625, // Range: 500-750
    ),
    PredefinedActivity(
      name: 'Golf',
      iconName: 'golf',
      icon: FFIcons.kgolf,
      caloriesPerHour: 375, // Range: 300-450
    ),
    PredefinedActivity(
      name: 'Tennis',
      iconName: 'sport6',
      icon: FFIcons.ksport6,
      caloriesPerHour: 500, // Range: 400-600
    ),
    PredefinedActivity(
      name: 'Baseball',
      iconName: 'sport7',
      icon: FFIcons.ksport7,
      caloriesPerHour: 450, // Range: 350-550
    ),
    PredefinedActivity(
      name: 'Soccer',
      iconName: 'soccerField',
      icon: FFIcons.ksoccerField,
      caloriesPerHour: 600, // Range: 500-700
    ),
    PredefinedActivity(
      name: 'Volleyball',
      iconName: 'sport8',
      icon: FFIcons.ksport8,
      caloriesPerHour: 400, // Range: 300-500
    ),
    PredefinedActivity(
      name: 'American Football',
      iconName: 'sport9',
      icon: FFIcons.ksport9,
      caloriesPerHour: 550, // Range: 450-650
    ),
    PredefinedActivity(
      name: 'Other',
      iconName: 'dotsHorizontal',
      icon: FFIcons.kdotsHorizontal,
      caloriesPerHour: 0, // User enters manually
    ),
  ];

  /// Calculate calories burned based on duration and calories per hour
  /// Formula: calories = (caloriesPerHour / 60) × duration_minutes
  static int calculateCalories({
    required int caloriesPerHour,
    required int durationMinutes,
  }) {
    return ((caloriesPerHour / 60) * durationMinutes).round();
  }

  /// Get activity by name
  static PredefinedActivity? getActivityByName(String name) {
    try {
      return activities.firstWhere(
        (activity) => activity.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// Get activity by icon name
  static PredefinedActivity? getActivityByIconName(String iconName) {
    try {
      return activities.firstWhere(
        (activity) => activity.iconName == iconName,
      );
    } catch (e) {
      return null;
    }
  }
}
