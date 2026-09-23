import 'package:speech_to_text/speech_to_text.dart' as stt;

/// Wraps speech_to_text so the "Listen" mode can transcribe what the
/// other (speaking) person says, letting the app's user read the reply.
class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isAvailable = false;
  bool isListening = false;

  Future<bool> init() async {
    isAvailable = await _speech.initialize(
      onStatus: (status) {
        isListening = status == 'listening';
      },
      onError: (error) {
        isListening = false;
      },
    );
    return isAvailable;
  }

  /// Starts listening. [onResult] fires continuously with partial and
  /// final transcriptions so the UI can update live as the other person talks.
  Future<void> startListening({
    required Function(String text, bool isFinal) onResult,
    String localeId = 'en_US', // use 'bn_BD' for Bengali
  }) async {
    if (!isAvailable) {
      final ok = await init();
      if (!ok) return;
    }
    isListening = true;
    await _speech.listen(
      listenOptions: stt.SpeechListenOptions(localeId: localeId),
      onResult: (result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  Future<void> stopListening() async {
    await _speech.stop();
    isListening = false;
  }
}
