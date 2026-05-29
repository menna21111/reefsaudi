import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/funcation.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../project/presentation/screens/project_details_screen.dart';
import '../../domain/entities/project.dart';
import 'package:intl/intl.dart';

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(project.status);

    return GestureDetector(
      onTap: () {
        AppFunctions.navigateTo(
          context,
          const ProjectDetailsScreen(),
          PageTransitionType.leftToRight,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.kSurfaceColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(statusData),
            _buildTitleAndDescription(),
            _buildBudgetAndEntity(),
            SizedBox(height: 14.h),
            _buildProgressBar(statusData),
            SizedBox(height: 12.h),
            Divider(color: AppColor.kBorderColor.withOpacity(0.3), height: 1),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusData(String status) {
    switch (status) {
      case 'finished':
        return {
          'color': AppColor.kPrimaryColor,
          'bg': AppColor.kPrimaryColor.withOpacity(0.1),
          'label': AppString.finished.tr(),
        };
      case 'stalled':
        return {
          'color': AppColor.kGoldColor,
          'bg': AppColor.kGoldColor.withOpacity(0.1),
          'label': AppString.stalled.tr(),
        };
      default:
        return {
          'color': Colors.cyan,
          'bg': Colors.cyan.withOpacity(0.1),
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
          RobotoText(
            text: project.daysLeft != null
                ? '${project.daysLeft} ${'يوم متبقي'.tr()}'
                : 'تم التسليم'.tr(),
            fontSize: 11.sp,
            color: AppColor.kGrayTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAndDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RobotoText(
            text: project.title,

            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColor.kWhiteColor,
          ),
          SizedBox(height: 6.h),
          RobotoText(
            text: project.description,
            fontSize: 12.sp,
            color: AppColor.kGrayTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetAndEntity() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RobotoText(
                text: 'الميزانية'.tr(),
                fontSize: 11.sp,
                color: AppColor.kGrayTextColor,
              ),
              SizedBox(height: 4.h),
              RobotoText(
                text:
                    '${NumberFormat('#,###').format(project.budget)} ${AppString.sar.tr()}',
                fontSize: 12.sp,
                color: AppColor.kPrimaryColor,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RobotoText(
                text: 'الحالة'.tr(),
                fontSize: 11.sp,
                color: AppColor.kGrayTextColor,
              ),

              SizedBox(height: 4.h),
              RobotoText(
                text: project.entityName,
                fontSize: 12.sp,
                color: AppColor.kWhiteColor,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Map<String, dynamic> statusData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RobotoText(
                text: 'نسبة الإنجاز'.tr(),
                fontSize: 11.sp,
                color: AppColor.kGrayTextColor,
              ),
              RobotoText(
                text: '${project.progress.toInt()}%',
                fontSize: 11.sp,
                color: AppColor.kWhiteColor,
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
              backgroundColor: AppColor.kBackgroundColor,
              valueColor: AlwaysStoppedAnimation<Color>(statusData['color']),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
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
                  color: AppColor.kGrayTextColor,
                  size: 20.sp,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.remove_red_eye_outlined,
                  color: AppColor.kGrayTextColor,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_horiz_rounded,
              color: AppColor.kGrayTextColor,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }
}
