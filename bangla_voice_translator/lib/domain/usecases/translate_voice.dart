import '../entities/translation.dart';
import '../repositories/translation_repository.dart';
import '../../core/utils/typedef.dart';

class TranslateVoice {
  final TranslationRepository repository;

  const TranslateVoice(this.repository);

  ResultFuture<Translation> call({
    required String audioPath,
    required TargetLanguage targetLanguage,
  }) {
    return repository.performFullTranslation(
      audioPath: audioPath,
      targetLanguage: targetLanguage,
    );
  }
}
