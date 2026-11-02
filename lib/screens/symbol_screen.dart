import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  'all': Icons.apps_rounded,
  'quick': Icons.flash_on_rounded,
  'needs': Icons.favorite_rounded,
  'emergency': Icons.warning_amber_rounded,
  'emotions': Icons.mood_rounded,
  'family': Icons.family_restroom_rounded,
  'work': Icons.work_rounded,
  'weather': Icons.wb_sunny_rounded,
  'money': Icons.attach_money_rounded,
  'tech': Icons.devices_rounded,
  'general': Icons.chat_bubble_outline_rounded,
};

const Map<String, IconData> _specificPhraseIcons = {
  'p1': Icons.check_circle_rounded,
  'p2': Icons.cancel_rounded,
  'p3': Icons.volunteer_activism_rounded,
  'p4': Icons.hourglass_top_rounded,
  'p5': Icons.support_agent_rounded,
  'p6': Icons.sick_rounded,
  'p7': Icons.local_drink_rounded,
  'p8': Icons.wc_rounded,
  'p9': Icons.restaurant_rounded,
  'p10': Icons.contact_phone_rounded,
  'p11': Icons.emergency_rounded,
  'p12': Icons.sentiment_very_satisfied_rounded,
  'p13': Icons.sentiment_dissatisfied_rounded,
  'p14': Icons.help_outline_rounded,
  'p15': Icons.wb_sunny_rounded,
  'p16': Icons.handshake_rounded,
  'p17': Icons.medical_services_rounded,
  'p18': Icons.exit_to_app_rounded,
  'p19': Icons.favorite_rounded,
  'p20': Icons.thumb_up_rounded,
  'p21': Icons.payments_rounded,
  'p22': Icons.handshake_rounded,
  'p23': Icons.access_time_rounded,
  'p24': Icons.sentiment_satisfied_rounded,
  'p25': Icons.watch_later_rounded,
  'p26': Icons.question_mark_rounded,
  'p27': Icons.replay_rounded,
  'p28': Icons.edit_note_rounded,
  'p29': Icons.people_alt_rounded,
  'p30': Icons.nights_stay_rounded,
  'p31': Icons.shopping_cart_rounded,
  'p32': Icons.credit_card_rounded,
  'p33': Icons.receipt_long_rounded,
  'p34': Icons.local_fire_department_rounded,
  'p35': Icons.eco_rounded,
  'p36': Icons.directions_bus_rounded,
  'p37': Icons.navigation_rounded,
  'p38': Icons.front_hand_rounded,
  'p39': Icons.local_taxi_rounded,
  'p40': Icons.event_seat_rounded,
  'p41': Icons.blur_circular_rounded,
  'p42': Icons.medication_rounded,
  'p43': Icons.local_hospital_rounded,
  'p44': Icons.block_rounded,
  'p45': Icons.airport_shuttle_rounded,
  'p46': Icons.badge_rounded,
  'p47': Icons.person_pin_rounded,
  'p48': Icons.chat_rounded,
  'p49': Icons.wb_sunny_rounded,
  'p50': Icons.celebration_rounded,
  'p51': Icons.bedtime_rounded,
  'p52': Icons.ac_unit_rounded,
  'p53': Icons.local_fire_department_rounded,
  'p54': Icons.lightbulb_rounded,
  'p55': Icons.lightbulb_outline_rounded,
  'p56': Icons.door_front_door_rounded,
  'p57': Icons.door_sliding_rounded,
  'p58': Icons.explore_off_rounded,
  'p59': Icons.speed_rounded,
  'p60': Icons.done_all_rounded,
  'p61': Icons.child_care_rounded,
  'p62': Icons.favorite_border_rounded,
  'p63': Icons.home_rounded,
  'p64': Icons.dinner_dining_rounded,
  'p65': Icons.cleaning_services_rounded,
  'p66': Icons.visibility_rounded,
  'p67': Icons.phone_android_rounded,
  'p68': Icons.favorite_rounded,
  'p69': Icons.work_rounded,
  'p70': Icons.email_rounded,
  'p71': Icons.event_rounded,
  'p72': Icons.live_help_rounded,
  'p73': Icons.description_rounded,
  'p74': Icons.verified_rounded,
  'p75': Icons.coffee_rounded,
  'p76': Icons.calendar_today_rounded,
  'p77': Icons.water_drop_rounded,
  'p78': Icons.wb_sunny_rounded,
  'p79': Icons.ac_unit_rounded,
  'p80': Icons.umbrella_rounded,
  'p81': Icons.wb_sunny_outlined,
  'p82': Icons.air_rounded,
  'p83': Icons.ac_unit_outlined,
  'p84': Icons.power_off_rounded,
  'p85': Icons.atm_rounded,
  'p86': Icons.account_balance_wallet_rounded,
  'p87': Icons.money_rounded,
  'p88': Icons.receipt_rounded,
  'p89': Icons.trending_up_rounded,
  'p90': Icons.local_offer_rounded,
  'p91': Icons.swap_horiz_rounded,
  'p92': Icons.thumb_up_alt_rounded,
  'p93': Icons.battery_alert_rounded,
  'p94': Icons.wifi_rounded,
  'p95': Icons.wifi_off_rounded,
  'p96': Icons.battery_charging_full_rounded,
  'p97': Icons.computer_rounded,
  'p98': Icons.message_rounded,
  'p99': Icons.camera_alt_rounded,
  'p100': Icons.phone_callback_rounded,
};

String _categoryLabel(AppLocalizations l10n, String category) => switch (category) {
      'all' => l10n.categoryAll,
      'quick' => l10n.categoryQuick,
      'needs' => l10n.categoryNeeds,
      'emergency' => l10n.categoryEmergency,
      'emotions' => l10n.categoryEmotions,
      'family' => l10n.categoryFamily,
      'work' => l10n.categoryWork,
      'weather' => l10n.categoryWeather,
      'money' => l10n.categoryMoney,
      'tech' => l10n.categoryTech,
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
  String _category = 'all';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  void _speakSymbol(Phrase phrase) async {
    HapticFeedback.mediumImpact();
    final text = await widget.storage.resolvePhraseText(context, phrase);
    await widget.tts.speak(text);
    await widget.storage.incrementUse(phrase.id);
    widget.onMessageSpoken(Message(
      id: _uuid.v4(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddPhraseDialog() {
    final textController = TextEditingController();
    String selectedCategory = _category == 'all' ? 'needs' : _category;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final categories = ['needs', 'emergency', 'emotions', 'quick', 'family', 'work', 'weather', 'money', 'tech', 'general'];
            return AlertDialog(
              title: const Text('Add Custom Phrase'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: 'Enter phrase text...',
                      ),
                      autofocus: true,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    const Text('Select Category:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: categories.map((cat) {
                        final selected = cat == selectedCategory;
                        return ChoiceChip(
                          label: Text(_categoryLabel(AppLocalizations.of(context)!, cat)),
                          selected: selected,
                          onSelected: (_) => setDialogState(() => selectedCategory = cat),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    final text = textController.text.trim();
                    if (text.isEmpty) return;
                    final newPhrase = Phrase(
                      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
                      text: text,
                      category: selectedCategory,
                    );
                    await widget.storage.savePhrase(newPhrase);
                    if (context.mounted) {
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final categories = ['all', 'needs', 'emergency', 'emotions', 'quick', 'family', 'work', 'weather', 'money', 'tech', 'general'];
    final candidatePhrases = _searchQuery.isNotEmpty
        ? widget.storage.getPhrases()
        : (_category == 'all'
            ? widget.storage.getPhrases()
            : widget.storage.getPhrases(category: _category));
    final phrases = _searchQuery.isEmpty
        ? candidatePhrases
        : candidatePhrases.where((p) => p.text.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    final activeColor = _category == 'all' ? theme.colorScheme.primary : CategoryColors.of(_category);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: InputDecoration(
                    hintText: 'Search phrases...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _showAddPhraseDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
            ],
          ),
        ),
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
                  _categoryIcons[cat] ?? Icons.chat_bubble_outline_rounded,
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
                    final itemColor = CategoryColors.of(phrase.category);
                    final itemIcon = _specificPhraseIcons[phrase.id] ?? _categoryIcons[phrase.category] ?? Icons.chat_bubble_outline_rounded;
                    return Card(
                      elevation: 1.5,
                      shadowColor: itemColor.withValues(alpha: 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        side: BorderSide(color: itemColor.withValues(alpha: 0.35), width: 1.2),
                      ),
                      color: theme.colorScheme.surfaceContainerLow,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        onTap: () => _speakSymbol(phrase),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      itemColor.withValues(alpha: 0.25),
                                      itemColor.withValues(alpha: 0.10),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: itemColor.withValues(alpha: 0.15),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(itemIcon, size: 28, color: itemColor),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  phrase.text,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
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
