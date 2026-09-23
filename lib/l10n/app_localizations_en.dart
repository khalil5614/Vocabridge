// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vocabridge';

  @override
  String get conversationTitle => 'Conversation';

  @override
  String get tabKeyboard => 'Keyboard';

  @override
  String get tabSymbols => 'Symbols';

  @override
  String get tabSign => 'Sign';

  @override
  String get tabListen => 'Listen';

  @override
  String backToTab(String tab) {
    return 'Back to $tab';
  }

  @override
  String get viewConversation => 'View conversation';

  @override
  String get language => 'Language';

  @override
  String get chooseLanguage => 'Choose language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageBengali => 'Bengali';

  @override
  String get quickPhrases => 'Quick phrases';

  @override
  String get tone => 'Tone';

  @override
  String get noSymbolsYet => 'No symbols in this category yet';

  @override
  String get noQuickPhrasesYet => 'No quick phrases yet';

  @override
  String get typeHint => 'Type what you want to say…';

  @override
  String get clear => 'Clear';

  @override
  String get speak => 'Speak';

  @override
  String get stopSpeaking => 'Stop speaking';

  @override
  String get conversationEmpty => 'Your conversation will appear here.';

  @override
  String get you => 'You';

  @override
  String get them => 'Them';

  @override
  String get theirWordsWillAppear => 'Their words will appear here…';

  @override
  String get tapMicInstructions =>
      'Tap the mic and hand the phone over, or let them speak toward it.';

  @override
  String get listening => 'Listening…';

  @override
  String get signVideoNotBundled => 'Sign video not bundled yet';

  @override
  String get addSignClipInstructions =>
      'Add a clip to assets/sign_videos/ for this phrase.';

  @override
  String get pickPhraseToSign => 'Pick a phrase below to see it signed';

  @override
  String get categoryQuick => 'Quick';

  @override
  String get categoryNeeds => 'Needs';

  @override
  String get categoryEmergency => 'Emergency';

  @override
  String get categoryEmotions => 'Emotions';

  @override
  String get categoryGeneral => 'General';

  @override
  String get toneNeutral => 'Neutral';

  @override
  String get toneHappy => 'Happy';

  @override
  String get toneUrgent => 'Urgent';

  @override
  String get toneSad => 'Sad';

  @override
  String get toneQuestion => 'Question';

  @override
  String get toneAngry => 'Angry';
}
