import '../models/message.dart';

/// Text for each seeded default phrase, per supported language code.
/// Keyed by the [Phrase.id] values used in [StorageService.seedDefaultPhrases]
/// so switching the app language can retranslate them in place.
const Map<String, Map<String, String>> defaultPhraseTranslations = {
  'p1': {'en': 'Yes', 'bn': 'হ্যাঁ'},
  'p2': {'en': 'No', 'bn': 'না'},
  'p3': {'en': 'Thank you', 'bn': 'ধন্যবাদ'},
  'p4': {'en': 'Please wait', 'bn': 'অনুগ্রহ করে অপেক্ষা করুন'},
  'p5': {'en': 'I need help', 'bn': 'আমার সাহায্য দরকার'},
  'p6': {'en': 'I am in pain', 'bn': 'আমার ব্যথা হচ্ছে'},
  'p7': {'en': 'I need water', 'bn': 'আমার পানি দরকার'},
  'p8': {'en': 'I need the bathroom', 'bn': 'আমার বাথরুমে যেতে হবে'},
  'p9': {'en': 'I am hungry', 'bn': 'আমার ক্ষুধা লেগেছে'},
  'p10': {'en': 'Call my family', 'bn': 'আমার পরিবারকে কল করুন'},
  'p11': {'en': 'Call 999', 'bn': '৯৯৯ নম্বরে কল করুন'},
  'p12': {'en': 'I am happy', 'bn': 'আমি খুশি'},
  'p13': {'en': 'I am sad', 'bn': 'আমি দুঃখিত'},
  'p14': {'en': 'I am confused', 'bn': 'আমি বিভ্রান্ত'},
};

const List<Map<String, String>> defaultPhraseSeed = [
  {'id': 'p1', 'category': 'quick'},
  {'id': 'p2', 'category': 'quick'},
  {'id': 'p3', 'category': 'quick'},
  {'id': 'p4', 'category': 'quick'},
  {'id': 'p5', 'category': 'quick'},
  {'id': 'p6', 'category': 'quick'},
  {'id': 'p7', 'category': 'needs'},
  {'id': 'p8', 'category': 'needs'},
  {'id': 'p9', 'category': 'needs'},
  {'id': 'p10', 'category': 'emergency'},
  {'id': 'p11', 'category': 'emergency'},
  {'id': 'p12', 'category': 'emotions'},
  {'id': 'p13', 'category': 'emotions'},
  {'id': 'p14', 'category': 'emotions'},
];

List<Phrase> buildDefaultPhrases(String languageCode) {
  return defaultPhraseSeed
      .map((p) => Phrase(
            id: p['id']!,
            text: defaultPhraseTranslations[p['id']]![languageCode] ??
                defaultPhraseTranslations[p['id']]!['en']!,
            category: p['category']!,
          ))
      .toList();
}
