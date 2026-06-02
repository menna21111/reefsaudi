import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import 'achievement_profile_avatar.dart';

class AchievementRatesAppBar extends StatelessWidget {
  const AchievementRatesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AchievementProfileAvatar(),
        SizedBox(width: 4.w),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
          icon: Icon(
            Icons.search_rounded,
            color: Theme.of(context).textTheme.bodyMedium?.color,
            size: 22.sp,
          ),
          onPressed: () {},
        ),
        Expanded(
          child: RobotoText(
            text: 'achievement_rates_management'.tr(),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.displayLarge?.color ?? AppColor.kWhiteColor,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(minWidth: 40.w, minHeight: 40.w),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 20.sp,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ],
    );
  }
}
