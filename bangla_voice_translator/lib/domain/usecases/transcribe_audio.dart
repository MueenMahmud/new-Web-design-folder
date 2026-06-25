import '../repositories/translation_repository.dart';
import '../../core/utils/typedef.dart';

class TranscribeAudio {
  final TranslationRepository repository;

  const TranscribeAudio(this.repository);

  ResultFuture<String> call(String audioPath) {
    return repository.transcribeAudio(audioPath);
  }
}
