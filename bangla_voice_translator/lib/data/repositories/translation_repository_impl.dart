import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/network_info.dart';
import '../../core/utils/typedef.dart';
import '../../domain/entities/translation.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/remote/openai_remote_source.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final OpenAiRemoteSource remoteSource;
  final NetworkInfo networkInfo;
  static const _uuid = Uuid();

  TranslationRepositoryImpl({
    required this.remoteSource,
    required this.networkInfo,
  });

  @override
  ResultFuture<String> transcribeAudio(String audioPath) async {
    if (!await networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }
    try {
      final text = await remoteSource.transcribeAudio(audioPath);
      return (data: text, failure: null);
    } on ServerException catch (e) {
      return (
        data: null,
        failure: ServerFailure(message: e.message, statusCode: e.statusCode)
      );
    }
  }

  @override
  ResultFuture<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    if (!await networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }
    try {
      final translated = await remoteSource.translateText(
        text: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
      return (data: translated, failure: null);
    } on ServerException catch (e) {
      return (
        data: null,
        failure: ServerFailure(message: e.message, statusCode: e.statusCode)
      );
    }
  }

  @override
  ResultFuture<String> generateSpeech({
    required String text,
    required String language,
  }) async {
    if (!await networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }
    try {
      final voice = _getVoiceForLanguage(language);
      final audioPath = await remoteSource.generateSpeech(
        text: text,
        voice: voice,
      );
      return (data: audioPath, failure: null);
    } on ServerException catch (e) {
      return (
        data: null,
        failure: ServerFailure(message: e.message, statusCode: e.statusCode)
      );
    }
  }

  @override
  ResultFuture<Translation> performFullTranslation({
    required String audioPath,
    required TargetLanguage targetLanguage,
  }) async {
    if (!await networkInfo.isConnected) {
      return (data: null, failure: const NetworkFailure());
    }

    try {
      // Step 1: Transcribe Bangla audio to text
      final sourceText = await remoteSource.transcribeAudio(audioPath);

      // Step 2: Translate to target language
      final targetLang = targetLanguage == TargetLanguage.korean
          ? AppConstants.korean
          : AppConstants.english;

      final translatedText = await remoteSource.translateText(
        text: sourceText,
        sourceLanguage: AppConstants.bangla,
        targetLanguage: targetLang,
      );

      // Step 3: Generate TTS audio
      final voice = _getVoiceForLanguage(targetLang);
      final ttsPath = await remoteSource.generateSpeech(
        text: translatedText,
        voice: voice,
      );

      final translation = Translation(
        id: _uuid.v4(),
        sourceText: sourceText,
        translatedText: translatedText,
        sourceLanguage: AppConstants.bangla,
        targetLanguage: targetLang,
        audioPath: audioPath,
        ttsAudioPath: ttsPath,
        createdAt: DateTime.now(),
      );

      return (data: translation, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: TranslationFailure(message: e.message));
    }
  }

  String _getVoiceForLanguage(String language) {
    switch (language) {
      case 'ko':
        return 'nova';
      case 'en':
        return 'alloy';
      case 'bn':
        return 'shimmer';
      default:
        return 'alloy';
    }
  }
}
