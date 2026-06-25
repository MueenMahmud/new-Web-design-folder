import '../repositories/translation_repository.dart';
import '../../core/utils/typedef.dart';

class TranslateText {
  final TranslationRepository repository;

  const TranslateText(this.repository);

  ResultFuture<String> call({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    return repository.translateText(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }
}
