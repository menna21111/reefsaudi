import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/funcation.dart';
import 'package:reefsaudia/core/services/service_locator.dart';

import '../../../../core/utils/app_theme_context.dart';
import 'package:reefsaudia/features/project/presentation/cubit/project_statistics_cubit.dart';
import '../screens/issues_screen.dart';
import '../screens/risks_screen.dart';
import 'stat_card.dart';

class StatsRow extends StatelessWidget {
  final String projectId;
  final double completionPercent;
  final double executionPercent;
  final int risksCount;

  const StatsRow({
    super.key,
    required this.projectId,
    required this.completionPercent,
    required this.executionPercent,
    required this.risksCount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'نسبة الإنجاز',
                value: '${completionPercent.toStringAsFixed(1)}%',
                color: colors.kPrimaryColor,
                showBottomLine: true,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: StatCard(
                title: 'نسبة التنفيذ',
                value: '${executionPercent.toStringAsFixed(1)}%',
                color: colors.kPrimaryColor,
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
                    BlocProvider(
                      create: (_) =>
                          sl<ProjectRisksCubit>()..load(projectId),
                      child: RisksScreen(projectId: projectId),
                    ),
                    PageTransitionType.rightToLeft,
                  );
                },
                child: StatCard(
                  title: 'إدارة المخاطر',
                  value: '$risksCount',
                  color: colors.kRedColor,
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
                  color: colors.kGoldColor,
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
