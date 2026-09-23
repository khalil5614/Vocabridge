import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

const Map<Tone, IconData> toneIcons = {
  Tone.neutral: Icons.remove_red_eye_outlined,
  Tone.happy: Icons.sentiment_satisfied_alt_rounded,
  Tone.urgent: Icons.priority_high_rounded,
  Tone.sad: Icons.sentiment_dissatisfied_rounded,
  Tone.question: Icons.help_outline_rounded,
  Tone.angry: Icons.mood_bad_rounded,
};

String toneLabel(AppLocalizations l10n, Tone tone) => switch (tone) {
      Tone.neutral => l10n.toneNeutral,
      Tone.happy => l10n.toneHappy,
      Tone.urgent => l10n.toneUrgent,
      Tone.sad => l10n.toneSad,
      Tone.question => l10n.toneQuestion,
      Tone.angry => l10n.toneAngry,
    };

/// Lets the user pick the emotional tone of what they're about to say,
/// so the TTS output isn't flat/robotic for every kind of message. Each
/// tone keeps a consistent semantic color (see [ToneColors]) so it stays
/// recognizable wherever it shows up (here, and on message bubbles).
class ToneSelector extends StatelessWidget {
  final Tone selected;
  final void Function(Tone) onChanged;

  const ToneSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Tone.values.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tone = Tone.values[index];
          final isSelected = tone == selected;
          final color = ToneColors.of(tone);
          return ChoiceChip(
            avatar: Icon(
              toneIcons[tone],
              size: 18,
              color: isSelected ? color : color.withValues(alpha: 0.7),
            ),
            label: Text(toneLabel(l10n, tone)),
            selected: isSelected,
            onSelected: (_) => onChanged(tone),
            selectedColor: color.withValues(alpha: 0.16),
            side: BorderSide(
              color: isSelected ? color : Theme.of(context).colorScheme.outlineVariant,
            ),
            labelStyle: TextStyle(
              color: isSelected ? color : null,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          );
        },
      ),
    );
  }
}
