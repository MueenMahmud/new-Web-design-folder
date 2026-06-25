import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/typedef.dart';
import '../../domain/entities/translation.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/local/local_storage_source.dart';
import '../datasources/remote/firebase_remote_source.dart';
import '../models/translation_model.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final LocalStorageSource localSource;
  final FirebaseRemoteSource remoteSource;

  HistoryRepositoryImpl({
    required this.localSource,
    required this.remoteSource,
  });

  @override
  ResultFuture<List<Translation>> getHistory({int? limit, int? offset}) async {
    try {
      final history = await localSource.getHistory();
      final start = offset ?? 0;
      final end = limit != null ? start + limit : history.length;
      final safeEnd = end > history.length ? history.length : end;
      return (
        data: history.sublist(start, safeEnd).cast<Translation>(),
        failure: null
      );
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> saveTranslation(Translation translation) async {
    try {
      final model = TranslationModel.fromEntity(translation);
      await localSource.saveToHistory(model);
      return (data: null, failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> deleteTranslation(String id) async {
    try {
      await localSource.deleteFromHistory(id);
      return (data: null, failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> clearHistory() async {
    try {
      await localSource.clearHistory();
      return (data: null, failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<List<Translation>> searchHistory(String query) async {
    try {
      final history = await localSource.getHistory();
      final lowerQuery = query.toLowerCase();
      final results = history
          .where((t) =>
              t.sourceText.toLowerCase().contains(lowerQuery) ||
              t.translatedText.toLowerCase().contains(lowerQuery))
          .toList()
          .cast<Translation>();
      return (data: results, failure: null);
    } on CacheException catch (e) {
      return (data: null, failure: CacheFailure(message: e.message));
    }
  }

  @override
  ResultFuture<void> syncWithCloud(String userId) async {
    try {
      final localHistory = await localSource.getHistory();
      for (final item in localHistory) {
        await remoteSource.saveTranslation(item);
      }

      final cloudHistory = await remoteSource.getTranslations(userId);
      for (final item in cloudHistory) {
        final exists = localHistory.any((t) => t.id == item.id);
        if (!exists) {
          await localSource.saveToHistory(item);
        }
      }
      return (data: null, failure: null);
    } catch (e) {
      return (data: null, failure: ServerFailure(message: 'Sync failed: $e'));
    }
  }
}
