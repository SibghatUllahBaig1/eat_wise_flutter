import 'package:cloud_firestore/cloud_firestore.dart';
import 'revenuecat_service.dart';

/// Subscription tiers
enum SubscriptionTier {
  free,
  standard,
  premium,
}

/// Subscription status
enum SubscriptionStatus {
  active,
  trial,
  expired,
  cancelled,
}

/// Service for managing user subscriptions
class SubscriptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RevenueCatService _revenueCat = RevenueCatService();

  static const _freeFeatures = [
    'basic_tracking',
    'water_tracker',
    'step_tracker',
    'weight_tracker',
  ];

  static const _standardFeatures = [
    ..._freeFeatures,
    'meal_tracking',
    'activity_tracking',
    'basic_recipes',
    'progress_charts',
  ];

  static const _premiumFeatures = [
    ..._standardFeatures,
    'ai_food_analysis',
    'advanced_recipes',
    'custom_meal_plans',
    'advanced_analytics',
    'export_data',
  ];

  DocumentReference<Map<String, dynamic>> _subscriptionDoc(String userId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc('current');

  bool _isActiveAppTrial(Map<String, dynamic>? subscription) {
    if (subscription == null) return false;
    if (subscription['status'] != 'trial') return false;

    final trialEndDate = (subscription['trialEndDate'] as Timestamp?)?.toDate();
    if (trialEndDate == null) return false;

    return DateTime.now().isBefore(trialEndDate);
  }

  /// Sync subscription from RevenueCat
  Future<void> syncFromRevenueCat(String userId) async {
    try {
      await _revenueCat.syncSubscriptionToFirestore(userId);
    } catch (e) {
      debugPrint('Error syncing from RevenueCat: $e');
    }
  }

  /// Get user's subscription data (syncs with RevenueCat unless on app trial).
  Future<Map<String, dynamic>?> getUserSubscription(String userId) async {
    try {
      final doc = await _subscriptionDoc(userId).get();
      final localData = doc.data();

      if (_isActiveAppTrial(localData)) {
        return localData;
      }

      await syncFromRevenueCat(userId);

      final updatedDoc = await _subscriptionDoc(userId).get();
      if (!updatedDoc.exists) return localData;

      final updatedData = updatedDoc.data();
      if (_isActiveAppTrial(localData)) {
        await _subscriptionDoc(userId).set(localData!, SetOptions(merge: true));
        return localData;
      }

      return updatedData;
    } catch (e) {
      debugPrint('Error getting subscription: $e');
      return null;
    }
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription(String userId) async {
    final subscription = await getUserSubscription(userId);
    if (subscription == null) return false;

    if (_isActiveAppTrial(subscription)) return true;

    final status = subscription['status'] as String?;
    return status == 'active' || status == 'trial';
  }

  /// Get user's subscription tier
  Future<SubscriptionTier> getSubscriptionTier(String userId) async {
    final subscription = await getUserSubscription(userId);
    if (subscription == null) return SubscriptionTier.free;

    if (_isActiveAppTrial(subscription)) {
      return SubscriptionTier.premium;
    }

    final tier = subscription['tier'] as String?;
    switch (tier) {
      case 'standard':
        return SubscriptionTier.standard;
      case 'premium':
        return SubscriptionTier.premium;
      default:
        return SubscriptionTier.free;
    }
  }

  /// Check if user is in trial period
  Future<bool> isInTrial(String userId) async {
    final subscription = await getUserSubscription(userId);
    return _isActiveAppTrial(subscription);
  }

  /// Start a 7-day premium trial for testing / new installs.
  Future<void> startFreeTrial(String userId) async {
    try {
      final trialEndDate = DateTime.now().add(const Duration(days: 7));

      await _subscriptionDoc(userId).set({
        'tier': 'premium',
        'status': 'trial',
        'trialStartDate': FieldValue.serverTimestamp(),
        'trialEndDate': Timestamp.fromDate(trialEndDate),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error starting trial: $e');
      rethrow;
    }
  }

  /// Grant the one-time 7-day trial to eligible users (new downloads / first sign-in).
  Future<void> ensureFreeTrialIfEligible(String userId) async {
    try {
      final doc = await _subscriptionDoc(userId).get();
      if (doc.exists) {
        final data = doc.data()!;
        if (_isActiveAppTrial(data)) return;
        if (data['trialStartDate'] != null) return;
        if (data['status'] == 'active' &&
            (data['tier'] == 'premium' || data['tier'] == 'standard')) {
          return;
        }
      }

      await startFreeTrial(userId);
      debugPrint('Started 7-day premium trial for $userId');
    } catch (e) {
      debugPrint('Error ensuring free trial: $e');
    }
  }

  /// Upgrade subscription
  Future<void> upgradeSubscription({
    required String userId,
    required SubscriptionTier tier,
  }) async {
    try {
      final tierString =
          tier == SubscriptionTier.premium ? 'premium' : 'standard';

      await _subscriptionDoc(userId).set({
        'tier': tierString,
        'status': 'active',
        'startDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error upgrading subscription: $e');
      rethrow;
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription(String userId) async {
    try {
      await _subscriptionDoc(userId).update({
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error cancelling subscription: $e');
      rethrow;
    }
  }

  /// Check if feature is available for user's subscription tier
  Future<bool> hasFeatureAccess({
    required String userId,
    required String featureName,
  }) async {
    final subscription = await getUserSubscription(userId);
    final isActive = await hasActiveSubscription(userId);

    if (_isActiveAppTrial(subscription)) {
      return _premiumFeatures.contains(featureName);
    }

    final tier = await getSubscriptionTier(userId);

    if (!isActive && !_freeFeatures.contains(featureName)) {
      return false;
    }

    switch (tier) {
      case SubscriptionTier.premium:
        return _premiumFeatures.contains(featureName);
      case SubscriptionTier.standard:
        return _standardFeatures.contains(featureName);
      case SubscriptionTier.free:
        return _freeFeatures.contains(featureName);
    }
  }
}

void debugPrint(String message) {
  print(message);
}
