import '../../domain/entities/translation.dart';

class TranslationModel extends Translation {
  const TranslationModel({
    required super.id,
    required super.sourceText,
    required super.translatedText,
    required super.sourceLanguage,
    required super.targetLanguage,
    super.audioPath,
    super.ttsAudioPath,
    required super.createdAt,
    super.isFavorite,
    super.userId,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      id: json['id'] as String,
      sourceText: json['sourceText'] as String,
      translatedText: json['translatedText'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      audioPath: json['audioPath'] as String?,
      ttsAudioPath: json['ttsAudioPath'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceText': sourceText,
      'translatedText': translatedText,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'audioPath': audioPath,
      'ttsAudioPath': ttsAudioPath,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'userId': userId,
    };
  }

  factory TranslationModel.fromEntity(Translation entity) {
    return TranslationModel(
      id: entity.id,
      sourceText: entity.sourceText,
      translatedText: entity.translatedText,
      sourceLanguage: entity.sourceLanguage,
      targetLanguage: entity.targetLanguage,
      audioPath: entity.audioPath,
      ttsAudioPath: entity.ttsAudioPath,
      createdAt: entity.createdAt,
      isFavorite: entity.isFavorite,
      userId: entity.userId,
    );
  }
}
