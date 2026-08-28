import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'revenuecat_service.dart';

/// App-managed one-time premium trial (independent of RevenueCat billing).
///
/// Trial dates live on the user document so RevenueCat sync to
/// `subscription/current` cannot reset or shorten the trial window.
class FreeTrialService {
  FreeTrialService._();
  static final FreeTrialService instance = FreeTrialService._();

  static const Duration duration = Duration(days: 7);

  static const String startedAtField = 'freeTrialStartedAt';
  static const String endsAtField = 'freeTrialEndsAt';

  static const String _subscriptionDocId = 'current';
  static const String _legacyTrialStartField = 'trialStartDate';
  static const String _legacyTrialEndField = 'trialEndDate';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Whether [userData] represents an active app-managed trial right now.
  static bool isActive(Map<String, dynamic>? userData) {
    final trialEndsAt = endsAt(userData);
    if (trialEndsAt == null) return false;
    return DateTime.now().isBefore(trialEndsAt);
  }

  static DateTime? startedAt(Map<String, dynamic>? userData) {
    return (userData?[startedAtField] as Timestamp?)?.toDate();
  }

  static DateTime? endsAt(Map<String, dynamic>? userData) {
    return (userData?[endsAtField] as Timestamp?)?.toDate();
  }

  /// Whole days remaining, inclusive of today (minimum 0).
  static int daysRemaining(Map<String, dynamic>? userData) {
    final end = endsAt(userData);
    if (end == null || !DateTime.now().isBefore(end)) return 0;
    return end.difference(DateTime.now()).inDays + 1;
  }

  /// Ensures eligible accounts receive exactly one 7-day trial.
  ///
  /// Safe to call on every sign-in and cold start — idempotent per account.
  Future<void> ensureStartedIfEligible(String userId) async {
    if (userId.isEmpty) return;

    try {
      final userRef = _firestore.collection('users').doc(userId);
      final userSnap = await userRef.get();
      final userData = userSnap.data();

      if (await _restoreLegacyTrialIfNeeded(userRef, userData)) return;
      if (_hasUsedTrial(userData)) return;
      if (await _hasLegacyTrialHistory(userRef)) return;
      if (userData?['proGranted'] == true) return;
      if (await _hasPaidEntitlement()) return;

      await _startTrial(userRef);
      debugPrint('FreeTrialService: started ${duration.inDays}-day trial for $userId');
    } catch (e, st) {
      debugPrint('FreeTrialService: ensureStartedIfEligible failed: $e\n$st');
    }
  }

  Future<bool> _restoreLegacyTrialIfNeeded(
    DocumentReference<Map<String, dynamic>> userRef,
    Map<String, dynamic>? userData,
  ) async {
    if (userData?[endsAtField] != null) return false;

    final subscriptionSnap =
        await userRef.collection('subscription').doc(_subscriptionDocId).get();
    final subscription = subscriptionSnap.data();
    final legacyEnd =
        (subscription?[_legacyTrialEndField] as Timestamp?)?.toDate();

    if (legacyEnd == null || !DateTime.now().isBefore(legacyEnd)) {
      return false;
    }

    await userRef.set({
      startedAtField:
          subscription?[_legacyTrialStartField] ?? FieldValue.serverTimestamp(),
      endsAtField: Timestamp.fromDate(legacyEnd),
    }, SetOptions(merge: true));

    return true;
  }

  bool _hasUsedTrial(Map<String, dynamic>? userData) {
    return userData?[startedAtField] != null;
  }

  Future<bool> _hasLegacyTrialHistory(
    DocumentReference<Map<String, dynamic>> userRef,
  ) async {
    final subscriptionSnap =
        await userRef.collection('subscription').doc(_subscriptionDocId).get();
    final subscription = subscriptionSnap.data();
    return subscription?[_legacyTrialStartField] != null ||
        subscription?[_legacyTrialEndField] != null;
  }

  Future<bool> _hasPaidEntitlement() async {
    final info = await RevenueCatService().getCustomerInfo();
    return info?.entitlements.active
            .containsKey(RevenueCatService.entitlementId) ==
        true;
  }

  Future<void> _startTrial(DocumentReference<Map<String, dynamic>> userRef) async {
    final endsAt = DateTime.now().add(duration);

    await userRef.set({
      startedAtField: FieldValue.serverTimestamp(),
      endsAtField: Timestamp.fromDate(endsAt),
    }, SetOptions(merge: true));

    await userRef.collection('subscription').doc(_subscriptionDocId).set({
      'tier': 'premium',
      'status': 'trial',
      'trialEndDate': Timestamp.fromDate(endsAt),
      'source': 'app_trial',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Writes trial state to `subscription/current` when RevenueCat has no active
  /// entitlement but the app trial is still running.
  Future<void> mirrorActiveTrialToSubscriptionDoc(String userId) async {
    if (userId.isEmpty) return;

    try {
      final userSnap = await _firestore.collection('users').doc(userId).get();
      final userData = userSnap.data();
      if (!isActive(userData)) return;

      final trialEnd = endsAt(userData)!;
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('subscription')
          .doc(_subscriptionDocId)
          .set({
        'tier': 'premium',
        'status': 'trial',
        'trialEndDate': Timestamp.fromDate(trialEnd),
        'source': 'app_trial',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('FreeTrialService: mirrorActiveTrialToSubscriptionDoc failed: $e');
    }
  }
}
