import '../entities/translation.dart';
import '../repositories/favorites_repository.dart';
import '../../core/utils/typedef.dart';

class GetFavorites {
  final FavoritesRepository repository;

  const GetFavorites(this.repository);

  ResultFuture<List<Translation>> call() {
    return repository.getFavorites();
  }
}

class AddFavorite {
  final FavoritesRepository repository;

  const AddFavorite(this.repository);

  ResultFuture<void> call(Translation translation) {
    return repository.addFavorite(translation);
  }
}

class RemoveFavorite {
  final FavoritesRepository repository;

  const RemoveFavorite(this.repository);

  ResultFuture<void> call(String id) {
    return repository.removeFavorite(id);
  }
}

class IsFavorite {
  final FavoritesRepository repository;

  const IsFavorite(this.repository);

  ResultFuture<bool> call(String id) {
    return repository.isFavorite(id);
  }
}
