import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/domain/entities/translation.dart';
import 'package:bangla_voice_translator/presentation/widgets/translation_result_card.dart';

void main() {
  final tTranslation = Translation(
    id: 'test-id',
    sourceText: 'হ্যালো',
    translatedText: 'Hello',
    sourceLanguage: 'bn',
    targetLanguage: 'en',
    createdAt: DateTime(2024, 1, 1),
  );

  group('TranslationResultCard', () {
    testWidgets('should display source and translated text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TranslationResultCard(
                translation: tTranslation,
                isPlaying: false,
                onPlay: () {},
                onStop: () {},
                onCopy: () {},
                onShare: () {},
                onFavorite: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('হ্যালো'), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('should display language labels',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TranslationResultCard(
                translation: tTranslation,
                isPlaying: false,
                onPlay: () {},
                onStop: () {},
                onCopy: () {},
                onShare: () {},
                onFavorite: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Bangla'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
    });

    testWidgets('should show play button when not playing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TranslationResultCard(
                translation: tTranslation,
                isPlaying: false,
                onPlay: () {},
                onStop: () {},
                onCopy: () {},
                onShare: () {},
                onFavorite: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Play'), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('should show stop button when playing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TranslationResultCard(
                translation: tTranslation,
                isPlaying: true,
                onPlay: () {},
                onStop: () {},
                onCopy: () {},
                onShare: () {},
                onFavorite: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Stop'), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsOneWidget);
    });

    testWidgets('should display action buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: TranslationResultCard(
                translation: tTranslation,
                isPlaying: false,
                onPlay: () {},
                onStop: () {},
                onCopy: () {},
                onShare: () {},
                onFavorite: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
