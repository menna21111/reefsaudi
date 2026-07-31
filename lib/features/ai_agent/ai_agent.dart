import 'package:flutter/material.dart';

import '../chat/chat.dart';
import '../chat/core/config/app_config.dart';

/// Opens the Fahim AI chat screen, connected with the current user identity.
///
/// Prefer [openChatScreen]; this keeps the older entry-point name working.
Future<void> openAiAgentChat(BuildContext context) async {
  ensureChatConfig();
  await openChatScreen(context);
}
