import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notifications_hub_service.dart';
import '../../data/models/user_chat_models.dart';
import '../../data/repositories/user_chat_repository_impl.dart';

sealed class UserChatThreadState extends Equatable {
  const UserChatThreadState();
  @override
  List<Object?> get props => [];
}

class UserChatThreadInitial extends UserChatThreadState {
  const UserChatThreadInitial();
}

class UserChatThreadLoading extends UserChatThreadState {
  const UserChatThreadLoading();
}

class UserChatThreadLoaded extends UserChatThreadState {
  const UserChatThreadLoaded({
    required this.messages,
    this.sending = false,
    this.error,
  });

  final List<UserChatMessage> messages;
  final bool sending;
  final String? error;

  UserChatThreadLoaded copyWith({
    List<UserChatMessage>? messages,
    bool? sending,
    String? error,
  }) =>
      UserChatThreadLoaded(
        messages: messages ?? this.messages,
        sending: sending ?? this.sending,
        error: error,
      );

  @override
  List<Object?> get props => [messages, sending, error];
}

class UserChatThreadError extends UserChatThreadState {
  const UserChatThreadError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class UserChatThreadCubit extends Cubit<UserChatThreadState> {
  UserChatThreadCubit({
    required UserChatRepository repository,
    required NotificationsHubService hub,
    required this.chatId,
    required this.currentUserId,
  })  : _repository = repository,
        _hub = hub,
        super(const UserChatThreadInitial());

  final UserChatRepository _repository;
  final NotificationsHubService _hub;
  final String chatId;
  final String currentUserId;

  StreamSubscription<UserChatPushEvent>? _msgSub;

  void _safeEmit(UserChatThreadState state) {
    if (isClosed) return;
    emit(state);
  }

  Future<void> load() async {
    _safeEmit(const UserChatThreadLoading());
    try {
      final messages = await _repository.getMessages(
        chatId: chatId,
        currentUserId: currentUserId,
      );
      if (isClosed) return;
      _safeEmit(UserChatThreadLoaded(messages: messages));
      _listenHub();
    } catch (e) {
      _safeEmit(UserChatThreadError(e.toString()));
    }
  }

  void _listenHub() {
    _msgSub ??= _hub.onNewMessage.listen((event) {
      if (isClosed) return;
      if (event.chatId != null && event.chatId != chatId) return;
      final current = state;
      if (current is! UserChatThreadLoaded) return;

      if (event.message != null) {
        final exists = current.messages.any((m) => m.id == event.message!.id);
        if (!exists) {
          _safeEmit(
            current.copyWith(
              messages: [...current.messages, event.message!],
            ),
          );
          return;
        }
      }
      unawaited(_reloadQuiet());
    });
  }

  Future<void> _reloadQuiet() async {
    try {
      final messages = await _repository.getMessages(
        chatId: chatId,
        currentUserId: currentUserId,
      );
      if (isClosed) return;
      final current = state;
      if (current is UserChatThreadLoaded) {
        _safeEmit(current.copyWith(messages: messages));
      } else {
        _safeEmit(UserChatThreadLoaded(messages: messages));
      }
    } catch (_) {}
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await sendAttachment(text: trimmed);
  }

  Future<void> sendAttachment({
    String text = '',
    String? filePath,
    UserChatAttachmentType attachmentType = UserChatAttachmentType.none,
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty && (filePath == null || filePath.isEmpty)) return;
    final current = state;
    if (current is! UserChatThreadLoaded) return;

    final optimistic = UserChatMessage(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      text: trimmed,
      senderId: currentUserId,
      createdAt: DateTime.now(),
      isMine: true,
      attachmentPath: filePath,
      attachmentType: attachmentType,
    );
    _safeEmit(
      current.copyWith(
        messages: [...current.messages, optimistic],
        sending: true,
        error: null,
      ),
    );

    try {
      await _repository.sendMessage(
        chatId: chatId,
        senderId: currentUserId,
        text: trimmed,
        filePath: filePath,
        attachmentType: attachmentType,
      );
      if (isClosed) return;
      await _reloadQuiet();
      if (isClosed) return;
      final after = state;
      if (after is UserChatThreadLoaded) {
        _safeEmit(after.copyWith(sending: false));
      }
    } catch (e) {
      if (isClosed) return;
      final after = state;
      if (after is UserChatThreadLoaded) {
        _safeEmit(after.copyWith(sending: false, error: e.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _msgSub?.cancel();
    _msgSub = null;
    return super.close();
  }
}
