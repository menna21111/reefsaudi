import '../models/user_chat_models.dart';
import '../datasources/user_chat_remote_data_source.dart';

abstract class UserChatRepository {
  Future<List<UserChatSummary>> getChats({int skip = 0, int take = 50});
  Future<List<UserChatContact>> getContacts({int skip = 0, int take = 100});

  Future<List<UserChatMessage>> getMessages({
    required String chatId,
    required String currentUserId,
    int skip = 0,
    int take = 100,
  });

  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? filePath,
    UserChatAttachmentType attachmentType = UserChatAttachmentType.none,
  });

  Future<String> startChat({
    required String senderId,
    required String recipientId,
    String? projectId,
  });
}

class UserChatRepositoryImpl implements UserChatRepository {
  UserChatRepositoryImpl(this._remote);

  final UserChatRemoteDataSource _remote;

  @override
  Future<List<UserChatSummary>> getChats({int skip = 0, int take = 50}) =>
      _remote.getChats(skip: skip, take: take);

  @override
  Future<List<UserChatContact>> getContacts({int skip = 0, int take = 100}) =>
      _remote.getContacts(skip: skip, take: take);

  @override
  Future<List<UserChatMessage>> getMessages({
    required String chatId,
    required String currentUserId,
    int skip = 0,
    int take = 100,
  }) =>
      _remote.getMessages(
        chatId: chatId,
        currentUserId: currentUserId,
        skip: skip,
        take: take,
      );

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? filePath,
    UserChatAttachmentType attachmentType = UserChatAttachmentType.none,
  }) =>
      _remote.sendMessage(
        chatId: chatId,
        senderId: senderId,
        text: text,
        filePath: filePath,
        attachmentType: attachmentType,
      );

  @override
  Future<String> startChat({
    required String senderId,
    required String recipientId,
    String? projectId,
  }) =>
      _remote.startChat(
        senderId: senderId,
        recipientId: recipientId,
        projectId: projectId,
      );
}
