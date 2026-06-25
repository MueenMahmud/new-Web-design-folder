# API Documentation

## OpenAI Integration

### Speech-to-Text (Whisper API)

**Endpoint:** `POST https://api.openai.com/v1/audio/transcriptions`

**Request:**
```
Content-Type: multipart/form-data
Authorization: Bearer {OPENAI_API_KEY}

file: {audio_file.wav}
model: whisper-1
language: bn
```

**Response:**
```json
{
  "text": "হ্যালো, আপনি কেমন আছেন?"
}
```

### Translation (GPT API)

**Endpoint:** `POST https://api.openai.com/v1/chat/completions`

**Request:**
```json
{
  "model": "gpt-4o-mini",
  "messages": [
    {
      "role": "system",
      "content": "You are a translator. Translate from Bangla to Korean. Only respond with the translation."
    },
    {
      "role": "user",
      "content": "হ্যালো, আপনি কেমন আছেন?"
    }
  ],
  "max_tokens": 1000,
  "temperature": 0.3
}
```

**Response:**
```json
{
  "choices": [
    {
      "message": {
        "content": "안녕하세요, 어떻게 지내세요?"
      }
    }
  ]
}
```

### Text-to-Speech (TTS API)

**Endpoint:** `POST https://api.openai.com/v1/audio/speech`

**Request:**
```json
{
  "model": "tts-1",
  "input": "안녕하세요, 어떻게 지내세요?",
  "voice": "alloy"
}
```

**Response:** Audio file (MP3 binary data)

## Firebase Integration

### Authentication

| Method | Firebase Service |
|--------|-----------------|
| Email/Password | `FirebaseAuth.signInWithEmailAndPassword()` |
| Google Sign-In | `FirebaseAuth.signInWithCredential(GoogleAuthProvider)` |
| Guest | `FirebaseAuth.signInAnonymously()` |
| Sign Out | `FirebaseAuth.signOut()` |
| Reset Password | `FirebaseAuth.sendPasswordResetEmail()` |

### Firestore Schema

```
users/
  {userId}/
    - uid: string
    - displayName: string?
    - email: string?
    - photoUrl: string?
    - isGuest: boolean
    - createdAt: timestamp
    - lastLoginAt: timestamp?

    translations/
      {translationId}/
        - id: string
        - sourceText: string
        - translatedText: string
        - sourceLanguage: string (bn)
        - targetLanguage: string (ko|en)
        - audioPath: string?
        - ttsAudioPath: string?
        - createdAt: timestamp
        - isFavorite: boolean
        - userId: string

    favorites/
      {favoriteId}/
        (same schema as translations)
```

## Internal API (Repository Pattern)

### TranslationRepository

```dart
abstract class TranslationRepository {
  ResultFuture<String> transcribeAudio(String audioPath);
  ResultFuture<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });
  ResultFuture<String> generateSpeech({
    required String text,
    required String language,
  });
  ResultFuture<Translation> performFullTranslation({
    required String audioPath,
    required TargetLanguage targetLanguage,
  });
}
```

### AuthRepository

```dart
abstract class AuthRepository {
  ResultFuture<UserProfile> signInWithEmail({
    required String email,
    required String password,
  });
  ResultFuture<UserProfile> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  });
  ResultFuture<UserProfile> signInWithGoogle();
  ResultFuture<UserProfile> signInAsGuest();
  ResultVoid signOut();
  ResultFuture<UserProfile?> getCurrentUser();
  ResultVoid resetPassword(String email);
}
```

### HistoryRepository

```dart
abstract class HistoryRepository {
  ResultFuture<List<Translation>> getHistory({int? limit, int? offset});
  ResultFuture<void> saveTranslation(Translation translation);
  ResultFuture<void> deleteTranslation(String id);
  ResultFuture<void> clearHistory();
  ResultFuture<List<Translation>> searchHistory(String query);
}
```

### FavoritesRepository

```dart
abstract class FavoritesRepository {
  ResultFuture<List<Translation>> getFavorites();
  ResultFuture<void> addFavorite(Translation translation);
  ResultFuture<void> removeFavorite(String id);
  ResultFuture<bool> isFavorite(String id);
}
```

## Error Handling

All repository methods return `ResultFuture<T>`, a record type:
```dart
typedef ResultFuture<T> = Future<({T? data, Failure? failure})>;
```

### Failure Types

| Type | Description |
|------|------------|
| `ServerFailure` | API/server errors |
| `NetworkFailure` | No internet connection |
| `CacheFailure` | Local storage errors |
| `AuthFailure` | Authentication errors |
| `AudioFailure` | Recording/playback errors |
| `TranslationFailure` | Translation pipeline errors |
| `PermissionFailure` | Missing device permissions |
