// Conditional export for RevenueCatService.
// On web (and other platforms without dart:io) the stub is used.
// On Android / iOS the real implementation backed by `purchases_flutter` is used.
export 'revenuecat_service_stub.dart'
    if (dart.library.io) 'revenuecat_service_mobile.dart';
