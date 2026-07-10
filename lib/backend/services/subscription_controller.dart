import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'entitlement_status.dart';
import 'purchase_result.dart';
import 'revenuecat_service.dart';

/// Single reactive source of truth for the user's `PSP yatoo LLC Pro`
/// entitlement. Registered once as a `ChangeNotifierProvider` and read
/// everywhere else via `context.watch<SubscriptionController>().isPro` —
/// no other place in the app should query RevenueCat directly.
class SubscriptionController extends ChangeNotifier {
  final RevenueCatService _revenueCat = RevenueCatService();
  StreamSubscription<CustomerInfo>? _customerInfoSub;

  bool isPro = false;
  EntitlementStatus status = EntitlementStatus.none;
  Offerings? offerings;
  bool isLoading = true;
  bool isPurchasing = false;
  String? lastError;
  CustomerInfo? _customerInfo;

  /// Deep link to the platform subscription-management page (App Store /
  /// Play Store), when RevenueCat has one for the current customer.
  String? get managementUrl => _customerInfo?.managementURL;

  EntitlementInfo? get _activeEntitlement =>
      _customerInfo?.entitlements.active[RevenueCatService.entitlementId];

  /// Full "product:basePlan" (Android) or product id (iOS) currently active,
  /// or `null` if the user has no active Pro subscription.
  String? get activeProductIdentifier => _activeEntitlement?.productIdentifier;

  Package? get monthlyPackage => _findPackage(PackageType.monthly);
  Package? get annualPackage => _findPackage(PackageType.annual);

  Package? _findPackage(PackageType type) {
    final packages = offerings?.current?.availablePackages;
    if (packages == null) return null;
    for (final pkg in packages) {
      if (pkg.packageType == type) return pkg;
    }
    return null;
  }

  Future<void> init() async {
    _customerInfoSub = _revenueCat.customerInfoStream.listen(_applyCustomerInfo);
    await Future.wait([
      _loadCustomerInfo(),
      refreshOfferings(),
    ]);
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCustomerInfo() async {
    final info = await _revenueCat.getCustomerInfo();
    if (info != null) _applyCustomerInfo(info);
  }

  Future<void> refreshOfferings() async {
    try {
      offerings = await _revenueCat.getOfferings();
    } catch (e) {
      debugPrint('SubscriptionController: refreshOfferings failed: $e');
    }
    notifyListeners();
  }

  void _applyCustomerInfo(CustomerInfo info) {
    _customerInfo = info;
    status = entitlementStatusFrom(
      info.entitlements.active[RevenueCatService.entitlementId] ??
          info.entitlements.all[RevenueCatService.entitlementId],
    );
    isPro = isProStatus(status);
    notifyListeners();
  }

  /// Purchase [package]. On Android this automatically routes through the
  /// plan-switch (proration) path if the user already holds a different
  /// active Pro product — see [RevenueCatService.purchasePackage].
  Future<PurchaseAttemptResult> purchase(Package package) async {
    if (isPurchasing) {
      return const PurchaseAttemptResult.error('A purchase is already in progress.');
    }
    isPurchasing = true;
    lastError = null;
    notifyListeners();
    try {
      final result = await _revenueCat.purchasePackage(package);
      switch (result.type) {
        case PurchaseOutcomeType.success:
          _applyCustomerInfo(result.customerInfo!);
          break;
        case PurchaseOutcomeType.cancelled:
          // No-op: user backed out of the purchase sheet, not an error.
          break;
        case PurchaseOutcomeType.error:
          lastError = result.message;
          break;
      }
      return result;
    } finally {
      isPurchasing = false;
      notifyListeners();
    }
  }

  Future<RestoreAttemptResult> restore() async {
    if (isPurchasing) {
      return const RestoreAttemptResult.error('A purchase is already in progress.');
    }
    isPurchasing = true;
    lastError = null;
    notifyListeners();
    try {
      final result = await _revenueCat.restorePurchases();
      if (result.isRestored) {
        _applyCustomerInfo(result.customerInfo!);
      } else if (result.type == RestoreOutcomeType.error) {
        lastError = result.message;
      }
      return result;
    } finally {
      isPurchasing = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _customerInfoSub?.cancel();
    super.dispose();
  }
}
