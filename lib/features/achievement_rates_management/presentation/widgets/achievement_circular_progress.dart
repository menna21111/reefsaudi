import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class AchievementCircularProgress extends StatelessWidget {
  final double value;
  final Color color;
  final int percent;

  const AchievementCircularProgress({
    super.key,
    required this.value,
    required this.color,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52.w,
      height: 52.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: 4.w,
            backgroundColor: AppColor.kBorderLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Text(
            '$percent%',
            style: TextStyle(
              color: AppColor.kWhiteColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Almarai',
            ),
          ),
        ],
      ),
    );
  }
}
