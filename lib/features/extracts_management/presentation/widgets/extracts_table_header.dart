import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import 'extracts_table_header_cell.dart';

class ExtractsTableHeader extends StatelessWidget {
  const ExtractsTableHeader({super.key});

  static const double projectNameWidth = 200;
  static const double sectorWidth = 100;
  static const double extractNumberWidth = 80;
  static const double valueWidth = 100;
  static const double statusWidth = 120;
  static const double managementWidth = 120;
  static const double dateWidth = 100;
  static const double actionsWidth = 80;

  static double get totalWidth =>
      projectNameWidth +
      sectorWidth +
      extractNumberWidth +
      valueWidth +
      statusWidth +
      managementWidth +
      dateWidth * 2 +
      actionsWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colors.kBorderColor.withOpacity(0.35),
        borderRadius: BorderRadiusDirectional.only(
          topStart: Radius.circular(16.r),
          topEnd: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          ExtractsTableHeaderCell(
            text: 'project_name'.tr(),
            width: projectNameWidth.w,
            align: TextAlign.right,
          ),
          ExtractsTableHeaderCell(
            text: 'sector'.tr(),
            width: sectorWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'extract_number'.tr(),
            width: extractNumberWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'value'.tr(),
            width: valueWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'status'.tr(),
            width: statusWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'extract_management_status'.tr(),
            width: managementWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'start_date'.tr(),
            width: dateWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'end_date'.tr(),
            width: dateWidth.w,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'actions'.tr(),
            width: actionsWidth.w,
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
