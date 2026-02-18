# EatWise Logo Header Component

A reusable Flutter component for displaying the EatWise logo with customizable options.

## Features

- **Flexible sizing**: Customize logo height
- **Alignment control**: Position logo as needed
- **Text option**: Show/hide "EatWise" text alongside logo
- **Custom styling**: Override text style when needed
- **Custom logo path**: Use different logo assets if needed

## Usage Examples

### 1. Basic Logo (Default)

```dart
import '/components/eatwise_logo_header/eatwise_logo_header_widget.dart';

// Simple logo with default settings (32px height, centered)
EatwiseLogoHeaderWidget()
```

### 2. Logo in AppBar

```dart
AppBar(
  backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
  automaticallyImplyLeading: false,
  title: EatwiseLogoHeaderWidget(
    height: 32.0,
    alignment: Alignment(-1.0, 0.0), // Left-aligned
  ),
  centerTitle: false,
  elevation: 0.0,
)
```

### 3. Logo with Text

```dart
EatwiseLogoHeaderWidget(
  height: 40.0,
  showText: true,
  alignment: Alignment.center,
)
```

### 4. Custom Styled Logo with Text

```dart
EatwiseLogoHeaderWidget(
  height: 48.0,
  showText: true,
  alignment: Alignment.center,
  textStyle: FlutterFlowTheme.of(context).headlineMedium.override(
    font: GoogleFonts.inter(
      fontWeight: FontWeight.w600,
    ),
    color: FlutterFlowTheme.of(context).primaryText,
    fontSize: 28.0,
    letterSpacing: 0.0,
  ),
)
```

### 5. Large Logo for Splash/Entry Pages

```dart
EatwiseLogoHeaderWidget(
  height: 80.0,
  alignment: Alignment.center,
)
```

### 6. Custom Logo Path

```dart
EatwiseLogoHeaderWidget(
  height: 32.0,
  logoPath: 'assets/images/custom_logo.png',
)
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `height` | `double` | `32.0` | Height of the logo image |
| `alignment` | `Alignment` | `Alignment.center` | Alignment of the logo image |
| `showText` | `bool` | `false` | Whether to show "EatWise" text next to logo |
| `logoPath` | `String` | `'assets/images/custom-images/logo.png'` | Path to logo asset |
| `textStyle` | `TextStyle?` | `null` | Custom text style (uses default if null) |

## Common Use Cases

### Replace existing logo in HomePage

**Before:**
```dart
title: ClipRRect(
  borderRadius: BorderRadius.circular(0.0),
  child: Image.asset(
    'assets/images/custom-images/logo.png',
    height: 32.0,
    fit: BoxFit.contain,
    alignment: Alignment(-1.0, 0.0),
  ),
),
```

**After:**
```dart
title: EatwiseLogoHeaderWidget(
  height: 32.0,
  alignment: Alignment(-1.0, 0.0),
),
```

## Benefits

1. **Consistency**: Ensures logo appears the same across all pages
2. **Maintainability**: Update logo in one place, changes reflect everywhere
3. **Flexibility**: Easy to customize per page while maintaining consistency
4. **Reusability**: Import once, use anywhere in the app
5. **Type Safety**: Compile-time checking of parameters

## Integration

The component is already exported in `/lib/index.dart`, so you can import it anywhere:

```dart
import '/index.dart';

// Then use it
EatwiseLogoHeaderWidget()
```

Or import directly:

```dart
import '/components/eatwise_logo_header/eatwise_logo_header_widget.dart';
```

