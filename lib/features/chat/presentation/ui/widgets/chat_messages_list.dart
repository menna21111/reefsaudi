import 'package:reefsaudia/features/chat/core/widgets/app_snack_bar.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/chat_message_bubble.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessagesList extends StatelessWidget {
  const ChatMessagesList({
    required this.scrollController,
    required this.onScrollToBottom,
    this.horizontalPadding = 16,
    super.key,
  });
  final ScrollController scrollController;
  final VoidCallback onScrollToBottom;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        // Auto-scroll for:
        // - new assistant chunks (receiving)
        // - just became ready after a response
        // - thinking (user just sent a message)
        // - listening (voice press-and-hold just started)
        if (state.status.isReceiving ||
            state.status.isReady ||
            state.status.isThinking ||
            state.status.isListening) {
          var isUserNearBottom = true;
          if (scrollController.hasClients) {
            final maxScroll = scrollController.position.maxScrollExtent;
            final currentScroll = scrollController.offset;
            // If the user has scrolled up more than 150 pixels,
            // don't auto-scroll
            isUserNearBottom = maxScroll - currentScroll <= 150;
          }

          // Force scroll on new user actions, otherwise respect
          // user's scroll position
          if (state.status.isThinking ||
              state.status.isListening ||
              isUserNearBottom) {
            onScrollToBottom();
          }
        }
        if (state.status.isFailure) {
          AppSnackBar.showError(
            context,
            state.errorMessage ?? context.tr('genericError'),
          );
        }
      },
      builder: (context, state) {
        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            120,
            horizontalPadding,
            20,
          ),
          itemCount: state.messages.length,
          itemBuilder: (context, index) {
            final message = state.messages[index];
            final isUser = message.role.isUser;
            final isLastMessage = index == state.messages.length - 1;
            // Feedback buttons only show once a bot response is fully received
            final isComplete =
                !isUser && (!isLastMessage || state.status.isReady);

            return ChatMessageBubble(
              text: message.text,
              isUser: isUser,
              isLastMessage: !isUser && isLastMessage,
              onTextChanged: onScrollToBottom,
              messageId: message.id,
              isComplete: isComplete,
              isVoice: message.isVoice,
              rating: message.rating,
              thinkingSteps: message.thinkingSteps,
              isGenerating: message.isGenerating,
              isThinkingExpanded: message.isThinkingExpanded,
            );
          },
        );
      },
    );
  }
}
