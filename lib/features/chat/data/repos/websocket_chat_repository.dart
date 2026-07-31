import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:reefsaudia/features/chat/domain/models/chat_event.dart';
import 'package:reefsaudia/features/chat/domain/repos/i_chat_repository.dart';
import 'package:reefsaudia/features/chat/core/services/websocket_service.dart';

/// Concrete [IChatRepository] backed by [WebSocketService].
///
/// Listens to the raw WebSocket streams, parses them, and yields
/// strongly-typed [ChatEvent] objects to the Presentation layer.
class WebSocketChatRepository implements IChatRepository {
  WebSocketChatRepository(this._webSocketService);

  final WebSocketService _webSocketService;

  final StreamController<ChatEvent> _eventController =
      StreamController<ChatEvent>.broadcast();

  StreamSubscription<String>? _textSub;
  StreamSubscription<String>? _userTranscriptSub;
  StreamSubscription<Uint8List>? _audioSub;
  StreamSubscription<void>? _doneSub;
  StreamSubscription<String>? _statusSub;

  @override
  Stream<ChatEvent> get chatEvents => _eventController.stream;

  @override
  Stream<Uint8List> get rawAudioStream => _webSocketService.audioStream;

  @override
  void connect(String url) {
    _webSocketService.connect(url);
    _subscribeToStreams();
  }

  void _subscribeToStreams() {
    // Cancel any existing subscriptions
    _textSub?.cancel();
    _userTranscriptSub?.cancel();
    _audioSub?.cancel();
    _doneSub?.cancel();
    _statusSub?.cancel();

    // Map text stream → TextChunkEvent
    _textSub = _webSocketService.textStream.listen(
      (text) => _eventController.add(TextChunkEvent(text)),
      onError: (e) => _eventController.add(ErrorEvent(e.toString())),
    );

    // Map user transcript stream → UserTranscriptEvent
    _userTranscriptSub = _webSocketService.userTranscriptStream.listen((text) {
      if (text.trim().isNotEmpty) {
        _eventController.add(UserTranscriptEvent(text));
      }
    });

    // Map audio stream → AudioChunkEvent
    _audioSub = _webSocketService.audioStream.listen(
      (chunk) => _eventController.add(AudioChunkEvent(chunk)),
      onError: (e) => _eventController.add(ErrorEvent(e.toString())),
    );

    // Map done stream → DoneEvent
    _doneSub = _webSocketService.doneStream.listen(
      (_) => _eventController.add(const DoneEvent()),
    );

    // Map status stream → StatusEvent
    _statusSub = _webSocketService.statusStream.listen(
      (status) => _eventController.add(StatusEvent(status)),
    );
  }

  @override
  void sendMessage(String messageId, String text, {bool isVoice = false}) {
    final payload = jsonEncode({
      'text': text,
      'is_voice': isVoice,
      'message_id': messageId,
    });
    _webSocketService.send(payload);
  }

  @override
  void sendAudio(Uint8List data) {
    _webSocketService.sendAudio(data);
  }

  @override
  void sendAudioEnd(String messageId) {
    _webSocketService.sendAudioEnd(messageId);
  }

  @override
  void sendAudioCancel() {
    _webSocketService.sendAudioCancel();
  }

  @override
  void sendFeedback(String messageId, int rating) {
    _webSocketService.sendFeedback(messageId, rating);
  }

  @override
  void sendFeedbackDetails(
    String messageId,
    int rating,
    String category,
    String comment,
  ) {
    _webSocketService.sendFeedbackDetails(messageId, rating, category, comment);
  }

  @override
  void sendNewChat() {
    _webSocketService.send(jsonEncode({'type': 'new_chat'}));
  }

  @override
  void disconnect() {
    _textSub?.cancel();
    _userTranscriptSub?.cancel();
    _audioSub?.cancel();
    _doneSub?.cancel();
    _statusSub?.cancel();
    _webSocketService.disconnect();
  }

  /// Release resources. Called by DI container on teardown.
  @override
  void dispose() {
    disconnect();
    _eventController.close();
  }
}
