import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatInputSendButton extends StatelessWidget {
  const ChatInputSendButton({
    required this.textController,
    required this.isBusy,
    super.key,
  });

  final TextEditingController textController;
  final bool isBusy;

  static const double _buttonSize = 56;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: isBusy
          ? null
          : () {
              context.read<ChatCubit>().sendMessage(textController.text);
              textController.clear();
              FocusManager.instance.primaryFocus?.unfocus();
            },
      child: SizedBox(
        width: _buttonSize,
        height: _buttonSize,
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isBusy ? 0.4 : 1.0,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: colors.orbGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.electricTeal.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_upward,
                color: colors.primaryNavy,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
