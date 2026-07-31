import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/widgets/riyal_price.dart';

class PortfolioStatusCard extends StatelessWidget {
  const PortfolioStatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.amount,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final int count;
  final String amount;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 16.sp),
              ),
              const Spacer(),
              Text(
                '$count',
                style: TextStyle(
                  color: colors.kWhiteColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(color: colors.kGrayColor, fontSize: 11.sp),
          ),
          SizedBox(height: 4.h),
          RiyalPriceLabel(
            price: amount,
            iconSize: 13.sp,
            iconColor: colors.kWhiteColor,
            style: TextStyle(
              color: colors.kWhiteColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
