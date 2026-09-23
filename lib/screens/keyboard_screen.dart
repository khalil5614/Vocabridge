import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../models/message.dart';
import '../services/tts_service.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';
import '../widgets/quick_phrases_bar.dart';
import '../widgets/section_label.dart';
import '../widgets/tone_selector.dart';

class KeyboardScreen extends StatefulWidget {
  final TtsService tts;
  final StorageService storage;
  final void Function(Message) onMessageSpoken;

  const KeyboardScreen({
    super.key,
    required this.tts,
    required this.storage,
    required this.onMessageSpoken,
  });

  @override
  State<KeyboardScreen> createState() => _KeyboardScreenState();
}

class _KeyboardScreenState extends State<KeyboardScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _uuid = const Uuid();
  Tone _tone = Tone.neutral;
  List<String> _suggestions = [];

  void _onTextChanged(String text) {
    final words = text.split(' ');
    final lastWord = words.isNotEmpty ? words.last : '';
    setState(() {
      _suggestions = widget.storage.predict(lastWord);
    });
  }

  void _applySuggestion(String word) {
    final words = _controller.text.split(' ');
    words[words.length - 1] = word;
    final newText = '${words.join(' ')} ';
    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
    _onTextChanged(newText);
  }

  Future<void> _speak() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await widget.storage.recordWords(text);
    await widget.tts.speak(text, tone: _tone);
    widget.onMessageSpoken(Message(
      id: _uuid.v4(),
      text: text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      tone: _tone,
    ));
    _controller.clear();
    setState(() => _suggestions = []);
    _focusNode.requestFocus();
  }

  void _speakQuickPhrase(Phrase phrase) async {
    await widget.tts.speak(phrase.text, tone: _tone);
    await widget.storage.incrementUse(phrase.id);
    widget.onMessageSpoken(Message(
      id: _uuid.v4(),
      text: phrase.text,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      tone: _tone,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final quickPhrases = widget.storage.getPhrases(category: 'quick');
    final hasText = _controller.text.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionLabel(l10n.quickPhrases),
          const SizedBox(height: AppSpacing.sm),
          QuickPhrasesBar(phrases: quickPhrases, onTap: _speakQuickPhrase),
          const SizedBox(height: AppSpacing.lg),
          SectionLabel(l10n.tone),
          const SizedBox(height: AppSpacing.sm),
          ToneSelector(selected: _tone, onChanged: (t) => setState(() => _tone = t)),
          const SizedBox(height: AppSpacing.lg),
          AnimatedSize(
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.topCenter,
            child: _suggestions.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _suggestions.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (context, i) => ActionChip(
                          label: Text(_suggestions[i]),
                          onPressed: () => _applySuggestion(_suggestions[i]),
                        ),
                      ),
                    ),
                  ),
          ),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: (t) {
              _onTextChanged(t);
              setState(() {});
            },
            autofocus: true,
            minLines: 3,
            maxLines: 6,
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: InputDecoration(
              hintText: l10n.typeHint,
              suffixIcon: hasText
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: l10n.clear,
                      onPressed: () {
                        _controller.clear();
                        _onTextChanged('');
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: hasText ? _speak : null,
                  icon: const Icon(Icons.volume_up_rounded, size: 26),
                  label: Text(l10n.speak),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              IconButton.filledTonal(
                iconSize: 28,
                padding: const EdgeInsets.all(16),
                onPressed: () => widget.tts.stop(),
                icon: const Icon(Icons.stop_rounded),
                tooltip: l10n.stopSpeaking,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
