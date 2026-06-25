import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/typedef.dart';
import '../../../domain/usecases/favorites_usecases.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
  }) : super(const FavoritesState()) {
    on<LoadFavorites>(_onLoad);
    on<AddToFavorites>(_onAdd);
    on<RemoveFromFavorites>(_onRemove);
  }

  Future<void> _onLoad(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    final result = await getFavorites();
    result.fold(
      onSuccess: (favorites) {
        emit(state.copyWith(
          status: FavoritesStatus.loaded,
          favorites: favorites,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onAdd(
    AddToFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    await addFavorite(event.translation);
    add(const LoadFavorites());
  }

  Future<void> _onRemove(
    RemoveFromFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    await removeFavorite(event.id);
    add(const LoadFavorites());
  }
}
