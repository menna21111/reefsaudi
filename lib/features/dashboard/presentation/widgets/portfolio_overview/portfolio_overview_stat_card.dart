import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_font.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/widgets/riyal_price.dart';

class PortfolioOverviewStatCard extends StatelessWidget {
  const PortfolioOverviewStatCard({
    super.key,
    required this.title,
    required this.mainValue,
    this.subValue,
    this.icon,
    this.valueColor,
    this.topBorderColor,
    this.withRiyal = false,
  });

  final String title;
  final String mainValue;
  final String? subValue;
  final IconData? icon;
  final Color? valueColor;
  final Color? topBorderColor;
  final bool withRiyal;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = valueColor ?? colors.kWhiteColor;
    final borderAccent = topBorderColor ?? colors.kPrimaryColor;
    final valueStyle = TextStyle(
      color: accent,
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      fontFamily: 'Almarai',
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        decoration: BoxDecoration(
          color: colors.kInputColor,
          border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 3.h,
              color: borderAccent,
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: RobotoText(
                          text: title,
                          color: colors.kGrayColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      if (icon != null)
                        Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: borderAccent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(icon, color: borderAccent, size: 16.sp),
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  if (withRiyal)
                    RiyalPriceLabel(
                      price: mainValue,
                      iconSize: 16.sp,
                      iconColor: accent,
                      style: valueStyle,
                    )
                  else
                    RobotoText(
                      text: mainValue,
                      color: accent,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  if (subValue != null) ...[
                    SizedBox(height: 4.h),
                    Text(
                      subValue!,
                      style: TextStyle(
                        color: colors.kGrayColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
