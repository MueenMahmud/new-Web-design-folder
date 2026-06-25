import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';

import '../../../core/utils/audio_helper.dart';
import '../../../core/utils/typedef.dart';
import '../../../domain/usecases/translate_voice.dart';
import '../../../domain/usecases/history_usecases.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final TranslateVoice translateVoice;
  final SaveTranslation saveTranslation;
  final AudioRecorder _recorder;
  final AudioPlayer _player;

  TranslationBloc({
    required this.translateVoice,
    required this.saveTranslation,
  })  : _recorder = AudioRecorder(),
        _player = AudioPlayer(),
        super(const TranslationState()) {
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<TranslateRecording>(_onTranslateRecording);
    on<PlayTranslationAudio>(_onPlayAudio);
    on<StopAudioPlayback>(_onStopAudio);
    on<ResetTranslation>(_onReset);
    on<ChangeTargetLanguage>(_onChangeLanguage);
    on<RetryTranslation>(_onRetry);
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<TranslationState> emit,
  ) async {
    try {
      if (await _recorder.hasPermission()) {
        final path = await AudioHelper.getRecordingPath();
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000,
            numChannels: 1,
          ),
          path: path,
        );
        emit(state.copyWith(
          status: TranslationStatus.recording,
          recordingPath: path,
        ));
      } else {
        emit(state.copyWith(
          status: TranslationStatus.error,
          errorMessage: 'Microphone permission denied',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TranslationStatus.error,
        errorMessage: 'Failed to start recording: $e',
      ));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<TranslationState> emit,
  ) async {
    try {
      final path = await _recorder.stop();
      if (path != null) {
        emit(state.copyWith(
          status: TranslationStatus.transcribing,
          recordingPath: path,
        ));
        add(TranslateRecording(targetLanguage: state.targetLanguage));
      }
    } catch (e) {
      emit(state.copyWith(
        status: TranslationStatus.error,
        errorMessage: 'Failed to stop recording: $e',
      ));
    }
  }

  Future<void> _onTranslateRecording(
    TranslateRecording event,
    Emitter<TranslationState> emit,
  ) async {
    final recordingPath = state.recordingPath;
    if (recordingPath == null) {
      emit(state.copyWith(
        status: TranslationStatus.error,
        errorMessage: 'No recording found',
      ));
      return;
    }

    emit(state.copyWith(status: TranslationStatus.translating));

    final result = await translateVoice(
      audioPath: recordingPath,
      targetLanguage: event.targetLanguage,
    );

    result.fold(
      onSuccess: (translation) {
        emit(state.copyWith(
          status: TranslationStatus.completed,
          translation: translation,
        ));
        saveTranslation(translation);
      },
      onFailure: (failure) {
        emit(state.copyWith(
          status: TranslationStatus.error,
          errorMessage: failure.message,
        ));
      },
    );
  }

  Future<void> _onPlayAudio(
    PlayTranslationAudio event,
    Emitter<TranslationState> emit,
  ) async {
    try {
      await _player.setFilePath(event.audioPath);
      emit(state.copyWith(isPlaying: true, status: TranslationStatus.playing));
      await _player.play();
      emit(state.copyWith(isPlaying: false, status: TranslationStatus.completed));
    } catch (e) {
      emit(state.copyWith(
        isPlaying: false,
        status: TranslationStatus.error,
        errorMessage: 'Playback failed: $e',
      ));
    }
  }

  Future<void> _onStopAudio(
    StopAudioPlayback event,
    Emitter<TranslationState> emit,
  ) async {
    await _player.stop();
    emit(state.copyWith(
        isPlaying: false, status: TranslationStatus.completed));
  }

  void _onReset(
    ResetTranslation event,
    Emitter<TranslationState> emit,
  ) {
    emit(const TranslationState());
  }

  void _onChangeLanguage(
    ChangeTargetLanguage event,
    Emitter<TranslationState> emit,
  ) {
    emit(state.copyWith(targetLanguage: event.targetLanguage));
  }

  Future<void> _onRetry(
    RetryTranslation event,
    Emitter<TranslationState> emit,
  ) async {
    if (state.recordingPath != null) {
      add(TranslateRecording(targetLanguage: state.targetLanguage));
    }
  }

  @override
  Future<void> close() {
    _recorder.dispose();
    _player.dispose();
    return super.close();
  }
}
