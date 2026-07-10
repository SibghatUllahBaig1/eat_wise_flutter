import 'package:purchases_flutter/purchases_flutter.dart';

enum PurchaseOutcomeType { success, cancelled, error }

/// Result of a [Purchases.purchase] attempt, with cancellation and network
/// errors distinguished from a genuine failure so the UI can react
/// appropriately (no-op on cancel, message on error).
class PurchaseAttemptResult {
  final PurchaseOutcomeType type;
  final CustomerInfo? customerInfo;
  final String? message;

  const PurchaseAttemptResult.success(CustomerInfo info)
      : type = PurchaseOutcomeType.success,
        customerInfo = info,
        message = null;

  const PurchaseAttemptResult.cancelled()
      : type = PurchaseOutcomeType.cancelled,
        customerInfo = null,
        message = null;

  const PurchaseAttemptResult.error(String msg)
      : type = PurchaseOutcomeType.error,
        customerInfo = null,
        message = msg;

  bool get isSuccess => type == PurchaseOutcomeType.success;
  bool get isCancelled => type == PurchaseOutcomeType.cancelled;
}

enum RestoreOutcomeType { restored, noPreviousPurchase, error }

class RestoreAttemptResult {
  final RestoreOutcomeType type;
  final CustomerInfo? customerInfo;
  final String? message;

  const RestoreAttemptResult.restored(CustomerInfo info)
      : type = RestoreOutcomeType.restored,
        customerInfo = info,
        message = null;

  const RestoreAttemptResult.noPreviousPurchase()
      : type = RestoreOutcomeType.noPreviousPurchase,
        customerInfo = null,
        message = null;

  const RestoreAttemptResult.error(String msg)
      : type = RestoreOutcomeType.error,
        customerInfo = null,
        message = msg;

  bool get isRestored => type == RestoreOutcomeType.restored;
}
