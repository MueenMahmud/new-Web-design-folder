import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/core/errors/failures.dart';
import 'package:bangla_voice_translator/core/utils/typedef.dart';
import 'package:bangla_voice_translator/domain/entities/translation.dart';
import 'package:bangla_voice_translator/domain/repositories/favorites_repository.dart';
import 'package:bangla_voice_translator/domain/usecases/favorites_usecases.dart';

class FakeFavoritesRepository implements FavoritesRepository {
  ({List<Translation>? data, Failure? failure})? getFavoritesResult;
  ({void data, Failure? failure})? addResult;
  ({void data, Failure? failure})? removeResult;
  ({bool? data, Failure? failure})? isFavoriteResult;
  ({void data, Failure? failure})? syncResult;

  @override
  ResultFuture<List<Translation>> getFavorites() async {
    return getFavoritesResult!;
  }

  @override
  ResultFuture<void> addFavorite(Translation translation) async {
    return addResult!;
  }

  @override
  ResultFuture<void> removeFavorite(String id) async {
    return removeResult!;
  }

  @override
  ResultFuture<bool> isFavorite(String id) async {
    return isFavoriteResult!;
  }

  @override
  ResultFuture<void> syncWithCloud(String userId) async {
    return syncResult!;
  }
}

void main() {
  late FakeFavoritesRepository fakeRepository;

  final tFavorites = [
    Translation(
      id: '1',
      sourceText: 'হ্যালো',
      translatedText: '안녕하세요',
      sourceLanguage: 'bn',
      targetLanguage: 'ko',
      createdAt: DateTime(2024, 1, 1),
      isFavorite: true,
    ),
  ];

  setUp(() {
    fakeRepository = FakeFavoritesRepository();
  });

  group('GetFavorites', () {
    test('should return list of favorite translations', () async {
      fakeRepository.getFavoritesResult = (data: tFavorites, failure: null);
      final usecase = GetFavorites(fakeRepository);

      final result = await usecase();

      expect(result.isSuccess, true);
      expect(result.data, tFavorites);
      expect(result.data?.first.isFavorite, true);
    });
  });

  group('AddFavorite', () {
    test('should add favorite successfully', () async {
      fakeRepository.addResult = (data: null, failure: null);
      final usecase = AddFavorite(fakeRepository);

      final result = await usecase(tFavorites.first);

      expect(result.isSuccess, true);
    });
  });

  group('RemoveFavorite', () {
    test('should remove favorite successfully', () async {
      fakeRepository.removeResult = (data: null, failure: null);
      final usecase = RemoveFavorite(fakeRepository);

      final result = await usecase('1');

      expect(result.isSuccess, true);
    });
  });

  group('IsFavorite', () {
    test('should return true for favorited translation', () async {
      fakeRepository.isFavoriteResult = (data: true, failure: null);
      final usecase = IsFavorite(fakeRepository);

      final result = await usecase('1');

      expect(result.isSuccess, true);
      expect(result.data, true);
    });

    test('should return false for non-favorited translation', () async {
      fakeRepository.isFavoriteResult = (data: false, failure: null);
      final usecase = IsFavorite(fakeRepository);

      final result = await usecase('2');

      expect(result.isSuccess, true);
      expect(result.data, false);
    });
  });
}
