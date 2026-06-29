import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/backend_manager.dart';
import '/backend/services/revenuecat_service.dart';
import '/backend/services/subscription_service.dart' hide debugPrint;
import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'upgrade_plan_widget.dart' show UpgradePlanWidget;
import 'package:flutter/material.dart';

enum BillingPeriod { monthly, annual }

class PlanDefinition {
  const PlanDefinition({
    required this.id,
    required this.title,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.annualSubtitle,
    required this.features,
    this.isPopular = false,
  });

  final String id;
  final String title;
  final String monthlyPrice;
  final String annualPrice;
  final String annualSubtitle;
  final List<String> features;
  final bool isPopular;
}

class UpgradePlanModel extends FlutterFlowModel<UpgradePlanWidget> {
  final _backend = BackendManager();
  final _revenueCat = RevenueCatService();

  static const plans = [
    PlanDefinition(
      id: 'free',
      title: 'Free',
      monthlyPrice: '\$0',
      annualPrice: '\$0',
      annualSubtitle: 'Basic tracking forever',
      features: [
        'Water, step & weight tracking',
        'Basic nutrition dashboard',
      ],
    ),
    PlanDefinition(
      id: 'standard',
      title: 'Standard',
      monthlyPrice: '\$4.99/mo',
      annualPrice: '\$39.99/yr',
      annualSubtitle: 'Save ~33% vs monthly',
      features: [
        'Everything in Free',
        'Meal & activity tracking',
        'Basic recipes',
        'Progress charts',
      ],
    ),
    PlanDefinition(
      id: 'premium',
      title: 'Premium',
      monthlyPrice: '\$9.99/mo',
      annualPrice: '\$79.99/yr',
      annualSubtitle: 'Best value · Save ~33%',
      features: [
        'Everything in Standard',
        'AI food photo analysis',
        'Advanced recipes & meal plans',
        'Advanced analytics & export',
      ],
      isPopular: true,
    ),
  ];

  Offerings? offerings;
  bool isLoading = true;
  bool isPurchasing = false;
  String? currentTier;
  bool isOnTrial = false;
  DateTime? trialEndDate;
  BillingPeriod billingPeriod = BillingPeriod.annual;
  String? errorMessage;
  bool revenueCatAvailable = false;

  @override
  void initState(BuildContext context) {
    loadOfferings();
  }

  Future<void> loadOfferings() async {
    isLoading = true;
    errorMessage = null;
    try {
      final uid = currentUserUid;
      if (uid.isNotEmpty) {
        await _revenueCat.setUserId(uid);
        final subscription =
            await _backend.subscriptionService.getUserSubscription(uid);
        isOnTrial =
            await _backend.subscriptionService.isInTrial(uid);
        trialEndDate =
            (subscription?['trialEndDate'] as Timestamp?)?.toDate();
        final tier =
            await _backend.subscriptionService.getSubscriptionTier(uid);
        currentTier = switch (tier) {
          SubscriptionTier.premium => 'premium',
          SubscriptionTier.standard => 'standard',
          SubscriptionTier.free => 'free',
        };
      }

      offerings = await _revenueCat.getOfferings();
      revenueCatAvailable = offerings?.current != null &&
          offerings!.current!.availablePackages.isNotEmpty;

      if (!revenueCatAvailable) {
        currentTier ??= await _revenueCat.getActiveSubscriptionTier() ?? 'free';
      }
    } catch (e) {
      errorMessage = 'Could not load live pricing. Showing standard plan rates.';
      debugPrint('Error loading offerings: $e');
    } finally {
      isLoading = false;
    }
  }

  String priceLabel(PlanDefinition plan) {
    if (plan.id == 'free') return 'Free';

    final pkg = getPackageForPlan(plan.id);
    if (pkg != null) return pkg.storeProduct.priceString;

    return billingPeriod == BillingPeriod.annual
        ? plan.annualPrice
        : plan.monthlyPrice;
  }

  String priceSubtitle(PlanDefinition plan) {
    if (plan.id == 'free') return plan.annualSubtitle;
    return billingPeriod == BillingPeriod.annual
        ? plan.annualSubtitle
        : 'Billed monthly · Cancel anytime';
  }

  Package? getPackageForPlan(String planId) {
    if (planId == 'free' || offerings?.current == null) return null;

    final packages = offerings!.current!.availablePackages;
    final tier = planId.toLowerCase();
    final periodKeywords = billingPeriod == BillingPeriod.monthly
        ? ['month', 'monthly']
        : ['year', 'annual', 'yearly'];

    for (final pkg in packages) {
      final id = pkg.identifier.toLowerCase();
      final matchesTier = id.contains(tier);
      final matchesPeriod = periodKeywords.any(id.contains);
      if (matchesTier && matchesPeriod) return pkg;
    }

    for (final pkg in packages) {
      if (pkg.identifier.toLowerCase().contains(tier)) return pkg;
    }

    final packageType = billingPeriod == BillingPeriod.monthly
        ? PackageType.monthly
        : PackageType.annual;
    for (final pkg in packages) {
      if (pkg.packageType == packageType) return pkg;
    }

    return packages.isNotEmpty ? packages.first : null;
  }

  Future<bool> purchasePlan(String planId) async {
    final package = getPackageForPlan(planId);
    if (package == null) {
      errorMessage =
          'Purchases are not configured yet. Add your RevenueCat API keys and products, then try again.';
      return false;
    }
    return purchasePackage(package);
  }

  Future<bool> purchasePackage(Package package) async {
    if (isPurchasing) return false;

    isPurchasing = true;
    errorMessage = null;

    try {
      final customerInfo = await _revenueCat.purchasePackage(package);
      if (customerInfo != null) {
        await _revenueCat.syncSubscriptionToFirestore(currentUserUid);
        currentTier = await _revenueCat.getActiveSubscriptionTier() ?? currentTier;
        isOnTrial = false;
        return true;
      }

      errorMessage = 'Purchase was not completed.';
      return false;
    } catch (e) {
      errorMessage = 'Purchase error: ${e.toString()}';
      debugPrint('Error purchasing: $e');
      return false;
    } finally {
      isPurchasing = false;
    }
  }

  Future<bool> restorePurchases() async {
    if (isPurchasing) return false;

    isPurchasing = true;
    errorMessage = null;

    try {
      final customerInfo = await _revenueCat.restorePurchases();
      if (customerInfo != null) {
        await _revenueCat.syncSubscriptionToFirestore(currentUserUid);
        currentTier = await _revenueCat.getActiveSubscriptionTier();
        return currentTier != null && currentTier != 'free';
      }

      errorMessage = 'No previous purchases found for this account.';
      return false;
    } catch (e) {
      errorMessage = 'Restore error: ${e.toString()}';
      debugPrint('Error restoring: $e');
      return false;
    } finally {
      isPurchasing = false;
    }
  }

  bool hasTier(String tier) => currentTier == tier;

  bool isCurrentPlan(String planId) {
    if (isOnTrial && planId == 'premium') return true;
    return hasTier(planId);
  }

  int? trialDaysRemaining() {
    if (trialEndDate == null) return null;
    final days = trialEndDate!.difference(DateTime.now()).inDays;
    return days < 0 ? 0 : days;
  }

  @override
  void dispose() {}
}
