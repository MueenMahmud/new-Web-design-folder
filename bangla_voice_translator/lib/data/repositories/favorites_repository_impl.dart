import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/typedef.dart';
import '../../domain/entities/translation.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/local/local_storage_source.dart';
import '../datasources/remote/firebase_remote_source.dart';
import '../models/translation_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final LocalStorageSource localSource;
  final FirebaseRemoteSource remoteSource;

  FavoritesRepositoryImpl({
    required this.localSource,
    required this.remoteSource,
  });

  @override
  ResultFuture<List<Translation>> getFavorites() async {
    try {
      final favorites = await localSource.getFavorites();
      return (data: favorites.cast<Translation>(), failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> addFavorite(Translation translation) async {
    try {
      final model = TranslationModel.fromEntity(
        translation.copyWith(isFavorite: true),
      );
      await localSource.addToFavorites(model);
      return (data: null, failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> removeFavorite(String id) async {
    try {
      await localSource.removeFromFavorites(id);
      return (data: null, failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<bool> isFavorite(String id) async {
    try {
      final result = await localSource.isFavorite(id);
      return (data: result, failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> syncWithCloud(String userId) async {
    try {
      final localFavorites = await localSource.getFavorites();
      for (final item in localFavorites) {
        await remoteSource.saveFavorite(userId, item);
      }

      final cloudFavorites = await remoteSource.getFavorites(userId);
      for (final item in cloudFavorites) {
        final exists = localFavorites.any((t) => t.id == item.id);
        if (!exists) {
          await localSource.addToFavorites(item);
        }
      }
      return (data: null, failure: null);
    } catch (e) {
      return (
        data: null,
        failure: ServerFailure(message: 'Sync failed: $e')
      );
    }
  }
}
