import 'package:flutter/widgets.dart';

/// Maps the app's language code ('en'/'bn') to the codes each platform
/// service actually wants, so there's one place to extend when adding
/// another language.
class AppLocale {
  AppLocale._();

  static const supportedCodes = ['en', 'bn'];

  static Locale toLocale(String code) => Locale(code);

  static String ttsLanguage(String code) => switch (code) {
        'bn' => 'bn-BD',
        _ => 'en-US',
      };

  static String sttLocaleId(String code) => switch (code) {
        'bn' => 'bn_BD',
        _ => 'en_US',
      };

  /// Bengali glyphs aren't in the bundled Atkinson Hyperlegible face, so
  /// Bengali text needs the bundled Noto Sans Bengali font instead.
  static String? fontFamilyOverride(String code) => switch (code) {
        'bn' => 'NotoSansBengali',
        _ => null,
      };
}
