import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/core/errors/failures.dart';
import 'package:bangla_voice_translator/core/utils/typedef.dart';
import 'package:bangla_voice_translator/domain/entities/translation.dart';
import 'package:bangla_voice_translator/domain/repositories/history_repository.dart';
import 'package:bangla_voice_translator/domain/usecases/history_usecases.dart';

class FakeHistoryRepository implements HistoryRepository {
  ({List<Translation>? data, Failure? failure})? getHistoryResult;
  ({void data, Failure? failure})? saveResult;
  ({void data, Failure? failure})? deleteResult;
  ({void data, Failure? failure})? clearResult;
  ({List<Translation>? data, Failure? failure})? searchResult;
  ({void data, Failure? failure})? syncResult;

  @override
  ResultFuture<List<Translation>> getHistory({int? limit, int? offset}) async {
    return getHistoryResult!;
  }

  @override
  ResultFuture<void> saveTranslation(Translation translation) async {
    return saveResult!;
  }

  @override
  ResultFuture<void> deleteTranslation(String id) async {
    return deleteResult!;
  }

  @override
  ResultFuture<void> clearHistory() async {
    return clearResult!;
  }

  @override
  ResultFuture<List<Translation>> searchHistory(String query) async {
    return searchResult!;
  }

  @override
  ResultFuture<void> syncWithCloud(String userId) async {
    return syncResult!;
  }
}

void main() {
  late FakeHistoryRepository fakeRepository;

  final tTranslations = [
    Translation(
      id: '1',
      sourceText: 'হ্যালো',
      translatedText: '안녕하세요',
      sourceLanguage: 'bn',
      targetLanguage: 'ko',
      createdAt: DateTime(2024, 1, 1),
    ),
    Translation(
      id: '2',
      sourceText: 'ধন্যবাদ',
      translatedText: 'Thank you',
      sourceLanguage: 'bn',
      targetLanguage: 'en',
      createdAt: DateTime(2024, 1, 2),
    ),
  ];

  setUp(() {
    fakeRepository = FakeHistoryRepository();
  });

  group('GetHistory', () {
    test('should return list of translations', () async {
      fakeRepository.getHistoryResult = (data: tTranslations, failure: null);
      final usecase = GetHistory(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
      expect(result.data, tTranslations);
      expect(result.data?.length, 2);
    });

    test('should return empty list when no history', () async {
      fakeRepository.getHistoryResult = (data: <Translation>[], failure: null);
      final usecase = GetHistory(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
      expect(result.data, isEmpty);
    });
  });

  group('SaveTranslation', () {
    test('should save translation successfully', () async {
      fakeRepository.saveResult = (data: null, failure: null);
      final usecase = SaveTranslation(fakeRepository);

      final result = await usecase(tTranslations.first);

      expect(result.isSuccess, true);
    });
  });

  group('DeleteTranslation', () {
    test('should delete translation successfully', () async {
      fakeRepository.deleteResult = (data: null, failure: null);
      final usecase = DeleteTranslation(fakeRepository);

      final result = await usecase('1');

      expect(result.isSuccess, true);
    });
  });

  group('ClearHistory', () {
    test('should clear all history', () async {
      fakeRepository.clearResult = (data: null, failure: null);
      final usecase = ClearHistory(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
    });
  });

  group('SearchHistory', () {
    test('should return matching translations', () async {
      fakeRepository.searchResult = (
        data: [tTranslations.first],
        failure: null,
      );
      final usecase = SearchHistory(fakeRepository);

      final result = await usecase('হ্যালো');

      expect(result.isSuccess, true);
      expect(result.data?.length, 1);
    });
  });
}
