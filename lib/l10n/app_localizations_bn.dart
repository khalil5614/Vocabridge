// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'ভোকাব্রিজ';

  @override
  String get conversationTitle => 'কথোপকথন';

  @override
  String get tabKeyboard => 'কীবোর্ড';

  @override
  String get tabSymbols => 'প্রতীক';

  @override
  String get tabSign => 'সাংকেতিক ভাষা';

  @override
  String get tabListen => 'শুনুন';

  @override
  String backToTab(String tab) {
    return '$tab-এ ফিরে যান';
  }

  @override
  String get viewConversation => 'কথোপকথন দেখুন';

  @override
  String get language => 'ভাষা';

  @override
  String get chooseLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get languageEnglish => 'ইংরেজি';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get quickPhrases => 'দ্রুত বাক্যাংশ';

  @override
  String get tone => 'সুর';

  @override
  String get noSymbolsYet => 'এই বিভাগে এখনও কোনো প্রতীক নেই';

  @override
  String get noQuickPhrasesYet => 'এখনও কোনো দ্রুত বাক্যাংশ নেই';

  @override
  String get typeHint => 'আপনি যা বলতে চান তা লিখুন…';

  @override
  String get clear => 'মুছুন';

  @override
  String get speak => 'বলুন';

  @override
  String get stopSpeaking => 'বলা বন্ধ করুন';

  @override
  String get conversationEmpty => 'আপনার কথোপকথন এখানে দেখা যাবে।';

  @override
  String get you => 'আপনি';

  @override
  String get them => 'তারা';

  @override
  String get theirWordsWillAppear => 'তাদের কথা এখানে দেখা যাবে…';

  @override
  String get tapMicInstructions =>
      'মাইক্রোফোনে ট্যাপ করে ফোনটি তাদের দিন, অথবা তাদের ফোনের দিকে কথা বলতে দিন।';

  @override
  String get listening => 'শোনা হচ্ছে…';

  @override
  String get signVideoNotBundled => 'সাংকেতিক ভাষার ভিডিও এখনও যুক্ত করা হয়নি';

  @override
  String get addSignClipInstructions =>
      'এই বাক্যাংশের জন্য assets/sign_videos/ ফোল্ডারে একটি ভিডিও যোগ করুন।';

  @override
  String get pickPhraseToSign =>
      'সাংকেতিক ভাষায় দেখতে নিচে থেকে একটি বাক্যাংশ বেছে নিন';

  @override
  String get categoryQuick => 'দ্রুত';

  @override
  String get categoryNeeds => 'প্রয়োজন';

  @override
  String get categoryEmergency => 'জরুরি';

  @override
  String get categoryEmotions => 'অনুভূতি';

  @override
  String get categoryGeneral => 'সাধারণ';

  @override
  String get categoryAll => 'সব';

  @override
  String get categoryFamily => 'পরিবার';

  @override
  String get categoryWork => 'কাজ';

  @override
  String get categoryWeather => 'আবহাওয়া';

  @override
  String get categoryMoney => 'অর্থ';

  @override
  String get categoryTech => 'প্রযুক্তি';

  @override
  String get toneNeutral => 'স্বাভাবিক';

  @override
  String get toneHappy => 'খুশি';

  @override
  String get toneUrgent => 'জরুরি';

  @override
  String get toneSad => 'দুঃখিত';

  @override
  String get toneQuestion => 'প্রশ্ন';

  @override
  String get toneAngry => 'রাগান্বিত';
}
