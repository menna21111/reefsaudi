import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../domain/entities/project.dart';
import 'package:intl/intl.dart';

class TableRowWidget extends StatelessWidget {
  final Project project;
  final bool isLast;

  const TableRowWidget({
    super.key,
    required this.project,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final statusData = _getStatusData(project.status);
    final parts = _getLocationParts(project.title);

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: AppColor.kBorderColor.withOpacity(0.3),
                ),
              ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProjectNameColumn(statusData),
            _buildTextColumn(parts['sector']!),
            _buildTextColumn(parts['region']!),
            _buildValueColumn(),
            _buildProgressColumn(statusData),
            _buildActionsColumn(),
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

  Map<String, String> _getLocationParts(String title) {
    final parts = title.split(' - ');
    if (parts.length >= 3) {
      return {'sector': parts[0], 'region': parts[1]};
    }
    return {'sector': 'الفاكهة', 'region': 'عسير'};
  }

  Widget _buildProjectNameColumn(Map<String, dynamic> statusData) {
    return SizedBox(
      width: 250.w,
      child: Row(
        children: [
          Container(
            width: 4.w,
            margin: EdgeInsets.only(
              right: 4.w,
              left: 12.w,
              top: 12.h,
              bottom: 12.h,
            ),
            decoration: BoxDecoration(
              color: statusData['color'],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Text(
                project.title,
                style: TextStyle(
                  color: AppColor.kWhiteColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextColumn(String text) {
    return SizedBox(
      width: 100.w,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildValueColumn() {
    return SizedBox(
      width: 150.w,
      child: Center(
        child: Text(
          '${NumberFormat('#,###').format(project.budget)} ${AppString.sar.tr()}',
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildProgressColumn(Map<String, dynamic> statusData) {
    return SizedBox(
      width: 180.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusData['bg'],
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: statusData['color'].withOpacity(0.3)),
              ),
              child: Text(
                statusData['label'],
                style: TextStyle(
                  color: statusData['color'],
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${project.progress.toInt()}%',
                      style: TextStyle(
                        color: AppColor.kWhiteColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: project.progress / 100,
                      minHeight: 4.h,
                      backgroundColor: AppColor.kBackgroundColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        statusData['color'],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsColumn() {
    return SizedBox(
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: Icon(
              Icons.remove_red_eye_outlined,
              color: AppColor.kGrayTextColor,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 8.w),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {},
            icon: Icon(
              Icons.description_outlined,
              color: AppColor.kGrayTextColor,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }
}
