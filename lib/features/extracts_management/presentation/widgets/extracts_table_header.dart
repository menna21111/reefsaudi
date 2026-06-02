import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import 'extracts_table_header_cell.dart';

class ExtractsTableHeader extends StatelessWidget {
  const ExtractsTableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColor.kBorderLight.withOpacity(0.5)
            : AppColor.kLightBorderLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        children: [
          ExtractsTableHeaderCell(
            text: 'sector'.tr(),
            flex: 2,
            align: TextAlign.right,
          ),
          ExtractsTableHeaderCell(
            text: 'extract_number'.tr(),
            flex: 3,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'value'.tr(),
            flex: 2,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'status'.tr(),
            flex: 2,
            align: TextAlign.center,
          ),
          ExtractsTableHeaderCell(
            text: 'extract_management_status'.tr(),
            flex: 2,
            align: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
