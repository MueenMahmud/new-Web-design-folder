import 'package:equatable/equatable.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}

class DeleteHistoryItem extends HistoryEvent {
  final String id;

  const DeleteHistoryItem({required this.id});

  @override
  List<Object?> get props => [id];
}

class ClearAllHistory extends HistoryEvent {
  const ClearAllHistory();
}

class SearchHistoryItems extends HistoryEvent {
  final String query;

  const SearchHistoryItems({required this.query});

  @override
  List<Object?> get props => [query];
}
