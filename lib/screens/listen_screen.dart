import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../l10n/app_localizations.dart';
import '../models/message.dart';
import '../services/stt_service.dart';
import '../theme/app_theme.dart';

/// "Listen" mode: the other (speaking) person talks into the phone,
/// and their words appear large on screen so the app's user can read
/// the reply. This is what makes the conversation two-way.
class ListenScreen extends StatefulWidget {
  final SttService stt;
  final void Function(Message) onMessageReceived;
  final String localeId;

  const ListenScreen({
    super.key,
    required this.stt,
    required this.onMessageReceived,
    this.localeId = 'en_US',
  });

  @override
  State<ListenScreen> createState() => _ListenScreenState();
}

class _ListenScreenState extends State<ListenScreen> with SingleTickerProviderStateMixin {
  final _uuid = const Uuid();
  String _liveText = '';
  bool _listening = false;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_listening) {
      await widget.stt.stopListening();
      setState(() => _listening = false);
      return;
    }
    setState(() {
      _listening = true;
      _liveText = '';
    });
    await widget.stt.startListening(
      localeId: widget.localeId,
      onResult: (text, isFinal) {
        setState(() => _liveText = text);
        if (isFinal && text.trim().isNotEmpty) {
          widget.onMessageReceived(Message(
            id: _uuid.v4(),
            text: text,
            sender: MessageSender.other,
            timestamp: DateTime.now(),
          ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.lg, AppSpacing.xl, AppSpacing.xl),
      child: Column(
        children: [
          _StatusBadge(listening: _listening),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _liveText.isEmpty ? l10n.theirWordsWillAppear : _liveText,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: _liveText.isEmpty
                        ? theme.colorScheme.onSurfaceVariant
                        : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = _listening ? 1.0 + (_pulseController.value * 0.12) : 1.0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  if (_listening)
                    Transform.scale(
                      scale: 1.4 + (_pulseController.value * 0.5),
                      child: Container(
                        width: 88,
                        height: 88,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.error
                              .withValues(alpha: 0.18 * (1 - _pulseController.value)),
                        ),
                      ),
                    ),
                  Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                ],
              );
            },
            child: FloatingActionButton.large(
              onPressed: _toggleListening,
              backgroundColor: _listening ? theme.colorScheme.error : theme.colorScheme.primary,
              foregroundColor: _listening ? theme.colorScheme.onError : theme.colorScheme.onPrimary,
              child: Icon(_listening ? Icons.stop_rounded : Icons.mic_rounded, size: 36),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool listening;
  const _StatusBadge({required this.listening});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final color = listening ? theme.colorScheme.error : theme.colorScheme.onSurfaceVariant;
    final textStyle = theme.textTheme.bodyMedium?.copyWith(
      color: color,
      fontWeight: listening ? FontWeight.w700 : FontWeight.w500,
    );

    if (!listening) {
      return Text(
        l10n.tapMicInstructions,
        textAlign: TextAlign.center,
        style: textStyle,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(l10n.listening, style: textStyle),
      ],
    );
  }
}
