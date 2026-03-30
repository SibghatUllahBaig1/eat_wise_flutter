import 'package:shared_preferences/shared_preferences.dart';

class MealReminderPreferences {
  /// Save meal reminder settings
  static Future<void> saveMealReminder({
    required String mealType,
    required bool enabled,
    required int hour,
    required int minute,
    required List<String> repeatDays,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = 'meal_reminder_${mealType.toLowerCase()}';

    await prefs.setBool('${prefix}_enabled', enabled);
    await prefs.setInt('${prefix}_hour', hour);
    await prefs.setInt('${prefix}_minute', minute);
    await prefs.setStringList('${prefix}_repeat', repeatDays);
  }

  /// Load meal reminder settings
  static Future<Map<String, dynamic>> loadMealReminder(String mealType) async {
    final prefs = await SharedPreferences.getInstance();
    final prefix = 'meal_reminder_${mealType.toLowerCase()}';

    final defaultHour = _getDefaultHour(mealType);
    const defaultMinute = 0;

    return {
      'enabled': prefs.getBool('${prefix}_enabled') ?? false,
      'hour': prefs.getInt('${prefix}_hour') ?? defaultHour,
      'minute': prefs.getInt('${prefix}_minute') ?? defaultMinute,
      'repeatDays': prefs.getStringList('${prefix}_repeat') ??
          [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ],
    };
  }

  /// Get default hour for meal type
  static int _getDefaultHour(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return 7;
      case 'lunch':
        return 12;
      case 'dinner':
        return 19;
      case 'snack':
        return 15;
      default:
        return 9;
    }
  }
}
