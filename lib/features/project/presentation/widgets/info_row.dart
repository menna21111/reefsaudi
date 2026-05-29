import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RobotoText(
          text: label,
          color: AppColor.kGrayTextColor,
          fontSize: 11.sp,
        ),
        RobotoText(
          text: value,
          color: valueColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
