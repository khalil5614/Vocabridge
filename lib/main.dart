import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'l10n/app_locale.dart';
import 'l10n/app_localizations.dart';
import 'services/tts_service.dart';
import 'services/stt_service.dart';
import 'services/storage_service.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // The app's typeface is bundled locally (assets/google_fonts/) rather than
  // fetched from Google's servers at runtime — this must keep working with
  // no internet connection, since it's used for real-time communication.
  GoogleFonts.config.allowRuntimeFetching = false;

  final storage = StorageService();
  await storage.init();

  final languageCode = storage.getLanguageCode();

  final tts = TtsService();
  await tts.init(language: AppLocale.ttsLanguage(languageCode));

  final stt = SttService();
  await stt.init();

  runApp(VocaBridgeApp(tts: tts, stt: stt, storage: storage, initialLanguageCode: languageCode));
}

class VocaBridgeApp extends StatefulWidget {
  final TtsService tts;
  final SttService stt;
  final StorageService storage;
  final String initialLanguageCode;

  const VocaBridgeApp({
    super.key,
    required this.tts,
    required this.stt,
    required this.storage,
    required this.initialLanguageCode,
  });

  @override
  State<VocaBridgeApp> createState() => _VocaBridgeAppState();
}

class _VocaBridgeAppState extends State<VocaBridgeApp> {
  late String _languageCode = widget.initialLanguageCode;

  Future<void> _changeLanguage(String code) async {
    if (code == _languageCode) return;
    await widget.storage.setLanguageCode(code);
    await widget.tts.setLanguage(AppLocale.ttsLanguage(code));
    setState(() => _languageCode = code);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(languageCode: _languageCode),
      darkTheme: AppTheme.dark(languageCode: _languageCode),
      themeMode: ThemeMode.system,
      locale: AppLocale.toLocale(_languageCode),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: HomeScreen(
        tts: widget.tts,
        stt: widget.stt,
        storage: widget.storage,
        languageCode: _languageCode,
        onLanguageChanged: _changeLanguage,
      ),
    );
  }
}
