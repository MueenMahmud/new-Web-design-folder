import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/domain/entities/translation.dart';
import 'package:bangla_voice_translator/presentation/widgets/translation_list_tile.dart';

void main() {
  final tTranslation = Translation(
    id: 'test-id',
    sourceText: 'হ্যালো',
    translatedText: 'Hello',
    sourceLanguage: 'bn',
    targetLanguage: 'en',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
  );

  group('TranslationListTile', () {
    testWidgets('should display source and translated text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TranslationListTile(
              translation: tTranslation,
            ),
          ),
        ),
      );

      expect(find.text('হ্যালো'), findsOneWidget);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('should show language flags', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TranslationListTile(
              translation: tTranslation,
            ),
          ),
        ),
      );

      expect(find.textContaining('BN'), findsOneWidget);
      expect(find.textContaining('EN'), findsOneWidget);
    });

    testWidgets('should show copy button when callback provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TranslationListTile(
              translation: tTranslation,
              onCopy: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.copy), findsOneWidget);
    });

    testWidgets('should show favorite icon when callback provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TranslationListTile(
              translation: tTranslation,
              onFavorite: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('should show filled favorite when isFavorite is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TranslationListTile(
              translation: tTranslation,
              isFavorite: true,
              onFavorite: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}
