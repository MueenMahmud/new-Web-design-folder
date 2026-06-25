import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/typedef.dart';
import '../../../domain/usecases/history_usecases.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetHistory getHistory;
  final DeleteTranslation deleteTranslation;
  final ClearHistory clearHistory;
  final SearchHistory searchHistory;

  HistoryBloc({
    required this.getHistory,
    required this.deleteTranslation,
    required this.clearHistory,
    required this.searchHistory,
  }) : super(const HistoryState()) {
    on<LoadHistory>(_onLoad);
    on<DeleteHistoryItem>(_onDelete);
    on<ClearAllHistory>(_onClear);
    on<SearchHistoryItems>(_onSearch);
  }

  Future<void> _onLoad(
    LoadHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    final result = await getHistory();
    result.fold(
      onSuccess: (translations) {
        emit(state.copyWith(
          status: HistoryStatus.loaded,
          translations: translations,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: HistoryStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onDelete(
    DeleteHistoryItem event,
    Emitter<HistoryState> emit,
  ) async {
    await deleteTranslation(event.id);
    add(const LoadHistory());
  }

  Future<void> _onClear(
    ClearAllHistory event,
    Emitter<HistoryState> emit,
  ) async {
    await clearHistory();
    emit(state.copyWith(
      status: HistoryStatus.loaded,
      translations: [],
    ));
  }

  Future<void> _onSearch(
    SearchHistoryItems event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    final result = await searchHistory(event.query);
    result.fold(
      onSuccess: (translations) {
        emit(state.copyWith(
          status: HistoryStatus.loaded,
          translations: translations,
        ));
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: HistoryStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }
}
