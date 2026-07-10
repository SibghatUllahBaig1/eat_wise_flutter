import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'purchase_result.dart';

/// Web stub for RevenueCatService — the RevenueCat web plugin has no API
/// key configured for this project, so purchases are disabled on web.
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  static String get entitlementId => 'PSP yatoo LLC Pro';

  final StreamController<CustomerInfo> _customerInfoController =
      StreamController<CustomerInfo>.broadcast();

  bool _isConfigured = false;
  bool get isConfigured => _isConfigured;

  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;
  CustomerInfo? get lastCustomerInfo => null;

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

  Future<Offerings?> getOfferings() async => null;

  Future<PurchaseAttemptResult> purchasePackage(Package package) async {
    return const PurchaseAttemptResult.error(
        'Purchases are not available on web.');
  }

  Future<RestoreAttemptResult> restorePurchases() async {
    return const RestoreAttemptResult.error(
        'Purchases are not available on web.');
  }

  Future<CustomerInfo?> getCustomerInfo() async => null;
}
