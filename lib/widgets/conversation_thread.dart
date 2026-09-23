import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/message.dart';
import '../theme/app_theme.dart';

/// Displays the running conversation as chat bubbles — the app user's
/// spoken-out messages on one side, the other person's transcribed
/// replies on the other. Keeps both people able to follow along visually,
/// not just by ear.
class ConversationThread extends StatelessWidget {
  final List<Message> messages;

  const ConversationThread({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    if (messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.forum_outlined, size: 40, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(height: 12),
              Text(
                l10n.conversationEmpty,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final isUser = msg.sender == MessageSender.user;
        // Group consecutive messages from the same sender visually —
        // only show the sender label on the first bubble of a run.
        final prevSameSender =
            index + 1 < messages.length && messages[index + 1].sender == msg.sender;

        return Padding(
          padding: EdgeInsets.only(top: prevSameSender ? 2 : 12),
          child: Column(
            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              if (!prevSameSender)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Text(
                    isUser ? l10n.you : l10n.them,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              _MessageBubble(message: msg, isUser: isUser),
            ],
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;
  final bool isUser;

  const _MessageBubble({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bubbleColor = isUser ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHigh;
    final textColor = isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.md),
            topRight: const Radius.circular(AppRadius.md),
            bottomLeft: Radius.circular(isUser ? AppRadius.md : 4),
            bottomRight: Radius.circular(isUser ? 4 : AppRadius.md),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUser && message.tone != Tone.neutral)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Icon(
                  _toneIcon(message.tone),
                  size: 15,
                  color: textColor.withValues(alpha: 0.85),
                ),
              ),
            Text(
              message.text,
              style: theme.textTheme.bodyLarge?.copyWith(color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _toneIcon(Tone tone) {
    switch (tone) {
      case Tone.happy:
        return Icons.sentiment_satisfied_alt_rounded;
      case Tone.urgent:
        return Icons.priority_high_rounded;
      case Tone.sad:
        return Icons.sentiment_dissatisfied_rounded;
      case Tone.question:
        return Icons.help_outline_rounded;
      case Tone.angry:
        return Icons.mood_bad_rounded;
      case Tone.neutral:
        return Icons.remove_red_eye_outlined;
    }
  }

  String _formatTime(DateTime t) {
    final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
