import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

/// The role of a chat message sender.
enum MessageRole {
  user,
  assistant;

  bool get isUser => this == MessageRole.user;
  bool get isAssistant => this == MessageRole.assistant;
}

/// Strongly-typed model for a single chat message.
///
/// Replaces the raw `Map<String, String>` used previously in [ChatState].
class ChatMessageModel extends Equatable {
  ChatMessageModel({
    required this.role,
    required this.text,
    this.rating,
    this.isVoice = false,
    this.thinkingSteps = const [],
    this.isGenerating = false,
    this.isThinkingExpanded = false,
    String? id,
  }) : id = id ?? const Uuid().v4();

  /// Unique identifier generated via epoch timestamp
  final String id;

  /// Who sent this message.
  final MessageRole role;

  /// The message content.
  final String text;

  /// User feedback: `'thumbs_up'` | `'thumbs_down'` | `null` (unrated).
  final String? rating;

  /// Whether this message was spoken (voice input/output).
  final bool isVoice;

  /// Accumulated AI thinking/status steps (e.g., "Searching database...").
  final List<String> thinkingSteps;

  /// True while the AI is actively generating this message.
  /// Used by [DynamicThinkingBlock] to determine Phase 1 vs Phase 2.
  final bool isGenerating;

  /// Whether the thinking accordion is expanded (Phase 2 UI state).
  final bool isThinkingExpanded;

  ChatMessageModel copyWith({
    String? id,
    MessageRole? role,
    String? text,
    String? rating,
    bool? isVoice,
    List<String>? thinkingSteps,
    bool? isGenerating,
    bool? isThinkingExpanded,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      role: role ?? this.role,
      text: text ?? this.text,
      rating: rating ?? this.rating,
      isVoice: isVoice ?? this.isVoice,
      thinkingSteps: thinkingSteps ?? this.thinkingSteps,
      isGenerating: isGenerating ?? this.isGenerating,
      isThinkingExpanded: isThinkingExpanded ?? this.isThinkingExpanded,
    );
  }

  @override
  List<Object?> get props => [
    id,
    role,
    text,
    rating,
    isVoice,
    thinkingSteps,
    isGenerating,
    isThinkingExpanded,
  ];
}
