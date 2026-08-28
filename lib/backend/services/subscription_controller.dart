import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'entitlement_status.dart';
import 'free_trial_service.dart';
import 'purchase_result.dart';
import 'revenuecat_service.dart';

/// Single reactive source of truth for Pro access:
/// RevenueCat entitlement, admin [proGranted], or app-managed free trial.
class SubscriptionController extends ChangeNotifier {
  final RevenueCatService _revenueCat = RevenueCatService();

  StreamSubscription<CustomerInfo>? _customerInfoSub;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userAccessSub;

  static SubscriptionController? _instance;

  SubscriptionController() {
    _instance = this;
  }

  static Future<void> refreshIfReady() async {
    await _instance?.refreshAfterAuth();
  }

  static void onUserSignedOut() {
    final controller = _instance;
    if (controller == null) return;
    controller._stopUserAccessListener();
    controller._resetAccessState();
    controller.notifyListeners();
  }

  bool isPro = false;
  bool isOnFreeTrial = false;
  int? freeTrialDaysRemaining;
  DateTime? freeTrialEndsAt;

  EntitlementStatus status = EntitlementStatus.none;
  Offerings? offerings;
  bool isLoading = true;
  bool isPurchasing = false;
  String? lastError;
  CustomerInfo? _customerInfo;

  bool _proGranted = false;
  bool _freeTrialActive = false;
  String? _userAccessListenerId;

  String? get managementUrl => _customerInfo?.managementURL;

  EntitlementInfo? get _activeEntitlement =>
      _customerInfo?.entitlements.active[RevenueCatService.entitlementId];

  String? get activeProductIdentifier => _activeEntitlement?.productIdentifier;

  Package? get monthlyPackage => _findPackage(PackageType.monthly);
  Package? get annualPackage => _findPackage(PackageType.annual);

  /// User-facing plan label for profile and upgrade screens.
  String get planLabel {
    if (status == EntitlementStatus.inGracePeriod) {
      return 'Pro (billing issue)';
    }
    if (isOnFreeTrial && freeTrialDaysRemaining != null) {
      return 'Pro Trial ($freeTrialDaysRemaining days left)';
    }
    if (isPro) return 'Pro';
    return 'Free';
  }

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
      _startUserAccessListener(uid);
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

  Future<void> refreshAfterAuth() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {
      _startUserAccessListener(uid);
    } else {
      _stopUserAccessListener();
    }

    if (!_revenueCat.isConfigured) {
      isLoading = false;
      _recomputeAccess();
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
    _recomputeAccess();
  }

  void _recomputeAccess() {
    final hasPaidEntitlement = isProStatus(status);
    final nextIsPro = hasPaidEntitlement || _proGranted || _freeTrialActive;
    final nextOnTrial =
        _freeTrialActive && !hasPaidEntitlement && !_proGranted;
    final nextDaysRemaining =
        nextOnTrial ? FreeTrialService.daysRemaining(_userAccessSnapshot) : null;
    final nextEndsAt =
        nextOnTrial ? FreeTrialService.endsAt(_userAccessSnapshot) : null;

    final changed = isPro != nextIsPro ||
        isOnFreeTrial != nextOnTrial ||
        freeTrialDaysRemaining != nextDaysRemaining ||
        freeTrialEndsAt != nextEndsAt;

    isPro = nextIsPro;
    isOnFreeTrial = nextOnTrial;
    freeTrialDaysRemaining = nextDaysRemaining;
    freeTrialEndsAt = nextEndsAt;

    if (changed) notifyListeners();
  }

  Map<String, dynamic>? _userAccessSnapshot;

  /// Refresh Firestore access flags (admin grant + free trial) before gating.
  Future<void> refreshProGrant() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) return;

    _ensureUserAccessListener(uid);
    await _fetchUserAccess(uid);
  }

  void _ensureUserAccessListener(String userId) {
    if (_userAccessListenerId == userId && _userAccessSub != null) return;

    _userAccessSub?.cancel();
    _userAccessListenerId = userId;
    _userAccessSub = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen(
      (snapshot) => _applyUserAccessData(snapshot.data()),
      onError: (Object e) {
        debugPrint('SubscriptionController: user access listener failed: $e');
      },
    );
  }

  Future<void> _fetchUserAccess(String userId) async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      _applyUserAccessData(snapshot.data());
    } catch (e) {
      debugPrint('SubscriptionController: user access fetch failed: $e');
    }
  }

  void _applyUserAccessData(Map<String, dynamic>? data) {
    _userAccessSnapshot = data;
    _proGranted = data?['proGranted'] == true;
    _freeTrialActive = FreeTrialService.isActive(data);
    _recomputeAccess();
  }

  void _startUserAccessListener(String userId) {
    _ensureUserAccessListener(userId);
    unawaited(_fetchUserAccess(userId));
  }

  void _stopUserAccessListener() {
    _userAccessSub?.cancel();
    _userAccessSub = null;
    _userAccessListenerId = null;
  }

  void _resetAccessState() {
    isPro = false;
    isOnFreeTrial = false;
    freeTrialDaysRemaining = null;
    freeTrialEndsAt = null;
    status = EntitlementStatus.none;
    _proGranted = false;
    _freeTrialActive = false;
    _userAccessSnapshot = null;
  }

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
    _userAccessSub?.cancel();
    super.dispose();
  }
}
