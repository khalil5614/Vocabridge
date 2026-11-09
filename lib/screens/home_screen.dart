import 'package:flutter/material.dart';
import '../l10n/app_locale.dart';
import '../l10n/app_localizations.dart';
import '../models/message.dart';
import '../services/tts_service.dart';
import '../services/stt_service.dart';
import '../services/storage_service.dart';
import '../widgets/conversation_thread.dart';
import 'keyboard_screen.dart';
import 'symbol_screen.dart';
import 'sign_screen.dart';
import 'listen_screen.dart';

class HomeScreen extends StatefulWidget {
  final TtsService tts;
  final SttService stt;
  final StorageService storage;
  final String languageCode;
  final void Function(String code) onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.tts,
    required this.stt,
    required this.storage,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tabIndex = 0;
  bool _showThread = false;
  final List<Message> _thread = [];

  void _addMessage(Message m) {
    widget.storage.addMessage(m);
    setState(() => _thread.insert(0, m));
  }

  void _showSetNameDialog(BuildContext context) {
    final controller = TextEditingController(text: widget.storage.getUserName());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Your Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter your name...'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              await widget.storage.setUserName(controller.text.trim());
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _thread.addAll(widget.storage.getHistory(limit: 50));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final tabTitles = [l10n.tabKeyboard, l10n.tabSymbols, l10n.tabSign, l10n.tabListen];
    final screens = [
      KeyboardScreen(tts: widget.tts, storage: widget.storage, onMessageSpoken: _addMessage),
      SymbolScreen(tts: widget.tts, storage: widget.storage, onMessageSpoken: _addMessage),
      SignScreen(storage: widget.storage),
      ListenScreen(
        stt: widget.stt,
        onMessageReceived: _addMessage,
        localeId: AppLocale.sttLocaleId(widget.languageCode),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 34,
              height: 34,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/logo_voca.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(_showThread ? l10n.conversationTitle : l10n.appTitle),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.translate_rounded),
            tooltip: l10n.chooseLanguage,
            initialValue: widget.languageCode,
            onSelected: widget.onLanguageChanged,
            itemBuilder: (context) => [
              CheckedPopupMenuItem(
                value: 'en',
                checked: widget.languageCode == 'en',
                child: Text(l10n.languageEnglish),
              ),
              CheckedPopupMenuItem(
                value: 'bn',
                checked: widget.languageCode == 'bn',
                child: Text(l10n.languageBengali),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.person_outline_rounded),
            tooltip: 'Set Name',
            onPressed: () => _showSetNameDialog(context),
          ),
          IconButton(
            icon: Icon(_showThread ? Icons.keyboard_alt_outlined : Icons.forum_outlined),
            tooltip: _showThread ? l10n.backToTab(tabTitles[_tabIndex]) : l10n.viewConversation,
            onPressed: () => setState(() => _showThread = !_showThread),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: SafeArea(
          key: ValueKey(_showThread ? 'thread' : _tabIndex),
          child: _showThread
              ? ConversationThread(messages: _thread)
              : screens[_tabIndex],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tabIndex,
        onDestinationSelected: (i) => setState(() {
          _tabIndex = i;
          _showThread = false;
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.keyboard_alt_outlined),
            selectedIcon: const Icon(Icons.keyboard_alt),
            label: tabTitles[0],
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view),
            label: tabTitles[1],
          ),
          NavigationDestination(
            icon: const Icon(Icons.sign_language_outlined),
            selectedIcon: const Icon(Icons.sign_language),
            label: tabTitles[2],
          ),
          NavigationDestination(
            icon: const Icon(Icons.hearing_outlined),
            selectedIcon: const Icon(Icons.hearing),
            label: tabTitles[3],
          ),
        ],
      ),
    );
  }
}
