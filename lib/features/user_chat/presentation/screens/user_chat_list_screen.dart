import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../../core/notifications_hub_service.dart';
import '../../data/models/user_chat_models.dart';
import '../../data/repositories/user_chat_repository_impl.dart';
import '../cubit/user_chat_list_cubit.dart';
import '../cubit/user_chat_thread_cubit.dart';
import 'user_chat_thread_screen.dart';

class UserChatListScreen extends StatelessWidget {
  const UserChatListScreen({super.key});

  void _openThread(BuildContext context, UserChatSummary chat) {
    final listCubit = context.read<UserChatListCubit>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider(
          create: (_) => UserChatThreadCubit(
            repository: context.read<UserChatRepository>(),
            hub: context.read<NotificationsHubService>(),
            chatId: chat.id,
            currentUserId: listCubit.currentUserId,
          )..load(),
          child: UserChatThreadScreen(title: chat.displayName),
        ),
      ),
    );
  }

  Future<void> _openContact(
    BuildContext context,
    UserChatContact contact,
  ) async {
    final listCubit = context.read<UserChatListCubit>();
    final repository = context.read<UserChatRepository>();
    final chatId = await repository.startChat(
      senderId: listCubit.currentUserId,
      recipientId: contact.id,
    );
    if (!context.mounted) return;
    _openThread(
      context,
      UserChatSummary(
        id: chatId,
        displayName: contact.displayName,
        recipientId: contact.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        foregroundColor: colors.kFontColor,
        title: Text(
          'user_chat_title'.tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        actions: [
          BlocBuilder<UserChatListCubit, UserChatListState>(
            builder: (context, state) {
              final connected =
                  state is UserChatListLoaded && state.hubConnected;
              return Padding(
                padding: EdgeInsetsDirectional.only(end: 12.w),
                child: Icon(
                  Icons.circle,
                  size: 10.sp,
                  color: connected ? colors.kPrimaryColor : colors.kGrayColor,
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<UserChatListCubit, UserChatListState>(
        builder: (context, state) {
          if (state is UserChatListLoading || state is UserChatListInitial) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }
          if (state is UserChatListError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.kFontColor),
                    ),
                    SizedBox(height: 12.h),
                    TextButton(
                      onPressed: () => context.read<UserChatListCubit>().load(),
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is! UserChatListLoaded) {
            return const SizedBox.shrink();
          }
          if (state.chats.isEmpty && state.contacts.isEmpty) {
            return Center(
              child: Text(
                'user_chat_empty'.tr(),
                style: TextStyle(color: colors.kGrayColor, fontSize: 15.sp),
              ),
            );
          }

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<UserChatListCubit>().refresh(),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              children: [
                if (state.chats.isNotEmpty) ...[
                  _SectionLabel(title: 'user_chat_recent_chats'.tr()),
                  ...state.chats.map(
                    (chat) => Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                          leading: CircleAvatar(
                            backgroundColor: colors.kPrimaryColor.withValues(alpha: 0.15),
                            child: Text(
                              chat.displayName.isNotEmpty
                                  ? chat.displayName.characters.first
                                  : '?',
                              style: TextStyle(
                                color: colors.kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            chat.displayName,
                            style: TextStyle(
                              color: colors.kFontColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                          subtitle: chat.lastMessage == null
                              ? null
                              : Text(
                                  chat.lastMessage!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors.kGrayColor,
                                    fontSize: 12.sp,
                                  ),
                                ),
                          trailing: chat.unreadCount > 0
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.kPrimaryColor,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Text(
                                    '${chat.unreadCount}',
                                    style: TextStyle(
                                      color: colors.kWhiteColor,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
                          onTap: () => _openThread(context, chat),
                        ),
                        Divider(
                          color: colors.kBorderColor.withValues(alpha: 0.4),
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
                if (state.contacts.isNotEmpty) ...[
                  _SectionLabel(title: 'user_chat_contacts'.tr()),
                  ...state.contacts.map(
                    (contact) => Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 6.h),
                          leading: CircleAvatar(
                            backgroundColor: colors.kGoldColor.withValues(alpha: 0.16),
                            child: Text(
                              contact.displayName.isNotEmpty
                                  ? contact.displayName.characters.first
                                  : '?',
                              style: TextStyle(
                                color: colors.kGoldColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            contact.displayName,
                            style: TextStyle(
                              color: colors.kFontColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15.sp,
                            ),
                          ),
                          subtitle: Text(
                            'user_chat_start_new'.tr(),
                            style: TextStyle(
                              color: colors.kGrayColor,
                              fontSize: 12.sp,
                            ),
                          ),
                          trailing: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: colors.kGoldColor,
                          ),
                          onTap: () => _openContact(context, contact),
                        ),
                        Divider(
                          color: colors.kBorderColor.withValues(alpha: 0.4),
                          height: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: TextStyle(
          color: colors.kGrayColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
