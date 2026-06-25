import 'package:flutter/material.dart';

class RecordingButton extends StatelessWidget {
  final bool isRecording;
  final bool isProcessing;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const RecordingButton({
    super.key,
    required this.isRecording,
    required this.isProcessing,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isProcessing
          ? null
          : (isRecording ? onStopRecording : onStartRecording),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isRecording ? 100 : 80,
        height: isRecording ? 100 : 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isProcessing
              ? colorScheme.surfaceContainerHighest
              : (isRecording
                  ? colorScheme.error
                  : colorScheme.primary),
          boxShadow: [
            BoxShadow(
              color: (isRecording
                      ? colorScheme.error
                      : colorScheme.primary)
                  .withValues(alpha: isRecording ? 0.4 : 0.3),
              blurRadius: isRecording ? 30 : 15,
              spreadRadius: isRecording ? 5 : 0,
            ),
          ],
        ),
        child: isProcessing
            ? const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              )
            : Icon(
                isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: isRecording ? 48 : 36,
              ),
      ),
    );
  }
}
