import 'dart:io';

import 'package:dio/dio.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/audio_helper.dart';

abstract class OpenAiRemoteSource {
  Future<String> transcribeAudio(String audioPath);

  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });

  Future<String> generateSpeech({
    required String text,
    required String voice,
  });
}

class OpenAiRemoteSourceImpl implements OpenAiRemoteSource {
  final ApiClient apiClient;

  OpenAiRemoteSourceImpl({required this.apiClient});

  @override
  Future<String> transcribeAudio(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        throw const AudioException(message: 'Audio file not found');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioPath,
          filename: 'audio.wav',
        ),
        'model': AppConstants.whisperModel,
        'language': AppConstants.bangla,
        'response_format': 'json',
      });

      final response = await apiClient.postFormData<Map<String, dynamic>>(
        AppConstants.whisperEndpoint,
        data: formData,
      );

      return response.data?['text'] as String? ?? '';
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Transcription failed: $e');
    }
  }

  @override
  Future<String> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    try {
      final languageName = _getLanguageName(targetLanguage);
      final sourceLanguageName = _getLanguageName(sourceLanguage);

      final response = await apiClient.post<Map<String, dynamic>>(
        AppConstants.chatEndpoint,
        data: {
          'model': AppConstants.gptModel,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a professional translator. Translate the following '
                      '$sourceLanguageName text to $languageName. '
                      'Only output the translation, nothing else.',
            },
            {
              'role': 'user',
              'content': text,
            },
          ],
          'temperature': 0.3,
          'max_tokens': 1000,
        },
      );

      final choices = response.data?['choices'] as List<dynamic>?;
      if (choices == null || choices.isEmpty) {
        throw const ServerException(message: 'No translation received');
      }

      final message = choices[0]['message'] as Map<String, dynamic>;
      return message['content'] as String? ?? '';
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Translation failed: $e');
    }
  }

  @override
  Future<String> generateSpeech({
    required String text,
    required String voice,
  }) async {
    try {
      final response = await apiClient.downloadBytes(
        AppConstants.ttsEndpoint,
        data: {
          'model': AppConstants.ttsModel,
          'input': text,
          'voice': voice,
          'response_format': 'mp3',
        },
      );

      final outputPath = await AudioHelper.getTtsOutputPath();
      final file = File(outputPath);
      await file.writeAsBytes(response.data ?? []);

      return outputPath;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Speech generation failed: $e');
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'bn':
        return 'Bengali (Bangla)';
      case 'ko':
        return 'Korean';
      case 'en':
        return 'English';
      default:
        return code;
    }
  }
}
