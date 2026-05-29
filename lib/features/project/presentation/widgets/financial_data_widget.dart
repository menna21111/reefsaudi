import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reefsaudia/core/utils/app_color.dart';

class FinancialDataWidget extends StatelessWidget {
  final double totalBudget;
  final double actualExpenses;
  final double remaining;
  final String budgetStatus;
  final String budgetStatusColor;

  const FinancialDataWidget({
    Key? key,
    required this.totalBudget,
    required this.actualExpenses,
    required this.remaining,
    required this.budgetStatus,
    this.budgetStatusColor = 'red',
  }) : super(key: key);

  Color _getStatusColor() {
    switch (budgetStatusColor) {
      case 'primary':
        return AppColor.kPrimaryColor;
      case 'gold':
        return AppColor.kGoldColor;
      case 'red':
        return AppColor.kRedColor;
      default:
        return AppColor.kRedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.monetization_on,
                color: AppColor.kPrimaryColor,
                size: 16.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'البيانات المالية',
                style: TextStyle(
                  color: AppColor.kWhiteColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Center(
            child: SizedBox(
              width: 160.w,
              height: 160.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 50.r,
                          startDegreeOffset: -90,
                          sections: [
                            PieChartSectionData(
                              color: AppColor.kPrimaryColor,
                              value: actualExpenses * value,
                              title: '',
                              radius: 20.r,
                            ),
                            PieChartSectionData(
                              color: AppColor.kBorderColor.withOpacity(0.3),
                              value: remaining * value,
                              title: '',
                              radius: 20.r,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: totalBudget),
                        duration: const Duration(milliseconds: 1500),
                        curve: Curves.easeOut,
                        builder: (context, value, child) {
                          return Text(
                            '${value.toStringAsFixed(1)}M',
                            style: TextStyle(
                              color: AppColor.kWhiteColor,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                      Text(
                        'إجمالي الميزانية',
                        style: TextStyle(
                          color: AppColor.kGrayTextColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          _buildFinancialItem(
            '${actualExpenses}M SAR',
            'المصروفات الفعلية',
            AppColor.kPrimaryColor,
          ),
          SizedBox(height: 12.h),
          _buildFinancialItem(
            '${remaining}M SAR',
            'المتبقي',
            AppColor.kGrayTextColor,
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColor.kBorderColor.withOpacity(0.2)),
          SizedBox(height: 12.h),
          _buildFinancialItem(
            budgetStatus,
            'حالة الميزانية',
            _getStatusColor(),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialItem(String value, String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 11.sp),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
