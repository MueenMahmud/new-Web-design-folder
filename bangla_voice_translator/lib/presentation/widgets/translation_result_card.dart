import 'package:flutter/material.dart';

import '../../domain/entities/translation.dart';

class TranslationResultCard extends StatelessWidget {
  final Translation translation;
  final bool isPlaying;
  final VoidCallback onPlay;
  final VoidCallback onStop;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final VoidCallback onFavorite;

  const TranslationResultCard({
    super.key,
    required this.translation,
    required this.isPlaying,
    required this.onPlay,
    required this.onStop,
    required this.onCopy,
    required this.onShare,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source text
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Bangla',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              translation.sourceText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 24),
            // Translated text
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getLanguageName(translation.targetLanguage),
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              translation.translatedText,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: isPlaying ? Icons.stop : Icons.play_arrow,
                  label: isPlaying ? 'Stop' : 'Play',
                  onTap: isPlaying ? onStop : onPlay,
                  color: colorScheme.primary,
                ),
                _ActionButton(
                  icon: Icons.copy,
                  label: 'Copy',
                  onTap: onCopy,
                  color: colorScheme.tertiary,
                ),
                _ActionButton(
                  icon: Icons.share,
                  label: 'Share',
                  onTap: onShare,
                  color: colorScheme.secondary,
                ),
                _ActionButton(
                  icon: Icons.favorite_border,
                  label: 'Save',
                  onTap: onFavorite,
                  color: colorScheme.error,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'ko':
        return 'Korean';
      case 'en':
        return 'English';
      default:
        return code;
    }
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
