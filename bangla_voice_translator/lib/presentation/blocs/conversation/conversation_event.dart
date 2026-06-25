import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

class StartConversation extends ConversationEvent {
  const StartConversation();
}

class StartUserRecording extends ConversationEvent {
  const StartUserRecording();
}

class StopUserRecording extends ConversationEvent {
  const StopUserRecording();
}

class StartPartnerRecording extends ConversationEvent {
  const StartPartnerRecording();
}

class StopPartnerRecording extends ConversationEvent {
  const StopPartnerRecording();
}

class ClearConversation extends ConversationEvent {
  const ClearConversation();
}

class PlayMessageAudio extends ConversationEvent {
  final String audioPath;

  const PlayMessageAudio({required this.audioPath});

  @override
  List<Object?> get props => [audioPath];
}
