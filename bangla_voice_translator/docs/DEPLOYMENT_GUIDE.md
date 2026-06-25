# Deployment Guide

## Prerequisites

- Flutter SDK 3.27.4+
- Android Studio with Android SDK
- Xcode 15+ (for iOS)
- Firebase CLI (`npm install -g firebase-tools`)
- Google Cloud account
- OpenAI API account
- Apple Developer account (for iOS App Store)
- Google Play Developer account (for Play Store)

## Firebase Setup

### 1. Create Firebase Project

```bash
firebase login
firebase projects:create bangla-voice-translator
```

### 2. Enable Services

- Go to Firebase Console > Authentication > Sign-in methods
- Enable: Email/Password, Google, Anonymous
- Go to Firestore Database > Create database (production mode)
- Go to Analytics > Enable
- Go to Crashlytics > Enable

### 3. Deploy Security Rules

```bash
cd bangla_voice_translator
firebase deploy --only firestore:rules
```

### 4. Download Config Files

- Android: Download `google-services.json` → place in `android/app/`
- iOS: Download `GoogleService-Info.plist` → place in `ios/Runner/`

## OpenAI API Setup

1. Create account at [platform.openai.com](https://platform.openai.com)
2. Generate API key
3. Set environment variable or update `lib/core/constants/api_keys.dart`

## Android Release Build

### 1. Generate Signing Key

```bash
keytool -genkey -v -keystore ~/bangla-voice-translator.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias bangla-voice-translator
```

### 2. Configure Signing

Create `android/key.properties`:
```properties
storePassword=<your_password>
keyPassword=<your_password>
keyAlias=bangla-voice-translator
storeFile=<path_to_keystore>/bangla-voice-translator.jks
```

### 3. Build Release APK/AAB

```bash
flutter build apk --release
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## iOS Release Build

### 1. Configure Xcode

- Open `ios/Runner.xcworkspace` in Xcode
- Set Bundle Identifier: `com.banglavoice.banglaVoiceTranslator`
- Configure signing team and provisioning profile
- Set deployment target to iOS 13.0+

### 2. Build Release

```bash
flutter build ios --release
```

### 3. Archive and Upload

- In Xcode: Product > Archive
- Upload to App Store Connect

## Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `OPENAI_API_KEY` | OpenAI API key for Whisper, GPT, TTS | Yes |
| `FIREBASE_PROJECT_ID` | Firebase project identifier | Yes |

## CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/flutter_ci.yml`) runs on every push and PR:

1. **Analyze & Test** - Lint, format check, static analysis, unit tests
2. **Build Android** - Debug APK build verification
3. **Build iOS** - Debug iOS build verification (macOS runner)

### Adding Secrets to GitHub

Go to repo Settings > Secrets and variables > Actions:

- `OPENAI_API_KEY` - Your OpenAI API key

## Performance Optimization

- Enable tree-shaking: `flutter build --release`
- Use `--split-per-abi` for Android: smaller APK per architecture
- Enable obfuscation: `flutter build --obfuscate --split-debug-info=symbols/`
- Configure ProGuard for Android release builds

## Monitoring

- **Firebase Crashlytics** - Real-time crash reports
- **Firebase Analytics** - User behavior tracking
- **Firebase Performance** - App performance metrics
