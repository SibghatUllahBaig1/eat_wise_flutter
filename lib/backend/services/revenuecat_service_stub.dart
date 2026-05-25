import 'package:flutter/foundation.dart';

/// Web stub for RevenueCatService
/// RevenueCat is not available on web
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  bool _isConfigured = false;

  Future<void> initialize() async {
    if (_isConfigured) return;
    _isConfigured = true;
    debugPrint('RevenueCatService (Web Stub): RevenueCat not available on web');
  }

  Future<void> setUserId(String userId) async {
    debugPrint('RevenueCatService (Web Stub): Cannot set user ID on web');
  }

  Future<void> logOut() async {
    debugPrint('RevenueCatService (Web Stub): logOut no-op on web');
  }

  Future<dynamic> getOfferings() async {
    return null;
  }

  Future<dynamic> purchasePackage(dynamic package) async {
    return null;
  }

  Future<dynamic> restorePurchases() async {
    return null;
  }

  Future<dynamic> getCustomerInfo() async {
    return null;
  }

  Future<bool> hasActiveSubscription() async {
    return false;
  }

  Future<String> getSubscriptionTier() async {
    return 'free';
  }

  Future<String?> getActiveSubscriptionTier() async {
    return null;
  }

  Future<void> syncSubscriptionToFirestore(String userId) async {
    debugPrint('RevenueCatService (Web Stub): Cannot sync subscription on web');
  }
}
