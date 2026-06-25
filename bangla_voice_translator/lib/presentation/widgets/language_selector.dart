import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/translation.dart';
import '../blocs/translation/translation_bloc.dart';
import '../blocs/translation/translation_event.dart';
import '../blocs/translation/translation_state.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<TranslationBloc, TranslationState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('From'),
                      const SizedBox(height: 4),
                      Chip(
                        label: const Text('Bangla'),
                        avatar: const Text('🇧🇩'),
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: colorScheme.primary,
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('To'),
                      const SizedBox(height: 4),
                      SegmentedButton<TargetLanguage>(
                        segments: const [
                          ButtonSegment(
                            value: TargetLanguage.korean,
                            label: Text('🇰🇷 KO'),
                          ),
                          ButtonSegment(
                            value: TargetLanguage.english,
                            label: Text('🇬🇧 EN'),
                          ),
                        ],
                        selected: {state.targetLanguage},
                        onSelectionChanged: (selected) {
                          context.read<TranslationBloc>().add(
                                ChangeTargetLanguage(
                                    targetLanguage: selected.first),
                              );
                        },
                        showSelectedIcon: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
