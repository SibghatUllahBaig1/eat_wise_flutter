# New Backend Services Implementation

## Overview

Four new backend services have been implemented to support additional app features that previously only had UI components.

## New Services

### 1. ActivityService (`lib/backend/firestore/activity_service.dart`)

**Purpose**: Track physical activities and exercises

**Key Features**:
- Add, update, and delete activity entries
- Track activity type, duration, calories burned, distance
- Get activities by date or date range
- Daily activity summaries (total calories, duration, distance)
- Favorite activities management

**Main Methods**:
- `addActivity()` - Log a new activity/exercise
- `updateActivity()` - Update existing activity
- `deleteActivity()` - Remove activity entry
- `getActivitiesByDate()` - Get all activities for a specific date
- `getActivitiesByDateRange()` - Get activities within a date range
- `getDailyActivitySummary()` - Get aggregated daily stats
- `addToFavorites()` - Save frequently used activities
- `getFavoriteActivities()` - Retrieve favorite activities

**Firestore Structure**:
```
users/{userId}/activities/{activityId}
  - activityType: string (running, cycling, swimming, etc.)
  - activityName: string
  - duration: int (minutes)
  - caloriesBurned: int
  - distance: double
  - distanceUnit: string (km/miles)
  - intensity: string (low/moderate/high)
  - notes: string
  - iconName: string
  - date: timestamp
  - createdAt: timestamp
  - updatedAt: timestamp

users/{userId}/favorite_activities/{favoriteId}
  - activityType: string
  - activityName: string
  - iconName: string
  - createdAt: timestamp
```

---

### 2. FeedbackService (`lib/backend/firestore/feedback_service.dart`)

**Purpose**: Collect and manage user feedback and ratings

**Key Features**:
- Submit feedback with ratings (1-5 stars)
- Categorize feedback (bug reports, feature requests, general)
- Track feedback status (pending, reviewed, resolved)
- Calculate average app ratings
- Admin response capability

**Main Methods**:
- `submitFeedback()` - Submit user feedback with rating
- `getUserFeedback()` - Get user's feedback history
- `updateFeedbackStatus()` - Update status (admin function)
- `getAverageRating()` - Get app's average rating and distribution
- `deleteFeedback()` - Remove feedback entry

**Firestore Structure**:
```
feedback/{feedbackId}
  - userId: string
  - rating: double (1-5)
  - comment: string
  - category: string (bug_report, feature_request, general)
  - metadata: map
  - status: string (pending, reviewed, resolved)
  - adminResponse: string
  - respondedAt: timestamp
  - createdAt: timestamp
  - updatedAt: timestamp
```

---

### 3. SupportService (`lib/backend/firestore/support_service.dart`)

**Purpose**: Manage support tickets and customer service messaging

**Key Features**:
- Create and manage support tickets
- Real-time messaging within tickets
- Track ticket status (open, in_progress, resolved, closed)
- Categorize and prioritize tickets
- File attachments support
- Unread message tracking

**Main Methods**:
- `createSupportTicket()` - Create new support ticket
- `addMessageToTicket()` - Add message to existing ticket
- `getUserTickets()` - Get all user's tickets (with optional status filter)
- `getTicketMessages()` - Get all messages in a ticket
- `updateTicketStatus()` - Change ticket status
- `markMessagesAsSeen()` - Mark messages as read
- `getUnreadMessageCount()` - Get count of unread admin messages
- `deleteTicket()` - Delete ticket and all messages

**Firestore Structure**:
```
users/{userId}/support_tickets/{ticketId}
  - subject: string
  - message: string (initial message)
  - category: string (technical, billing, general, feature_request)
  - priority: string (low, medium, high)
  - status: string (open, in_progress, resolved, closed)
  - attachmentUrls: array
  - lastMessageAt: timestamp
  - createdAt: timestamp
  - updatedAt: timestamp

users/{userId}/support_tickets/{ticketId}/messages/{messageId}
  - userId: string
  - message: string
  - isUserMessage: boolean
  - attachmentUrls: array
  - seen: boolean
  - createdAt: timestamp
```

---

### 4. NotificationService (`lib/backend/firestore/notification_service.dart`)

**Purpose**: Manage user notifications and notification preferences

**Key Features**:
- Store and manage notification preferences
- Create and schedule notifications
- Track read/unread status
- Support different notification types (meal reminders, water reminders, progress updates, achievements)
- Bulk operations (mark all as read, delete all read)

**Main Methods**:
- `updateNotificationPreferences()` - Update user's notification settings
- `getNotificationPreferences()` - Get current notification preferences
- `createNotification()` - Create a new notification
- `getUserNotifications()` - Get user's notifications (with read status filter)
- `markAsRead()` - Mark single notification as read
- `markAllAsRead()` - Mark all notifications as read
- `deleteNotification()` - Delete single notification
- `getUnreadCount()` - Get count of unread notifications
- `deleteAllRead()` - Delete all read notifications

**Firestore Structure**:
```
users/{userId}/settings/notification_preferences
  - mealtime: boolean
  - breakfast: boolean
  - lunch: boolean
  - supper: boolean
  - snack: boolean
  - water: boolean
  - checkYourProgress: boolean
  - dayOfTheWeek: string
  - reminderTimes: map
  - updatedAt: timestamp

users/{userId}/notifications/{notificationId}
  - title: string
  - message: string
  - type: string (meal_reminder, water_reminder, progress_update, achievement, general)
  - data: map (additional data)
  - read: boolean
  - readAt: timestamp
  - scheduledFor: timestamp
  - createdAt: timestamp
```

---

## Integration

All services have been:
1. ✅ Added to `lib/backend/firestore/index.dart` for easy importing
2. ✅ Integrated into `BackendManager` for centralized access
3. ✅ Compiled and verified without errors

## Usage Example

```dart
import 'package:your_app/backend/backend_manager.dart';

final backend = BackendManager();

// Activity tracking
await backend.activityService.addActivity(
  userId: backend.currentUserId!,
  date: DateTime.now(),
  activityType: 'running',
  activityName: 'Morning Run',
  duration: 30,
  caloriesBurned: 250,
);

// Submit feedback
await backend.feedbackService.submitFeedback(
  userId: backend.currentUserId!,
  rating: 5.0,
  comment: 'Great app!',
  category: 'general',
);

// Create support ticket
await backend.supportService.createSupportTicket(
  userId: backend.currentUserId!,
  subject: 'Need help with meal logging',
  message: 'How do I log custom foods?',
  category: 'general',
);

// Update notification preferences
await backend.notificationService.updateNotificationPreferences(
  userId: backend.currentUserId!,
  breakfast: true,
  lunch: true,
  water: true,
);
```

## UI Integration Status

### ✅ Completed
- **z_creat_activity** → ActivityService
  - File: `lib/home_pages/components/z_creat_activity/z_creat_activity_widget.dart`
  - Functionality: Users can now create and save custom activities to Firestore
  - Features:
    - Activity name input
    - Calories burned tracking
    - Duration tracking
    - Validation and error handling
    - Success/error feedback to user

### ❌ Not Implemented (Features are Hidden)
- **feedback** component → FeedbackService
  - Reason: Part of hidden "Help & Support" features
  - Note: Backend service exists but UI is commented out

- **support** component → SupportService
  - Reason: Part of hidden "Help & Support" features
  - Note: Backend service exists but UI is commented out

### ⚠️ Needs Clarification
- **z_creat_food**, **z_edit_food**, **z_delete_food** → MealService
  - These components appear to manage custom food items for a personal library
  - MealService currently handles complete meals with food lists
  - May need a separate PersonalFoodsService or different integration approach

- **notification settings** → NotificationService
  - Backend service exists
  - UI integration location needs to be identified (notifications settings page is hidden)

## Next Steps

1. **Clarify Food Management Architecture**
   - Determine if custom foods should be stored separately or as part of meals
   - Consider creating a PersonalFoodsService if needed

2. **Test Activity Creation**
   - Test the z_creat_activity component with real Firebase connection
   - Verify data is properly saved to Firestore
   - Test error handling scenarios

3. **Consider Unhiding Features**
   - If feedback and support features are needed, unhide the UI components
   - Connect them to the existing FeedbackService and SupportService

