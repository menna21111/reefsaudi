import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../domain/models/task_item.dart';

class TasksChangeStatusSheet {
  static Future<void> show(
    BuildContext context, {
    required TaskItem task,
    required ValueChanged<String> onStatusSelected,
  }) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColor.kSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.kBorderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),
              RobotoText(
                text: 'task_name'.tr(),
                color: AppColor.kPrimaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 4.h),
              Text(
                task.title,
                style: TextStyle(
                  color: AppColor.kGrayTextColor,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              _StatusOption(
                title: 'new_status'.tr(),
                subtitle: 'newly_added_tasks'.tr(),
                isSelected: task.status == 'new',
                icon: Icons.bookmark_added_rounded,
                onTap: () {
                  onStatusSelected('new');
                  Navigator.pop(sheetContext);
                },
              ),
              SizedBox(height: 12.h),
              _StatusOption(
                title: 'in_progress_status'.tr(),
                subtitle: 'currently_working_on'.tr(),
                isSelected: task.status == 'in_progress',
                icon: Icons.timelapse_rounded,
                onTap: () {
                  onStatusSelected('in_progress');
                  Navigator.pop(sheetContext);
                },
              ),
              SizedBox(height: 12.h),
              _StatusOption(
                title: 'under_review_status'.tr(),
                subtitle: 'waiting_supervisor_approval'.tr(),
                isSelected: task.status == 'pending',
                icon: Icons.rate_review_rounded,
                onTap: () {
                  onStatusSelected('pending');
                  Navigator.pop(sheetContext);
                },
              ),
              SizedBox(height: 12.h),
              _StatusOption(
                title: 'completed_status'.tr(),
                subtitle: 'task_fully_completed'.tr(),
                isSelected: task.status == 'ended',
                icon: Icons.check_circle_rounded,
                onTap: () {
                  onStatusSelected('ended');
                  Navigator.pop(sheetContext);
                },
              ),
              SizedBox(height: 24.h),
              OutlinedButton(
                onPressed: () => Navigator.pop(sheetContext),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColor.kInputBorderColor),
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: RobotoText(
                  text: 'cancel'.tr(),
                  color: AppColor.kRedColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatusOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _StatusOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.kPrimaryColor.withOpacity(0.1)
              : AppColor.kBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColor.kPrimaryColor
                : AppColor.kBorderColor.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : icon,
              color: isSelected
                  ? AppColor.kPrimaryColor
                  : AppColor.kGrayTextColor,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColor.kPrimaryColor
                          : AppColor.kWhiteColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColor.kGrayTextColor,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              color: AppColor.kGrayTextColor,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
