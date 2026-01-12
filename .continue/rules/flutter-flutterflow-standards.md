---
name: Flutter & FlutterFlow Standards
globs: ["**/*.dart", "lib/**/*", "**/*.yaml"]
alwaysApply: false
description: Best practices and standards for Flutter/FlutterFlow development in this project
---

# Flutter & FlutterFlow Development Standards

## Code Organization & Architecture

- Follow the existing project structure with separate folders for components, pages, backend, and utilities
- Keep FlutterFlow-generated code separate from custom code
- Place custom backend logic in `lib/backend/` directory
- Store reusable components in appropriate component folders (e.g., `lib/tracker/components/`)
- Use the existing app state management pattern with `FFAppState` for global state

## Null Safety & Error Handling

- Always use null-safe operators (`?.`, `??`) instead of force unwrapping (`!`) unless absolutely certain the value is non-null
- Use `valueOrDefault<T>()` helper for providing fallback values
- Handle potential null values from Firestore queries gracefully
- Use `.firstOrNull` instead of `.first` when accessing potentially empty lists
- Provide meaningful default values for UI elements when data is missing

## State Management

- Use `FFAppState()` for global app state
- Call `safeSetState()` or `setState()` when updating widget state
- Use `context.watch<FFAppState>()` to listen to app state changes in widgets
- Update persisted state using the appropriate update methods (e.g., `updateTrackerStruct`)
- Always initialize state variables with sensible defaults

## Firebase & Firestore Integration

- Use the existing backend service pattern for Firestore operations
- Store user-specific data with proper userId references
- Use Firestore timestamps for date/time fields
- Handle authentication state properly with `currentUserUid`
- Implement proper error handling for all Firebase operations
- Use transactions for operations that need atomicity

## Widget Development

- Respect FlutterFlow's widget structure and naming conventions
- Use `createModel()` for widget models
- Implement proper `dispose()` methods to prevent memory leaks
- Use `FocusNode` for text fields and dispose them properly
- Follow the existing pattern for modal bottom sheets and dialogs

## Data Structures

- Use custom Structs (e.g., `TrackerStruct`, `StepStruct`) for complex data
- Serialize/deserialize data properly using `.toMap()` and `.fromMap()` methods
- Store dates as DateTime objects and convert to timestamps for Firestore
- Use appropriate data types (int, double, String) consistently

## UI/UX Patterns

- Use `FlutterFlowTheme.of(context)` for consistent theming
- Follow the existing color scheme and design patterns
- Implement loading states with proper indicators
- Show user feedback with SnackBars for success/error messages
- Use `Navigator.pop(context)` to close modals after operations

## Performance & Best Practices

- Avoid hardcoded data in production code
- Use const constructors where possible for better performance
- Minimize widget rebuilds by using proper state management
- Dispose of controllers, focus nodes, and streams properly
- Use `safeSetState()` to prevent setState calls on unmounted widgets

## Testing & Validation

- Validate user input before processing
- Check for authentication state before Firestore operations
- Handle edge cases (empty lists, null values, network errors)
- Test with empty/initial state scenarios
- Verify data persistence across app restarts

## Package Management

- Use package managers (flutter pub add/remove) instead of manually editing pubspec.yaml
- Keep dependencies up to date
- Document any custom package configurations

## Code Style

- Follow Dart style guide conventions
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions focused and single-purpose
- Use async/await for asynchronous operations

## FlutterFlow-Specific Guidelines

- Don't modify FlutterFlow-generated widget files unless necessary
- Create custom components for reusable UI elements
- Use custom actions for complex business logic
- Leverage FlutterFlow's built-in functions where appropriate
- Document any manual code changes that might be overwritten

## Common Patterns in This Project

- Date handling: Use `DateTime` objects and convert to/from Firestore timestamps
- User data: Always include userId in document paths or fields
- Progress tracking: Store progress as double (0.0 to 1.0) and display as percentage
- List operations: Use `.where()`, `.toList()`, `.firstOrNull` pattern for filtering
- Modal editing: Pass data to edit modals and refresh parent on close

