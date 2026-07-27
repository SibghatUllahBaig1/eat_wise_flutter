import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _proGrantedSub;

  static SubscriptionController? _instance;

  SubscriptionController() {
    _instance = this;
  }

  /// Refresh subscription state after RevenueCat is configured post-login.
  static Future<void> refreshIfReady() async {
    await _instance?.refreshAfterAuth();
  }

  /// Reset Pro state when the user signs out.
  static void onUserSignedOut() {
    final controller = _instance;
    if (controller == null) return;
    controller._stopProGrantedListener();
    controller.isPro = false;
    controller.status = EntitlementStatus.none;
    controller.notifyListeners();
  }

  bool isPro = false;
  bool _proGranted = false;
  String? _proGrantedUserId;
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
    _customerInfoSub =
        _revenueCat.customerInfoStream.listen(_applyCustomerInfo);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      _startProGrantedListener(uid);
    }

    if (!_revenueCat.isConfigured) {
      isLoading = false;
      notifyListeners();
      return;
    }

    await Future.wait([
      _loadCustomerInfo(),
      refreshOfferings(),
    ]);
    isLoading = false;
    notifyListeners();
  }

  /// Call after sign-in once RevenueCat has been configured.
  Future<void> refreshAfterAuth() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      _startProGrantedListener(uid);
    } else {
      _stopProGrantedListener();
    }

    if (!_revenueCat.isConfigured) {
      isLoading = false;
      _updateIsPro();
      return;
    }
    isLoading = true;
    notifyListeners();
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
    isPro = isProStatus(status) || _proGranted;
    notifyListeners();
  }

  void _updateIsPro() {
    final nextIsPro = isProStatus(status) || _proGranted;
    if (isPro != nextIsPro) {
      isPro = nextIsPro;
      notifyListeners();
    }
  }

  /// Fetch the latest admin-granted Pro flag before gating a feature.
  Future<void> refreshProGrant() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    _ensureProGrantedListener(uid);
    await _fetchProGranted(uid);
  }

  void _ensureProGrantedListener(String userId) {
    if (_proGrantedUserId == userId && _proGrantedSub != null) return;

    _proGrantedSub?.cancel();
    _proGrantedUserId = userId;
    _proGrantedSub = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen(
      (snapshot) {
        _applyProGranted(snapshot.data()?['proGranted'] == true);
      },
      onError: (Object e) {
        debugPrint('SubscriptionController: proGranted listener failed: $e');
      },
    );
  }

  Future<void> _fetchProGranted(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      _applyProGranted(snapshot.data()?['proGranted'] == true);
    } catch (e) {
      debugPrint('SubscriptionController: proGranted fetch failed: $e');
    }
  }

  void _applyProGranted(bool granted) {
    if (_proGranted == granted) return;
    _proGranted = granted;
    debugPrint('SubscriptionController: proGranted=$granted');
    _updateIsPro();
  }

  void _startProGrantedListener(String userId) {
    _ensureProGrantedListener(userId);
    unawaited(_fetchProGranted(userId));
  }

  void _stopProGrantedListener() {
    _proGrantedSub?.cancel();
    _proGrantedSub = null;
    _proGrantedUserId = null;
    _proGranted = false;
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
    _proGrantedSub?.cancel();
    super.dispose();
  }
}
