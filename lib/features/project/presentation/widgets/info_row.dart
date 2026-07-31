import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_theme_context.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColor.kWhiteColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors=context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RobotoText(
          text: label,
          color: colors.kGrayColor,
          fontSize: 11.sp,
        ),
        SizedBox(width: 10.w),
        Flexible(
          child: RobotoText(
            text: value,
            color: colors.kGrayColor,
            fontSize: 12.sp,
            textAlign: TextAlign.end,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
