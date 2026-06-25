import 'package:equatable/equatable.dart';

import '../../../domain/entities/conversation_message.dart';

enum ConversationStatus {
  initial,
  ready,
  recordingUser,
  recordingPartner,
  processing,
  error,
}

class ConversationState extends Equatable {
  final ConversationStatus status;
  final List<ConversationMessage> messages;
  final String? errorMessage;
  final String userLanguage;
  final String partnerLanguage;

  const ConversationState({
    this.status = ConversationStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.userLanguage = 'bn',
    this.partnerLanguage = 'ko',
  });

  ConversationState copyWith({
    ConversationStatus? status,
    List<ConversationMessage>? messages,
    String? errorMessage,
    String? userLanguage,
    String? partnerLanguage,
  }) {
    return ConversationState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
      userLanguage: userLanguage ?? this.userLanguage,
      partnerLanguage: partnerLanguage ?? this.partnerLanguage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        errorMessage,
        userLanguage,
        partnerLanguage,
      ];
}
