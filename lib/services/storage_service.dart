import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/default_phrases.dart';
import '../models/message.dart';

/// All data lives on-device only (Hive/local boxes) — this app must
/// keep working with no internet connection, since it's used for
/// real-time, sometimes urgent, communication.
class StorageService {
  static const _historyBox = 'history';
  static const _phrasesBox = 'phrases';
  static const _wordFreqBox = 'word_freq'; // for prediction
  static const _settingsBox = 'settings';

  late Box _history;
  late Box _phrases;
  late Box _wordFreq;
  late Box _settings;

  Future<void> init() async {
    await Hive.initFlutter();
    _history = await Hive.openBox(_historyBox);
    _phrases = await Hive.openBox(_phrasesBox);
    _wordFreq = await Hive.openBox(_wordFreqBox);
    _settings = await Hive.openBox(_settingsBox);

    if (_phrases.isEmpty) {
      await _seedDefaultPhrases();
    }
  }

  // ---- App language ----

  String getLanguageCode() => _settings.get('language', defaultValue: 'en') as String;

  Future<void> setLanguageCode(String code) async {
    await _settings.put('language', code);
    await _retranslateDefaultPhrases(code);
  }

  // ---- User Profile / Name ----

  String getUserName() => _settings.get('user_name', defaultValue: '') as String;

  Future<void> setUserName(String name) async {
    await _settings.put('user_name', name);
  }

  Future<String> resolvePhraseText(BuildContext context, Phrase phrase) async {
    if (phrase.id == 'p47') {
      var name = getUserName();
      if (name.isEmpty) {
        name = await showDialog<String>(
              context: context,
              builder: (context) {
                final controller = TextEditingController();
                return AlertDialog(
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
                      onPressed: () => Navigator.pop(context, controller.text.trim()),
                      child: const Text('Save'),
                    ),
                  ],
                );
              },
            ) ?? '';
        if (name.isNotEmpty) {
          await setUserName(name);
        }
      }
      if (name.isNotEmpty) {
        final base = phrase.text.replaceAll(RegExp(r'\.+$'), '').trim();
        return '$base $name';
      }
    }
    return phrase.text;
  }

  /// The seeded default phrases (ids p1-p14) are re-seeded in [languageCode],
  /// keeping each phrase's use count and favorite flag. There is no phrase
  /// edit UI yet, so a default phrase's text is never user-authored and is
  /// always safe to overwrite on a language switch.
  Future<void> _retranslateDefaultPhrases(String languageCode) async {
    for (final translated in buildDefaultPhrases(languageCode)) {
      final raw = _phrases.get(translated.id);
      if (raw == null) continue;
      final existing = Phrase.fromMap(Map<String, dynamic>.from(raw));
      await savePhrase(Phrase(
        id: translated.id,
        text: translated.text,
        category: translated.category,
        isFavorite: existing.isFavorite,
        useCount: existing.useCount,
      ));
    }
  }

  // ---- Conversation history ----

  Future<void> addMessage(Message message) async {
    await _history.put(message.id, message.toMap());
  }

  List<Message> getHistory({int? limit}) {
    final all = _history.values
        .map((m) => Message.fromMap(Map<String, dynamic>.from(m)))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    if (limit != null && all.length > limit) return all.sublist(0, limit);
    return all;
  }

  Future<void> clearHistory() async => _history.clear();

  // ---- Quick phrases / favorites ----

  Future<void> savePhrase(Phrase phrase) async {
    await _phrases.put(phrase.id, phrase.toMap());
  }

  List<Phrase> getPhrases({String? category}) {
    final all = _phrases.values
        .map((p) => Phrase.fromMap(Map<String, dynamic>.from(p)))
        .toList();
    if (category != null) {
      return all.where((p) => p.category == category).toList();
    }
    return all;
  }

  List<Phrase> getFavorites() =>
      getPhrases().where((p) => p.isFavorite).toList();

  Future<void> incrementUse(String phraseId) async {
    final raw = _phrases.get(phraseId);
    if (raw == null) return;
    final phrase = Phrase.fromMap(Map<String, dynamic>.from(raw));
    phrase.useCount++;
    await savePhrase(phrase);
  }

  // ---- Word frequency (for simple local prediction) ----

  Future<void> recordWords(String sentence) async {
    final words = sentence.toLowerCase().split(RegExp(r'\s+'));
    for (final w in words) {
      if (w.trim().isEmpty) continue;
      final current = _wordFreq.get(w, defaultValue: 0) as int;
      await _wordFreq.put(w, current + 1);
    }
  }

  /// Returns the top words starting with [prefix], most-used first.
  /// This is a lightweight local model — no ML needed for v1, and it
  /// improves automatically the more the user types.
  List<String> predict(String prefix, {int limit = 5}) {
    if (prefix.isEmpty) return [];
    final matches = _wordFreq.keys
        .cast<String>()
        .where((w) => w.startsWith(prefix.toLowerCase()) && w != prefix.toLowerCase())
        .toList()
      ..sort((a, b) =>
          (_wordFreq.get(b, defaultValue: 0) as int)
              .compareTo(_wordFreq.get(a, defaultValue: 0) as int));
    return matches.take(limit).toList();
  }

  Future<void> _seedDefaultPhrases() async {
    for (final p in buildDefaultPhrases(getLanguageCode())) {
      await savePhrase(p);
    }
  }
}
