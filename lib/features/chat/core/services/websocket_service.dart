import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:reefsaudia/features/chat/core/services/connectivity_service.dart';
import 'package:reefsaudia/features/chat/core/services/websocket_message_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketService(this._connectivityService) {
    _connectivitySub = _connectivityService.onStatusChange.listen((
      hasInternet,
    ) async {
      if (hasInternet &&
          _channel == null &&
          !_isConnecting &&
          _targetUrl != null) {
        _logger.i('🌐 Internet restored — instant reconnect to $_targetUrl');
        _reconnectAttempts = 0; // bypass exponential backoff
        await connect(_targetUrl!);
      }
    });
  }

  final ConnectivityService _connectivityService;
  StreamSubscription<bool>? _connectivitySub;

  bool _isConnecting = false;
  Timer? _heartbeatTimer;
  WebSocketChannel? _channel;
  final StreamController<String> _textController =
      StreamController<String>.broadcast();
  final StreamController<Uint8List> _audioController =
      StreamController<Uint8List>.broadcast();
  final StreamController<String> _userTranscriptController =
      StreamController<String>.broadcast();
  final StreamController<void> _doneController =
      StreamController<void>.broadcast();
  final StreamController<String> _statusController =
      StreamController<String>.broadcast();

  Stream<String> get textStream => _textController.stream;
  Stream<Uint8List> get audioStream => _audioController.stream;
  Stream<String> get userTranscriptStream => _userTranscriptController.stream;
  Stream<void> get doneStream => _doneController.stream;
  Stream<String> get statusStream => _statusController.stream;

  final AppLogger _logger = AppLogger();
  final WebSocketMessageParser _parser = WebSocketMessageParser();

  bool get isConnected => _channel != null;

  /// The URL we intend to stay connected to.
  /// Set when connect() is called, cleared only on explicit disconnect().
  /// This persists through network drops so reconnect always knows where to go.
  String? _targetUrl;

  /// Counter for exponential backoff during reconnects
  int _reconnectAttempts = 0;

  /// Pending reconnect — cancelled on [disconnect] so we don't keep
  /// reconnecting after the user leaves chat.
  Timer? _reconnectTimer;

  void _cancelReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  void _scheduleReconnect(String url) {
    // Already waiting — don't stack multiple timers.
    if (_reconnectTimer?.isActive ?? false) {
      return;
    }

    // Max out at around 32 seconds (2^5)
    final delaySeconds = 1 << _reconnectAttempts.clamp(0, 5);
    _reconnectAttempts++;

    _logger.i(
      '⏳ Scheduling reconnect attempt $_reconnectAttempts '
      'in $delaySeconds seconds...',
    );
    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () async {
      _reconnectTimer = null;
      // User left chat / explicit disconnect — do not reconnect.
      if (_targetUrl == null || _targetUrl != url) {
        _logger.d('🔌 Reconnect skipped — no active target URL');
        return;
      }
      await connect(url);
    });
  }

  Future<void> connect(String url) async {
    if (kDebugMode) {
      _logger.d('🔌 CONNECT CALLED FROM:\n${StackTrace.current}');
    }

    if (_isConnecting) {
      _logger.d('🔌 Already connecting, skipping redundant connect request');
      return;
    }

    // Guard: already connected to same URL, skip redundant reconnect
    if (_channel != null && _targetUrl == url) {
      _logger.d('🔌 Already connected to same URL, skipping reconnect');
      return;
    }

    _isConnecting = true;
    try {
      // Remember where we want to be connected — persists through drops.
      _targetUrl = url;

      // Log when we close a previous connection before reconnect
      if (_channel != null) {
        _logger.i('🔌 Disconnecting previous connection before reconnect');
        if (kDebugMode) {
          _logger.d('🔌 PRE-RECONNECT DISCONNECT FROM:\n${StackTrace.current}');
        }
      }
      unawaited(_channel?.sink.close());
      _channel = null;
      _parser.clear();
      _heartbeatTimer?.cancel();
      _heartbeatTimer = null;

      _logger.i('🔌 Connecting to WebSocket: $url');
      if (kIsWeb) {
        // Standard connection for Web (dart:io WebSocket isn't supported)
        final uri = Uri.parse(url);
        _channel = WebSocketChannel.connect(uri);
        await _channel!.ready;
      } else {
        // Custom connection for Native (Android/iOS) to bypass IIS compression bug
        // ignore: close_sinks
        final socket = await WebSocket.connect(
          url,
          compression:
              CompressionOptions.compressionOff, // THIS BYPASSES THE IIS BUG
        );
        // We still use IOWebSocketChannel to maintain the stream abstraction
        _channel = IOWebSocketChannel(socket);
      }

      _logger.i('✅ WebSocket Connected');
      _reconnectAttempts = 0; // Reset counter on successful connection
      _startHeartbeat(); // Keep Cloudflare/IIS tunnel alive

      _channel!.stream.listen(
        _onMessage,
        onError: (error, stackTrace) {
          _logger.e('❌ WebSocket Error', error, stackTrace as StackTrace?);
          // Stop heartbeat so we don't ping a dead channel
          _heartbeatTimer?.cancel();
          _heartbeatTimer = null;
          if (_channel != null) {
            _logger.i('🔄 Attempting automatic reconnect...');
            final reconnectUrl = _targetUrl;
            _channel = null;
            // Do NOT clear _targetUrl — connectivity listener needs it.
            if (reconnectUrl != null) {
              _scheduleReconnect(reconnectUrl);
            }
          }
        },
        onDone: () {
          _logger.i('🔌 WebSocket Closed');
          _flushParser();
          if (kDebugMode) {
            _logger.d('🔌 STREAM CLOSED FROM:\n${StackTrace.current}');
          }
          // Stop heartbeat so we don't ping a dead channel
          _heartbeatTimer?.cancel();
          _heartbeatTimer = null;
          final wasUnexpected = _channel != null;
          final reconnectUrl = _targetUrl;
          _channel = null;
          // Do NOT clear _targetUrl — connectivity listener needs it.
          if (wasUnexpected && reconnectUrl != null) {
            _logger.i('🔄 Unexpected close, attempting reconnect...');
            _scheduleReconnect(reconnectUrl);
          }
        },
        cancelOnError: false,
      );
    } catch (e, st) {
      _channel = null;
      // Do NOT clear _targetUrl — connectivity listener needs it for retry.
      _logger.e('❌ Connection Failed', e, st);
      final reconnectUrl = _targetUrl;
      if (reconnectUrl != null) {
        _scheduleReconnect(reconnectUrl);
      }
    } finally {
      _isConnecting = false;
    }
  }

  void _onMessage(dynamic message) {
    final results = _parser.parse(message);
    _routeParsedMessages(results);
  }

  void _flushParser() {
    final results = _parser.flush();
    _routeParsedMessages(results);
  }

  void _routeParsedMessages(List<ParsedWsMessage> messages) {
    for (final msg in messages) {
      switch (msg) {
        case WsTextMessage(:final text):
          _textController.add(text);
        case WsAudioMessage(:final data):
          _audioController.add(data);
        case WsUserTranscriptMessage(:final text):
          _userTranscriptController.add(text);
        case WsDoneMessage():
          _doneController.add(null);
        case WsErrorMessage(:final message):
          _textController.addError(message);
        case WsStatusMessage(:final status):
          _statusController.add(status);
      }
    }
  }

  void send(String text) {
    if (_channel != null) {
      if (kDebugMode) {
        final preview = text.substring(0, text.length.clamp(0, 120));
        _logger.d('📤 WS SEND text: $preview');
      }
      _channel!.sink.add(text);
    } else {
      _logger.w('⚠️ Cannot send, WebSocket not connected');
    }
  }

  /// Send raw audio bytes to the backend for Gemini Live STT
  void sendAudio(Uint8List audioData) {
    if (_channel != null) {
      _channel!.sink.add(audioData);
      _logger.d('📤 Sent ${audioData.length} bytes to backend');
    } else {
      _logger.w('⚠️ Cannot send audio, WebSocket not connected');
    }
  }

  /// Signal end of audio stream
  void sendAudioEnd(String messageId) {
    if (kDebugMode) {
      _logger.d('📤 WS SEND audio_end signal for messageId: $messageId');
    }
    send(jsonEncode({'type': 'audio_end', 'message_id': messageId}));
  }

  /// Signal cancellation of audio (swipe to cancel) – backend clears buffer
  void sendAudioCancel() {
    if (kDebugMode) {
      _logger.d('📤 WS SEND audio_cancel signal');
    }
    send(jsonEncode({'type': 'audio_cancel'}));
  }

  /// Send thumbs up / down feedback for a bot response.
  /// Converts the parameters into the JSONL RAG schema structure.
  void sendFeedback(String messageId, int rating) {
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({
          'type': 'feedback',
          'message_id': messageId,
          'rating': rating,
        }),
      );
      if (kDebugMode) {
        _logger.d('📝 Feedback sent: $rating');
      }
    }
  }

  /// Send supplementary feedback details (category + optional comment).
  void sendFeedbackDetails(
    String messageId,
    int rating,
    String category,
    String comment,
  ) {
    if (_channel != null) {
      _channel!.sink.add(
        jsonEncode({
          'type': 'feedback_details',
          'message_id': messageId,
          'rating': rating,
          'category': category,
          'feedback_text': comment,
        }),
      );
      if (kDebugMode) {
        _logger.d('📝 Feedback details sent: category=$category');
      }
    }
  }

  void disconnect() {
    _cancelReconnect();
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    _reconnectAttempts = 0;
    if (_channel != null) {
      if (kDebugMode) {
        _logger
          ..d('🔌 WebSocket disconnect() called')
          ..d('🔌 DISCONNECT CALLED FROM:\n${StackTrace.current}');
      }
      // Clear target before closing so onDone does not schedule reconnect.
      _targetUrl = null;
      _channel!.sink.close();
      _channel = null;
    } else {
      // Only here (explicit user-initiated disconnect) do we clear _targetUrl,
      // so the connectivity listener knows not to auto-reconnect.
      _targetUrl = null;
    }
    _parser.clear();
  }

  /// Starts (or restarts) the 30-second heartbeat timer.
  /// Sends a ping frame to keep Cloudflare/IIS idle-timeout from
  /// silently cutting the WebSocket tunnel.
  void _startHeartbeat() {
    _heartbeatTimer?.cancel(); // cancel any previous timer first
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (_channel != null) {
        _channel!.sink.add(jsonEncode({'type': 'ping'}));
        if (kDebugMode) {
          _logger.d('💓 Heartbeat ping sent');
        }
      }
    });
  }

  void dispose() {
    if (kDebugMode) {
      _logger.d('🔴 DISPOSE CALLED FROM:\n${StackTrace.current}');
    }
    _connectivitySub?.cancel();
    _heartbeatTimer?.cancel(); // safety net before disconnect
    disconnect();
    _textController.close();
    _audioController.close();
    _userTranscriptController.close();
    _doneController.close();
    _statusController.close();
  }
}
