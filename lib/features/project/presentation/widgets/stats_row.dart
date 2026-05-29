import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/funcation.dart';
import '../../../../core/utils/app_color.dart';
import '../screens/risks_screen.dart';
import '../screens/issues_screen.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'نسبة الإنجاز',
                value: '100.0%',
                color: AppColor.kPrimaryColor,
                showBottomLine: true,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: StatCard(
                title: 'نسبة التنفيذ',
                value: '100.0%',
                color: AppColor.kPrimaryColor,
                showBottomLine: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  AppFunctions.navigateTo(
                    context,
                    const RisksScreen(),
                    PageTransitionType.rightToLeft,
                  );
                },
                child: StatCard(
                  title: 'إدارة المخاطر',
                  value: '0',
                  color: AppColor.kRedColor,
                  icon: Icons.warning_amber_outlined,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  AppFunctions.navigateTo(
                    context,
                    const IssuesScreen(),
                    PageTransitionType.rightToLeft,
                  );
                },
                child: StatCard(
                  title: 'المشاكل',
                  value: '0',
                  color: AppColor.kGoldColor,
                  icon: Icons.error_outline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
