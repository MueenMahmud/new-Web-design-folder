import '../entities/translation.dart';
import '../../core/utils/typedef.dart';

abstract class FavoritesRepository {
  ResultFuture<List<Translation>> getFavorites();

  ResultFuture<void> addFavorite(Translation translation);

  ResultFuture<void> removeFavorite(String id);

  ResultFuture<bool> isFavorite(String id);

  ResultFuture<void> syncWithCloud(String userId);
}
