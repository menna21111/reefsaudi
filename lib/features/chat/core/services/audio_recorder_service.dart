import 'dart:async';
import 'dart:typed_data';

import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:record/record.dart';

/// Manages microphone recording lifecycle, extracted from [ChatCubit].
///
/// Responsibilities:
/// - Check microphone permissions
/// - Start/stop PCM audio streaming (16kHz, mono, pcm16bits)
/// - Expose audio data and normalized amplitude streams
class AudioRecorderService {
  AudioRecorderService();

  final AudioRecorder _recorder = AudioRecorder();
  final AppLogger _logger = AppLogger();

  StreamSubscription<List<int>>? _recorderSub;
  StreamSubscription<Amplitude>? _amplitudeSub;

  StreamController<Uint8List>? _audioDataController;
  StreamController<double>? _amplitudeController;

  bool _isRecording = false;

  /// Whether the service is currently recording.
  bool get isRecording => _isRecording;

  /// Stream of PCM audio chunks from the microphone.
  ///
  /// Only active while recording. Returns [Stream.empty] when idle.
  Stream<Uint8List> get audioDataStream =>
      _audioDataController?.stream ?? const Stream.empty();

  /// Stream of normalized amplitude values (0.0 – 1.0) for waveform UI.
  ///
  /// Only active while recording. Returns [Stream.empty] when idle.
  Stream<double> get amplitudeStream =>
      _amplitudeController?.stream ?? const Stream.empty();

  /// Map dBFS (-160..0) to normalized height (0..1) for bar display.
  static double _normalizeAmplitude(double db) {
    const minDb = -45.0; // Noise floor
    const maxDb = -2.0; // Loudest speaking
    var t = (db - minDb) / (maxDb - minDb);
    t = t.clamp(0.0, 1.0);
    return t * t; // Non-linear: quiet visible, loud distinct
  }

  /// Start recording from the microphone.
  ///
  /// Streams PCM audio at 16kHz mono (required by Gemini Live STT).
  /// Throws if microphone permission is denied.
  Future<void> startRecording() async {
    if (_isRecording) {
      return;
    }

    try {
      // Create broadcast controllers before any await so streams are
      // ready when the UI switches to recording mode.
      await _audioDataController?.close();
      _audioDataController = StreamController<Uint8List>.broadcast();

      await _amplitudeController?.close();
      _amplitudeController = StreamController<double>.broadcast();

      // Check permissions
      if (!(await _recorder.hasPermission())) {
        throw Exception('Microphone permission denied');
      }

      // ⚠️ CRITICAL: Gemini Live STT requires 16kHz, not 24kHz
      final stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits, // LINEAR16 PCM
          sampleRate: 16000, // Gemini Live requirement
          numChannels: 1, // Mono
          bitRate: 256000, // 16000 Hz × 16 bits
        ),
      );

      _isRecording = true;

      // Amplitude subscription for waveform UI
      await _amplitudeSub?.cancel();
      _amplitudeSub = _recorder
          .onAmplitudeChanged(const Duration(milliseconds: 50))
          .listen((amp) {
            if (!(_amplitudeController?.isClosed ?? true)) {
              _amplitudeController!.add(_normalizeAmplitude(amp.current));
            }
          });

      // Forward recorder chunks as Uint8List
      await _recorderSub?.cancel();
      var chunkCount = 0;
      _recorderSub = stream.listen(
        (chunk) {
          chunkCount++;
          final audioData = Uint8List.fromList(chunk);
          if (!(_audioDataController?.isClosed ?? true)) {
            _audioDataController!.add(audioData);
          }
          if (chunkCount % 10 == 0) {
            _logger.d(
              '🎵 Recorded chunk #$chunkCount (${audioData.length} bytes)',
            );
          }
        },
        onError: (error) {
          _logger.e('❌ Recording error', error);
          _isRecording = false;
        },
        onDone: () {
          _logger.d('✅ Audio stream complete ($chunkCount chunks total)');
        },
      );

      _logger.d('🎙️ Recording started');
    } catch (e) {
      _logger.e('❌ Recording start error', e);
      _isRecording = false;
      await _audioDataController?.close();
      _audioDataController = null;
      await _amplitudeController?.close();
      _amplitudeController = null;
      rethrow;
    }
  }

  /// Stop the current recording session.
  ///
  /// Cleans up subscriptions, stops the recorder, and closes streams.
  Future<void> stopRecording() async {
    if (!_isRecording) {
      _logger.d('⚠️ stopRecording called but not recording');
      return;
    }

    try {
      _logger.d('🛑 Stopping recorder...');
      await _amplitudeSub?.cancel();
      _amplitudeSub = null;
      await _amplitudeController?.close();
      _amplitudeController = null;
      await _recorderSub?.cancel();
      _recorderSub = null;
      await _audioDataController?.close();
      _audioDataController = null;
      await _recorder.stop();
      _isRecording = false;
      _logger.d('✅ Recording stopped');
    } catch (e) {
      _logger.e('❌ Stop recording error', e);
      _isRecording = false;
    }
  }

  /// Release all resources. Call when the service is no longer needed.
  Future<void> dispose() async {
    await stopRecording();
    await _recorder.dispose();
  }
}
