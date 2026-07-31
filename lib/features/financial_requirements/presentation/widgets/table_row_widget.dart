import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../../domain/entities/financial_requirement.dart';
import 'action_buttons.dart';
import 'status_badge.dart';

class TableRowWidget extends StatelessWidget {
  final FinancialRequirement item;
  final bool isEven;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TableRowWidget({
    super.key,
    required this.item,
    required this.isEven,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isEven
            ? colors.kBgColor.withValues(alpha: 0.35)
            : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: colors.kBorderColor.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _projectCell(context, item.projectName),
          _cell(context, item.sector, 120.w, colors.kFontColor, 11.sp),
          _cell(context, item.extractNumber, 100.w, colors.kGrayColor, 11.sp),
          _cell(
            context,
            item.extractValue,
            120.w,
            colors.kPrimaryColor,
            11.sp,
            bold: true,
          ),
          _statusBadge(item.extractStatus, 120.w),
          _statusBadge(item.projectManagementStatus, 140.w),
          _cell(context, item.startDate, 100.w, colors.kGrayColor, 10.sp),
          _cell(context, item.endDate, 100.w, colors.kGrayColor, 10.sp),
          ActionButtons(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }

  Widget _statusBadge(String status, double width) {
    return SizedBox(width: width, child: StatusBadge(label: status));
  }

  Widget _cell(
    BuildContext context,
    String text,
    double width,
    Color color,
    double size, {
    bool bold = false,
  }) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: color,
          fontSize: size,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }

  Widget _projectCell(BuildContext context, String name) {
    final colors = context.appColors;
    return SizedBox(
      width: 280.w,
      child: Text(
        name,
        textAlign: TextAlign.start,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: colors.kFontColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
