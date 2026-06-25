import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../blocs/translation/translation_bloc.dart';
import '../blocs/translation/translation_event.dart';
import '../blocs/translation/translation_state.dart';
import '../blocs/favorites/favorites_bloc.dart';
import '../blocs/favorites/favorites_event.dart';
import '../widgets/recording_button.dart';
import '../widgets/language_selector.dart';
import '../widgets/translation_result_card.dart';

class VoiceTranslationScreen extends StatelessWidget {
  const VoiceTranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bangla Voice Translator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: BlocBuilder<TranslationBloc, TranslationState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const LanguageSelector(),
                const SizedBox(height: 24),
                _buildStatusIndicator(context, state),
                const SizedBox(height: 32),
                RecordingButton(
                  isRecording: state.status == TranslationStatus.recording,
                  isProcessing:
                      state.status == TranslationStatus.transcribing ||
                          state.status == TranslationStatus.translating ||
                          state.status == TranslationStatus.generatingAudio,
                  onStartRecording: () {
                    context.read<TranslationBloc>().add(const StartRecording());
                  },
                  onStopRecording: () {
                    context.read<TranslationBloc>().add(const StopRecording());
                  },
                ),
                const SizedBox(height: 32),
                if (state.status == TranslationStatus.completed &&
                    state.translation != null)
                  TranslationResultCard(
                    translation: state.translation!,
                    isPlaying: state.isPlaying,
                    onPlay: () {
                      final path = state.translation!.ttsAudioPath;
                      if (path != null) {
                        context.read<TranslationBloc>().add(
                              PlayTranslationAudio(audioPath: path),
                            );
                      }
                    },
                    onStop: () {
                      context
                          .read<TranslationBloc>()
                          .add(const StopAudioPlayback());
                    },
                    onCopy: () {
                      Clipboard.setData(ClipboardData(
                        text: state.translation!.translatedText,
                      ));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                    onShare: () {
                      Share.share(
                        '${state.translation!.sourceText}\n\n'
                        '${state.translation!.translatedText}',
                      );
                    },
                    onFavorite: () {
                      context.read<FavoritesBloc>().add(
                            AddToFavorites(translation: state.translation!),
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to favorites')),
                      );
                    },
                  ),
                if (state.status == TranslationStatus.error)
                  _buildErrorCard(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context, TranslationState state) {
    final colorScheme = Theme.of(context).colorScheme;
    String message;
    IconData icon;

    switch (state.status) {
      case TranslationStatus.initial:
        message = 'Tap the microphone to start';
        icon = Icons.mic_none;
      case TranslationStatus.recording:
        message = 'Listening...';
        icon = Icons.hearing;
      case TranslationStatus.transcribing:
        message = 'Transcribing speech...';
        icon = Icons.text_fields;
      case TranslationStatus.translating:
        message = 'Translating...';
        icon = Icons.translate;
      case TranslationStatus.generatingAudio:
        message = 'Generating voice...';
        icon = Icons.record_voice_over;
      case TranslationStatus.completed:
        message = 'Translation complete';
        icon = Icons.check_circle;
      case TranslationStatus.playing:
        message = 'Playing audio...';
        icon = Icons.volume_up;
      case TranslationStatus.error:
        message = 'Error occurred';
        icon = Icons.error_outline;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (state.status == TranslationStatus.transcribing ||
            state.status == TranslationStatus.translating ||
            state.status == TranslationStatus.generatingAudio)
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          )
        else
          Icon(icon, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
        ),
      ],
    );
  }

  Widget _buildErrorCard(BuildContext context, TranslationState state) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: colorScheme.error, size: 48),
            const SizedBox(height: 8),
            Text(
              state.errorMessage ?? 'An error occurred',
              style: TextStyle(color: colorScheme.onErrorContainer),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: () {
                context.read<TranslationBloc>().add(const RetryTranslation());
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
