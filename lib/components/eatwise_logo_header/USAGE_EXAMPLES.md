# EatWise Logo Header - Real Usage Examples

This document shows real-world examples of how to use the EatwiseLogoHeaderWidget in different pages of the EatWise app.

## Example 1: HomePage AppBar (Current Implementation)

### Location: `lib/home_pages/home_page/home_page_widget.dart`

**Current Code (lines 93-108):**
```dart
appBar: AppBar(
  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
  automaticallyImplyLeading: false,
  title: ClipRRect(
    borderRadius: BorderRadius.circular(0.0),
    child: Image.asset(
      'assets/images/custom-images/logo.png',
      height: 32.0,
      fit: BoxFit.contain,
      alignment: Alignment(-1.0, 0.0),
    ),
  ),
  actions: const [],
  centerTitle: false,
  elevation: 0.0,
),
```

**Refactored with Component:**
```dart
appBar: AppBar(
  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
  automaticallyImplyLeading: false,
  title: EatwiseLogoHeaderWidget(
    height: 32.0,
    alignment: Alignment(-1.0, 0.0),
  ),
  actions: const [],
  centerTitle: false,
  elevation: 0.0,
),
```

**Benefits:**
- Reduces code from 9 lines to 4 lines
- Easier to maintain
- Consistent logo rendering

---

## Example 2: Login Page Header

### Location: `lib/register/log_in/log_in_widget.dart`

**Add Logo Above "Welcome Back!" (after line 120):**
```dart
children: [
  // Add logo at the top
  Padding(
    padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
    child: Center(
      child: EatwiseLogoHeaderWidget(
        height: 60.0,
        showText: true,
        alignment: Alignment.center,
      ),
    ),
  ),
  Align(
    alignment: AlignmentDirectional(0.0, -1.0),
    child: Padding(
      padding: EdgeInsetsDirectional.fromSTEB(24.0, 12.0, 24.0, 0.0),
      child: Text(
        'Welcome Back!',
        // ... rest of the code
```

---

## Example 3: Sign Up Page Header

### Location: `lib/register/sign_up/sign_up_widget.dart`

**Add Logo Above "Create Your Account" (after line 132):**
```dart
children: [
  // Add logo at the top
  Padding(
    padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 12.0),
    child: Center(
      child: EatwiseLogoHeaderWidget(
        height: 60.0,
        showText: true,
        alignment: Alignment.center,
      ),
    ),
  ),
  Align(
    alignment: AlignmentDirectional(0.0, -1.0),
    child: Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
      child: Text(
        'Create Your Account',
        // ... rest of the code
```

---

## Example 4: Profile Page Header

### Location: `lib/profile/profile/profile_widget.dart`

**Replace AppBar Title (around line 97-100):**
```dart
appBar: AppBar(
  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
  automaticallyImplyLeading: false,
  title: EatwiseLogoHeaderWidget(
    height: 28.0,
    showText: true,
  ),
  actions: const [],
  centerTitle: true,
  elevation: 0.0,
),
```

---

## Example 5: Admin Panel Header

### Location: `lib/admin/pages/dashboard_home_page.dart`

**Add to AppBar:**
```dart
appBar: AppBar(
  title: EatwiseLogoHeaderWidget(
    height: 36.0,
    showText: true,
    textStyle: FlutterFlowTheme.of(context).headlineMedium.override(
      font: GoogleFonts.inter(fontWeight: FontWeight.bold),
      color: Colors.white,
      fontSize: 26.0,
      letterSpacing: 0.0,
    ),
  ),
  backgroundColor: FlutterFlowTheme.of(context).primary,
  centerTitle: false,
),
```

---

## Example 6: Splash/Loading Screen

**Create a centered logo:**
```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      EatwiseLogoHeaderWidget(
        height: 120.0,
        alignment: Alignment.center,
      ),
      SizedBox(height: 24.0),
      CircularProgressIndicator(
        color: FlutterFlowTheme.of(context).primary,
      ),
    ],
  ),
)
```

---

## Quick Reference

### Import Statement
```dart
import '/components/eatwise_logo_header/eatwise_logo_header_widget.dart';
// or
import '/index.dart';
```

### Common Configurations

**Small AppBar Logo (Left-aligned):**
```dart
EatwiseLogoHeaderWidget(
  height: 28.0,
  alignment: Alignment(-1.0, 0.0),
)
```

**Medium AppBar Logo (Centered):**
```dart
EatwiseLogoHeaderWidget(
  height: 32.0,
  alignment: Alignment.center,
)
```

**Large Logo with Text (Auth Pages):**
```dart
EatwiseLogoHeaderWidget(
  height: 60.0,
  showText: true,
  alignment: Alignment.center,
)
```

**Extra Large Logo (Splash):**
```dart
EatwiseLogoHeaderWidget(
  height: 100.0,
  alignment: Alignment.center,
)
```

