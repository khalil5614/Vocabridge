import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

/// A horizontal row of one-tap phrases, always visible so the user
/// doesn't have to type or navigate for the most common things they say.
class QuickPhrasesBar extends StatelessWidget {
  final List<Phrase> phrases;
  final void Function(Phrase phrase) onTap;

  const QuickPhrasesBar({
    super.key,
    required this.phrases,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = CategoryColors.of('quick');

    if (phrases.isEmpty) {
      return Container(
        height: 56,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Text(
          AppLocalizations.of(context)!.noQuickPhrasesYet,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: phrases.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final phrase = phrases[index];
          return Material(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              onTap: () => onTap(phrase),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: color.withValues(alpha: 0.35)),
                ),
                child: Text(
                  phrase.text,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
