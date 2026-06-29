import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';

/// RevenueCat configuration.
///
/// Replace these placeholder keys with the public SDK keys from your
/// RevenueCat dashboard (Project → API Keys). They are safe to ship in the
/// client; they are not secrets. See:
/// https://www.revenuecat.com/docs/projects/api-keys
class _RcConfig {
  // TODO: Replace with the real iOS public SDK key (starts with `appl_`).
  static const String iosApiKey = 'appl_REPLACE_ME';

  // TODO: Replace with the real Android public SDK key (starts with `goog_`).
  static const String androidApiKey = 'goog_REPLACE_ME';

  /// Entitlement identifiers configured in the RevenueCat dashboard.
  /// Each subscription product is attached to one of these entitlements.
  static const String entitlementStandard = 'standard';
  static const String entitlementPremium = 'premium';
}

/// Real RevenueCat service used on Android & iOS.
///
/// Responsibilities:
///   * Configure the SDK with the per-platform public API key
///   * Identify the signed-in user so purchases follow them across devices
///   * Expose offerings/packages to the UI
///   * Perform purchases and restores
///   * Listen for entitlement changes and mirror them to Firestore so
///     server-side rules / Cloud Functions can read the current tier
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isConfigured = false;
  String? _currentUserId;
  CustomerInfo? _lastCustomerInfo;

  bool get isConfigured => _isConfigured;

  /// Configure the RevenueCat SDK. Safe to call multiple times.
  Future<void> initialize() async {
    if (_isConfigured) return;
    try {
      await Purchases.setLogLevel(
        kReleaseMode ? LogLevel.warn : LogLevel.debug,
      );

      final apiKey =
          Platform.isIOS ? _RcConfig.iosApiKey : _RcConfig.androidApiKey;
      if (apiKey.contains('REPLACE_ME')) {
        debugPrint(
            '💳 RevenueCat: placeholder API key in use — purchases will fail until real keys are provided.');
      }

      final config = PurchasesConfiguration(apiKey);
      await Purchases.configure(config);

      // Mirror entitlement changes from RevenueCat to Firestore automatically.
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdated);

      _isConfigured = true;
      debugPrint('💳 RevenueCat: configured for ${Platform.operatingSystem}');
    } catch (e, st) {
      debugPrint('💳 RevenueCat: initialize failed: $e\n$st');
    }
  }

  /// Associate purchases with the signed-in Firebase user.
  Future<void> setUserId(String userId) async {
    await initialize();
    if (userId.isEmpty || _currentUserId == userId) return;
    try {
      final result = await Purchases.logIn(userId);
      _currentUserId = userId;
      _lastCustomerInfo = result.customerInfo;
      await _syncCustomerInfo(userId, result.customerInfo);
      debugPrint(
          '💳 RevenueCat: logged in $userId (created=${result.created})');
    } catch (e) {
      debugPrint('💳 RevenueCat: setUserId failed: $e');
    }
  }

  /// Detach the current user (call on sign-out).
  Future<void> logOut() async {
    if (!_isConfigured) return;
    try {
      await Purchases.logOut();
      _currentUserId = null;
      _lastCustomerInfo = null;
      debugPrint('💳 RevenueCat: logged out');
    } catch (e) {
      debugPrint('💳 RevenueCat: logOut failed: $e');
    }
  }

  /// Fetch offerings (groups of purchasable packages) from RevenueCat.
  Future<Offerings?> getOfferings() async {
    await initialize();
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('💳 RevenueCat: getOfferings failed: $e');
      return null;
    }
  }

  /// Purchase a package. Returns the updated [CustomerInfo] on success.
  Future<CustomerInfo?> purchasePackage(Package package) async {
    await initialize();
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final info = result.customerInfo;
      _lastCustomerInfo = info;
      if (_currentUserId != null) {
        await _syncCustomerInfo(_currentUserId!, info);
      }
      return info;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('💳 RevenueCat: user cancelled purchase');
      } else {
        debugPrint('💳 RevenueCat: purchase failed: ${e.message} (code=$code)');
      }
      return null;
    } catch (e) {
      debugPrint('💳 RevenueCat: purchase failed: $e');
      return null;
    }
  }

  /// Restore previously purchased subscriptions (e.g., after re-install).
  Future<CustomerInfo?> restorePurchases() async {
    await initialize();
    try {
      final info = await Purchases.restorePurchases();
      _lastCustomerInfo = info;
      if (_currentUserId != null) {
        await _syncCustomerInfo(_currentUserId!, info);
      }
      return info;
    } catch (e) {
      debugPrint('💳 RevenueCat: restorePurchases failed: $e');
      return null;
    }
  }

  /// Fetch the latest [CustomerInfo] from RevenueCat.
  Future<CustomerInfo?> getCustomerInfo() async {
    await initialize();
    try {
      final info = await Purchases.getCustomerInfo();
      _lastCustomerInfo = info;
      return info;
    } catch (e) {
      debugPrint('💳 RevenueCat: getCustomerInfo failed: $e');
      return null;
    }
  }

  /// `true` if the user has any active premium-or-better entitlement.
  Future<bool> hasActiveSubscription() async {
    final tier = await getActiveSubscriptionTier();
    return tier != null;
  }

  /// Returns the highest-active tier as a string, or `null` if free.
  /// Possible values: `'premium'`, `'standard'`, or `null`.
  Future<String?> getActiveSubscriptionTier() async {
    final info = _lastCustomerInfo ?? await getCustomerInfo();
    if (info == null) return null;
    return _tierFromCustomerInfo(info);
  }

  /// Convenience alias used by older callers — returns `'free'` when inactive.
  Future<String> getSubscriptionTier() async {
    return (await getActiveSubscriptionTier()) ?? 'free';
  }

  /// Force-pull the latest customer info and mirror it to Firestore.
  Future<void> syncSubscriptionToFirestore(String userId) async {
    final info = await getCustomerInfo();
    if (info == null) return;
    await _syncCustomerInfo(userId, info);
  }

  // ── Internal helpers ───────────────────────────────────────────────────────

  void _onCustomerInfoUpdated(CustomerInfo info) {
    _lastCustomerInfo = info;
    final uid = _currentUserId;
    if (uid != null && uid.isNotEmpty) {
      // Fire-and-forget; failure is logged but not surfaced.
      // ignore: discarded_futures
      _syncCustomerInfo(uid, info);
    }
  }

  String? _tierFromCustomerInfo(CustomerInfo info) {
    final entitlements = info.entitlements.active;
    if (entitlements.containsKey(_RcConfig.entitlementPremium)) {
      return 'premium';
    }
    if (entitlements.containsKey(_RcConfig.entitlementStandard)) {
      return 'standard';
    }
    return null;
  }

  /// Write the current entitlement state to `users/{uid}/subscription/current`.
  /// The same document shape is read by [SubscriptionService].
  Future<void> _syncCustomerInfo(String userId, CustomerInfo info) async {
    try {
      final existingDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc('current')
          .get();
      if (existingDoc.exists) {
        final existing = existingDoc.data();
        if (existing != null && existing['status'] == 'trial') {
          final trialEnd =
              (existing['trialEndDate'] as Timestamp?)?.toDate();
          if (trialEnd != null && DateTime.now().isBefore(trialEnd)) {
            return;
          }
        }
      }

      final tier = _tierFromCustomerInfo(info);
      final isActive = tier != null;
      final entitlement = isActive
          ? info.entitlements.active[tier == 'premium'
              ? _RcConfig.entitlementPremium
              : _RcConfig.entitlementStandard]
          : null;

      final data = <String, dynamic>{
        'tier': tier ?? 'free',
        'status': isActive
            ? (entitlement?.periodType == PeriodType.trial ? 'trial' : 'active')
            : 'expired',
        'productIdentifier': entitlement?.productIdentifier,
        'willRenew': entitlement?.willRenew,
        'periodType': entitlement?.periodType.name,
        'latestPurchaseDate': entitlement?.latestPurchaseDate,
        'originalPurchaseDate': entitlement?.originalPurchaseDate,
        'expirationDate': entitlement?.expirationDate,
        'store': entitlement?.store.name,
        'isSandbox': entitlement?.isSandbox,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc('current')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      debugPrint('💳 RevenueCat: Firestore sync failed: $e');
    }
  }
}
