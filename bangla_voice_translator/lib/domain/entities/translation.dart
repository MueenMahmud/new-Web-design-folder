import 'package:equatable/equatable.dart';

enum TargetLanguage { korean, english }

class Translation extends Equatable {
  final String id;
  final String sourceText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final String? audioPath;
  final String? ttsAudioPath;
  final DateTime createdAt;
  final bool isFavorite;
  final String? userId;

  const Translation({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    this.audioPath,
    this.ttsAudioPath,
    required this.createdAt,
    this.isFavorite = false,
    this.userId,
  });

  Translation copyWith({
    String? id,
    String? sourceText,
    String? translatedText,
    String? sourceLanguage,
    String? targetLanguage,
    String? audioPath,
    String? ttsAudioPath,
    DateTime? createdAt,
    bool? isFavorite,
    String? userId,
  }) {
    return Translation(
      id: id ?? this.id,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      audioPath: audioPath ?? this.audioPath,
      ttsAudioPath: ttsAudioPath ?? this.ttsAudioPath,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        sourceText,
        translatedText,
        sourceLanguage,
        targetLanguage,
        audioPath,
        ttsAudioPath,
        createdAt,
        isFavorite,
        userId,
      ];
}
