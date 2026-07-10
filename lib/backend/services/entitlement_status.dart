import 'package:purchases_flutter/purchases_flutter.dart';

/// Reactive status of the user's `PSP yatoo LLC Pro` entitlement.
///
/// [active] and [inGracePeriod] both grant Pro access — RevenueCat/the
/// stores keep the entitlement active during a billing retry (grace period)
/// so we treat them the same for feature gating, matching Play/App Store
/// default behavior.
enum EntitlementStatus {
  /// Entitlement is active and in good standing.
  active,

  /// Entitlement is still active but a billing issue was detected — the
  /// store is retrying the charge. Still counts as Pro.
  inGracePeriod,

  /// Entitlement is no longer active and the last known state was a
  /// billing issue (retry window ended without resolving).
  billingIssue,

  /// Entitlement was purchased before but is no longer active (cancelled or
  /// naturally expired).
  expired,

  /// No purchase history for this entitlement at all.
  none,
}

/// Derive [EntitlementStatus] from RevenueCat's [EntitlementInfo] for the
/// `PSP yatoo LLC Pro` entitlement (`null` when the user has never held it).
EntitlementStatus entitlementStatusFrom(EntitlementInfo? entitlement) {
  if (entitlement == null) return EntitlementStatus.none;
  final hasBillingIssue = entitlement.billingIssueDetectedAt != null;
  if (entitlement.isActive) {
    return hasBillingIssue
        ? EntitlementStatus.inGracePeriod
        : EntitlementStatus.active;
  }
  return hasBillingIssue ? EntitlementStatus.billingIssue : EntitlementStatus.expired;
}

/// `true` for the two statuses that should unlock Pro features.
bool isProStatus(EntitlementStatus status) =>
    status == EntitlementStatus.active || status == EntitlementStatus.inGracePeriod;
