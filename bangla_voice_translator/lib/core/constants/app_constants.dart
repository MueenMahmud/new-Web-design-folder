class AppConstants {
  AppConstants._();

  static const String appName = 'Bangla Voice Translator';
  static const String appVersion = '1.0.0';

  // API
  static const String openAiBaseUrl = 'https://api.openai.com/v1';
  static const String whisperEndpoint = '/audio/transcriptions';
  static const String chatEndpoint = '/chat/completions';
  static const String ttsEndpoint = '/audio/speech';

  // Models
  static const String whisperModel = 'whisper-1';
  static const String gptModel = 'gpt-4o-mini';
  static const String ttsModel = 'tts-1';

  // Languages
  static const String bangla = 'bn';
  static const String korean = 'ko';
  static const String english = 'en';

  // Audio
  static const int sampleRate = 16000;
  static const int maxRecordingDuration = 60;
  static const String audioFormat = 'wav';

  // Cache
  static const int maxHistoryItems = 500;
  static const int maxFavoriteItems = 200;

  // Timeouts
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;

  // Firestore collections
  static const String usersCollection = 'users';
  static const String translationsCollection = 'translations';
  static const String favoritesCollection = 'favorites';

  // SharedPreferences keys
  static const String themeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String onboardingKey = 'onboarding_completed';
  static const String guestModeKey = 'guest_mode';
}
