import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/chat_input_area.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/chat_messages_list.dart';
import 'package:flutter/material.dart';

/// Max width for chat content on web / large screens; keeps layout readable.
const double kChatMaxWidth = 700;

class ChatScreenBody extends StatelessWidget {
  const ChatScreenBody({
    required this.scrollController,
    required this.textController,
    required this.onScrollToBottom,
    required this.onStopAudio,
    super.key,
  });
  final ScrollController scrollController;
  final TextEditingController textController;
  final VoidCallback onScrollToBottom;
  final Future<void> Function() onStopAudio;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > kChatMaxWidth;

    return DecoratedBox(
      decoration: BoxDecoration(gradient: colors.backgroundGradient),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: kChatMaxWidth),
          child: Column(
            children: [
              Expanded(
                child: ChatMessagesList(
                  scrollController: scrollController,
                  onScrollToBottom: onScrollToBottom,
                  horizontalPadding: isWide ? 24.0 : 16.0,
                ),
              ),
              ChatInputArea(
                textController: textController,
                onScrollToBottom: onScrollToBottom,
                onStopAudio: onStopAudio,
                horizontalPadding: isWide ? 16.0 : 6.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
