import 'package:dio/dio.dart';

import '../../../../core/network/account_list_query.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/dx_list_query.dart';
import '../../../../core/network/pmo_endpoints.dart';
import '../models/user_chat_models.dart';

abstract class UserChatRemoteDataSource {
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

class UserChatRemoteDataSourceImpl implements UserChatRemoteDataSource {
  List<Map<String, dynamic>> _asMapList(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is List) {
        return nested.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      }
    }
    if (data is List) {
      return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return const [];
  }

  @override
  Future<List<UserChatSummary>> getChats({int skip = 0, int take = 50}) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.chatList,
      query: DxListQuery.paged(skip: skip, take: take),
    );
    return _asMapList(response.data).map(UserChatSummary.fromJson).where((c) => c.id.isNotEmpty).toList();
  }

  @override
  Future<List<UserChatContact>> getContacts({
    int skip = 0,
    int take = 100,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.accountListDx,
      query: AccountListQuery.dx(skip: skip, take: take),
    );
    return _asMapList(response.data)
        .map(UserChatContact.fromJson)
        .where((c) => c.id.isNotEmpty)
        .toList();
  }

  @override
  Future<List<UserChatMessage>> getMessages({
    required String chatId,
    required String currentUserId,
    int skip = 0,
    int take = 100,
  }) async {
    final response = await DioHelper.getData(
      url: PmoEndpoints.chatListMessages(chatId),
      query: DxListQuery.paged(skip: skip, take: take),
    );
    final items = _asMapList(response.data)
        .map((e) => UserChatMessage.fromJson(e, currentUserId: currentUserId))
        .toList();
    // API may return newest-first; keep chronological for bubbles.
    items.sort((a, b) {
      final aAt = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bAt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return aAt.compareTo(bAt);
    });
    return items;
  }

  @override
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String text,
    String? filePath,
    UserChatAttachmentType attachmentType = UserChatAttachmentType.none,
  }) async {
    final payload = <String, dynamic>{
      'Text': text,
      'ChatId': chatId,
      'SenderId': senderId,
    };
    if (filePath != null && filePath.isNotEmpty) {
      payload['File'] = await MultipartFile.fromFile(filePath);
      payload['AttachmentType'] = attachmentType.apiValue;
    }
    await DioHelper.postData(
      url: PmoEndpoints.chatSendMessage,
      data: FormData.fromMap(payload),
    );
  }

  @override
  Future<String> startChat({
    required String senderId,
    required String recipientId,
    String? projectId,
  }) async {
    final response = await DioHelper.postData(
      url: PmoEndpoints.chatStart,
      data: {
        'senderId': senderId,
        'recipientId': recipientId,
        if (projectId != null && projectId.isNotEmpty) 'projectId': projectId,
      },
    );

    final body = response.data;
    if (body is Map) {
      final map = Map<String, dynamic>.from(body);
      final id = map['id'] ??
          map['chatId'] ??
          map['ChatId'] ??
          (map['data'] is Map ? (map['data']['id'] ?? map['data']['chatId']) : null);
      if (id != null && '$id'.isNotEmpty) return '$id';
    }
    if (body is String && body.isNotEmpty) return body;
    throw const FormatException('Unexpected start-chat response');
  }
}
