import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class MessageBubbleContainer extends StatelessWidget {
  const MessageBubbleContainer({
    required this.isUser,
    required this.child,
    super.key,
  });
  final bool isUser;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.85,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? colors.electricTeal.withValues(alpha: 0.15)
            : colors.secondaryNavy.withValues(alpha: 0.85),
        borderRadius: _getBorderRadius(),
        border: Border.all(
          color: isUser
              ? colors.electricTeal.withValues(alpha: 0.3)
              : colors.slateGrey.withValues(alpha: 0.15),
        ),
      ),
      child: SelectionArea(child: child),
    );
  }

  BorderRadius _getBorderRadius() {
    return BorderRadius.only(
      topLeft: const Radius.circular(20),
      topRight: const Radius.circular(20),
      bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
      bottomRight: isUser ? Radius.zero : const Radius.circular(20),
    );
  }
}
