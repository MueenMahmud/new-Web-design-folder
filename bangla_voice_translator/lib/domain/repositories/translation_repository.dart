import '../entities/translation.dart';
import '../../core/utils/typedef.dart';

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
