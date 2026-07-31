import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/widgets/riyal_price.dart';

class PortfolioFinancialSubStat extends StatelessWidget {
  const PortfolioFinancialSubStat({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.withRiyal = true,
  });

  final String label;
  final String value;
  final Color color;
  final bool withRiyal;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final valueStyle = TextStyle(
      color: colors.kWhiteColor,
      fontSize: 13.sp,
      fontWeight: FontWeight.bold,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                label,
                style: TextStyle(color: colors.kGrayColor, fontSize: 10.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        if (withRiyal)
          RiyalPriceLabel(
            price: value,
            iconSize: 12.sp,
            iconColor: colors.kWhiteColor,
            style: valueStyle,
          )
        else
          Text(value, style: valueStyle),
      ],
    );
  }
}
