import 'dart:typed_data';

import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:flutter_soloud/flutter_soloud.dart'
    show AudioSource, Channels, SoLoud, SoundHandle;

/// Manages SoLoud audio playback for TTS streaming, extracted from
/// [ChatScreen].
///
/// Responsibilities:
/// - Initialize / deinitialize the SoLoud engine
/// - Create and manage buffer-stream sources
/// - Feed PCM audio chunks for real-time playback
/// - Handle buffer errors with automatic stream recovery
class AudioPlayerService {
  AudioPlayerService();

  final AppLogger _logger = AppLogger();

  late SoLoud _soloud;
  AudioSource? _streamingSource;
  SoundHandle? _currentHandle;
  int _currentChunkCount = 0;
  bool _initialized = false;

  /// Whether the SoLoud engine is initialized and ready.
  bool get isInitialized => _initialized;

  /// Initialize the SoLoud engine.
  ///
  /// Must be called once before [feedChunk] or [reset]. Typically called in
  /// the ChatScreen's `initState`.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    try {
      _soloud = SoLoud.instance;
      // Backend sends 24kHz mono PCM
      await _soloud.init(sampleRate: 24000, channels: Channels.mono);
      await _setupBufferStream();
      _initialized = true;
      _logger.d('✅ AudioPlayerService initialized');
    } catch (e, st) {
      // Native SoLoud may be missing until a clean rebuild / pod install.
      // Chat text still works without TTS playback.
      _initialized = false;
      _logger.e(
        '⚠️ AudioPlayerService init failed — voice playback disabled',
        e,
        st,
      );
    }
  }

  /// Feed a chunk of PCM audio data for playback.
  ///
  /// Automatically starts playback on the first chunk and handles
  /// buffer-full errors by resetting the stream transparently.
  void feedChunk(Uint8List chunk) {
    if (!_initialized || _streamingSource == null) {
      return;
    }

    try {
      _soloud.addAudioDataStream(_streamingSource!, chunk);
      _currentChunkCount++;

      // Ensure it's playing
      if (_currentHandle == null ||
          !_soloud.getIsValidVoiceHandle(_currentHandle!)) {
        // Start at 0 volume to avoid "pop", then fade in
        _soloud.play(_streamingSource!, volume: 0).then((handle) {
          _currentHandle = handle;
          _soloud.fadeVolume(handle, 1, const Duration(milliseconds: 80));
        });
      }
    } catch (e, st) {
      final errorMsg = e.toString();
      if (errorMsg.contains('Buffer') ||
          errorMsg.contains('SoLoud') ||
          errorMsg.contains('ended')) {
        _logger.w(
          '🔄 Buffer error at chunk $_currentChunkCount, resetting: '
          '$errorMsg',
        );
        _resetAndContinueSync(chunk);
      } else {
        _logger.e('Audio Feed Error', e, st);
      }
    }
  }

  /// Reset the audio stream (stop current playback, create fresh buffer).
  ///
  /// Call when the user sends a new message or presses the mic button.
  Future<void> reset() async {
    if (!_initialized) {
      return;
    }

    // Stop current playback
    if (_currentHandle != null) {
      await _soloud.stop(_currentHandle!);
      _currentHandle = null;
    }

    // Mark stream as ended and dispose
    if (_streamingSource != null) {
      try {
        _soloud.setDataIsEnded(_streamingSource!);
      } catch (_) {
        _logger.d('Note: Stream already ended or disposed');
      }
      await _soloud.disposeSource(_streamingSource!);
      _streamingSource = null;
    }

    _currentChunkCount = 0;
    await _setupBufferStream();
  }

  Future<void> _setupBufferStream() async {
    try {
      _streamingSource = _soloud.setBufferStream(
        maxBufferSizeBytes:
            10 * 1024 * 1024, // 10MB (handles very long responses)
        bufferingTimeNeeds: 0.1, // 100ms initial buffering
      );
      _logger.d('✅ Buffer stream source created (10MB)');
    } catch (e, st) {
      _logger.e('Setup Stream Error', e, st);
    }
  }

  void _resetAndContinueSync(Uint8List newChunk) {
    final oldHandle = _currentHandle;
    final oldSource = _streamingSource;

    try {
      _streamingSource = _soloud.setBufferStream(
        maxBufferSizeBytes: 10 * 1024 * 1024,
        bufferingTimeNeeds: 0.1,
      );
      _currentChunkCount = 0;
      _logger.d('✅ New audio stream created');

      _soloud.addAudioDataStream(_streamingSource!, newChunk);
      _currentChunkCount = 1;

      // Start playing new stream (volume 0 → fade in)
      _soloud.play(_streamingSource!, volume: 0).then((newHandle) {
        _currentHandle = newHandle;
        _soloud.fadeVolume(newHandle, 1, const Duration(milliseconds: 80));
        _logger.d('▶️ Playing new stream');

        // Clean up old stream after new one started
        Future.delayed(const Duration(milliseconds: 100), () {
          if (oldHandle != null) {
            _soloud.stop(oldHandle);
          }
          if (oldSource != null) {
            try {
              _soloud
                ..setDataIsEnded(oldSource)
                ..disposeSource(oldSource);
            } catch (e) {
              // Ignore cleanup errors
            }
          }
        });
      });
    } catch (e, st) {
      _logger.e('Error creating new stream', e, st);
      if (oldSource != null) {
        try {
          _soloud
            ..setDataIsEnded(oldSource)
            ..disposeSource(oldSource);
        } catch (_) {}
      }
    }
  }

  /// Release all resources. Call when the service is no longer needed.
  Future<void> dispose() async {
    if (!_initialized) {
      return;
    }

    if (_streamingSource != null) {
      await _soloud.disposeSource(_streamingSource!);
      _streamingSource = null;
    }
    _soloud.deinit();
    _initialized = false;
    _logger.d('🔴 AudioPlayerService disposed');
  }
}
