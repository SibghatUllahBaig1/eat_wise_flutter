# EatWise Firebase Database Schema

## Overview
This document describes the Firestore database structure for the EatWise nutrition tracking application.

## Collections

### 1. users
Main collection for user profiles and data.

**Document ID**: User's Firebase Auth UID

**Fields**:
- `userId` (string): User's unique ID
- `displayName` (string): User's display name
- `email` (string): User's email address
- `photoUrl` (string): URL to user's profile photo
- `gender` (string): User's gender (Male/Female/Other)
- `dateOfBirth` (timestamp): User's date of birth
- `height` (string): User's height
- `weight` (map): Current weight data
  - `value` (number): Weight value
  - `unit` (string): Unit (kg/lbs)
- `targetWeight` (map): Target weight data
  - `value` (number): Target weight value
  - `unit` (string): Unit (kg/lbs)
- `onboardingAnswers` (map): Onboarding questionnaire answers
- `waterGoal` (number): Daily water intake goal in ml
- `stepGoal` (number): Daily step count goal
- `createdAt` (timestamp): Account creation timestamp
- `updatedAt` (timestamp): Last update timestamp

#### Subcollections:

##### users/{userId}/settings
User preferences and settings.

**Document ID**: `preferences`

**Fields**:
- `notifications` (map): Notification settings
  - `mealtime` (boolean)
  - `breakfast` (timestamp)
  - `lunch` (timestamp)
  - `dinner` (timestamp)
  - `snack` (timestamp)
  - `water` (boolean)
  - `checkYourProgress` (boolean)
  - `dayOfTheWeek` (array)
- `darkMode` (string): Theme preference (Light/Dark/System)
- `language` (map): Language settings
  - `language` (string)
  - `langCode` (string)
  - `flag` (string)
- `accountSecurity` (map): Security settings
  - `biometricId` (boolean)
  - `faceId` (boolean)
  - `smsAuthenticator` (boolean)
  - `googleAuthenticator` (boolean)
- `updatedAt` (timestamp)

##### users/{userId}/meals
Meal tracking entries.

**Document ID**: Auto-generated

**Fields**:
- `userId` (string): User ID
- `date` (timestamp): Meal date and time
- `type` (string): Meal type (breakfast/lunch/dinner/snack)
- `foods` (array): List of food items
  - `title` (string): Food name
  - `kcal` (number): Calories
  - `gram` (number): Serving size in grams
  - `carbs` (number): Carbohydrates in grams
  - `protein` (number): Protein in grams
  - `fat` (number): Fat in grams
- `totalCalories` (number): Total calories for the meal
- `totalCarbs` (number): Total carbs for the meal
- `totalProtein` (number): Total protein for the meal
- `totalFat` (number): Total fat for the meal
- `notes` (string): Optional notes
- `imageUrl` (string): Optional meal photo URL
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

**Indexes**:
- `userId` ASC, `date` DESC
- `userId` ASC, `type` ASC, `date` DESC

##### users/{userId}/water_tracker
Daily water intake tracking.

**Document ID**: Date in format `YYYY-MM-DD`

**Fields**:
- `userId` (string): User ID
- `date` (timestamp): Date
- `intake` (number): Water intake in ml
- `goal` (number): Daily goal in ml
- `unit` (string): Unit (ml/oz)
- `progress` (number): Progress percentage (0.0 to 1.0)
- `updatedAt` (timestamp)

**Indexes**:
- `userId` ASC, `date` DESC

##### users/{userId}/weight_tracker
Weight tracking entries.

**Document ID**: Auto-generated

**Fields**:
- `userId` (string): User ID
- `date` (timestamp): Measurement date
- `weight` (number): Weight value
- `unit` (string): Unit (kg/lbs)
- `notes` (string): Optional notes
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

**Indexes**:
- `userId` ASC, `date` DESC

##### users/{userId}/step_tracker
Daily step count tracking.

**Document ID**: Date in format `YYYY-MM-DD`

**Fields**:
- `userId` (string): User ID
- `date` (timestamp): Date
- `steps` (number): Step count
- `goal` (number): Daily step goal
- `progress` (number): Progress percentage (0.0 to 1.0)
- `updatedAt` (timestamp)

**Indexes**:
- `userId` ASC, `date` DESC

##### users/{userId}/goals
User health and fitness goals.

**Document ID**: Auto-generated

**Fields**:
- `userId` (string): User ID
- `goalType` (string): Type of goal
- `title` (string): Goal title
- `description` (string): Goal description
- `targetValues` (map): Target metrics
- `targetDate` (timestamp): Goal target date
- `isActive` (boolean): Whether goal is currently active
- `progress` (number): Progress percentage (0.0 to 1.0)
- `createdAt` (timestamp)
- `updatedAt` (timestamp)

##### users/{userId}/nutrition_history
Historical nutrition data aggregated by day.

**Document ID**: Date in format `YYYY-MM-DD`

**Fields**:
- `userId` (string): User ID
- `date` (timestamp): Date
- `totalCalories` (number): Total calories consumed
- `totalCarbs` (number): Total carbs consumed
- `totalProtein` (number): Total protein consumed
- `totalFat` (number): Total fat consumed
- `mealCount` (number): Number of meals logged
- `updatedAt` (timestamp)

**Indexes**:
- `userId` ASC, `date` DESC

---

### 2. recipes
Public recipe collection.

**Document ID**: Auto-generated

**Fields**:
- `title` (string): Recipe title
- `description` (string): Recipe description
- `content` (string): Recipe instructions
- `image` (string): Recipe image URL
- `tags` (array): Recipe tags/categories
- `cookTime` (number): Cooking time in minutes
- `kcal` (number): Calories per serving
- `createdAt` (timestamp)

**Indexes**:
- `tags` ARRAY_CONTAINS, `createdAt` DESC

---

### 3. foods
Food database for quick meal logging.

**Document ID**: Auto-generated

**Fields**:
- `title` (string): Food name
- `kcal` (number): Calories per serving
- `gram` (number): Serving size in grams
- `carbs` (number): Carbohydrates in grams
- `protein` (number): Protein in grams
- `fat` (number): Fat in grams
- `category` (string): Food category
- `createdAt` (timestamp)

**Indexes**:
- `title` ASC

---

## Security Rules

All user data is protected by Firebase Security Rules that ensure:
1. Users can only read/write their own data
2. Authentication is required for all operations
3. Data validation is enforced on writes
4. Public collections (recipes, foods) are read-only for users

See `firestore.rules` for complete security rules.

---

## Data Flow

### User Registration
1. User signs up via Firebase Auth
2. `initializeUserData()` creates user profile in Firestore
3. Default settings are created
4. User completes onboarding, data is saved to profile

### Daily Tracking
1. User logs meals → saved to `users/{userId}/meals`
2. User tracks water → saved to `users/{userId}/water_tracker`
3. User logs weight → saved to `users/{userId}/weight_tracker`
4. Steps are synced → saved to `users/{userId}/step_tracker`
5. Daily nutrition summary is calculated and cached in `nutrition_history`

### Dashboard
1. App loads today's data from all tracker subcollections
2. Aggregates nutrition data from meals
3. Calculates progress towards goals
4. Displays charts and statistics

