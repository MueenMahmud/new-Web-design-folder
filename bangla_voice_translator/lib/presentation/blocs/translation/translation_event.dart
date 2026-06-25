import 'package:equatable/equatable.dart';

import '../../../domain/entities/translation.dart';

abstract class TranslationEvent extends Equatable {
  const TranslationEvent();

  @override
  List<Object?> get props => [];
}

class StartRecording extends TranslationEvent {
  const StartRecording();
}

class StopRecording extends TranslationEvent {
  const StopRecording();
}

class TranslateRecording extends TranslationEvent {
  final TargetLanguage targetLanguage;

  const TranslateRecording({required this.targetLanguage});

  @override
  List<Object?> get props => [targetLanguage];
}

class PlayTranslationAudio extends TranslationEvent {
  final String audioPath;

  const PlayTranslationAudio({required this.audioPath});

  @override
  List<Object?> get props => [audioPath];
}

class StopAudioPlayback extends TranslationEvent {
  const StopAudioPlayback();
}

class ResetTranslation extends TranslationEvent {
  const ResetTranslation();
}

class ChangeTargetLanguage extends TranslationEvent {
  final TargetLanguage targetLanguage;

  const ChangeTargetLanguage({required this.targetLanguage});

  @override
  List<Object?> get props => [targetLanguage];
}

class RetryTranslation extends TranslationEvent {
  const RetryTranslation();
}
