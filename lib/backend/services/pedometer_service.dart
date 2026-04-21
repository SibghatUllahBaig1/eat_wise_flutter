// Conditional export for PedometerService
// Web: stub (no hardware sensor access)
// Mobile (Android / iOS): real pedometer implementation
export 'pedometer_service_mobile.dart'
    if (dart.library.html) 'pedometer_service_web.dart';
