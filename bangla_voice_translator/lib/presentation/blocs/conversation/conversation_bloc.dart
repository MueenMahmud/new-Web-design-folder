import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/audio_helper.dart';
import '../../../core/utils/typedef.dart';
import '../../../domain/entities/conversation_message.dart';
import '../../../domain/usecases/transcribe_audio.dart';
import '../../../domain/usecases/translate_text.dart';
import '../../../domain/usecases/generate_speech.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final TranscribeAudio transcribeAudio;
  final TranslateText translateText;
  final GenerateSpeech generateSpeech;
  final AudioRecorder _recorder;
  final AudioPlayer _player;
  static const _uuid = Uuid();

  String? _currentRecordingPath;

  ConversationBloc({
    required this.transcribeAudio,
    required this.translateText,
    required this.generateSpeech,
  })  : _recorder = AudioRecorder(),
        _player = AudioPlayer(),
        super(const ConversationState()) {
    on<StartConversation>(_onStart);
    on<StartUserRecording>(_onStartUserRecording);
    on<StopUserRecording>(_onStopUserRecording);
    on<StartPartnerRecording>(_onStartPartnerRecording);
    on<StopPartnerRecording>(_onStopPartnerRecording);
    on<ClearConversation>(_onClear);
    on<PlayMessageAudio>(_onPlayAudio);
  }

  void _onStart(
    StartConversation event,
    Emitter<ConversationState> emit,
  ) {
    emit(state.copyWith(
      status: ConversationStatus.ready,
      messages: [],
    ));
  }

  Future<void> _onStartUserRecording(
    StartUserRecording event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      if (await _recorder.hasPermission()) {
        _currentRecordingPath = await AudioHelper.getRecordingPath();
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000,
            numChannels: 1,
          ),
          path: _currentRecordingPath!,
        );
        emit(state.copyWith(status: ConversationStatus.recordingUser));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ConversationStatus.error,
        errorMessage: 'Recording failed: $e',
      ));
    }
  }

  Future<void> _onStopUserRecording(
    StopUserRecording event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      final path = await _recorder.stop();
      if (path == null) return;

      emit(state.copyWith(status: ConversationStatus.processing));

      await _processRecording(
        path: path,
        speaker: MessageSpeaker.user,
        sourceLanguage: state.userLanguage,
        targetLanguage: state.partnerLanguage,
        emit: emit,
      );
    } catch (e) {
      emit(state.copyWith(
        status: ConversationStatus.error,
        errorMessage: 'Processing failed: $e',
      ));
    }
  }

  Future<void> _onStartPartnerRecording(
    StartPartnerRecording event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      if (await _recorder.hasPermission()) {
        _currentRecordingPath = await AudioHelper.getRecordingPath();
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            sampleRate: 16000,
            numChannels: 1,
          ),
          path: _currentRecordingPath!,
        );
        emit(state.copyWith(status: ConversationStatus.recordingPartner));
      }
    } catch (e) {
      emit(state.copyWith(
        status: ConversationStatus.error,
        errorMessage: 'Recording failed: $e',
      ));
    }
  }

  Future<void> _onStopPartnerRecording(
    StopPartnerRecording event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      final path = await _recorder.stop();
      if (path == null) return;

      emit(state.copyWith(status: ConversationStatus.processing));

      await _processRecording(
        path: path,
        speaker: MessageSpeaker.partner,
        sourceLanguage: state.partnerLanguage,
        targetLanguage: state.userLanguage,
        emit: emit,
      );
    } catch (e) {
      emit(state.copyWith(
        status: ConversationStatus.error,
        errorMessage: 'Processing failed: $e',
      ));
    }
  }

  Future<void> _processRecording({
    required String path,
    required MessageSpeaker speaker,
    required String sourceLanguage,
    required String targetLanguage,
    required Emitter<ConversationState> emit,
  }) async {
    final transcribeResult = await transcribeAudio(path);
    if (transcribeResult.isFailure) {
      emit(state.copyWith(
        status: ConversationStatus.error,
        errorMessage: transcribeResult.failure!.message,
      ));
      return;
    }

    final originalText = transcribeResult.data!;

    final translateResult = await translateText(
      text: originalText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
    if (translateResult.isFailure) {
      emit(state.copyWith(
        status: ConversationStatus.error,
        errorMessage: translateResult.failure!.message,
      ));
      return;
    }

    final translatedText = translateResult.data!;

    final speechResult = await generateSpeech(
      text: translatedText,
      language: targetLanguage,
    );

    final audioPath = speechResult.data;

    final message = ConversationMessage(
      id: _uuid.v4(),
      originalText: originalText,
      translatedText: translatedText,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      speaker: speaker,
      audioPath: audioPath,
      timestamp: DateTime.now(),
    );

    final updatedMessages = [...state.messages, message];
    emit(state.copyWith(
      status: ConversationStatus.ready,
      messages: updatedMessages,
    ));

    // Auto-play the translated audio
    if (audioPath != null) {
      try {
        await _player.setFilePath(audioPath);
        await _player.play();
      } catch (_) {
        // Ignore playback errors in conversation mode
      }
    }
  }

  void _onClear(
    ClearConversation event,
    Emitter<ConversationState> emit,
  ) {
    emit(const ConversationState(status: ConversationStatus.ready));
  }

  Future<void> _onPlayAudio(
    PlayMessageAudio event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      await _player.setFilePath(event.audioPath);
      await _player.play();
    } catch (_) {
      // Ignore playback errors
    }
  }

  @override
  Future<void> close() {
    _recorder.dispose();
    _player.dispose();
    return super.close();
  }
}
