import '../repositories/translation_repository.dart';
import '../../core/utils/typedef.dart';

class GenerateSpeech {
  final TranslationRepository repository;

  const GenerateSpeech(this.repository);

  ResultFuture<String> call({
    required String text,
    required String language,
  }) {
    return repository.generateSpeech(text: text, language: language);
  }
}
