String? _str(dynamic value) {
  final text = value?.toString().trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

DateTime? _date(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  var text = value.toString().trim();
  if (text.isEmpty) return null;

  // API may send 7+ fractional digits; Dart parses up to microseconds (6).
  text = text.replaceFirstMapped(
    RegExp(r'\.(\d{7,})'),
    (m) => '.${m[1]!.substring(0, 6)}',
  );

  return DateTime.tryParse(text);
}

String? _messagePreview(dynamic value) {
  final text = _str(value);
  if (text != null) {
    final trimmed = text.trim();
    if (!trimmed.startsWith('{') || !trimmed.endsWith('}')) {
      return trimmed;
    }
  }

  if (value is Map) {
    final map = Map<String, dynamic>.from(value);
    return _str(map['messageText']) ??
        _str(map['text']) ??
        _str(map['Text']) ??
        _str(map['message']) ??
        _str(map['body']) ??
        _str(map['lastMessageText']) ??
        _str(map['senderFullName']) ??
        _str(map['senderId']);
  }

  return text;
}

enum UserChatAttachmentType {
  none(0),
  image(1),
  pdf(2),
  document(3),
  other(4);

  const UserChatAttachmentType(this.apiValue);
  final int apiValue;

  static UserChatAttachmentType fromApi(dynamic value) {
    final parsed = value is int ? value : int.tryParse(value?.toString() ?? '');
    return UserChatAttachmentType.values.firstWhere(
      (item) => item.apiValue == parsed,
      orElse: () => UserChatAttachmentType.none,
    );
  }
}

/// Conversation row from `GET Chat/list`.
class UserChatSummary {
  const UserChatSummary({
    required this.id,
    required this.displayName,
    this.recipientId,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.isGroup = false,
  });

  final String id;
  final String displayName;
  final String? recipientId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final bool isGroup;

  factory UserChatSummary.fromJson(Map<String, dynamic> json) {
    final id = _str(json['id']) ??
        _str(json['chatId']) ??
        _str(json['ChatId']) ??
        _str(json['recipientId']) ??
        _str(json['RecipientId']) ??
        '';
    final name = _str(json['displayName']) ??
        _str(json['DisplayName']) ??
        _str(json['groupName']) ??
        _str(json['title']) ??
        _str(json['name']) ??
        '—';
    final last = _messagePreview(json['lastMessage']) ??
        _messagePreview(json['LastMessage']) ??
        _str(json['lastMessageText']) ??
        _str(json['text']);
    final unread = json['unreadCount'] ??
        json['UnreadCount'] ??
        json['unreadMessages'] ??
        0;

    return UserChatSummary(
      id: id,
      displayName: name,
      recipientId: _str(json['recipientId']) ?? _str(json['RecipientId']),
      lastMessage: last,
      lastMessageAt: _date(json['lastMessageAt'] ?? json['LastMessageAt'] ?? json['updatedAt']),
      unreadCount: unread is int ? unread : int.tryParse('$unread') ?? 0,
      isGroup: json['isGroup'] == true || json['IsGroup'] == true,
    );
  }
}

class UserChatContact {
  const UserChatContact({
    required this.id,
    required this.displayName,
  });

  final String id;
  final String displayName;

  factory UserChatContact.fromJson(Map<String, dynamic> json) {
    return UserChatContact(
      id: _str(json['id']) ?? '',
      displayName: _str(json['fullName']) ??
          _str(json['displayName']) ??
          _str(json['name']) ??
          _str(json['email']) ??
          '—',
    );
  }
}

/// Single message from `GET Chat/list-messages/{chatId}`.
class UserChatMessage {
  const UserChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    this.createdAt,
    this.isMine = false,
    this.attachmentPath,
    this.attachmentType = UserChatAttachmentType.none,
  });

  final String id;
  final String text;
  final String senderId;
  final DateTime? createdAt;
  final bool isMine;
  final String? attachmentPath;
  final UserChatAttachmentType attachmentType;

  bool get hasAttachment => attachmentPath != null && attachmentPath!.isNotEmpty;

  factory UserChatMessage.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    // Sender may be a flat id or a nested `sender` object (send-message reply).
    final senderObj = json['sender'];
    final sender = _str(json['senderId']) ??
        _str(json['SenderId']) ??
        (senderObj is Map ? _str(senderObj['id']) : null) ??
        _str(json['userId']) ??
        '';
    final text = _str(json['messageText']) ??
        _str(json['text']) ??
        _str(json['Text']) ??
        _str(json['message']) ??
        _str(json['body']) ??
        '';
    final id = _str(json['messageId']) ??
        _str(json['id']) ??
        '${sender}_${json['messageSendDate'] ?? json['sendDate'] ?? text.hashCode}';

    return UserChatMessage(
      id: id,
      text: text,
      senderId: sender,
      createdAt: _date(
        json['messageSendDate'] ??
            json['sendDate'] ??
            json['createdAt'] ??
            json['CreatedAt'] ??
            json['sentAt'] ??
            json['date'],
      ),
      isMine: sender.isNotEmpty &&
          sender.toLowerCase() == currentUserId.toLowerCase(),
      attachmentPath:
          _str(json['chatAttachmentPath']) ?? _str(json['attachmentPath']),
      attachmentType: UserChatAttachmentType.fromApi(
        json['chatAttachmentType'] ?? json['attachmentType'],
      ),
    );
  }

  UserChatMessage copyWith({
    bool? isMine,
    String? text,
    String? attachmentPath,
    UserChatAttachmentType? attachmentType,
  }) => UserChatMessage(
        id: id,
        text: text ?? this.text,
        senderId: senderId,
        createdAt: createdAt,
        isMine: isMine ?? this.isMine,
        attachmentPath: attachmentPath ?? this.attachmentPath,
        attachmentType: attachmentType ?? this.attachmentType,
      );
}

/// Realtime payload from SignalR `NewMessagePushed`.
class UserChatPushEvent {
  const UserChatPushEvent({
    this.chatId,
    this.message,
    this.raw = const {},
  });

  final String? chatId;
  final UserChatMessage? message;
  final Map<String, dynamic> raw;

  factory UserChatPushEvent.fromJson(
    Map<String, dynamic> json, {
    required String currentUserId,
  }) {
    final nested = json['message'];
    final messageMap = nested is Map<String, dynamic> ? nested : json;

    final chatObj = messageMap['chat'];
    final chatId = _str(json['chatId']) ??
        _str(json['ChatId']) ??
        _str(messageMap['chatId']) ??
        _str(messageMap['ChatId']) ??
        (chatObj is Map ? _str(chatObj['id']) : null);

    UserChatMessage? message;
    final text = _str(messageMap['messageText']) ??
        _str(messageMap['text']) ??
        _str(messageMap['Text']) ??
        _str(messageMap['message']);
    if (text != null && text.isNotEmpty) {
      message =
          UserChatMessage.fromJson(messageMap, currentUserId: currentUserId);
    }

    return UserChatPushEvent(
      chatId: chatId,
      message: message,
      raw: json,
    );
  }
}
