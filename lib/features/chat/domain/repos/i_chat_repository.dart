import 'dart:typed_data';

import 'package:reefsaudia/features/chat/domain/models/chat_event.dart';

/// Abstract interface for the chat data source.
///
/// Enforces the Dependency Inversion Principle (DIP): the Presentation layer
/// depends on this abstraction, not on the concrete [WebSocketService].
abstract interface class IChatRepository {
  /// Merged stream of all typed [ChatEvent]s from the backend.
  ///
  /// The repository parses raw WebSocket messages and yields clean,
  /// strongly-typed events.
  Stream<ChatEvent> get chatEvents;

  /// Raw audio byte stream for the audio player (TTS playback).
  ///
  /// Kept separate from [chatEvents] because the audio player needs
  /// direct `Uint8List` chunks without wrapping/unwrapping overhead.
  Stream<Uint8List> get rawAudioStream;

  /// Connect to the WebSocket backend at [url].
  void connect(String url);

  /// Send a text message to the backend.
  ///
  /// Set [isVoice] to `true` when the text originated from voice input.
  void sendMessage(String messageId, String text, {bool isVoice = false});

  /// Send raw audio bytes (PCM) from the microphone to the backend.
  void sendAudio(Uint8List data);

  /// Signal the end of an audio recording session.
  void sendAudioEnd(String messageId);

  /// Signal cancellation of an audio recording (swipe-to-cancel).
  void sendAudioCancel();

  /// Send thumbs-up/thumbs-down feedback for a bot response.
  ///
  /// [rating] is `1` for thumbs_up or `-1` for thumbs_down.
  void sendFeedback(String messageId, int rating);

  /// Send supplementary feedback details (category + optional comment).
  void sendFeedbackDetails(
    String messageId,
    int rating,
    String category,
    String comment,
  );

  /// Reset the conversation (start a new chat).
  void sendNewChat();

  /// Disconnect from the WebSocket.
  void disconnect();

  /// Release resources. Called by the DI container on teardown.
  void dispose();
}
