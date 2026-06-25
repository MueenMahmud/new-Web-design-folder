import '../entities/translation.dart';
import '../../core/utils/typedef.dart';

abstract class HistoryRepository {
  ResultFuture<List<Translation>> getHistory({int? limit, int? offset});

  ResultFuture<void> saveTranslation(Translation translation);

  ResultFuture<void> deleteTranslation(String id);

  ResultFuture<void> clearHistory();

  ResultFuture<List<Translation>> searchHistory(String query);

  ResultFuture<void> syncWithCloud(String userId);
}
