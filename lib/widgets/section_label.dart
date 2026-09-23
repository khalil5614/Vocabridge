import 'package:flutter/material.dart';

/// Small uppercase caption used to label a section of a screen
/// (e.g. "Quick phrases", "Tone") — keeps visual hierarchy consistent
/// across screens instead of every screen inventing its own heading style.
class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
      ),
    );
  }
}
