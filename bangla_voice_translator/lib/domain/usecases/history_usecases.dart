import '../entities/translation.dart';
import '../repositories/history_repository.dart';
import '../../core/utils/typedef.dart';

class GetHistory {
  final HistoryRepository repository;

  const GetHistory(this.repository);

  ResultFuture<List<Translation>> call({int? limit, int? offset}) {
    return repository.getHistory(limit: limit, offset: offset);
  }
}

class SaveTranslation {
  final HistoryRepository repository;

  const SaveTranslation(this.repository);

  ResultFuture<void> call(Translation translation) {
    return repository.saveTranslation(translation);
  }
}

class DeleteTranslation {
  final HistoryRepository repository;

  const DeleteTranslation(this.repository);

  ResultFuture<void> call(String id) {
    return repository.deleteTranslation(id);
  }
}

class ClearHistory {
  final HistoryRepository repository;

  const ClearHistory(this.repository);

  ResultFuture<void> call() {
    return repository.clearHistory();
  }
}

class SearchHistory {
  final HistoryRepository repository;

  const SearchHistory(this.repository);

  ResultFuture<List<Translation>> call(String query) {
    return repository.searchHistory(query);
  }
}
