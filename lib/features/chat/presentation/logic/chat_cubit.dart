import 'dart:async';
import 'dart:typed_data';

import 'package:reefsaudia/features/chat/core/constants/chat_constants.dart';
import 'package:reefsaudia/features/chat/core/logging/app_logger.dart';
import 'package:reefsaudia/features/chat/core/services/audio_recorder_service.dart';
import 'package:reefsaudia/features/chat/core/services/connectivity_service.dart';
import 'package:reefsaudia/features/chat/domain/models/chat_event.dart';
import 'package:reefsaudia/features/chat/domain/models/chat_message_model.dart';
import 'package:reefsaudia/features/chat/domain/repos/i_chat_repository.dart';
import 'package:reefsaudia/features/chat/presentation/logic/text_audio_sync_manager.dart';
import 'package:reefsaudia/features/chat/presentation/logic/voice_input_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._repository, this._recorderService, this._connectivityService)
    : super(const ChatState()) {
    _syncManager = TextAudioSyncManager(
      onTextReadyToEmit: _updateStateWithBuffer,
    );
    _voiceInputManager = VoiceInputManager(
      repository: _repository,
      recorderService: _recorderService,
      onVoiceMessageStarted: _onVoiceMessageStarted,
      onRecordingStopped: _onRecordingStopped,
      onRecordingCancelled: _onRecordingCancelled,
      onRecordingError: _onRecordingError,
    );
    _connectivitySub = _connectivityService.onStatusChange.listen((
      hasInternet,
    ) {
      if (!hasInternet) {
        _logger.w('🔴 Internet lost — notifying UI');
        emit(state.copyWith(errorMessage: 'No internet connection'));
      } else {
        _logger.i('🟢 Internet restored — clearing error');
        // Clear offline error only; don't override other active statuses.
        if (state.errorMessage == 'No internet connection') {
          emit(state.copyWith(clearErrorMessage: true));
        }
      }
    });
  }

  final IChatRepository _repository;
  final AudioRecorderService _recorderService;
  final ConnectivityService _connectivityService;
  final AppLogger _logger = AppLogger();

  late final TextAudioSyncManager _syncManager;
  late final VoiceInputManager _voiceInputManager;

  StreamSubscription<ChatEvent>? _eventSub;
  StreamSubscription<bool>? _connectivitySub;
  String? _activeResponseId;

  /// Raw audio stream for the audio player (passthrough from repository).
  Stream<Uint8List> get rawAudioStream => _repository.rawAudioStream;

  /// Amplitude stream for voice-wave UI (from recorder service).
  Stream<double> get amplitudeStream => _recorderService.amplitudeStream;

  /// Whether the recorder is currently active.
  bool get isRecording => _recorderService.isRecording;

  // ─── Connection ──────────────────────────────────────────────────────

  void connect(String url) {
    emit(state.copyWith(status: ChatStatus.connecting));
    _repository.connect(url);

    // Subscribe to typed chat events
    _eventSub?.cancel();
    _syncManager.reset();

    _eventSub = _repository.chatEvents.listen(_onChatEvent);

    emit(state.copyWith(status: ChatStatus.ready));
  }

  // ─── Chat Event Handling ─────────────────────────────────────────────

  void _onChatEvent(ChatEvent event) {
    switch (event) {
      case TextChunkEvent(:final text):
        _onTextChunk(text);
      case AudioChunkEvent():
        _onAudioChunk();
      case UserTranscriptEvent(:final text):
        _onUserTranscript(text);
      case DoneEvent():
        _onDone();
      case ErrorEvent(:final message):
        _onError(message);
      case StatusEvent(:final status):
        _onStatus(status);
    }
  }

  void _onTextChunk(String text) {
    _syncManager.onTextChunkReceived(text, wasVoiceInput: state.wasVoiceInput);
  }

  void _onAudioChunk() {
    _syncManager.onAudioChunkReceived();
  }

  void _onUserTranscript(String text) {
    _logger.d('🎤 User said: $text');

    final messageId = _voiceInputManager.pendingVoiceMessageId;

    // Force stop recording when transcript received
    _voiceInputManager.forceStopRecording();

    final newMessages = List<ChatMessageModel>.from(state.messages);
    final index = newMessages.indexWhere((m) => m.id == messageId);

    if (index != -1) {
      newMessages[index] = newMessages[index].copyWith(text: text);
    } else {
      newMessages.add(
        ChatMessageModel(
          id: messageId,
          role: MessageRole.user,
          text: text,
          isVoice: true,
        ),
      );
    }

    // IMMEDIATELY ADD AI PLACEHOLDER
    if (_activeResponseId != null) {
      newMessages.add(
        ChatMessageModel(
          id: _activeResponseId,
          role: MessageRole.assistant,
          text: '', // Empty text
          isVoice: true,
          isGenerating: true,
          thinkingSteps: const [],
        ),
      );
    }

    _resetResponseState();

    // Clear the pending ID *after* the bubble has been updated successfully.
    _voiceInputManager.clearPendingVoiceMessageId();

    emit(
      state.copyWith(
        status: ChatStatus.thinking,
        messages: newMessages,
        wasVoiceInput: true,
      ),
    );
  }

  void _onDone() {
    _logger.d('✅ Response done signal received');
    _syncManager.onDone();

    // Mark the last assistant message as finished generating
    final newMessages = [...state.messages];
    if (newMessages.isNotEmpty && newMessages.last.role.isAssistant) {
      final lastIdx = newMessages.length - 1;
      newMessages[lastIdx] = newMessages[lastIdx].copyWith(isGenerating: false);
    }

    _logger.d('🛑 state changing to ready explicitly in _onDone');
    _activeResponseId = null;
    emit(
      state.copyWith(
        status: ChatStatus.ready,
        wasVoiceInput: false,
        messages: newMessages,
      ),
    );
  }

  void _onError(String message) {
    // If an error arrives while a voice bubble is pending (e.g. transcription
    // failed), remove the stranded '...' bubble so it doesn't stay forever.
    var newMessages = state.messages;
    if (_voiceInputManager.pendingVoiceMessageId != null) {
      newMessages = state.messages
          .where((m) => m.id != _voiceInputManager.pendingVoiceMessageId)
          .toList();
      _voiceInputManager.clearPendingVoiceMessageId();
    }
    emit(
      state.copyWith(
        status: ChatStatus.failure,
        errorMessage: message,
        messages: newMessages,
      ),
    );
  }

  // ─── Text UI Updates ─────────────────────────────────────────────────

  void _updateStateWithBuffer(String fullText) {
    // Determine if we need to append a new assistant bubble
    // We need a new bubble ONLY if the last message isn't the current active assistant response.
    final needsNewBubble =
        state.messages.isEmpty ||
        !state.messages.last.role.isAssistant ||
        state.messages.last.id != _activeResponseId;

    late final List<ChatMessageModel> newMessages;

    if (needsNewBubble) {
      // Create a full copy and append the new placeholder
      newMessages = List<ChatMessageModel>.from(state.messages)
        ..add(
          ChatMessageModel(
            id: _activeResponseId,
            role: MessageRole.assistant,
            text: fullText,
            isVoice: state.wasVoiceInput,
          ),
        );
    } else {
      // OPTIMIZATION: Just create a new list with the exact same
      // references, except for the last item which we replace.
      // This is dramatically faster than List.from() on every chunk.
      newMessages = List<ChatMessageModel>.of(state.messages);
      final lastIdx = newMessages.length - 1;
      newMessages[lastIdx] = newMessages[lastIdx].copyWith(text: fullText);
    }

    if (!isClosed) {
      // If the backend stream is already fully done (ready),
      // DO NOT revert to receiving just because a delayed
      // text chunk (from the audio sync delay) is being flushed.
      final newStatus = state.status == ChatStatus.ready
          ? ChatStatus.ready
          : ChatStatus.receiving;
      _logger.d(
        '🛑 state changing to ${newStatus.name} in _updateStateWithBuffer',
      );
      emit(state.copyWith(messages: newMessages, status: newStatus));
    }
  }

  /// Handle a live status update from the AI's thinking process.
  void _onStatus(String status) {
    final newMessages = [...state.messages];

    // Find or create the assistant message being generated
    if (newMessages.isEmpty || !newMessages.last.role.isAssistant) {
      // Create an empty assistant bubble to attach the thinking steps to
      newMessages.add(
        ChatMessageModel(
          id: _activeResponseId,
          role: MessageRole.assistant,
          text: '',
          isVoice: state.wasVoiceInput,
          isGenerating: true,
          thinkingSteps: [status],
        ),
      );
    } else {
      final lastIdx = newMessages.length - 1;
      final current = newMessages[lastIdx];
      newMessages[lastIdx] = current.copyWith(
        isGenerating: true,
        thinkingSteps: [...current.thinkingSteps, status],
      );
    }

    emit(state.copyWith(messages: newMessages));
  }

  /// Toggle the thinking accordion for a specific message.
  void toggleThinkingExpanded(String messageId) {
    final newMessages = List<ChatMessageModel>.from(state.messages);
    final index = newMessages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final msg = newMessages[index];
    newMessages[index] = msg.copyWith(
      isThinkingExpanded: !msg.isThinkingExpanded,
    );
    emit(state.copyWith(messages: newMessages));
  }

  // ─── Send Actions ────────────────────────────────────────────────────

  /// Send a text message (from keyboard input).
  void sendMessage(String text, {bool isVoice = false}) {
    if (state.isBusy) return;
    if (text.trim().isEmpty) {
      return;
    }

    final traceId = const Uuid().v4();
    _activeResponseId = traceId;

    final newMessages = List<ChatMessageModel>.from(state.messages)
      ..add(
        ChatMessageModel(role: MessageRole.user, text: text, isVoice: isVoice),
      )
      // IMMEDIATELY ADD AI PLACEHOLDER
      ..add(
        ChatMessageModel(
          id: traceId,
          role: MessageRole.assistant,
          text: '', // Empty text
          isVoice: isVoice,
          isGenerating: true,
          thinkingSteps: const [],
        ),
      );

    _resetResponseState();

    emit(
      state.copyWith(
        status: ChatStatus.thinking,
        messages: newMessages,
        wasVoiceInput: isVoice,
      ),
    );

    _repository.sendMessage(traceId, text, isVoice: isVoice);
  }

  /// Start a new chat conversation (reset context).
  void startNewChat() {
    if (_recorderService.isRecording) {
      _voiceInputManager.forceStopRecording();
    }

    emit(
      state.copyWith(
        messages: [],
        status: ChatStatus.ready,
        wasVoiceInput: false,
      ),
    );

    _syncManager.reset();
    _repository.sendNewChat();
    _logger.d('🔄 New chat started');
  }

  /// Send thumbs-up / thumbs-down feedback for a bot response.
  void sendFeedback({required String messageId, required String rating}) {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) {
      return;
    }

    final newMessages = List<ChatMessageModel>.from(state.messages);

    newMessages[messageIndex] = newMessages[messageIndex].copyWith(
      rating: rating,
    );
    emit(state.copyWith(messages: newMessages));

    final ratingInt = ratingToInt(rating);

    _repository.sendFeedback(messageId, ratingInt);
    _logger.d('📝 sendFeedback: $rating for message #$messageIndex');
  }

  /// Send supplementary feedback details (category + optional comment).
  void sendFeedbackDetails({
    required String messageId,
    required String rating,
    required String category,
    String? comment,
  }) {
    final messageIndex = state.messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) {
      return;
    }

    final ratingInt = ratingToInt(rating);

    _repository.sendFeedbackDetails(
      messageId,
      ratingInt,
      category,
      comment ?? '',
    );
    _logger.d('📝 sendFeedbackDetails: category=$category');
  }

  // ─── Recording UI Callbacks ──────────────────────────────────────────

  void _onVoiceMessageStarted(String messageId, String activeResponseId) {
    _activeResponseId = activeResponseId;
    final newMessages = List<ChatMessageModel>.from(state.messages)
      ..add(
        ChatMessageModel(
          id: messageId,
          role: MessageRole.user,
          text: '...', // Pending transcript
          isVoice: true,
        ),
      );

    _resetResponseState();

    emit(
      state.copyWith(
        status: ChatStatus.listening,
        messages: newMessages,
        wasVoiceInput: true,
      ),
    );
  }

  void _onRecordingStopped() {
    emit(state.copyWith(status: ChatStatus.ready, wasVoiceInput: false));
  }

  void _onRecordingCancelled(String messageId) {
    final newMessages = state.messages.where((m) => m.id != messageId).toList();
    emit(
      state.copyWith(
        status: ChatStatus.ready,
        wasVoiceInput: false,
        messages: newMessages,
      ),
    );
  }

  void _onRecordingError(String errorMsg) {
    emit(state.copyWith(status: ChatStatus.failure, errorMessage: errorMsg));
  }

  // ─── Recording Actions ───────────────────────────────────────────────

  Future<void> startRecording() async {
    if (state.isBusy) return;
    await _voiceInputManager.startRecording();
  }

  Future<void> stopRecording() => _voiceInputManager.stopRecording();
  Future<void> cancelRecording() => _voiceInputManager.cancelRecording();
  Future<void> toggleVoice() => _voiceInputManager.toggleVoice();

  // ─── Helpers ─────────────────────────────────────────────────────────

  void _resetResponseState() {
    _syncManager.reset();
  }

  @override
  Future<void> close() {
    _eventSub?.cancel();
    _connectivitySub?.cancel();
    _syncManager.dispose();
    _voiceInputManager.dispose();
    _repository.disconnect();
    return super.close();
  }
}
