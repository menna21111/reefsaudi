import 'dart:async';
import 'dart:typed_data';

import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:reefsaudia/features/chat/core/services/audio_recorder_service.dart';
import 'package:reefsaudia/features/chat/domain/repos/i_chat_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:uuid/uuid.dart';

/// Manages the voice recording lifecycle, sending chunks to the backend,
/// and coordinating audio_end/audio_cancel signals.
class VoiceInputManager {
  VoiceInputManager({
    required this.repository,
    required this.recorderService,
    required this.onVoiceMessageStarted,
    required this.onRecordingStopped,
    required this.onRecordingCancelled,
    required this.onRecordingError,
  });

  final IChatRepository repository;
  final AudioRecorderService recorderService;

  final void Function(String messageId, String activeResponseId)
  onVoiceMessageStarted;
  final void Function() onRecordingStopped;
  final void Function(String messageId) onRecordingCancelled;
  final void Function(String error) onRecordingError;

  final AppLogger _logger = AppLogger();

  StreamSubscription<Uint8List>? _recorderDataSub;

  /// The ID of the user's pending '...' voice message bubble.
  String? pendingVoiceMessageId;

  /// The ID for the assistant's upcoming response to this voice input.
  String? _activeResponseIdFromVoice;

  /// Start recording (push-to-talk).
  Future<void> startRecording() async {
    if (recorderService.isRecording) {
      return;
    }

    pendingVoiceMessageId = const Uuid().v4();
    _activeResponseIdFromVoice = const Uuid().v4();

    // Let the Cubit eagerly create the UI bubbles
    onVoiceMessageStarted(pendingVoiceMessageId!, _activeResponseIdFromVoice!);

    try {
      await recorderService.startRecording();

      // Forward recorder audio chunks to backend
      await _recorderDataSub?.cancel();
      _recorderDataSub = recorderService.audioDataStream.listen(
        repository.sendAudio,
      );

      _logger.d(
        '🎙️ Push-to-talk: Recording started with ID $pendingVoiceMessageId',
      );
    } catch (e) {
      _logger.e('❌ Recording error', e);
      pendingVoiceMessageId = null;
      _activeResponseIdFromVoice = null;
      onRecordingError(tr('micError'));
    }
  }

  /// Stop recording (push-to-talk: release button).
  Future<void> stopRecording() async {
    if (!recorderService.isRecording) {
      _logger.d('⚠️ stopRecording called but not recording');
      return;
    }

    _logger.d('🛑 stopRecording: Stopping...');
    onRecordingStopped();
    await _stopRecording(sendAudioEnd: true);
    _logger.d('🎙️ Push-to-talk: Recording stopped, processing...');
  }

  /// Cancel recording (swipe to cancel).
  Future<void> cancelRecording() async {
    if (!recorderService.isRecording) {
      _logger.d('⚠️ cancelRecording called but not recording');
      return;
    }

    _logger.d('🛑 cancelRecording: Swipe to cancel, discarding...');
    await _stopRecording(sendAudioEnd: false);
    repository.sendAudioCancel();

    if (pendingVoiceMessageId != null) {
      onRecordingCancelled(pendingVoiceMessageId!);
      pendingVoiceMessageId = null;
    }
    _logger.d('🎙️ Recording cancelled');
  }

  /// Toggle voice recording.
  Future<void> toggleVoice() async {
    if (recorderService.isRecording) {
      await stopRecording();
    } else {
      await startRecording();
    }
  }

  /// Force stop recording (e.g., when a transcript is received or chat resets).
  /// Doesn't send an audio_end signal; relies on transcript timing or reset.
  void forceStopRecording() {
    if (recorderService.isRecording) {
      _logger.d('🛑 Force stopping recording (transcript received or reset)');
      unawaited(_stopRecording(sendAudioEnd: false));
    }
  }

  /// Used by the Cubit to clear the tracking ID once the transcript
  /// replaces the '...' bubble.
  void clearPendingVoiceMessageId() {
    pendingVoiceMessageId = null;
  }

  Future<void> _stopRecording({required bool sendAudioEnd}) async {
    await _recorderDataSub?.cancel();
    _recorderDataSub = null;

    await recorderService.stopRecording();

    if (sendAudioEnd && _activeResponseIdFromVoice != null) {
      _logger.d('📤 Sending audio_end signal to backend...');
      repository.sendAudioEnd(_activeResponseIdFromVoice!);
      _logger.d('✅ Recording stopped and audio_end sent');
    } else {
      _logger.d('✅ Recording stopped (cancelled, no send)');
      pendingVoiceMessageId = null;
      _activeResponseIdFromVoice = null;
    }
  }

  void dispose() {
    _recorderDataSub?.cancel();
  }
}
