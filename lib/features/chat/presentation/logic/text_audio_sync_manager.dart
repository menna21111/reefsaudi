import 'dart:async';

import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';

/// Manages the complex timing synchronization between incoming text and audio chunks.
///
/// Ensures that text (which arrives quickly) is delayed to visually sync
/// with the spoken audio (which arrives and plays more slowly).
class TextAudioSyncManager {
  TextAudioSyncManager({required this.onTextReadyToEmit});

  /// Callback fired when the manager determines text should be emitted
  /// to the UI state.
  final void Function(String fullText) onTextReadyToEmit;

  final AppLogger _logger = AppLogger();

  final StringBuffer _currentResponseBuffer = StringBuffer();
  Timer? _throttleTimer;

  bool _isPlayingAudio = false;
  bool _audioDelayApplied = false;
  DateTime? _firstAudioChunkTime;
  bool _awaitingAudioForCurrentResponse = false;
  bool _isClosed = false;

  /// Call this when a text chunk arrives from the backend.
  void onTextChunkReceived(String text, {required bool wasVoiceInput}) {
    _logger.d('📥 Text chunk received: "$text"');
    _currentResponseBuffer.write(text);

    // Text-only (keyboard) input: no audio to sync with, display immediately.
    if (!wasVoiceInput) {
      _processTextUpdate();
      return;
    }

    // Hold text until first audio chunk arrives (text often arrives first)
    if (!_isPlayingAudio) {
      _awaitingAudioForCurrentResponse = true;
      return;
    }

    // Apply delay so text appears ~in sync with voice (not before it)
    if (!_audioDelayApplied && _firstAudioChunkTime != null) {
      final timeSinceFirstAudio = DateTime.now().difference(
        _firstAudioChunkTime!,
      );
      const totalDelay = Duration(seconds: 3);

      if (timeSinceFirstAudio < totalDelay) {
        final remainingDelay = totalDelay - timeSinceFirstAudio;
        _logger.d(
          '⏳ Delaying text by ${remainingDelay.inMilliseconds}ms for sync',
        );
        Timer(remainingDelay, () {
          if (_isClosed) {
            return;
          }
          _audioDelayApplied = true;
          _processTextUpdate();
        });
        return;
      }
      _audioDelayApplied = true;
    }

    _processTextUpdate();
  }

  /// Call this when an audio chunk arrives from the backend.
  void onAudioChunkReceived() {
    if (!_isPlayingAudio) {
      _isPlayingAudio = true;
      _audioDelayApplied = false;
      _firstAudioChunkTime = DateTime.now();
      _logger.d('🔊 First audio chunk - starting text delay window');

      // If we buffered text before audio, show it after delay
      if (_awaitingAudioForCurrentResponse) {
        _awaitingAudioForCurrentResponse = false;
        Timer(const Duration(seconds: 3), () {
          if (_isClosed) {
            return;
          }
          _audioDelayApplied = true;
          _processTextUpdate();
        });
      }
    }
  }

  /// Reset the sync tracking state for a new message.
  void reset() {
    _currentResponseBuffer.clear();
    _isPlayingAudio = false;
    _audioDelayApplied = false;
    _firstAudioChunkTime = null;
    _awaitingAudioForCurrentResponse = false;
    _throttleTimer?.cancel();
  }

  /// Call this when the stream is completely done.
  /// Flushes any pending text immediately.
  void onDone() {
    _isPlayingAudio = false;
    _audioDelayApplied = false;
    _firstAudioChunkTime = null;
    _awaitingAudioForCurrentResponse = false;
    _throttleTimer?.cancel();

    // Flush immediately instead of throttling
    onTextReadyToEmit(_currentResponseBuffer.toString());
  }

  void _processTextUpdate() {
    if (_throttleTimer?.isActive ?? false) {
      return;
    }

    _throttleTimer = Timer(const Duration(milliseconds: 200), () {
      if (_isClosed) {
        return;
      }
      onTextReadyToEmit(_currentResponseBuffer.toString());
    });
  }

  /// Call when the cubit is closed so timers don't fire on dead objects.
  void dispose() {
    _isClosed = true;
    _throttleTimer?.cancel();
  }
}
