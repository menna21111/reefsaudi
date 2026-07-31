import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/notifications_hub_service.dart';
import '../../data/models/user_chat_models.dart';
import '../../data/repositories/user_chat_repository_impl.dart';

sealed class UserChatListState extends Equatable {
  const UserChatListState();
  @override
  List<Object?> get props => [];
}

class UserChatListInitial extends UserChatListState {
  const UserChatListInitial();
}

class UserChatListLoading extends UserChatListState {
  const UserChatListLoading();
}

class UserChatListLoaded extends UserChatListState {
  const UserChatListLoaded({
    required this.chats,
    required this.contacts,
    this.isRefreshing = false,
    this.hubConnected = false,
  });

  final List<UserChatSummary> chats;
  final List<UserChatContact> contacts;
  final bool isRefreshing;
  final bool hubConnected;

  int get unreadTotal =>
      chats.fold<int>(0, (sum, c) => sum + c.unreadCount);

  UserChatListLoaded copyWith({
    List<UserChatSummary>? chats,
    List<UserChatContact>? contacts,
    bool? isRefreshing,
    bool? hubConnected,
  }) =>
      UserChatListLoaded(
        chats: chats ?? this.chats,
        contacts: contacts ?? this.contacts,
        isRefreshing: isRefreshing ?? this.isRefreshing,
        hubConnected: hubConnected ?? this.hubConnected,
      );

  @override
  List<Object?> get props => [chats, contacts, isRefreshing, hubConnected];
}

class UserChatListError extends UserChatListState {
  const UserChatListError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class UserChatListCubit extends Cubit<UserChatListState> {
  UserChatListCubit({
    required UserChatRepository repository,
    required NotificationsHubService hub,
    required this.currentUserId,
  })  : _repository = repository,
        _hub = hub,
        super(const UserChatListInitial());

  final UserChatRepository _repository;
  final NotificationsHubService _hub;
  final String currentUserId;

  StreamSubscription<UserChatPushEvent>? _msgSub;
  StreamSubscription<bool>? _connSub;

  Future<void> load() async {
    emit(const UserChatListLoading());
    try {
      final chats = await _repository.getChats();
      final contacts = await _repository.getContacts();
      if (isClosed) return;
      emit(
        UserChatListLoaded(
          chats: chats,
          contacts: _filterContacts(contacts, chats),
          hubConnected: _hub.isConnected,
        ),
      );
      await _ensureHub();
    } catch (e) {
      if (isClosed) return;
      emit(UserChatListError(e.toString()));
    }
  }

  Future<void> refresh() async {
    final current = state;
    if (current is UserChatListLoaded) {
      if (!isClosed) emit(current.copyWith(isRefreshing: true));
    }
    try {
      final chats = await _repository.getChats();
      final contacts = await _repository.getContacts();
      if (isClosed) return;
      emit(
        UserChatListLoaded(
          chats: chats,
          contacts: _filterContacts(contacts, chats),
          hubConnected: _hub.isConnected,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      if (current is UserChatListLoaded) {
        emit(current.copyWith(isRefreshing: false));
      } else {
        emit(UserChatListError(e.toString()));
      }
    }
  }

  Future<void> _ensureHub() async {
    _msgSub ??= _hub.onNewMessage.listen((_) {
      if (isClosed) return;
      unawaited(refresh());
    });
    _connSub ??= _hub.onConnectionChanged.listen((connected) {
      if (isClosed) return;
      final current = state;
      if (current is UserChatListLoaded) {
        emit(current.copyWith(hubConnected: connected));
      }
    });
    await _hub.connect(currentUserId: currentUserId);
  }

  List<UserChatContact> _filterContacts(
    List<UserChatContact> contacts,
    List<UserChatSummary> chats,
  ) {
    final existingIds = chats
        .map((chat) => chat.recipientId?.trim())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet();

    return contacts
        .where((contact) =>
            contact.id != currentUserId && !existingIds.contains(contact.id))
        .toList()
      ..sort(
        (a, b) => a.displayName.toLowerCase().compareTo(
              b.displayName.toLowerCase(),
            ),
      );
  }

  @override
  Future<void> close() async {
    await _msgSub?.cancel();
    await _connSub?.cancel();
    return super.close();
  }
}
