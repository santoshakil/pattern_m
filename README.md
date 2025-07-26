# Pattern M - Modular Flutter Architecture

A production-ready Flutter application template featuring a modular, scalable architecture with comprehensive tooling, clean architecture principles, and enterprise-grade features.

## 🏗 Architecture Overview

Pattern M implements a feature-based clean architecture with clear separation of concerns, making it ideal for large-scale applications that require maintainability, testability, and team collaboration.

## ✨ Key Features

- **Clean Architecture**: Strict separation between data, domain, and presentation layers
- **Feature-First Structure**: Modular organization by features for better scalability
- **Advanced Dependency Injection**: Centralized DI container with provider overrides
- **Multi-Environment Support**: Built-in configurations for dev, staging, and production
- **Comprehensive Error Handling**: Type-safe failures using Freezed with pattern matching
- **Enterprise Logging**: Structured logging with environment-aware configurations
- **Advanced Routing**: Protected routes, shell routes, and auth-aware navigation
- **Type-Safe State Management**: Riverpod with code generation and compile-time safety
- **Rich Context Extensions**: Productivity helpers for common UI operations
- **Internationalization Ready**: Full i18n support with ARB files and type-safe access

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry with DI and environment setup
├── app.v.dart                   # Root widget with global configurations
├── core/                        # Core functionality and infrastructure
│   ├── config/
│   │   └── env.dart            # Environment configuration and feature flags
│   ├── constants/              # App-wide constants and enums
│   ├── di/
│   │   └── injection.dart      # Dependency injection container
│   ├── errors/
│   │   ├── exceptions.dart     # Custom exceptions
│   │   ├── failures.dart       # Freezed failure types
│   │   └── failures.freezed.dart
│   ├── extensions/             # Dart/Flutter extensions
│   │   ├── collection_extensions.dart
│   │   ├── context_extensions.dart    # UI helpers (theme, navigation, dialogs)
│   │   ├── datetime_extensions.dart
│   │   ├── string_extensions.dart
│   │   └── widget_extensions.dart
│   ├── logger/
│   │   └── logger.s.dart       # Structured logging service
│   ├── theme/
│   │   └── app_theme.dart      # Centralized theming
│   └── utils/
│       ├── formatters.dart     # Data formatting utilities
│       └── validators.dart     # Input validation logic
├── features/                   # Feature modules (clean architecture)
│   ├── auth/                   # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/    # Remote/local data sources
│   │   │   ├── models/         # DTOs and serialization
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/       # Business models
│   │   │   ├── repositories/   # Repository contracts
│   │   │   └── usecases/       # Business logic
│   │   └── presentation/
│   │       ├── providers/      # State management (.p.dart)
│   │       ├── screens/        # Page widgets (.v.dart)
│   │       └── widgets/        # Feature-specific widgets
│   ├── home/                   # Home feature
│   └── settings/               # Settings feature
├── l10n/                       # Localization
│   ├── app_en.arb             # English translations
│   ├── app_localizations.dart  # Generated
│   └── app_localizations_en.dart
└── shared/                     # Cross-feature shared code
    ├── data/
    │   └── services/
    │       └── storage.s.dart  # Shared storage service
    ├── domain/
    │   └── models/             # Shared domain models
    └── presentation/
        ├── providers/          # Global providers
        │   ├── auth.p.dart     # Auth state provider
        │   ├── router.p.dart   # Router with guards
        │   └── theme.p.dart    # Theme state
        └── widgets/            # Shared UI components
            ├── error_screen.dart
            └── splash_screen.dart
```

## 🎯 File Naming Conventions

Pattern M uses specific file suffixes for clarity and consistency:

- `.v.dart` - **Views/Screens**: UI components that represent full pages
- `.p.dart` - **Providers**: Riverpod state management files
- `.s.dart` - **Services**: Business logic services (storage, API, etc.)
- `.g.dart` - **Generated**: Auto-generated files (do not edit)
- `.freezed.dart` - **Freezed**: Generated immutable models

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.8.1
- Dart SDK (included with Flutter)
- Android Studio / VS Code with Flutter extensions

### Initial Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd pattern_m
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 💻 Development

### Code Generation

The project heavily uses code generation for boilerplate reduction:

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development (recommended)
dart run build_runner watch --delete-conflicting-outputs
```

Generated files include:
- Riverpod providers (`*.p.g.dart`)
- Freezed models (`*.freezed.dart`, `*.g.dart`)
- JSON serialization (`*.g.dart`)
- Localization (`app_localizations*.dart`)

### Environment Configuration

The app supports multiple environments configured in `lib/core/config/env.dart`:

```dart
// Automatic environment detection
- Debug mode → Development
- Release mode → Production
- Environment variable → Staging

// Environment-specific features
- API endpoints
- Feature flags
- Timeouts
- Analytics/Crash reporting
```

### Adding New Features

1. **Create feature structure**
   ```
   lib/features/new_feature/
   ├── data/
   │   ├── datasources/
   │   ├── models/
   │   └── repositories/
   ├── domain/
   │   ├── entities/
   │   ├── repositories/
   │   └── usecases/
   └── presentation/
       ├── providers/
       ├── screens/
       └── widgets/
   ```

2. **Implement layers bottom-up**
   - Start with domain entities and repositories
   - Implement data layer with concrete repositories
   - Create providers for state management
   - Build UI screens and widgets

3. **Register in DI container** (if needed)
   ```dart
   // In lib/core/di/injection.dart
   static Future<void> init() async {
     // Add your service initialization
   }
   ```

4. **Add routes**
   ```dart
   // In lib/shared/presentation/providers/router.p.dart
   GoRoute(
     path: '/new-feature',
     name: 'newFeature',
     builder: (context, state) => const NewFeatureScreen(),
   ),
   ```

### State Management Patterns

**Provider with Code Generation**
```dart
@riverpod
class FeatureName extends _$FeatureName {
  @override
  FeatureState build() => FeatureState.initial();
  
  void updateState() {
    state = state.copyWith(/* updates */);
  }
}
```

**Async Provider**
```dart
@riverpod
Future<List<Item>> fetchItems(Ref ref) async {
  final repository = ref.watch(itemRepositoryProvider);
  return repository.getItems();
}
```

### Error Handling

Pattern M uses type-safe error handling with Freezed:

```dart
// Define failures
@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;
  
  const factory Failure.network({
    required String message,
  }) = NetworkFailure;
}

// Handle failures
failure.when(
  server: (message, code) => showServerError(message),
  network: (message) => showNetworkError(message),
  // ... other cases
);
```

### Using Context Extensions

The framework provides rich context extensions for common operations:

```dart
// Theme access
context.primaryColor
context.textTheme.headlineLarge

// Responsive design
if (context.isMobile) // < 600px
if (context.isTablet) // 600-1200px
if (context.isDesktop) // > 1200px

// Navigation helpers
context.showErrorSnackBar('Error message');
context.showSuccessSnackBar('Success!');
context.showLoadingDialog();
context.showAppBottomSheet(child: MySheet());

// Localization
context.l10n.welcomeMessage
```

## 🧪 Testing

### Unit Tests
```bash
flutter test

# With coverage
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Test Structure
```
test/
├── core/
│   ├── utils/
│   └── extensions/
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   └── home/
└── shared/
```

### Testing Best Practices
- Test use cases with mocked repositories
- Test providers with ProviderContainer
- Use `mocktail` or `mockito` for mocking
- Focus on business logic coverage

## 🔐 Security Considerations

- Never commit sensitive data (API keys, secrets)
- Use environment variables for configuration
- Implement certificate pinning for production
- Enable obfuscation for release builds
- Regular dependency updates

## 📱 Platform-Specific Setup

### Android
- Minimum SDK: 21 (Android 5.0)
- Target SDK: Latest stable
- ProGuard rules for release builds

### iOS
- Minimum deployment target: 12.0
- Swift version: Latest stable
- Code signing for distribution

### Web
- Responsive design support
- PWA capabilities
- SEO optimization ready

## 🏗 Build & Deployment

### Development Build
```bash
flutter run --debug
```

### Staging Build
```bash
flutter run --dart-define=ENVIRONMENT=staging
```

### Production Builds
```bash
# Android
flutter build apk --release --obfuscate --split-debug-info=debug_info

# iOS
flutter build ios --release --obfuscate --split-debug-info=debug_info

# Web
flutter build web --release --web-renderer canvaskit
```

## 🔧 Troubleshooting

### Common Issues

1. **Build runner conflicts**
   ```bash
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Pod install failures (iOS)**
   ```bash
   cd ios
   pod deintegrate
   pod install --repo-update
   ```

3. **Gradle issues (Android)**
   ```bash
   cd android
   ./gradlew clean
   ./gradlew build
   ```

## 📚 Best Practices

1. **Architecture**
   - Keep layers independent
   - Depend on abstractions, not concretions
   - One feature, one folder
   - Shared code in `/shared`

2. **State Management**
   - Use code generation for type safety
   - Keep providers focused and testable
   - Dispose resources properly

3. **Error Handling**
   - Always handle failures explicitly
   - Provide user-friendly error messages
   - Log errors for debugging

4. **Performance**
   - Use const constructors
   - Implement proper list optimization
   - Profile before optimizing
   - Monitor app size

## 🤝 Contributing

1. Follow the established architecture
2. Write tests for new features
3. Update documentation
4. Run linting: `flutter analyze`
5. Format code: `dart format .`
6. Create detailed pull requests

## 📄 License

This project is a template and can be used freely for any purpose.