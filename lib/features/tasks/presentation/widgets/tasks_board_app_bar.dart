import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class TasksBoardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String projectSubtitle;
  final VoidCallback? onSearchTap;

  const TasksBoardAppBar({
    super.key,
    this.showBackButton = false,
    this.projectSubtitle = 'Sustainable Coastal Dev.',
    this.onSearchTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : IconButton(
              icon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).iconTheme.color,
                size: 22.sp,
              ),
              onPressed: onSearchTap,
            ),
      title: Column(
        children: [
          RobotoText(
            text: 'tasks_board'.tr(),
            color: Theme.of(context).textTheme.displayLarge?.color ?? AppColor.kWhiteColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 2.h),
          Text(
            projectSubtitle,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        if (showBackButton)
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).iconTheme.color,
              size: 22.sp,
            ),
            onPressed: onSearchTap,
          )
        else
          const SizedBox(width: 48),
      ],
    );
  }
}
