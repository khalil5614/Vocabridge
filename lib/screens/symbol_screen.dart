import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../models/message.dart';
import '../services/tts_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// Maps category to a Material icon as a stand-in for real symbol
/// artwork. Swap these for an actual icon set (e.g., ARASAAC, which is
/// free to use for AAC apps) before shipping — Material icons are a
/// functional placeholder, not final symbol design.
const Map<String, IconData> _categoryIcons = {
  'quick': Icons.flash_on_rounded,
  'needs': Icons.favorite_rounded,
  'emergency': Icons.warning_amber_rounded,
  'emotions': Icons.mood_rounded,
  'general': Icons.chat_bubble_outline_rounded,
};

String _categoryLabel(AppLocalizations l10n, String category) => switch (category) {
      'quick' => l10n.categoryQuick,
      'needs' => l10n.categoryNeeds,
      'emergency' => l10n.categoryEmergency,
      'emotions' => l10n.categoryEmotions,
      _ => l10n.categoryGeneral,
    };

class SymbolScreen extends StatefulWidget {
  final TtsService tts;
  final StorageService storage;
  final void Function(Message) onMessageSpoken;

  const SymbolScreen({
    super.key,
    required this.tts,
    required this.storage,
    required this.onMessageSpoken,
  });

  @override
  State<SymbolScreen> createState() => _SymbolScreenState();
}

class _SymbolScreenState extends State<SymbolScreen> {
  final _uuid = const Uuid();
  String _category = 'needs';

  void _speakSymbol(Phrase phrase) async {
    await widget.tts.speak(phrase.text);
    await widget.storage.incrementUse(phrase.id);
    widget.onMessageSpoken(Message(
      id: _uuid.v4(),
      text: phrase.text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final categories = ['needs', 'emergency', 'emotions', 'quick'];
    final phrases = widget.storage.getPhrases(category: _category);
    final activeColor = CategoryColors.of(_category);

    return Column(
      children: [
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final cat = categories[i];
              final selected = cat == _category;
              final color = CategoryColors.of(cat);
              return ChoiceChip(
                label: Text(_categoryLabel(l10n, cat)),
                avatar: Icon(
                  _categoryIcons[cat],
                  size: 18,
                  color: selected ? color : color.withValues(alpha: 0.7),
                ),
                selected: selected,
                onSelected: (_) => setState(() => _category = cat),
                selectedColor: color.withValues(alpha: 0.16),
                side: BorderSide(color: selected ? color : theme.colorScheme.outlineVariant),
                labelStyle: TextStyle(
                  color: selected ? color : null,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: phrases.isEmpty
              ? Center(
                  child: Text(
                    l10n.noSymbolsYet,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: phrases.length,
                  itemBuilder: (context, index) {
                    final phrase = phrases[index];
                    return Material(
                      color: activeColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        onTap: () => _speakSymbol(phrase),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            border: Border.all(color: activeColor.withValues(alpha: 0.28)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: activeColor.withValues(alpha: 0.16),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(_categoryIcons[_category], size: 26, color: activeColor),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                child: Text(
                                  phrase.text,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
