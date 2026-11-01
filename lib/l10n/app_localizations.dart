import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocabridge'**
  String get appTitle;

  /// No description provided for @conversationTitle.
  ///
  /// In en, this message translates to:
  /// **'Conversation'**
  String get conversationTitle;

  /// No description provided for @tabKeyboard.
  ///
  /// In en, this message translates to:
  /// **'Keyboard'**
  String get tabKeyboard;

  /// No description provided for @tabSymbols.
  ///
  /// In en, this message translates to:
  /// **'Symbols'**
  String get tabSymbols;

  /// No description provided for @tabSign.
  ///
  /// In en, this message translates to:
  /// **'Sign'**
  String get tabSign;

  /// No description provided for @tabListen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get tabListen;

  /// No description provided for @backToTab.
  ///
  /// In en, this message translates to:
  /// **'Back to {tab}'**
  String backToTab(String tab);

  /// No description provided for @viewConversation.
  ///
  /// In en, this message translates to:
  /// **'View conversation'**
  String get viewConversation;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get chooseLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get languageBengali;

  /// No description provided for @quickPhrases.
  ///
  /// In en, this message translates to:
  /// **'Quick phrases'**
  String get quickPhrases;

  /// No description provided for @tone.
  ///
  /// In en, this message translates to:
  /// **'Tone'**
  String get tone;

  /// No description provided for @noSymbolsYet.
  ///
  /// In en, this message translates to:
  /// **'No symbols in this category yet'**
  String get noSymbolsYet;

  /// No description provided for @noQuickPhrasesYet.
  ///
  /// In en, this message translates to:
  /// **'No quick phrases yet'**
  String get noQuickPhrasesYet;

  /// No description provided for @typeHint.
  ///
  /// In en, this message translates to:
  /// **'Type what you want to say…'**
  String get typeHint;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @speak.
  ///
  /// In en, this message translates to:
  /// **'Speak'**
  String get speak;

  /// No description provided for @stopSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Stop speaking'**
  String get stopSpeaking;

  /// No description provided for @conversationEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your conversation will appear here.'**
  String get conversationEmpty;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @them.
  ///
  /// In en, this message translates to:
  /// **'Them'**
  String get them;

  /// No description provided for @theirWordsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Their words will appear here…'**
  String get theirWordsWillAppear;

  /// No description provided for @tapMicInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap the mic and hand the phone over, or let them speak toward it.'**
  String get tapMicInstructions;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get listening;

  /// No description provided for @signVideoNotBundled.
  ///
  /// In en, this message translates to:
  /// **'Sign video not bundled yet'**
  String get signVideoNotBundled;

  /// No description provided for @addSignClipInstructions.
  ///
  /// In en, this message translates to:
  /// **'Add a clip to assets/sign_videos/ for this phrase.'**
  String get addSignClipInstructions;

  /// No description provided for @pickPhraseToSign.
  ///
  /// In en, this message translates to:
  /// **'Pick a phrase below to see it signed'**
  String get pickPhraseToSign;

  /// No description provided for @categoryQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get categoryQuick;

  /// No description provided for @categoryNeeds.
  ///
  /// In en, this message translates to:
  /// **'Needs'**
  String get categoryNeeds;

  /// No description provided for @categoryEmergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get categoryEmergency;

  /// No description provided for @categoryEmotions.
  ///
  /// In en, this message translates to:
  /// **'Emotions'**
  String get categoryEmotions;

  /// No description provided for @categoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get categoryGeneral;

  /// No description provided for @categoryFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get categoryFamily;

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categoryWeather.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get categoryWeather;

  /// No description provided for @categoryMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get categoryMoney;

  /// No description provided for @categoryTech.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get categoryTech;

  /// No description provided for @toneNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get toneNeutral;

  /// No description provided for @toneHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get toneHappy;

  /// No description provided for @toneUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get toneUrgent;

  /// No description provided for @toneSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get toneSad;

  /// No description provided for @toneQuestion.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get toneQuestion;

  /// No description provided for @toneAngry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get toneAngry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
