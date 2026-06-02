import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/extract_item.dart';

class ExtractStatusBadge extends StatelessWidget {
  final ExtractStatus status;

  const ExtractStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: color,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
