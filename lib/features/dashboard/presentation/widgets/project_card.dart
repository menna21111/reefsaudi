import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/services/service_locator.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/funcation.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../project/presentation/cubit/project_statistics_cubit.dart';
import '../../../project/presentation/screens/project_details_screen.dart';
import '../../domain/entities/project.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  Color _parseHexColor(String? hex, Color fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    final value = hex.replaceAll('#', '');
    if (value.length != 6) return fallback;
    return Color(int.parse('FF$value', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final statusData = _getStatusData(context, project.status);

    return GestureDetector(
      onTap: () {
        AppFunctions.navigateTo(
          context,
          BlocProvider(
            create: (_) => sl<ProjectDetailsCubit>()..load(project.id),
            child: ProjectDetailsScreen(projectId: project.id),
          ),
          PageTransitionType.leftToRight,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(statusData),
            _buildTitleAndDescription(context),
            _buildBudgetAndEntity(context),
            SizedBox(height: 14.h),
            _buildProgressBar(context, statusData),
            SizedBox(height: 12.h),
            Divider(
              color: colors.kBorderColor.withValues(alpha: 0.3),
              height: 1,
            ),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(BuildContext context, String status) {
    final colors = context.appColors;
    final apiColor = _parseHexColor(project.statusColor, colors.kPrimaryColor);

    switch (status) {
      case 'finished':
        return {
          'color': apiColor,
          'bg': apiColor.withValues(alpha: 0.1),
          'label': AppString.finished.tr(),
        };
      case 'stalled':
        return {
          'color': apiColor,
          'bg': apiColor.withValues(alpha: 0.1),
          'label': AppString.stalled.tr(),
        };
      default:
        return {
          'color': apiColor,
          'bg': apiColor.withValues(alpha: 0.1),
          'label': AppString.inProgress.tr(),
        };
    }
  }

  Widget _buildHeader(Map<String, dynamic> statusData) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusData['bg'],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: statusData['color'].withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: statusData['color'],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 6.w),
                RobotoText(
                  text: statusData['label'],

                  color: statusData['color'],
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          Builder(
            builder: (context) => RobotoText(
              text: project.daysLeft != null
                  ? '${project.daysLeft} ${AppString.daysRemaining.tr()}'
                  : AppString.delivered.tr(),
              fontSize: 11.sp,
              color: context.appColors.kGrayColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndDescription(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RobotoText(
            text: project.title,

            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: colors.kFontColor,
          ),
          SizedBox(height: 6.h),
          RobotoText(
            text: project.description,
            fontSize: 12.sp,
            color: colors.kGrayColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetAndEntity(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RobotoText(
                text: AppString.budget.tr(),
                fontSize: 11.sp,
                color: colors.kGrayColor,
              ),
              SizedBox(height: 4.h),
              RobotoText(
                text:
                    '${NumberFormat('#,###').format(project.budget)} ${AppString.sar.tr()}',
                fontSize: 12.sp,
                color: colors.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RobotoText(
                text: AppString.statusLabel.tr(),
                fontSize: 11.sp,
                color: colors.kGrayColor,
              ),

              SizedBox(height: 4.h),
              RobotoText(
                text: project.entityName,
                fontSize: 12.sp,
                color: colors.kFontColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, Map<String, dynamic> statusData) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RobotoText(
                text: AppString.completionPercentage.tr(),
                fontSize: 11.sp,
                color: colors.kGrayColor,
              ),
              RobotoText(
                text: '${project.progress.toInt()}%',
                fontSize: 11.sp,
                color: colors.kFontColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: project.progress / 100,
              minHeight: 6.h,
              backgroundColor: colors.kBgColor,
              valueColor: AlwaysStoppedAnimation<Color>(statusData['color']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.description_outlined,
                  color: colors.kGrayColor,
                  size: 20.sp,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  color: colors.kGrayColor,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz_rounded,
              color: colors.kGrayColor,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
