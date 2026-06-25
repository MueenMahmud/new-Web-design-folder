import 'package:equatable/equatable.dart';

import '../../../domain/entities/translation.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesEvent {
  const LoadFavorites();
}

class AddToFavorites extends FavoritesEvent {
  final Translation translation;

  const AddToFavorites({required this.translation});

  @override
  List<Object?> get props => [translation];
}

class RemoveFromFavorites extends FavoritesEvent {
  final String id;

  const RemoveFromFavorites({required this.id});

  @override
  List<Object?> get props => [id];
}
