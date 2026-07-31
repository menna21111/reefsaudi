import 'dart:typed_data';

/// Strongly-typed events emitted by [IChatRepository] from the WebSocket.
///
/// Each subtype represents a distinct message type received from the backend,
/// replacing the raw `Map<String, dynamic>` / split-stream approach.
sealed class ChatEvent {
  const ChatEvent();
}

/// A chunk of the bot's text response (streamed incrementally).
class TextChunkEvent extends ChatEvent {
  const TextChunkEvent(this.text);
  final String text;

  @override
  String toString() => 'TextChunkEvent("$text")';
}

/// A chunk of audio data (PCM bytes) for TTS playback.
class AudioChunkEvent extends ChatEvent {
  const AudioChunkEvent(this.data);
  final Uint8List data;

  @override
  String toString() => 'AudioChunkEvent(${data.length} bytes)';
}

/// The user's speech-to-text transcript from Gemini Live STT.
class UserTranscriptEvent extends ChatEvent {
  const UserTranscriptEvent(this.text);
  final String text;

  @override
  String toString() => 'UserTranscriptEvent("$text")';
}

/// Signals that the current bot response is complete.
class DoneEvent extends ChatEvent {
  const DoneEvent();

  @override
  String toString() => 'DoneEvent()';
}

/// An error received from the backend.
class ErrorEvent extends ChatEvent {
  const ErrorEvent(this.message);
  final String message;

  @override
  String toString() => 'ErrorEvent("$message")';
}

/// A live status update from the AI's thinking process.
class StatusEvent extends ChatEvent {
  const StatusEvent(this.status);
  final String status;

  @override
  String toString() => 'StatusEvent("$status")';
}
