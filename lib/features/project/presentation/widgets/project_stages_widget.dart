import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

class ProjectStagesWidget extends StatelessWidget {
  final List<StageData> stages;

  const ProjectStagesWidget({
    Key? key,
    required this.stages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.stairs, color: AppColor.kPrimaryColor, size: 16.sp),
              SizedBox(width: 8.w),
              Text(
                'مراحل المشروع',
                style: TextStyle(
                  color: AppColor.kWhiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stages
                .asMap()
                .entries
                .map((entry) => _buildStageBar(
                      entry.value.label,
                      entry.value.progress,
                      entry.key,
                    ))
                .toList(),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegend('مكتمل', AppColor.kPrimaryColor),
              _buildLegend('قيد التنفيذ', AppColor.kGoldColor),
              _buildLegend('مجدول', AppColor.kBorderColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStageBar(String label, double progress, int delay) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: AppColor.kBorderColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.bottomCenter,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: progress),
            duration: Duration(milliseconds: 1000 + (delay * 200)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Container(
                width: 60.w,
                height: 100.h * value,
                decoration: BoxDecoration(
                  color: AppColor.kPrimaryColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 9.sp),
        ),
      ],
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 9.sp),
        ),
      ],
    );
  }
}

class StageData {
  final String label;
  final double progress;

  StageData({required this.label, required this.progress});
}
