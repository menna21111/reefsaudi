import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:reefsaudia/features/chat/presentation/ui/widgets/feedback_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Thumbs-up / thumbs-down row rendered below completed AI bubbles.
///
/// If [currentRating] is null both icons are shown (neutral state).
/// Once rated, only the chosen icon is shown highlighted — no reverting.
class FeedbackRowWidget extends StatelessWidget {
  const FeedbackRowWidget({
    required this.messageId,
    this.currentRating,
    super.key,
  });

  final String messageId;

  /// 'thumbs_up' | 'thumbs_down' | null (unrated)
  final String? currentRating;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasRating = currentRating != null;

    // After rating: only show the chosen icon, highlighted
    if (hasRating) {
      final isUp = currentRating == 'thumbs_up';
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isUp ? Icons.thumb_up_rounded : Icons.thumb_down_rounded,
              size: 16,
              color: isUp ? colors.electricTeal : colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              isUp ? 'مفيد' : 'غير مفيد',
              style: TextStyle(
                fontSize: 11,
                color: colors.slateGrey.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      );
    }

    // Unrated: show both buttons
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FeedbackButton(
          icon: Icons.thumb_up_outlined,
          tooltip: 'مفيد',
          onTap: () => context.read<ChatCubit>().sendFeedback(
            messageId: messageId,
            rating: 'thumbs_up',
          ),
        ),
        _FeedbackButton(
          icon: Icons.thumb_down_outlined,
          tooltip: 'غير مفيد',
          onTap: () {
            // Step 1: Send thumbs_down immediately
            context.read<ChatCubit>().sendFeedback(
              messageId: messageId,
              rating: 'thumbs_down',
            );
            // Step 2: Open details dialog for categorization
            showFeedbackDetailsDialog(context, messageId, 'thumbs_down');
          },
        ),
      ],
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Icon(
            icon,
            size: 16,
            color: colors.slateGrey.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}
