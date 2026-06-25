import 'package:flutter/material.dart';

import '../../domain/entities/translation.dart';

class TranslationListTile extends StatelessWidget {
  final Translation translation;
  final bool isFavorite;
  final VoidCallback? onCopy;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;

  const TranslationListTile({
    super.key,
    required this.translation,
    this.isFavorite = false,
    this.onCopy,
    this.onFavorite,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: Key(translation.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: colorScheme.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getLanguageFlag(translation.sourceLanguage),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_right_alt, size: 16),
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getLanguageFlag(translation.targetLanguage),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTime(translation.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                translation.sourceText,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                translation.translatedText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onCopy != null)
                    IconButton(
                      icon: const Icon(Icons.copy, size: 18),
                      onPressed: onCopy,
                      tooltip: 'Copy',
                    ),
                  if (onFavorite != null)
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFavorite ? colorScheme.error : null,
                      ),
                      onPressed: onFavorite,
                      tooltip: isFavorite
                          ? 'Remove from favorites'
                          : 'Add to favorites',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLanguageFlag(String code) {
    switch (code) {
      case 'bn':
        return '🇧🇩 BN';
      case 'ko':
        return '🇰🇷 KO';
      case 'en':
        return '🇬🇧 EN';
      default:
        return code;
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
