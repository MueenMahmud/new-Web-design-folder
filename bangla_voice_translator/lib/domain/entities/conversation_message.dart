import 'package:equatable/equatable.dart';

enum MessageSpeaker { user, partner }

class ConversationMessage extends Equatable {
  final String id;
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final MessageSpeaker speaker;
  final String? audioPath;
  final DateTime timestamp;

  const ConversationMessage({
    required this.id,
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.speaker,
    this.audioPath,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        id,
        originalText,
        translatedText,
        sourceLanguage,
        targetLanguage,
        speaker,
        audioPath,
        timestamp,
      ];
}
