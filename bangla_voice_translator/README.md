# Bangla Voice Translator

Real-time AI-powered voice translation app that converts Bangla speech into Korean and English voice.

## Features

- **Bangla Voice to Korean Voice** - Record Bangla speech and get Korean voice translation
- **Bangla Voice to English Voice** - Record Bangla speech and get English voice translation
- **Real-time Conversation Mode** - Bidirectional translation for live conversations
- **Translation History** - Browse and search past translations
- **Favorites** - Save frequently used translations
- **Offline Phrasebook** - Common phrases available without internet
- **Audio Playback** - Listen to translations with TTS
- **Copy & Share** - Share translated text
- **Dark Mode** - System, light, and dark theme support
- **Multi-language UI** - English, Bangla, and Korean interface
- **Guest Mode** - Use the app without creating an account
- **User Authentication** - Email/password, Google Sign-In
- **Cloud Sync** - Sync translations across devices via Firebase

## Architecture

```
lib/
├── core/                    # Shared utilities, constants, theme
│   ├── constants/           # App constants, API keys
│   ├── di/                  # Dependency injection (GetIt)
│   ├── errors/              # Failure/exception classes
│   ├── network/             # API client, network info
│   ├── routes/              # GoRouter configuration
│   ├── theme/               # Material 3 theme
│   └── utils/               # Audio helper, type definitions
├── data/                    # Data layer
│   ├── datasources/         # Remote (OpenAI, Firebase) and local sources
│   ├── models/              # Data models (JSON serialization)
│   └── repositories/        # Repository implementations
├── domain/                  # Domain layer (business logic)
│   ├── entities/            # Core entities (Translation, UserProfile)
│   ├── repositories/        # Abstract repository contracts
│   └── usecases/            # Use cases (single responsibility)
└── presentation/            # Presentation layer
    ├── blocs/               # BLoC state management
    ├── screens/             # App screens
    └── widgets/             # Reusable widgets
```

### Design Patterns

- **Clean Architecture** - Domain, Data, Presentation layer separation
- **BLoC Pattern** - Event-driven state management
- **Repository Pattern** - Data access abstraction with dependency inversion
- **Dependency Injection** - GetIt service locator
- **Result Type** - Functional error handling with `ResultFuture<T>`

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter 3.27.4 |
| State Management | flutter_bloc 8.1.3 |
| DI | get_it 7.6.4 |
| HTTP Client | dio 5.3.3 |
| Auth | Firebase Auth 4.16.0 |
| Database | Cloud Firestore 4.14.0 |
| Analytics | Firebase Analytics 10.8.0 |
| Crash Reporting | Firebase Crashlytics 3.4.8 |
| Audio Recording | record 5.0.4 |
| Audio Playback | just_audio 0.9.36 |
| Routing | go_router 12.1.3 |
| Design | Material 3 |

## AI Services

| Service | Provider | Purpose |
|---------|----------|---------|
| Speech-to-Text | OpenAI Whisper | Transcribe Bangla audio to text |
| Translation | GPT-4o-mini | Translate Bangla to Korean/English |
| Text-to-Speech | OpenAI TTS | Generate audio for translated text |

## Getting Started

### Prerequisites

- Flutter SDK 3.27.4+
- Dart SDK 3.0+
- Android Studio / Xcode
- Firebase project
- OpenAI API key

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/MueenMahmud/new-Web-design-folder.git
   cd new-Web-design-folder/bangla_voice_translator
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Enable Authentication (Email/Password, Google, Anonymous)
   - Create Cloud Firestore database
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place in `android/app/` and `ios/Runner/` respectively

4. **Configure OpenAI API Key**
   - Get an API key from [platform.openai.com](https://platform.openai.com)
   - Set the environment variable `OPENAI_API_KEY`
   - Or update `lib/core/constants/api_keys.dart`

5. **Run the app**
   ```bash
   flutter run
   ```

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/domain/usecases/translate_voice_test.dart
```

### Test Structure

```
test/
├── data/
│   └── models/              # Model serialization tests
├── domain/
│   └── usecases/            # Use case unit tests
└── presentation/
    └── widgets/             # Widget tests
```

## CI/CD

GitHub Actions workflow at `.github/workflows/flutter_ci.yml`:

- **Analyze & Test** - Format check, static analysis, unit tests with coverage
- **Build Android** - Debug APK build
- **Build iOS** - Debug iOS build (macOS runner)

## Building for Release

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Firebase Security Rules

See `firestore.rules` for production Firestore security rules that enforce:
- User-owned data access (read/write only own documents)
- Data validation (required fields, size limits)
- Subcollection protection for translations and favorites

## Screens

| Screen | Description |
|--------|------------|
| Splash | Animated app intro with gradient background |
| Onboarding | 4-page feature walkthrough |
| Login | Email/password auth with guest mode option |
| Home | Bottom navigation hub (5 tabs) |
| Voice Translation | Main translation UI with recording, language selection, result display |
| Conversation | Real-time bidirectional translation with message bubbles |
| History | Searchable list of past translations |
| Favorites | Saved translations collection |
| Settings | Theme, language, account preferences |
| Profile | User info display and account management |

## Performance

- Translation response target: < 5 seconds
- App startup target: < 2 seconds
- Supports 100,000+ users via Firebase infrastructure

## License

This project is proprietary software. All rights reserved.
