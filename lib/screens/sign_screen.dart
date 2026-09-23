import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../l10n/app_localizations.dart';
import '../services/storage_service.dart';
import '../theme/app_theme.dart';

/// v1 scope: user picks a phrase, app plays a matching sign-language
/// video from assets/sign_videos/. This build ships WITHOUT real video
/// files — you need to source a licensed sign-language video set
/// (e.g., WLASL for ASL) and drop clips into assets/sign_videos/ named
/// to match each phrase's id (e.g., p1.mp4 for "Yes").
///
/// Phase 2 (later, per plan): replace/extend this with camera-based
/// sign recognition (MediaPipe Hands + a trained TFLite classifier)
/// so the app can go sign -> speech, not just phrase -> sign video.
class SignScreen extends StatefulWidget {
  final StorageService storage;

  const SignScreen({super.key, required this.storage});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  VideoPlayerController? _controller;
  String? _activePhraseId;
  bool _videoMissing = false;
  bool _loading = false;

  Future<void> _playSign(String phraseId) async {
    await _controller?.dispose();
    setState(() {
      _activePhraseId = phraseId;
      _videoMissing = false;
      _loading = true;
      _controller = null;
    });
    final path = 'assets/sign_videos/$phraseId.mp4';
    final controller = VideoPlayerController.asset(path);
    try {
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _controller = controller;
        _loading = false;
      });
      controller.play();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _videoMissing = true;
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final phrases = widget.storage.getPhrases();

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: const Color(0xFF15181C),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Center(
              child: _activePhraseId == null
                  ? _EmptyPlayerState(theme: theme, text: l10n.pickPhraseToSign)
                  : _loading
                      ? const CircularProgressIndicator(color: Colors.white70)
                      : _videoMissing
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.videocam_off_rounded, color: Colors.white54, size: 32),
                                  const SizedBox(height: 12),
                                  Text(
                                    l10n.signVideoNotBundled,
                                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    l10n.addSignClipInstructions,
                                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : (_controller != null && _controller!.value.isInitialized)
                              ? AspectRatio(
                                  aspectRatio: _controller!.value.aspectRatio,
                                  child: VideoPlayer(_controller!),
                                )
                              : const CircularProgressIndicator(color: Colors.white70),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
            itemCount: phrases.length,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final phrase = phrases[index];
              final active = phrase.id == _activePhraseId;
              return Material(
                color: active
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  onTap: () => _playSign(phrase.id),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            phrase.text,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        Icon(
                          active ? Icons.play_circle_fill_rounded : Icons.sign_language_rounded,
                          color: active
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmptyPlayerState extends StatelessWidget {
  final ThemeData theme;
  final String text;
  const _EmptyPlayerState({required this.theme, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sign_language_rounded, color: Colors.white54, size: 36),
          const SizedBox(height: 12),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
