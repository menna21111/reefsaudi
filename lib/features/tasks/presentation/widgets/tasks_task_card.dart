import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../domain/models/task_item.dart';

class TasksTaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;

  const TasksTaskCard({
    super.key,
    required this.task,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 3.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: task.indicatorColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            if (task.hasImage) ...[
              SizedBox(height: 12.h),
              Container(
                height: 70.h,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isDark 
                      ? AppColor.kBackgroundColor 
                      : AppColor.kLightSurfaceColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 6.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColor.kPrimaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            height: 6.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: AppColor.kGoldColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.insert_chart_outlined_rounded,
                      color: AppColor.kPrimaryColor,
                      size: 36.sp,
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10.r,
                      backgroundColor: AppColor.kPrimaryColor.withOpacity(0.2),
                      child: Text(
                        task.owner[0],
                        style: TextStyle(
                          color: AppColor.kPrimaryColor,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      task.owner,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: task.badgeColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    task.statusLabel,
                    style: TextStyle(
                      color: task.badgeTextColor,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
