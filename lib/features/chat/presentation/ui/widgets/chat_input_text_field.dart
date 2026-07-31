import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _SendIntent extends Intent {
  const _SendIntent();
}

class ChatInputTextField extends StatelessWidget {
  const ChatInputTextField({
    required this.textController,
    required this.isBusy,
    super.key,
  });

  final TextEditingController textController;
  final bool isBusy;

  static bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    // Shortcuts: Enter (without Shift) → send. Shift+Enter won't match, so
    // TextField gets it and inserts newline. includeRepeats: false prevents
    // key repeat from sending.
    final shortcuts = _isMobile
        // Mobile: Enter = newline, Send button = send
        ? <ShortcutActivator, Intent>{}
        : <ShortcutActivator, Intent>{
            const SingleActivator(
              LogicalKeyboardKey.enter,
              includeRepeats: false,
            ): const _SendIntent(),
            const SingleActivator(
              LogicalKeyboardKey.numpadEnter,
              includeRepeats: false,
            ): const _SendIntent(),
          };

    return Shortcuts(
      shortcuts: shortcuts,
      child: Actions(
        actions: {
          _SendIntent: CallbackAction<_SendIntent>(
            onInvoke: (_) {
              if (isBusy) return null;
              final text = textController.text.trim();
              if (text.isNotEmpty) {
                context.read<ChatCubit>().sendMessage(text);
                textController.clear();
              }
              return null;
            },
          ),
        },
        child: TextField(
          controller: textController,
          enabled: !isBusy,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.multiline,
          // newline ensures TextField inserts \n when Shortcuts don't match (e.g. Shift+Enter)
          textInputAction: TextInputAction.newline,
          minLines: 1,
          maxLines: 5,
          style: TextStyle(color: colors.offWhite),
          decoration: InputDecoration(
            hintText: context.tr('chatHint'),
            hintStyle: TextStyle(
              color: colors.slateGrey.withValues(alpha: 0.5),
            ),
            filled: true,
            fillColor: colors.secondaryNavy,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
          onSubmitted: (text) {
            if (isBusy) return;
            final t = text.trim();
            if (t.isNotEmpty) {
              context.read<ChatCubit>().sendMessage(t);
              textController.clear();
            }
          },
        ),
      ),
    );
  }
}
