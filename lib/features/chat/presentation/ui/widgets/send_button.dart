import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendButton extends StatelessWidget {
  const SendButton({required this.textController, super.key});

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondaryNavy,
        shape: BoxShape.circle,
        border: Border.all(color: colors.slateGrey.withValues(alpha: 0.3)),
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_upward, color: colors.electricTeal),
        onPressed: () {
          context.read<ChatCubit>().sendMessage(textController.text);
          textController.clear();
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    );
  }
}
