import 'package:equatable/equatable.dart';

import '../../../domain/entities/translation.dart';

enum TranslationStatus {
  initial,
  recording,
  transcribing,
  translating,
  generatingAudio,
  completed,
  playing,
  error,
}

class TranslationState extends Equatable {
  final TranslationStatus status;
  final Translation? translation;
  final TargetLanguage targetLanguage;
  final String? recordingPath;
  final String? errorMessage;
  final bool isPlaying;

  const TranslationState({
    this.status = TranslationStatus.initial,
    this.translation,
    this.targetLanguage = TargetLanguage.korean,
    this.recordingPath,
    this.errorMessage,
    this.isPlaying = false,
  });

  TranslationState copyWith({
    TranslationStatus? status,
    Translation? translation,
    TargetLanguage? targetLanguage,
    String? recordingPath,
    String? errorMessage,
    bool? isPlaying,
  }) {
    return TranslationState(
      status: status ?? this.status,
      translation: translation ?? this.translation,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      recordingPath: recordingPath ?? this.recordingPath,
      errorMessage: errorMessage ?? this.errorMessage,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [
        status,
        translation,
        targetLanguage,
        recordingPath,
        errorMessage,
        isPlaying,
      ];
}
