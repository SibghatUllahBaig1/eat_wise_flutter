import 'package:firebase_auth/firebase_auth.dart';
import 'firestore/index.dart';

/// Central backend manager that provides access to all backend services
class BackendManager {
  static final BackendManager _instance = BackendManager._internal();

  factory BackendManager() {
    return _instance;
  }

  BackendManager._internal();

  // Service instances
  final UserService _userService = UserService();
  final MealService _mealService = MealService();
  final WaterTrackerService _waterTrackerService = WaterTrackerService();
  final WeightTrackerService _weightTrackerService = WeightTrackerService();
  final StepTrackerService _stepTrackerService = StepTrackerService();
  final RecipeService _recipeService = RecipeService();
  final AnalyticsService _analyticsService = AnalyticsService();
  final SyncService _syncService = SyncService();
  final ActivityService _activityService = ActivityService();
  final CalorieGoalHistoryService _calorieGoalHistoryService =
      CalorieGoalHistoryService();
  final FeedbackService _feedbackService = FeedbackService();
  final SupportService _supportService = SupportService();
  final NotificationService _notificationService = NotificationService();
  final ApiKeysService _apiKeysService = ApiKeysService();

  // Getters for services
  UserService get userService => _userService;
  MealService get mealService => _mealService;
  WaterTrackerService get waterTrackerService => _waterTrackerService;
  WeightTrackerService get weightTrackerService => _weightTrackerService;
  StepTrackerService get stepTrackerService => _stepTrackerService;
  RecipeService get recipeService => _recipeService;
  AnalyticsService get analyticsService => _analyticsService;
  SyncService get syncService => _syncService;
  ActivityService get activityService => _activityService;
  CalorieGoalHistoryService get calorieGoalHistoryService =>
      _calorieGoalHistoryService;
  FeedbackService get feedbackService => _feedbackService;
  SupportService get supportService => _supportService;
  NotificationService get notificationService => _notificationService;
  ApiKeysService get apiKeysService => _apiKeysService;

  // Current user helpers
  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAuthenticated => FirebaseAuth.instance.currentUser != null;
  User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Initialize user data after authentication
  Future<void> initializeUserData({
    required String userId,
    String? displayName,
    String? email,
    String? photoUrl,
  }) async {
    try {
      // Create user profile
      await _userService.createOrUpdateUserProfile(
        userId: userId,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
      );

      // Initialize default settings
      await _userService.updateUserSettings(
        userId: userId,
        darkMode: 'Light',
        notifications: {
          'mealtime': true,
          'water': true,
          'checkYourProgress': true,
        },
      );
    } catch (e) {
      throw Exception('Failed to initialize user data: $e');
    }
  }

  /// Sync local app state to Firestore
  Future<void> syncAppStateToFirestore({
    required String userId,
    Map<String, dynamic>? profile,
    Map<String, dynamic>? settings,
    List<Map<String, dynamic>>? goals,
  }) async {
    try {
      if (profile != null) {
        await _userService.createOrUpdateUserProfile(
          userId: userId,
          displayName: profile['displayName'],
          email: profile['email'],
          photoUrl: profile['photoUrl'],
          gender: profile['gender'],
          dateOfBirth: profile['dateOfBirth'],
          height: profile['height'],
          weight: profile['weight'],
          targetWeight: profile['targetWeight'],
          onboardingAnswers: profile['onboardingAnswers'],
        );
      }

      if (settings != null) {
        await _userService.updateUserSettings(
          userId: userId,
          notifications: settings['notifications'],
          darkMode: settings['darkMode'],
          language: settings['language'],
          accountSecurity: settings['accountSecurity'],
        );
      }

      // Goals sync removed - GoalsService was deleted
    } catch (e) {
      throw Exception('Failed to sync app state: $e');
    }
  }

  /// Load user data from Firestore to app state
  Future<Map<String, dynamic>> loadUserDataFromFirestore({
    required String userId,
  }) async {
    try {
      final profile = await _userService.getUserProfile(userId);
      final settings = await _userService.getUserSettings(userId);

      return {
        'profile': profile,
        'settings': settings,
        'goals': [], // Goals sync removed - GoalsService was deleted
      };
    } catch (e) {
      throw Exception('Failed to load user data: $e');
    }
  }

  /// Get dashboard data for today
  Future<Map<String, dynamic>> getTodayDashboardData({
    required String userId,
  }) async {
    try {
      return await _analyticsService.getDashboardData(
        userId: userId,
        date: DateTime.now(),
      );
    } catch (e) {
      throw Exception('Failed to get dashboard data: $e');
    }
  }

  /// Get dashboard data for a specific date
  Future<Map<String, dynamic>> getDashboardDataForDate({
    required String userId,
    required DateTime date,
  }) async {
    try {
      return await _analyticsService.getDashboardData(
        userId: userId,
        date: date,
      );
    } catch (e) {
      throw Exception('Failed to get dashboard data: $e');
    }
  }

  /// Get weekly summary
  Future<Map<String, dynamic>> getWeeklySummary({
    required String userId,
    required DateTime startDate,
  }) async {
    try {
      return await _analyticsService.getWeeklySummary(
        userId: userId,
        startDate: startDate,
      );
    } catch (e) {
      throw Exception('Failed to get weekly summary: $e');
    }
  }

  /// Get monthly nutrition chart data
  Future<List<Map<String, dynamic>>> getMonthlyNutritionChart({
    required String userId,
    required DateTime month,
  }) async {
    try {
      return await _analyticsService.getMonthlyNutritionChart(
        userId: userId,
        month: month,
      );
    } catch (e) {
      throw Exception('Failed to get monthly nutrition chart: $e');
    }
  }

  /// Get weight progress chart data
  Future<List<Map<String, dynamic>>> getWeightProgressChart({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      return await _analyticsService.getWeightProgressChart(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      throw Exception('Failed to get weight progress chart: $e');
    }
  }

  /// Dispose all services
  void dispose() {
    _userService.dispose();
    _mealService.dispose();
    _waterTrackerService.dispose();
    _weightTrackerService.dispose();
    _stepTrackerService.dispose();
    _recipeService.dispose();
  }
}
