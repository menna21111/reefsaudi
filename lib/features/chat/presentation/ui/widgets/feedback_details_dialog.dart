import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/presentation/logic/chat_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Opens a dialog asking the user to categorize their thumbs-down feedback.
void showFeedbackDetailsDialog(
  BuildContext context,
  String messageId,
  String rating,
) {
  showDialog<void>(
    context: context,
    builder: (_) => BlocProvider.value(
      value: context.read<ChatCubit>(),
      child: _FeedbackDetailsDialog(messageId: messageId, rating: rating),
    ),
  );
}

class _FeedbackDetailsDialog extends StatefulWidget {
  const _FeedbackDetailsDialog({required this.messageId, required this.rating});

  final String messageId;
  final String rating;

  @override
  State<_FeedbackDetailsDialog> createState() => _FeedbackDetailsDialogState();
}

class _FeedbackDetailsDialogState extends State<_FeedbackDetailsDialog> {
  late final TextEditingController commentController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final categories = [
      'categoryWrongInfo',
      'categoryIrrelevant',
      'categoryInappropriate',
      'categoryOther',
    ];

    return AlertDialog(
      backgroundColor: colors.secondaryNavy,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        context.tr('feedbackTitle'),
        style: TextStyle(color: colors.offWhite, fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedCategory,
            dropdownColor: colors.primaryNavy,
            style: TextStyle(color: colors.offWhite, fontSize: 14),
            decoration: InputDecoration(
              hintText: context.tr('selectReason'),
              hintStyle: TextStyle(
                color: colors.slateGrey.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: colors.primaryNavy,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: categories
                .map(
                  (catKey) => DropdownMenuItem(
                    value: catKey,
                    child: Text(context.tr(catKey)),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedCategory = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: commentController,
            maxLines: 3,
            style: TextStyle(color: colors.offWhite, fontSize: 14),
            decoration: InputDecoration(
              hintText: context.tr('additionalComment'),
              hintStyle: TextStyle(
                color: colors.slateGrey.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: colors.primaryNavy,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            context.tr('skip'),
            style: TextStyle(color: colors.slateGrey.withValues(alpha: 0.7)),
          ),
        ),
        FilledButton(
          onPressed: _selectedCategory == null ? null : _submit,
          child: Text(context.tr('send')),
        ),
      ],
    );
  }

  void _submit() {
    context.read<ChatCubit>().sendFeedbackDetails(
      messageId: widget.messageId,
      rating: widget.rating,
      category: context.tr(_selectedCategory!),
      comment: commentController.text.trim(),
    );
    Navigator.of(context).pop();
  }
}
