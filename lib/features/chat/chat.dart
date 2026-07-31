import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/permissions/permission_cubit.dart';
import '../../core/services/service_locator.dart';
import 'core/config/app_config.dart';
import 'core/networking/url_provider.dart';
import 'presentation/logic/chat_cubit.dart';
import 'presentation/ui/chat_screen.dart';

/// Opens the Fahim chat screen (WebSocket AI agent) with the current user.
Future<void> openChatScreen(BuildContext context) async {
  ensureChatConfig();

  final profile = context.read<PermissionCubit>().state;
  final url = UrlProvider.webSocketUrlWithUser(
    userId: profile?.id,
    userName: profile?.displayName ?? profile?.userName,
  );

  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<ChatCubit>()..connect(url),
        child: const ChatScreen(),
      ),
    ),
  );
}
