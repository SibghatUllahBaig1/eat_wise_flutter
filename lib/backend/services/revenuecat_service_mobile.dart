import 'dart:async';
import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';

import 'purchase_result.dart';

/// RevenueCat configuration.
///
/// Replace these placeholder keys with the public SDK keys from your
/// RevenueCat dashboard (Project → API Keys). They are safe to ship in the
/// client; they are not secrets. See:
/// https://www.revenuecat.com/docs/projects/api-keys
class _RcConfig {
  // TODO: replace with real RevenueCat API key before release
  static const String _androidApiKey = 'goog_kvTeomxOzcbEOGIUMUsYflfSqHo';

  // TODO: replace with real RevenueCat API key before release
  static const String _iosApiKey = 'appl_ooVaXUXZaFXVxKYQPmOeMVDfKZi';

  /// The single entitlement configured in the RevenueCat dashboard. Every
  /// subscription product (monthly + annual) is attached to this entitlement.
  static const String entitlementId = 'PSP yatoo LLC Pro';
}

/// Real RevenueCat service used on Android & iOS.
///
/// Responsibilities:
///   * Configure the SDK with the per-platform public API key
///   * Identify the signed-in user so purchases follow them across devices
///   * Expose offerings/packages to the UI
///   * Perform purchases (handling Android plan-switch proration) and restores
///   * Push entitlement changes to listeners in real time via [customerInfoStream]
///   * Mirror the current entitlement state to Firestore so server-side
///     rules / Cloud Functions can read it
class RevenueCatService {
  static final RevenueCatService _instance = RevenueCatService._internal();
  factory RevenueCatService() => _instance;
  RevenueCatService._internal();

  /// The entitlement identifier configured in the RevenueCat dashboard.
  static String get entitlementId => _RcConfig.entitlementId;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StreamController<CustomerInfo> _customerInfoController = StreamController<CustomerInfo>.broadcast();

  bool _isConfigured = false;
  String? _currentUserId;
  CustomerInfo? _lastCustomerInfo;

  bool get isConfigured => _isConfigured;

  /// Broadcasts every [CustomerInfo] update RevenueCat pushes — renewals,
  /// cancellations, billing issues, refunds, and purchases made on other
  /// devices — not just the result of a purchase made in this session.
  Stream<CustomerInfo> get customerInfoStream => _customerInfoController.stream;

  CustomerInfo? get lastCustomerInfo => _lastCustomerInfo;

  /// Configure the RevenueCat SDK. Safe to call multiple times.
  Future<void> initialize() async {
    if (_isConfigured) return;
    try {
      await Purchases.setLogLevel(
        kReleaseMode ? LogLevel.warn : LogLevel.debug,
      );

      final apiKey = Platform.isIOS ? _RcConfig._iosApiKey : _RcConfig._androidApiKey;
      if (apiKey.startsWith('PLACEHOLDER_')) {
        debugPrint('💳 RevenueCat: placeholder API key in use — purchases will fail until real keys are provided.');
      }

      final config = PurchasesConfiguration(apiKey);
      await Purchases.configure(config);

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
      _customerInfoController.add(result.customerInfo);
      await _syncCustomerInfo(userId, result.customerInfo);
      debugPrint('💳 RevenueCat: logged in $userId (created=${result.created})');
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
  /// Exposes the `default` offering with its `$rc_monthly`/`$rc_annual` packages.
  Future<Offerings?> getOfferings() async {
    await initialize();
    try {
      return await Purchases.getOfferings();
    } catch (e) {
      debugPrint('💳 RevenueCat: getOfferings failed: $e');
      return null;
    }
  }

  /// Purchase a package.
  ///
  /// On Android, if the user already holds an active EatWise Pro
  /// subscription on a *different* product (e.g. switching monthly ->
  /// annual), this routes through Play Billing's replace-product flow
  /// (`StoreProductChangeInfo`) instead of a plain purchase — a plain
  /// purchase would create a second, concurrent subscription rather than
  /// replacing the first.
  Future<PurchaseAttemptResult> purchasePackage(Package package) async {
    await initialize();
    try {
      final current = _lastCustomerInfo ?? await getCustomerInfo();
      final activeEntitlement = current?.entitlements.active[_RcConfig.entitlementId];
      final newProductId = package.storeProduct.identifier;

      PurchaseParams params;
      if (!kIsWeb && Platform.isAndroid && activeEntitlement != null && activeEntitlement.productIdentifier != newProductId) {
        debugPrint(
            '💳 RevenueCat: switching plan on Android — ${activeEntitlement.productIdentifier} -> $newProductId (proration: withTimeProration)');
        params = PurchaseParams.package(
          package,
          productChangeInfo: StoreProductChangeInfo(
            activeEntitlement.productIdentifier,
            replacementMode: StoreReplacementMode.withTimeProration,
          ),
        );
      } else {
        params = PurchaseParams.package(package);
      }

      final result = await Purchases.purchase(params);
      final info = result.customerInfo;
      _lastCustomerInfo = info;
      _customerInfoController.add(info);
      if (_currentUserId != null) {
        await _syncCustomerInfo(_currentUserId!, info);
      }

      // Sanity check for the Android upgrade/downgrade path: exactly one
      // EatWise product should be active after a plan switch, never two.
      debugPrint('💳 RevenueCat: post-purchase active subscriptions: ${info.activeSubscriptions}');

      return PurchaseAttemptResult.success(info);
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('💳 RevenueCat: user cancelled purchase');
        return const PurchaseAttemptResult.cancelled();
      }
      if (code == PurchasesErrorCode.networkError) {
        debugPrint('💳 RevenueCat: purchase failed — network error');
        return const PurchaseAttemptResult.error('Network error — check your connection and try again.');
      }
      debugPrint('💳 RevenueCat: purchase failed: ${e.message} (code=$code)');
      return PurchaseAttemptResult.error(e.message ?? 'Purchase failed. Please try again.');
    } catch (e) {
      debugPrint('💳 RevenueCat: purchase failed: $e');
      return PurchaseAttemptResult.error(e.toString());
    }
  }

  /// Restore previously purchased subscriptions (e.g., after re-install).
  Future<RestoreAttemptResult> restorePurchases() async {
    await initialize();
    try {
      final info = await Purchases.restorePurchases();
      _lastCustomerInfo = info;
      _customerInfoController.add(info);
      if (_currentUserId != null) {
        await _syncCustomerInfo(_currentUserId!, info);
      }
      final hasEntitlement = info.entitlements.active.containsKey(_RcConfig.entitlementId);
      return hasEntitlement ? RestoreAttemptResult.restored(info) : const RestoreAttemptResult.noPreviousPurchase();
    } catch (e) {
      debugPrint('💳 RevenueCat: restorePurchases failed: $e');
      return RestoreAttemptResult.error(e.toString());
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

  /// Write the current entitlement state to `users/{uid}/subscription/current`.
  Future<void> _syncCustomerInfo(String userId, CustomerInfo info) async {
    try {
      final entitlement = info.entitlements.active[_RcConfig.entitlementId] ?? info.entitlements.all[_RcConfig.entitlementId];
      final isActive = info.entitlements.active.containsKey(_RcConfig.entitlementId);

      final data = <String, dynamic>{
        'tier': isActive ? 'pro' : 'free',
        'status': isActive ? (entitlement?.periodType == PeriodType.trial ? 'trial' : 'active') : 'expired',
        'productIdentifier': entitlement?.productIdentifier,
        'willRenew': entitlement?.willRenew,
        'periodType': entitlement?.periodType.name,
        'latestPurchaseDate': entitlement?.latestPurchaseDate,
        'originalPurchaseDate': entitlement?.originalPurchaseDate,
        'expirationDate': entitlement?.expirationDate,
        'billingIssueDetectedAt': entitlement?.billingIssueDetectedAt,
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

  void _onCustomerInfoUpdated(CustomerInfo info) {
    _lastCustomerInfo = info;
    _customerInfoController.add(info);
    final uid = _currentUserId;
    if (uid != null && uid.isNotEmpty) {
      // Fire-and-forget; failure is logged but not surfaced.
      // ignore: discarded_futures
      _syncCustomerInfo(uid, info);
    }
  }
}
