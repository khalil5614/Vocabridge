enum MessageSender { user, other }

enum Tone { neutral, happy, urgent, sad, question, angry }

class Message {
  final String id;
  final String text;
  final MessageSender sender;
  final DateTime timestamp;
  final Tone tone;

  Message({
    required this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.tone = Tone.neutral,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'sender': sender.name,
        'timestamp': timestamp.toIso8601String(),
        'tone': tone.name,
      };

  factory Message.fromMap(Map<String, dynamic> map) => Message(
        id: map['id'],
        text: map['text'],
        sender: MessageSender.values.byName(map['sender']),
        timestamp: DateTime.parse(map['timestamp']),
        tone: Tone.values.byName(map['tone'] ?? 'neutral'),
      );
}

/// A saved phrase, either a quick phrase, favorite, or symbol-linked phrase.
class Phrase {
  final String id;
  final String text;
  final String? iconAsset; // for symbol board
  final String category;
  bool isFavorite;
  int useCount;

  Phrase({
    required this.id,
    required this.text,
    this.iconAsset,
    this.category = 'general',
    this.isFavorite = false,
    this.useCount = 0,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'iconAsset': iconAsset,
        'category': category,
        'isFavorite': isFavorite,
        'useCount': useCount,
      };

  factory Phrase.fromMap(Map<String, dynamic> map) => Phrase(
        id: map['id'],
        text: map['text'],
        iconAsset: map['iconAsset'],
        category: map['category'] ?? 'general',
        isFavorite: map['isFavorite'] ?? false,
        useCount: map['useCount'] ?? 0,
      );
}
