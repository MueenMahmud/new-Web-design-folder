import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/conversation_message.dart';
import '../blocs/conversation/conversation_bloc.dart';
import '../blocs/conversation/conversation_event.dart';
import '../blocs/conversation/conversation_state.dart';

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation Mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context
                  .read<ConversationBloc>()
                  .add(const ClearConversation());
            },
          ),
        ],
      ),
      body: BlocBuilder<ConversationBloc, ConversationState>(
        builder: (context, state) {
          if (state.status == ConversationStatus.initial) {
            return _buildStartScreen(context);
          }

          return Column(
            children: [
              // Language indicators
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: colorScheme.surfaceContainerHighest,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.person, size: 18),
                      label: const Text('Bangla'),
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                    Icon(Icons.swap_horiz, color: colorScheme.primary),
                    Chip(
                      avatar: const Icon(Icons.person_outline, size: 18),
                      label: const Text('Korean'),
                      backgroundColor: colorScheme.secondaryContainer,
                    ),
                  ],
                ),
              ),
              // Messages
              Expanded(
                child: state.messages.isEmpty
                    ? Center(
                        child: Text(
                          'Start speaking to begin the conversation',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color:
                                    colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(
                              context, state.messages[index]);
                        },
                      ),
              ),
              // Processing indicator
              if (state.status == ConversationStatus.processing)
                const LinearProgressIndicator(),
              // Recording buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildRecordButton(
                      context: context,
                      label: 'Bangla',
                      isRecording: state.status ==
                          ConversationStatus.recordingUser,
                      isDisabled: state.status ==
                              ConversationStatus.processing ||
                          state.status ==
                              ConversationStatus.recordingPartner,
                      onStart: () => context
                          .read<ConversationBloc>()
                          .add(const StartUserRecording()),
                      onStop: () => context
                          .read<ConversationBloc>()
                          .add(const StopUserRecording()),
                      color: colorScheme.primary,
                    ),
                    _buildRecordButton(
                      context: context,
                      label: 'Korean',
                      isRecording: state.status ==
                          ConversationStatus.recordingPartner,
                      isDisabled: state.status ==
                              ConversationStatus.processing ||
                          state.status ==
                              ConversationStatus.recordingUser,
                      onStart: () => context
                          .read<ConversationBloc>()
                          .add(const StartPartnerRecording()),
                      onStop: () => context
                          .read<ConversationBloc>()
                          .add(const StopPartnerRecording()),
                      color: colorScheme.secondary,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStartScreen(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Real-time Conversation',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Translate conversations between\nBangla and Korean speakers',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              context
                  .read<ConversationBloc>()
                  .add(const StartConversation());
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Conversation'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      BuildContext context, ConversationMessage message) {
    final isUser = message.speaker == MessageSpeaker.user;
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Card(
          color: isUser
              ? colorScheme.primaryContainer
              : colorScheme.secondaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.originalText,
                  style: TextStyle(
                    color: isUser
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(height: 16),
                Text(
                  message.translatedText,
                  style: TextStyle(
                    color: isUser
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSecondaryContainer,
                  ),
                ),
                if (message.audioPath != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      context.read<ConversationBloc>().add(
                            PlayMessageAudio(
                                audioPath: message.audioPath!),
                          );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_fill,
                          size: 20,
                          color: isUser
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Play',
                          style: TextStyle(
                            fontSize: 12,
                            color: isUser
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecordButton({
    required BuildContext context,
    required String label,
    required bool isRecording,
    required bool isDisabled,
    required VoidCallback onStart,
    required VoidCallback onStop,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isDisabled
              ? null
              : (isRecording ? onStop : onStart),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isRecording ? 80 : 64,
            height: isRecording ? 80 : 64,
            decoration: BoxDecoration(
              color: isDisabled
                  ? color.withValues(alpha: 0.3)
                  : (isRecording
                      ? color.withValues(alpha: 0.2)
                      : color),
              shape: BoxShape.circle,
              border: isRecording
                  ? Border.all(color: color, width: 3)
                  : null,
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: isRecording ? color : Colors.white,
              size: isRecording ? 36 : 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ],
    );
  }
}
