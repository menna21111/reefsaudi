import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color.dart';

class StatusBadge extends StatelessWidget {
  final String label;

  const StatusBadge({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(label);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 10.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
      ),
    );
  }

  Color _resolveColor(String status) {
    final normalized = status.trim();

    if (normalized.contains('صرف') || normalized.contains('مكتمل')) {
      return Colors.cyan;
    }
    if (normalized.contains('معتمد') || normalized.contains('ممول')) {
      return AppColor.kPrimaryColor;
    }
    if (normalized.contains('غير')) {
      return AppColor.kGoldColor;
    }

    return AppColor.kGrayTextColor;
  }
}
