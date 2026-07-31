import 'dart:convert';
import 'dart:typed_data';

import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:flutter/foundation.dart';

/// Parsed result of a single WebSocket message.
///
/// This is a simple sealed union so [WebSocketService] can route each result
/// to the correct stream controller without touching JSON or raw bytes.
sealed class ParsedWsMessage {
  const ParsedWsMessage();
}

class WsTextMessage extends ParsedWsMessage {
  const WsTextMessage(this.text);
  final String text;
}

class WsAudioMessage extends ParsedWsMessage {
  const WsAudioMessage(this.data);
  final Uint8List data;
}

class WsUserTranscriptMessage extends ParsedWsMessage {
  const WsUserTranscriptMessage(this.text);
  final String text;
}

class WsDoneMessage extends ParsedWsMessage {
  const WsDoneMessage();
}

class WsErrorMessage extends ParsedWsMessage {
  const WsErrorMessage(this.message);
  final String message;
}

class WsStatusMessage extends ParsedWsMessage {
  const WsStatusMessage(this.status);
  final String status;
}

/// Pure data transformer that converts raw WebSocket [dynamic] messages into
/// strongly-typed [ParsedWsMessage] objects.
///
/// Handles:
/// - Binary frames (raw PCM audio bytes)
/// - JSON text frames (text, audio-as-base64, user_transcript, done, error)
/// - Audio batching for performance (flushes at [_batchThreshold])
class WebSocketMessageParser {
  WebSocketMessageParser();

  final AppLogger _logger = AppLogger();

  // Audio batching — accumulates small chunks, flushes at threshold
  final BytesBuilder _audioBatcher = BytesBuilder();
  static const int _batchThreshold = 16384; // 16KB

  /// Parse a single raw WebSocket message into zero or more typed results.
  ///
  /// Returns a list because audio batching may yield 0 results (buffered)
  /// or 2 results when a `done` triggers a flush + done.
  List<ParsedWsMessage> parse(dynamic message) {
    try {
      // Binary frame → raw audio bytes
      if (message is List<int>) {
        return _addAudioBytes(Uint8List.fromList(message));
      }
      if (message is Uint8List) {
        return _addAudioBytes(message);
      }

      // JSON text frame
      if (message is String) {
        final json = jsonDecode(message) as Map<String, dynamic>;
        final type = json['type'] as String? ?? '';

        switch (type) {
          case 'audio':
            final b64 = json['data'] as String? ?? '';
            return _addAudioBytes(base64Decode(b64));

          case 'text':
          case 'output_transcription':
            final text = json['data'] as String? ?? '';
            if (kDebugMode) {
              _logger.d(
                '📥 WS TEXT received: '
                '${text.substring(0, text.length.clamp(0, 120))}',
              );
            }
            return [WsTextMessage(text)];

          case 'user_transcript':
            final text = json['data'] as String? ?? '';
            if (kDebugMode) {
              _logger.d('📥 WS USER_TRANSCRIPT received: $text');
            }
            return [WsUserTranscriptMessage(text)];

          case 'done':
            return _flushWithDone();

          case 'error':
            final errorMsg = json['message'] as String? ?? 'Unknown error';
            _logger.w('⚠️ Backend Error: $errorMsg');
            return [WsErrorMessage(errorMsg)];

          case 'status':
            final status = json['data'] as String? ?? '';
            if (kDebugMode) {
              _logger.d('📥 WS STATUS received: $status');
            }
            return [WsStatusMessage(status)];

          // Keep-alive pong from backend — silently ignore.
          case 'pong':
            return const [];

          default:
            return const [];
        }
      }

      return const [];
    } catch (e, st) {
      _logger.e('⚠️ Parse Error', e, st);
      return const [];
    }
  }

  /// Flush any remaining audio bytes in the batcher.
  ///
  /// Call this before disposing the parser or when the connection closes.
  List<ParsedWsMessage> flush() {
    if (_audioBatcher.isNotEmpty) {
      final data = _audioBatcher.takeBytes();
      if (kDebugMode) {
        _logger.d('📥 WS AUDIO flushed (${data.length} bytes)');
      }
      return [WsAudioMessage(data)];
    }
    return const [];
  }

  /// Reset internal state (e.g. on disconnect).
  void clear() => _audioBatcher.clear();

  // ── Private helpers ──────────────────────────────────────────────────

  List<ParsedWsMessage> _addAudioBytes(Uint8List bytes) {
    _audioBatcher.add(bytes);
    if (_audioBatcher.length >= _batchThreshold) {
      final data = _audioBatcher.takeBytes();
      if (kDebugMode) {
        _logger.d('📥 WS AUDIO received (${data.length} bytes)');
      }
      return [WsAudioMessage(data)];
    }
    return const [];
  }

  List<ParsedWsMessage> _flushWithDone() {
    final results = <ParsedWsMessage>[];
    // Flush any buffered audio before signalling done
    if (_audioBatcher.isNotEmpty) {
      final data = _audioBatcher.takeBytes();
      if (kDebugMode) {
        _logger.d('📥 WS AUDIO flushed (${data.length} bytes)');
      }
      results.add(WsAudioMessage(data));
    }
    _logger.i('✅ Stream Complete');
    results.add(const WsDoneMessage());
    return results;
  }
}
