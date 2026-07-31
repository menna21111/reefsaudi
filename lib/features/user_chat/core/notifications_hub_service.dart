import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/network/api_constant.dart';
import '../../../../core/services/token_service/token_storage.dart';
import '../data/models/user_chat_models.dart';

/// SignalR JSON hub client for `hubs/notifications`.
///
/// Matches the web client: skip negotiation, WebSockets only, listen for
/// `NewMessagePushed` / `NotificationPushed`.
class NotificationsHubService {
  NotificationsHubService(this._tokenStorage);

  final TokenStorage _tokenStorage;

  static const _recordSeparator = '\u001e';

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  bool _disposed = false;
  bool _handshakeDone = false;
  bool _isConnecting = false;
  String _buffer = '';
  String _currentUserId = '';
  int _reconnectAttempts = 0;

  final _messageController = StreamController<UserChatPushEvent>.broadcast();
  final _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  Stream<UserChatPushEvent> get onNewMessage => _messageController.stream;
  Stream<Map<String, dynamic>> get onNotification =>
      _notificationController.stream;
  Stream<bool> get onConnectionChanged => _connectionController.stream;

  bool get isConnected => _channel != null && _handshakeDone;

  Future<void> connect({required String currentUserId}) async {
    _currentUserId = currentUserId;
    _disposed = false;
    await _open();
  }

  Future<void> _open() async {
    if (_disposed) return;
    if (_isConnecting) return;
    _isConnecting = true;

    try {
      final token = await _tokenStorage.getToken();
      final jwe = ApiConstants.normalizeJweAccessToken(token);
      if (jwe == null || jwe.isEmpty) {
        if (kDebugMode) {
          debugPrint('NotificationsHub: no access token');
        }
        return;
      }

      await _closeSocket(reconnect: false);

      final uri = _hubUri(jwe);
      if (kDebugMode) {
        debugPrint(
          'NotificationsHub connecting: '
          '${uri.scheme}://${uri.host}${uri.path}',
        );
      }

      final channel = IOWebSocketChannel.connect(uri);
      // Wait for the TCP/TLS upgrade so connection errors surface here
      // instead of as an unhandled stream exception later.
      await channel.ready;

      if (_disposed) {
        await channel.sink.close();
        return;
      }

      _channel = channel;
      _handshakeDone = false;
      _buffer = '';
      _reconnectAttempts = 0;

      _sub = channel.stream.listen(
        _onData,
        onError: (Object e, StackTrace st) {
          if (kDebugMode) {
            debugPrint('NotificationsHub stream error: $e');
          }
          _connectionController.add(false);
          _scheduleReconnect();
        },
        onDone: () {
          if (kDebugMode) {
            debugPrint('NotificationsHub closed');
          }
          _connectionController.add(false);
          _scheduleReconnect();
        },
        cancelOnError: false,
      );

      // SignalR handshake (see screenshot Messages tab).
      channel.sink.add('{"protocol":"json","version":1}$_recordSeparator');
    } on Object catch (e) {
      // Swallow connect failures (bad URL, network, 401, etc.) and retry.
      if (kDebugMode) {
        debugPrint('NotificationsHub connect failed: $e');
      }
      _channel = null;
      _handshakeDone = false;
      _connectionController.add(false);
      _scheduleReconnect();
    } finally {
      _isConnecting = false;
    }
  }

  /// Builds `wss://host/hubs/notifications?access_token=...`
  ///
  /// Important: never pass `port: 0` into [Uri] — Dart serializes that as
  /// `:0` and the WebSocket handshake fails.
  Uri _hubUri(String accessToken) {
    final api = Uri.parse(ApiConstants.reefBaseUrl);
    final scheme =
        (api.scheme == 'https' || api.scheme == 'wss') ? 'wss' : 'ws';
    final host = api.host.isNotEmpty ? api.host : 'apiour.mohamedelsayed.site';

    final hasCustomPort = api.hasPort &&
        api.port > 0 &&
        api.port != 80 &&
        api.port != 443;
    final authority = hasCustomPort ? '$host:${api.port}' : host;

    return Uri.parse(
      '$scheme://$authority/hubs/notifications'
      '?access_token=${Uri.encodeQueryComponent(accessToken)}',
    );
  }

  void _onData(dynamic data) {
    final chunk = data is String ? data : utf8.decode(data as List<int>);
    _buffer += chunk;

    while (true) {
      final idx = _buffer.indexOf(_recordSeparator);
      if (idx < 0) break;
      final frame = _buffer.substring(0, idx).trim();
      _buffer = _buffer.substring(idx + 1);
      if (frame.isEmpty) continue;
      _handleFrame(frame);
    }
  }

  void _handleFrame(String frame) {
    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(frame);
      if (decoded is Map<String, dynamic>) {
        json = decoded;
      }
    } catch (_) {
      return;
    }
    if (json == null) return;

    // Handshake ack is `{}`.
    if (!_handshakeDone && json.isEmpty) {
      _handshakeDone = true;
      _connectionController.add(true);
      _startPing();
      if (kDebugMode) debugPrint('NotificationsHub connected');
      return;
    }

    final type = json['type'];
    // type 6 = ping; reply with ping to keep alive (web also exchanges type 6).
    if (type == 6) {
      _channel?.sink.add('{"type":6}$_recordSeparator');
      return;
    }

    // type 1 = Invocation
    if (type == 1) {
      final target = json['target']?.toString();
      final args = json['arguments'];
      final payload = (args is List && args.isNotEmpty && args.first is Map)
          ? Map<String, dynamic>.from(args.first as Map)
          : <String, dynamic>{};

      if (kDebugMode) {
        debugPrint('NotificationsHub target: $target');
        debugPrint('NotificationsHub payload: ${jsonEncode(payload)}');
      }

      if (target == 'NewMessagePushed') {
        _messageController.add(
          UserChatPushEvent.fromJson(
            payload,
            currentUserId: _currentUserId,
          ),
        );
      } else if (target == 'NotificationPushed') {
        _notificationController.add(payload);
      }
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_channel == null || !_handshakeDone) return;
      _channel!.sink.add('{"type":6}$_recordSeparator');
    });
  }

  void _scheduleReconnect() {
    _pingTimer?.cancel();
    _handshakeDone = false;
    if (_disposed) return;
    if (_reconnectTimer?.isActive ?? false) return;

    // Cap at ~32s: 1, 2, 4, 8, 16, 32
    final delaySeconds = 1 << _reconnectAttempts.clamp(0, 5);
    _reconnectAttempts++;

    if (kDebugMode) {
      debugPrint(
        'NotificationsHub reconnect in ${delaySeconds}s '
        '(attempt $_reconnectAttempts)',
      );
    }

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      _reconnectTimer = null;
      if (_disposed) return;
      unawaited(_open());
    });
  }

  Future<void> _closeSocket({required bool reconnect}) async {
    _pingTimer?.cancel();
    _pingTimer = null;
    await _sub?.cancel();
    _sub = null;
    try {
      await _channel?.sink.close();
    } catch (_) {}
    _channel = null;
    _handshakeDone = false;
    if (!reconnect) {
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
    }
  }

  Future<void> disconnect() async {
    _disposed = true;
    _reconnectAttempts = 0;
    await _closeSocket(reconnect: false);
  }

  Future<void> dispose() async {
    await disconnect();
    await _messageController.close();
    await _notificationController.close();
    await _connectionController.close();
  }
}
