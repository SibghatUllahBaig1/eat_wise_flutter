---
name: Debugging & Troubleshooting
alwaysApply: false
description: Common debugging patterns and troubleshooting steps for Flutter/FlutterFlow issues
---

# Debugging & Troubleshooting Guide

## Common Flutter Errors

### Null Check Operator Errors
**Error**: `Null check operator used on a null value`

**Solution**:
- Replace `!` with `?` for safe navigation
- Use `??` to provide default values
- Use `.firstOrNull` instead of `.first!`
- Example: `list.firstOrNull?.property ?? defaultValue`

### setState Called After Dispose
**Error**: `setState() called after dispose()`

**Solution**:
- Use `safeSetState()` instead of `setState()`
- Check `mounted` before calling setState
- Properly dispose of controllers and streams
- Cancel timers and subscriptions in dispose()

### Type Errors
**Error**: `type 'X' is not a subtype of type 'Y'`

**Solution**:
- Use explicit type casting: `(value as Type?)`
- Check types before casting
- Use `is` operator for type checking
- Provide proper type annotations

## Debugging Workflow

1. **Check the error stack trace** - Identify the exact line causing the issue
2. **Verify data flow** - Check if data is being passed correctly
3. **Add debug prints** - Use `debugPrint()` to log values
4. **Check null safety** - Ensure all nullable values are handled
5. **Verify state updates** - Confirm setState is being called when needed
6. **Test edge cases** - Empty lists, null values, initial state

## Common Issues in This Project

### Hardcoded Data Showing Instead of Real Data
**Cause**: Default values in FFAppState or widget initialization

**Fix**:
- Remove hardcoded default values from FFAppState
- Initialize with empty arrays/null values
- Load real data from Firestore on app start
- Clear cached data if needed

### Data Not Persisting
**Cause**: Not saving to Firestore or SharedPreferences

**Fix**:
- Verify Firestore write operations are being called
- Check authentication state before writes
- Ensure proper error handling in save operations
- Check Firestore security rules

### UI Not Updating After Data Change
**Cause**: Missing setState or state management issue

**Fix**:
- Call `safeSetState()` after data changes
- Use `context.watch<FFAppState>()` for global state
- Verify the widget is listening to state changes
- Check if the correct state variable is being updated

### Modal Not Closing After Save
**Cause**: Missing Navigator.pop() call

**Fix**:
```dart
await saveData();
if (context.mounted) {
  Navigator.pop(context);
}
```

## Debugging Tools

### Flutter DevTools
- Use Flutter Inspector to examine widget tree
- Check performance tab for rebuilds
- Monitor network requests
- View console logs

### Debug Prints
```dart
debugPrint('Value: $value');
debugPrint('Data: ${data.toMap()}');
debugPrint('Error: $e, Stack: $stackTrace');
```

### Breakpoints
- Set breakpoints in VS Code
- Step through code execution
- Inspect variable values
- Check call stack

## Performance Issues

### Excessive Rebuilds
**Symptoms**: UI feels sluggish, animations stutter

**Fix**:
- Use `const` constructors where possible
- Minimize widget rebuilds with proper state management
- Use `RepaintBoundary` for complex widgets
- Profile with Flutter DevTools

### Memory Leaks
**Symptoms**: App crashes after extended use

**Fix**:
- Dispose controllers, focus nodes, streams
- Cancel subscriptions in dispose()
- Use weak references where appropriate
- Profile memory usage

## Testing Strategies

### Unit Testing
- Test business logic separately from UI
- Mock Firestore and external dependencies
- Test edge cases and error scenarios
- Verify data transformations

### Widget Testing
- Test widget rendering with different states
- Verify user interactions
- Test navigation flows
- Check error states

### Integration Testing
- Test complete user flows
- Verify Firestore integration
- Test authentication flows
- Check data persistence

## Hot Reload Issues

**Problem**: Changes not appearing after hot reload

**Solutions**:
- Try hot restart instead (Shift + R)
- Stop and restart the app completely
- Clear build cache: `flutter clean`
- Check if changes are in stateful widget's build method

## Common FlutterFlow Issues

### Generated Code Conflicts
**Problem**: Manual changes get overwritten

**Solution**:
- Keep custom code in separate files
- Use custom actions for business logic
- Document manual changes clearly
- Use version control to track changes

### State Not Syncing
**Problem**: FFAppState changes not reflecting in UI

**Solution**:
- Ensure widget is watching FFAppState
- Call update methods on FFAppState
- Check if state is being updated correctly
- Verify notifyListeners() is being called

## Quick Fixes Checklist

- [ ] Check for null values and use safe navigation
- [ ] Verify authentication state before Firestore operations
- [ ] Ensure setState/safeSetState is called after data changes
- [ ] Check error messages in console/debug output
- [ ] Verify data types match expected types
- [ ] Test with empty/initial state
- [ ] Check Firestore security rules
- [ ] Verify network connectivity
- [ ] Clear app data and test fresh install
- [ ] Check for proper error handling

