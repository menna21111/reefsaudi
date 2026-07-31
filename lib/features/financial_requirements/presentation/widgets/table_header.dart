import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.kBorderColor.withValues(alpha: 0.35),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(16.r),
          topEnd: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          _buildCell(
            context,
            AppString.projectName.tr(),
            width: 280.w,
            align: TextAlign.start,
          ),
          _buildCell(context, AppString.sector.tr(), width: 120.w),
          _buildCell(context, AppString.extractNumber.tr(), width: 100.w),
          _buildCell(context, AppString.extractValue.tr(), width: 120.w),
          _buildCell(context, AppString.extractStatus.tr(), width: 120.w),
          _buildCell(
            context,
            AppString.projectManagementStatus.tr(),
            width: 140.w,
          ),
          _buildCell(context, AppString.startDate.tr(), width: 100.w),
          _buildCell(context, AppString.endDate.tr(), width: 100.w),
          _buildCell(context, '', width: 80.w),
        ],
      ),
    );
  }

  Widget _buildCell(
    BuildContext context,
    String text, {
    required double width,
    TextAlign align = TextAlign.center,
  }) {
    final colors = context.appColors;
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: colors.kGrayColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
