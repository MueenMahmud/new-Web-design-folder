import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bangla_voice_translator/presentation/widgets/recording_button.dart';

void main() {
  group('RecordingButton', () {
    testWidgets('should show mic icon when not recording',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: false,
              isProcessing: false,
              onStartRecording: () {},
              onStopRecording: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(find.byIcon(Icons.stop), findsNothing);
    });

    testWidgets('should show stop icon when recording',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: true,
              isProcessing: false,
              onStartRecording: () {},
              onStopRecording: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.stop), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsNothing);
    });

    testWidgets('should show progress indicator when processing',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: false,
              isProcessing: true,
              onStartRecording: () {},
              onStopRecording: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should call onStartRecording when tapped while not recording',
        (WidgetTester tester) async {
      var wasStarted = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: false,
              isProcessing: false,
              onStartRecording: () => wasStarted = true,
              onStopRecording: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(wasStarted, true);
    });

    testWidgets('should call onStopRecording when tapped while recording',
        (WidgetTester tester) async {
      var wasStopped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecordingButton(
              isRecording: true,
              isProcessing: false,
              onStartRecording: () {},
              onStopRecording: () => wasStopped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(wasStopped, true);
    });
  });
}
