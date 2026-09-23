import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:voca_bridge/main.dart';
import 'package:voca_bridge/services/storage_service.dart';
import 'package:voca_bridge/services/stt_service.dart';
import 'package:voca_bridge/services/tts_service.dart';

/// Widget tests run with no real platform engine underneath, so plugin
/// method channels (Hive's path_provider lookup, flutter_tts, speech_to_text)
/// have no implementation to respond — leaving `await` calls on them hanging
/// forever instead of failing fast. These mocks give each channel a minimal,
/// harmless response so service init can complete under test.
void _mockPlatformChannels() {
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  messenger.setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (call) async =>
        call.method == 'getApplicationDocumentsDirectory' ? Directory.systemTemp.path : null,
  );

  messenger.setMockMethodCallHandler(
    const MethodChannel('flutter_tts'),
    (call) async => 1,
  );

  messenger.setMockMethodCallHandler(
    const MethodChannel('plugin.csdcorp.com/speech_to_text'),
    (call) async => call.method == 'initialize' ? false : null,
  );
}

void main() {
  setUpAll(_mockPlatformChannels);

  testWidgets('App launches on the Keyboard tab with navigation visible', (tester) async {
    // Service init performs real file I/O (Hive) and platform-channel calls,
    // which never resolve inside testWidgets' fake-async zone unless run
    // through runAsync — see https://api.flutter.dev/flutter/flutter_test/WidgetTester/runAsync.html
    final storage = StorageService();
    final tts = TtsService();
    final stt = SttService();
    await tester.runAsync(() async {
      await storage.init();
      await tts.init();
      await stt.init();
    });

    await tester.pumpWidget(VocaBridgeApp(
      tts: tts,
      stt: stt,
      storage: storage,
      initialLanguageCode: storage.getLanguageCode(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Vocabridge'), findsOneWidget);
    expect(find.text('Type what you want to say…'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('Symbols'));
    await tester.pumpAndSettle();

    expect(find.text('Type what you want to say…'), findsNothing);
  });
}
