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

  /// Sync subscription from RevenueCat
  Future<void> syncFromRevenueCat(String userId) async {
    try {
      await _revenueCat.syncSubscriptionToFirestore(userId);
    } catch (e) {
      debugPrint('Error syncing from RevenueCat: $e');
    }
  }

  /// Get user's subscription data (syncs with RevenueCat first)
  Future<Map<String, dynamic>?> getUserSubscription(String userId) async {
    try {
      // Sync with RevenueCat first
      await syncFromRevenueCat(userId);

      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc('current')
          .get();

      if (!doc.exists) return null;

      return doc.data();
    } catch (e) {
      debugPrint('Error getting subscription: $e');
      return null;
    }
  }

  /// Check if user has active subscription
  Future<bool> hasActiveSubscription(String userId) async {
    final subscription = await getUserSubscription(userId);
    if (subscription == null) return false;

    final status = subscription['status'] as String?;
    return status == 'active' || status == 'trial';
  }

  /// Get user's subscription tier
  Future<SubscriptionTier> getSubscriptionTier(String userId) async {
    final subscription = await getUserSubscription(userId);
    if (subscription == null) return SubscriptionTier.free;

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
    if (subscription == null) return false;

    final status = subscription['status'] as String?;
    if (status != 'trial') return false;

    final trialEndDate = (subscription['trialEndDate'] as Timestamp?)?.toDate();
    if (trialEndDate == null) return false;

    return DateTime.now().isBefore(trialEndDate);
  }

  /// Start free trial for user
  Future<void> startFreeTrial(String userId) async {
    try {
      final trialEndDate = DateTime.now().add(Duration(days: 7));

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc('current')
          .set({
        'tier': 'standard',
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

  /// Upgrade subscription
  Future<void> upgradeSubscription({
    required String userId,
    required SubscriptionTier tier,
  }) async {
    try {
      final tierString =
          tier == SubscriptionTier.premium ? 'premium' : 'standard';

      await _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc('current')
          .set({
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
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc('current')
          .update({
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
    final tier = await getSubscriptionTier(userId);
    final isActive = await hasActiveSubscription(userId);

    // Free tier features
    final freeFeatures = [
      'basic_tracking',
      'water_tracker',
      'step_tracker',
      'weight_tracker',
    ];

    // Standard tier features (includes free)
    final standardFeatures = [
      ...freeFeatures,
      'meal_tracking',
      'activity_tracking',
      'basic_recipes',
      'progress_charts',
    ];

    // Premium tier features (includes standard)
    final premiumFeatures = [
      ...standardFeatures,
      'ai_food_analysis',
      'advanced_recipes',
      'custom_meal_plans',
      'advanced_analytics',
      'export_data',
    ];

    if (!isActive && !freeFeatures.contains(featureName)) {
      return false;
    }

    switch (tier) {
      case SubscriptionTier.premium:
        return premiumFeatures.contains(featureName);
      case SubscriptionTier.standard:
        return standardFeatures.contains(featureName);
      case SubscriptionTier.free:
        return freeFeatures.contains(featureName);
    }
  }
}

void debugPrint(String message) {
  print(message);
}
