// Conditional export for NotificationService
// Uses stub implementation for both web and mobile.
//
// Reminder delivery is handled server-side via FCM (see
// `firebase/functions/index.js`) — the app only needs to sync the user's
// reminder preferences and timezone to Firestore via `MealReminderService`.
// This stub remains in place for any future ad-hoc local-notification needs.
export 'notification_service_stub.dart';
