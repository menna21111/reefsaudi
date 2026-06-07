import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../domain/entities/financial_requirement.dart';
import 'status_badge.dart';
import 'action_buttons.dart';

class TableRowWidget extends StatelessWidget {
  final FinancialRequirement item;
  final bool isEven;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TableRowWidget({super.key, required this.item, required this.isEven,
    required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isEven ? AppColor.kBackgroundColor.withOpacity(0.3) : Colors.transparent,
        border: Border(bottom: BorderSide(color: AppColor.kBorderColor.withOpacity(0.15), width: 0.5))),
      child: Row(children: [
        _projectCell(item.projectName),
        _cell(item.sector, 120.w, AppColor.kWhiteColor, 11.sp),
        _cell(item.extractNumber, 100.w, AppColor.kGrayTextColor, 11.sp),
        _cell(item.extractValue, 120.w, AppColor.kPrimaryColor, 11.sp, bold: true),
        _statusBadge(item.extractStatus, 120.w),
        _statusBadge(item.projectManagementStatus, 140.w),
        _cell(item.startDate, 100.w, AppColor.kGrayTextColor, 10.sp),
        _cell(item.endDate, 100.w, AppColor.kGrayTextColor, 10.sp),
        ActionButtons(onEdit: onEdit, onDelete: onDelete),
      ]));
  }

  Widget _statusBadge(String status, double width) {
    return SizedBox(width: width, child: StatusBadge(label: status));
  }

  Widget _cell(String text, double width, Color color, double size, {bool bold = false}) {
    return SizedBox(
      width: width,
      child: Text(text, textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: size,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontFamily: 'Almarai')));
  }

  Widget _projectCell(String name) {
    return SizedBox(
      width: 280.w,
      child: Text(name, textAlign: TextAlign.start, maxLines: 2, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColor.kWhiteColor, fontSize: 12.sp,
          fontWeight: FontWeight.w600, fontFamily: 'Almarai')));
  }
}
