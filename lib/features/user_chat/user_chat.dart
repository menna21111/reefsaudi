import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/permissions/permission_cubit.dart';
import '../../core/services/service_locator.dart';
import 'core/notifications_hub_service.dart';
import 'data/repositories/user_chat_repository_impl.dart';
import 'presentation/cubit/user_chat_list_cubit.dart';
import 'presentation/screens/user_chat_list_screen.dart';

/// Opens the user-to-user chat list (SignalR notifications hub + Chat APIs).
Future<void> openUserChatScreen(BuildContext context) async {
  final profile = context.read<PermissionCubit>().state;
  final userId = profile?.id;
  if (userId == null || userId.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User session not ready')),
    );
    return;
  }

  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(
        providers: [
          RepositoryProvider<UserChatRepository>.value(
            value: sl<UserChatRepository>(),
          ),
          RepositoryProvider<NotificationsHubService>.value(
            value: sl<NotificationsHubService>(),
          ),
          BlocProvider(
            create: (_) => UserChatListCubit(
              repository: sl(),
              hub: sl(),
              currentUserId: userId,
            )..load(),
          ),
        ],
        child: const UserChatListScreen(),
      ),
    ),
  );
}
