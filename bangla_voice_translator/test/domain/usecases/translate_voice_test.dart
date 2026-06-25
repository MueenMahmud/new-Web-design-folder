import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/core/errors/failures.dart';
import 'package:bangla_voice_translator/core/utils/typedef.dart';
import 'package:bangla_voice_translator/domain/entities/translation.dart';
import 'package:bangla_voice_translator/domain/repositories/translation_repository.dart';
import 'package:bangla_voice_translator/domain/usecases/translate_voice.dart';

class FakeTranslationRepository implements TranslationRepository {
  ({Translation? data, Failure? failure})? fullTranslationResult;

  @override
  ResultFuture<Translation> performFullTranslation({
    required String audioPath,
    required TargetLanguage targetLanguage,
  }) async {
    return fullTranslationResult!;
  }

  @override
  ResultFuture<String> transcribeAudio(String audioPath) async {
    return (data: '', failure: null);
  }

  @override
  ResultFuture<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    return (data: '', failure: null);
  }

  @override
  ResultFuture<String> generateSpeech({
    required String text,
    required String language,
  }) async {
    return (data: '', failure: null);
  }
}

void main() {
  late TranslateVoice usecase;
  late FakeTranslationRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeTranslationRepository();
    usecase = TranslateVoice(fakeRepository);
  });

  final tTranslation = Translation(
    id: 'test-id',
    sourceText: 'হ্যালো',
    translatedText: '안녕하세요',
    sourceLanguage: 'bn',
    targetLanguage: 'ko',
    createdAt: DateTime(2024, 1, 1),
  );

  group('TranslateVoice', () {
    test('should return Translation on successful translation', () async {
      fakeRepository.fullTranslationResult = (
        data: tTranslation,
        failure: null,
      );

      final result = await usecase(
        audioPath: '/test/audio.wav',
        targetLanguage: TargetLanguage.korean,
      );

      expect(result.isSuccess, true);
      expect(result.data, tTranslation);
    });

    test('should return failure when translation fails', () async {
      const failure = ServerFailure(message: 'Translation failed');
      fakeRepository.fullTranslationResult = (
        data: null,
        failure: failure,
      );

      final result = await usecase(
        audioPath: '/test/audio.wav',
        targetLanguage: TargetLanguage.korean,
      );

      expect(result.isFailure, true);
      expect(result.failure, failure);
    });
  });
}
