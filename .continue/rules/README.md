# Continue.dev Rules for EatWise Flutter/FlutterFlow Project

This directory contains rules that guide AI assistants (like Continue.dev) when working with this codebase.

## What Are Rules?

Rules provide context-aware instructions to AI coding assistants. They help the AI understand:
- Project-specific patterns and conventions
- Best practices for this codebase
- Common pitfalls to avoid
- Debugging strategies

## Rules in This Project

### 1. `flutter-flutterflow-standards.md`
**When it applies**: Working with any Dart files, especially in `lib/` directory

**What it covers**:
- Code organization and architecture patterns
- Null safety and error handling
- State management with FFAppState
- Firebase/Firestore integration basics
- Widget development patterns
- UI/UX conventions
- Performance best practices

**Use this when**: Writing new features, refactoring code, or fixing bugs

### 2. `firebase-patterns.md`
**When it applies**: Working with backend services, Firestore operations, or data persistence

**What it covers**:
- Firestore document structure
- Service layer patterns
- Query patterns and optimization
- Data conversion between Dart and Firestore
- Error handling for Firebase operations
- Real-time updates and offline support

**Use this when**: Implementing data persistence, creating new services, or debugging Firestore issues

### 3. `debugging-troubleshooting.md`
**When it applies**: Debugging errors or troubleshooting issues

**What it covers**:
- Common Flutter errors and solutions
- Debugging workflow and strategies
- Project-specific common issues
- Performance troubleshooting
- Testing strategies
- Quick fixes checklist

**Use this when**: Encountering errors, performance issues, or unexpected behavior

## How Rules Work

### Automatic Application
Rules with `globs` patterns are automatically applied when you're working with matching files:
- `**/*.dart` - All Dart files
- `lib/backend/**/*.dart` - Backend service files
- `**/*.yaml` - Configuration files

### Manual Selection
You can also manually select which rules to apply in your Continue.dev interface.

### Rule Properties

Each rule has:
- **name**: Display name in the UI
- **globs**: File patterns that trigger the rule (optional)
- **alwaysApply**: Whether to always include this rule (true/false)
- **description**: What the rule covers (helps AI decide when to use it)

## Adding New Rules

To add a new rule:

1. Create a new `.md` file in this directory
2. Add YAML frontmatter with rule metadata:
```markdown
---
name: Your Rule Name
globs: ["**/*.dart"]
alwaysApply: false
description: Brief description of what this rule covers
---

# Your Rule Content

- Rule point 1
- Rule point 2
```

3. The rule will automatically be available in Continue.dev

## Best Practices for Rules

- **Be specific**: Include concrete examples and code snippets
- **Be concise**: Focus on the most important patterns
- **Be current**: Update rules as the project evolves
- **Be practical**: Include real solutions to real problems
- **Use examples**: Show code examples for complex patterns

## Updating Rules

Rules should be updated when:
- New patterns emerge in the codebase
- Common issues are discovered
- Architecture changes
- New best practices are adopted
- Team conventions change

## Rule Naming Convention

Use descriptive, kebab-case names:
- `flutter-flutterflow-standards.md` - General standards
- `firebase-patterns.md` - Specific technology patterns
- `debugging-troubleshooting.md` - Problem-solving guides

## Integration with Continue.dev

These rules integrate with Continue.dev's AI assistant to:
1. Provide context when you ask questions
2. Guide code generation and suggestions
3. Help with debugging and troubleshooting
4. Ensure consistency across the codebase

## Learn More

- [Continue.dev Rules Documentation](https://docs.continue.dev/customize/deep-dives/rules)
- [Continue.dev Configuration](https://docs.continue.dev/reference)

