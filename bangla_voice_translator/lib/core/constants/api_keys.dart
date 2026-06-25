/// API keys configuration.
/// In production, these should be loaded from environment variables
/// or a secure secrets manager — never hardcoded.
class ApiKeys {
  ApiKeys._();

  static String get openAiApiKey =>
      const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');

  static String get googleCloudApiKey =>
      const String.fromEnvironment('GOOGLE_CLOUD_API_KEY', defaultValue: '');
}
