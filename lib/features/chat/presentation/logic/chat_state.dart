part of 'chat_cubit.dart';

enum ChatStatus {
  initial,
  connecting,
  ready,
  listening,
  thinking,
  receiving,
  failure;

  bool get isInitial => this == ChatStatus.initial;
  bool get isConnecting => this == ChatStatus.connecting;
  bool get isReady => this == ChatStatus.ready;
  bool get isListening => this == ChatStatus.listening;
  bool get isThinking => this == ChatStatus.thinking;
  bool get isReceiving => this == ChatStatus.receiving;
  bool get isFailure => this == ChatStatus.failure;
}

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.errorMessage,
    this.wasVoiceInput = false,
  });
  final ChatStatus status;
  final List<ChatMessageModel> messages;
  final String? errorMessage;
  final bool wasVoiceInput;

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessageModel>? messages,
    String? errorMessage,
    bool? wasVoiceInput,
    bool clearErrorMessage = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      wasVoiceInput: wasVoiceInput ?? this.wasVoiceInput,
    );
  }

  /// True while the AI is actively generating a response.
  /// Used to block new sends and disable the input UI.
  bool get isBusy =>
      status == ChatStatus.thinking || status == ChatStatus.receiving;

  @override
  List<Object?> get props => [status, messages, errorMessage, wasVoiceInput];
}
