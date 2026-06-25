import 'package:equatable/equatable.dart';

import '../../../domain/entities/translation.dart';

enum HistoryStatus { initial, loading, loaded, error }

class HistoryState extends Equatable {
  final HistoryStatus status;
  final List<Translation> translations;
  final String? errorMessage;

  const HistoryState({
    this.status = HistoryStatus.initial,
    this.translations = const [],
    this.errorMessage,
  });

  HistoryState copyWith({
    HistoryStatus? status,
    List<Translation>? translations,
    String? errorMessage,
  }) {
    return HistoryState(
      status: status ?? this.status,
      translations: translations ?? this.translations,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, translations, errorMessage];
}
