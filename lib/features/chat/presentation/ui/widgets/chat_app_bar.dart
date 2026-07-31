import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _showNewChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final dialogColors = AppColors.of(dialogContext);
        return AlertDialog(
          backgroundColor: dialogColors.secondaryNavy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: dialogColors.slateGrey.withValues(alpha: 0.2),
            ),
          ),
          title: Text(
            dialogContext.tr('newChat'),
            style: TextStyle(
              color: dialogColors.offWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            dialogContext.tr('newChatConfirm'),
            style: TextStyle(color: dialogColors.slateGrey, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                dialogContext.tr('cancel'),
                style: TextStyle(color: dialogColors.slateGrey, fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                context.read<ChatCubit>().startNewChat();
              },
              child: Text(
                dialogContext.tr('yes'),
                style: TextStyle(
                  color: dialogColors.electricTeal,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return AppBar(
      title: const Text('Fahim', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      backgroundColor: colors.primaryNavy.withValues(alpha: 0.95),
      elevation: 0,
      foregroundColor: colors.offWhite,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: context.tr('newChatTooltip'),
          onPressed: () => _showNewChatDialog(context),
        ),
      ],
    );
  }
}
