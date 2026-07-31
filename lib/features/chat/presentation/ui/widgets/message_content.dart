import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/typewriter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageContent extends StatelessWidget {
  const MessageContent({
    required this.text,
    required this.isUser,
    required this.isLastMessage,
    required this.onTextChanged,
    this.onFinishedTyping,
    super.key,
  });
  final String text;
  final bool isUser;
  final bool isLastMessage;
  final VoidCallback onTextChanged;
  final VoidCallback? onFinishedTyping;

  MarkdownStyleSheet _markdownStyleSheet(AppColors colors) =>
      MarkdownStyleSheet(
        p: TextStyle(fontSize: 16, color: colors.offWhite, height: 1.5),
        strong: TextStyle(
          fontWeight: FontWeight.bold,
          color: colors.accentGold,
        ),
        blockquote: TextStyle(color: colors.slateGrey),
        code: TextStyle(
          color: colors.electricTeal,
          backgroundColor: colors.primaryNavy.withValues(alpha: 0.5),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    if (isUser) {
      return Text(
        text,
        style: TextStyle(
          color: colors.offWhite,
          fontSize: 16,
          height: 1.4,
        ),
      );
    }

    final sheet = _markdownStyleSheet(colors);

    if (isLastMessage) {
      return TypewriterMarkdown(
        text: text,
        onChanged: onTextChanged,
        onFinished: onFinishedTyping,
        styleSheet: sheet,
      );
    }

    return MarkdownBody(data: text, styleSheet: sheet);
  }
}
