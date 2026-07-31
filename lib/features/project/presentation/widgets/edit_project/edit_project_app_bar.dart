import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';

class EditProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditProjectAppBar({super.key, this.title});

  final String? title;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AppBar(
      backgroundColor: colors.kInputColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, color: colors.kFontColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title ?? AppString.editProject.tr(),
        style: TextStyle(
          color: colors.kFontColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: colors.kBorderColor.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
