import 'package:reefsaudia/features/chat/core/theming/app_colors.dart';
import 'package:reefsaudia/features/chat/core/widgets/app_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButton extends StatelessWidget {
  const CopyButton({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return IconButton(
      icon: Icon(
        Icons.copy,
        size: 18,
        color: colors.slateGrey.withValues(alpha: 0.5),
      ),
      onPressed: () {
        if (text.isEmpty) {
          return;
        }
        Clipboard.setData(ClipboardData(text: text));
        AppSnackBar.showSuccess(
          context,
          context.tr('copied'),
          duration: const Duration(seconds: 1),
        );
      },
    );
  }
}
