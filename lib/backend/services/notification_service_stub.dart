import 'package:flutter/foundation.dart';

/// Web stub for NotificationService
/// Local notifications are not available on web
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    debugPrint(
        'NotificationService (Web Stub): Notifications not available on web');
  }

  Future<void> requestPermissions() async {
    debugPrint('NotificationService (Web Stub): No permissions needed on web');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    debugPrint(
        'NotificationService (Web Stub): Cannot schedule notification on web');
  }

  Future<void> cancelNotification(int id) async {
    debugPrint(
        'NotificationService (Web Stub): Cannot cancel notification on web');
  }

  Future<void> cancelAllNotifications() async {
    debugPrint(
        'NotificationService (Web Stub): Cannot cancel notifications on web');
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint(
        'NotificationService (Web Stub): Cannot show notification on web');
  }
}
