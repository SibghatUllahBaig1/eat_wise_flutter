import '/backend/backend_manager.dart';
import '/backend/services/revenuecat_service.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'upgrade_plan_widget.dart' show UpgradePlanWidget;
import 'package:flutter/material.dart';

class UpgradePlanModel extends FlutterFlowModel<UpgradePlanWidget> {
  final _backend = BackendManager();
  final _revenueCat = RevenueCatService();

  Offerings? offerings;
  bool isLoading = true;
  bool isPurchasing = false;
  String? currentTier;
  String? errorMessage;

  @override
  void initState(BuildContext context) {
    loadOfferings();
  }

  /// Load RevenueCat offerings
  Future<void> loadOfferings() async {
    isLoading = true;
    try {
      // Initialize RevenueCat with user ID
      await _revenueCat.setUserId(currentUserUid);

      // Get current subscription tier
      currentTier = await _revenueCat.getActiveSubscriptionTier();

      // Load offerings
      offerings = await _revenueCat.getOfferings();
    } catch (e) {
      errorMessage = 'Failed to load subscription plans';
      debugPrint('Error loading offerings: $e');
    } finally {
      isLoading = false;
    }
  }

  /// Purchase a package
  Future<bool> purchasePackage(Package package) async {
    if (isPurchasing) return false;

    isPurchasing = true;
    errorMessage = null;

    try {
      final customerInfo = await _revenueCat.purchasePackage(package);

      if (customerInfo != null) {
        // Sync to Firestore
        await _revenueCat.syncSubscriptionToFirestore(currentUserUid);

        // Update current tier
        currentTier = await _revenueCat.getActiveSubscriptionTier();

        return true;
      }

      errorMessage = 'Purchase failed';
      return false;
    } catch (e) {
      errorMessage = 'Purchase error: ${e.toString()}';
      debugPrint('Error purchasing: $e');
      return false;
    } finally {
      isPurchasing = false;
    }
  }

  /// Restore purchases
  Future<bool> restorePurchases() async {
    if (isPurchasing) return false;

    isPurchasing = true;
    errorMessage = null;

    try {
      final customerInfo = await _revenueCat.restorePurchases();

      if (customerInfo != null) {
        // Sync to Firestore
        await _revenueCat.syncSubscriptionToFirestore(currentUserUid);

        // Update current tier
        currentTier = await _revenueCat.getActiveSubscriptionTier();

        return true;
      }

      errorMessage = 'No purchases to restore';
      return false;
    } catch (e) {
      errorMessage = 'Restore error: ${e.toString()}';
      debugPrint('Error restoring: $e');
      return false;
    } finally {
      isPurchasing = false;
    }
  }

  /// Get package by identifier
  Package? getPackageByIdentifier(String identifier) {
    if (offerings == null || offerings!.current == null) return null;

    try {
      return offerings!.current!.availablePackages.firstWhere(
        (pkg) => pkg.identifier.contains(identifier),
      );
    } catch (e) {
      return null;
    }
  }

  /// Localized price string for the matching tier package, or `null` if the
  /// offering hasn't loaded yet (e.g., RevenueCat not configured / no network).
  String? priceFor(String identifier) {
    final pkg = getPackageByIdentifier(identifier);
    return pkg?.storeProduct.priceString;
  }

  /// Check if user has specific tier
  bool hasTier(String tier) {
    return currentTier == tier;
  }

  @override
  void dispose() {}
}
