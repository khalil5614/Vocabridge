import 'package:flutter_tts/flutter_tts.dart';
import '../models/message.dart';

/// Handles all text-to-speech playback, including tone-adjusted
/// pitch/rate so speech doesn't sound flat for every kind of message.
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isSpeaking = false;

  bool get isSpeaking => _isSpeaking;

  Future<void> init({String language = 'en-US'}) async {
    await _tts.setLanguage(language);
    await _tts.setVolume(1.0);
    _tts.setStartHandler(() => _isSpeaking = true);
    _tts.setCompletionHandler(() => _isSpeaking = false);
    _tts.setCancelHandler(() => _isSpeaking = false);
  }

  Future<void> setLanguage(String languageCode) async {
    // Examples: 'en-US' for English, 'bn-BD' for Bengali.
    // Bengali TTS voice availability depends on the device's installed
    // TTS engine (Google TTS supports bn-BD on most Android devices).
    await _tts.setLanguage(languageCode);
  }

  Future<void> setRate(double rate) async => _tts.setSpeechRate(rate); // 0.0 - 1.0
  Future<void> setPitch(double pitch) async => _tts.setPitch(pitch); // 0.5 - 2.0

  /// Speaks [text], adjusting rate/pitch based on [tone] so messages
  /// carry some emotional signal instead of sounding robotic and flat.
  Future<void> speak(String text, {Tone tone = Tone.neutral}) async {
    switch (tone) {
      case Tone.happy:
        await _tts.setPitch(1.25);
        await _tts.setSpeechRate(0.55);
        break;
      case Tone.urgent:
        await _tts.setPitch(1.1);
        await _tts.setSpeechRate(0.65);
        break;
      case Tone.sad:
        await _tts.setPitch(0.85);
        await _tts.setSpeechRate(0.4);
        break;
      case Tone.question:
        await _tts.setPitch(1.15);
        await _tts.setSpeechRate(0.5);
        break;
      case Tone.angry:
        await _tts.setPitch(0.9);
        await _tts.setSpeechRate(0.6);
        break;
      case Tone.neutral:
        await _tts.setPitch(1.0);
        await _tts.setSpeechRate(0.5);
        break;
    }
    await _tts.speak(text);
  }

  /// Immediately stops playback. Critical for real conversations —
  /// users need to cancel a wrong phrase mid-sentence, not wait it out.
  Future<void> stop() async {
    await _tts.stop();
    _isSpeaking = false;
  }
}
