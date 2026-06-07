import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';

class TableHeader extends StatelessWidget {
  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.kBorderLight.withOpacity(0.5),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(16.r),
          topEnd: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          _buildCell(AppString.projectName.tr(), width: 280.w, align: TextAlign.start),
          _buildCell(AppString.sector.tr(), width: 120.w, align: TextAlign.center),
          _buildCell(AppString.extractNumber.tr(), width: 100.w, align: TextAlign.center),
          _buildCell(AppString.extractValue.tr(), width: 120.w, align: TextAlign.center),
          _buildCell(AppString.extractStatus.tr(), width: 120.w, align: TextAlign.center),
          _buildCell(AppString.projectManagementStatus.tr(), width: 140.w, align: TextAlign.center),
          _buildCell(AppString.startDate.tr(), width: 100.w, align: TextAlign.center),
          _buildCell(AppString.endDate.tr(), width: 100.w, align: TextAlign.center),
          _buildCell('', width: 80.w, align: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required double width, TextAlign align = TextAlign.center}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: AppColor.kGrayTextColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
