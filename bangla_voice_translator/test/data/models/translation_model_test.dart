import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/data/models/translation_model.dart';
import 'package:bangla_voice_translator/domain/entities/translation.dart';

void main() {
  final tModel = TranslationModel(
    id: 'test-id',
    sourceText: 'হ্যালো',
    translatedText: '안녕하세요',
    sourceLanguage: 'bn',
    targetLanguage: 'ko',
    createdAt: DateTime(2024, 1, 1),
    isFavorite: false,
  );

  final tJson = {
    'id': 'test-id',
    'sourceText': 'হ্যালো',
    'translatedText': '안녕하세요',
    'sourceLanguage': 'bn',
    'targetLanguage': 'ko',
    'audioPath': null,
    'ttsAudioPath': null,
    'createdAt': '2024-01-01T00:00:00.000',
    'isFavorite': false,
    'userId': null,
  };

  group('TranslationModel', () {
    test('should be a subclass of Translation entity', () {
      expect(tModel, isA<Translation>());
    });

    test('should create model from JSON', () {
      final result = TranslationModel.fromJson(tJson);

      expect(result.id, tModel.id);
      expect(result.sourceText, tModel.sourceText);
      expect(result.translatedText, tModel.translatedText);
      expect(result.sourceLanguage, tModel.sourceLanguage);
      expect(result.targetLanguage, tModel.targetLanguage);
      expect(result.isFavorite, tModel.isFavorite);
    });

    test('should convert model to JSON', () {
      final result = tModel.toJson();

      expect(result['id'], tJson['id']);
      expect(result['sourceText'], tJson['sourceText']);
      expect(result['translatedText'], tJson['translatedText']);
      expect(result['sourceLanguage'], tJson['sourceLanguage']);
      expect(result['targetLanguage'], tJson['targetLanguage']);
      expect(result['isFavorite'], tJson['isFavorite']);
    });

    test('should create model from entity', () {
      final entity = Translation(
        id: 'test-id',
        sourceText: 'হ্যালো',
        translatedText: '안녕하세요',
        sourceLanguage: 'bn',
        targetLanguage: 'ko',
        createdAt: DateTime(2024, 1, 1),
      );

      final result = TranslationModel.fromEntity(entity);

      expect(result.id, entity.id);
      expect(result.sourceText, entity.sourceText);
      expect(result.translatedText, entity.translatedText);
    });

    test('should handle JSON with optional fields', () {
      final jsonWithOptionals = {
        'id': 'test-id',
        'sourceText': 'হ্যালো',
        'translatedText': '안녕하세요',
        'sourceLanguage': 'bn',
        'targetLanguage': 'ko',
        'audioPath': '/path/to/audio.wav',
        'ttsAudioPath': '/path/to/tts.mp3',
        'createdAt': '2024-01-01T00:00:00.000',
        'isFavorite': true,
        'userId': 'user-123',
      };

      final result = TranslationModel.fromJson(jsonWithOptionals);

      expect(result.audioPath, '/path/to/audio.wav');
      expect(result.ttsAudioPath, '/path/to/tts.mp3');
      expect(result.isFavorite, true);
      expect(result.userId, 'user-123');
    });
  });
}
