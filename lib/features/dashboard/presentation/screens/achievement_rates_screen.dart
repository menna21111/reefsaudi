import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/utils/app_color.dart';
import '../widgets/custom_progress_bar.dart';
import '../widgets/monthly_record_card.dart';

class AchievementRatesScreen extends StatelessWidget {
  const AchievementRatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'إدارة نسب الإنجاز',
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.kPrimaryColor),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColor.kGrayTextColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.kSurfaceColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  CustomProgressBar(
                    
                    label: 'نسبة الإنجاز المخطط لها',
                    percentageText: '25%',
                    percentage: 0.25,
                    color: AppColor.kGrayTextColor, backgroundColor: AppColor.kPrimaryColor
                  ),
                  SizedBox(height: 16.h),
                  CustomProgressBar(
                    label: 'نسبة الإنجاز الفعلي',
                    percentageText: '20%',
                    percentage: 0.20,
                    color: AppColor.kPrimaryColor, backgroundColor: AppColor.kPrimaryColor,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add,
                    color: AppColor.kWhiteColor,
                    size: 16,
                  ),
                  label: Text(
                    'إضافة شهر',
                    style: TextStyle(
                      color: AppColor.kWhiteColor,
                      fontSize: 12.sp,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.kPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
                Text(
                  'سجل الإنجاز الشهري',
                  style: TextStyle(
                    color: AppColor.kWhiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            MonthlyRecordCard(
              month: 'مارس, 2024',
              plannedPercentage: '20%',
              actualPercentage: '25%',
              progressValue: 0.25,
              progressColor: AppColor.kPrimaryColor,
            ),
            MonthlyRecordCard(
              month: 'فبراير, 2024',
              plannedPercentage: '15%',
              actualPercentage: '20%',
              progressValue: 0.20,
              progressColor: AppColor.kPrimaryColor,
            ),
            MonthlyRecordCard(
              month: 'ديسمبر, 2023',
              plannedPercentage: '17%',
              actualPercentage: '7%',
              progressValue: 0.07,
              progressColor: AppColor.kGoldColor,
            ),
            MonthlyRecordCard(
              month: 'أغسطس, 2023',
              plannedPercentage: '10%',
              actualPercentage: '12%',
              progressValue: 0.12,
              progressColor: AppColor.kRedColor,
            ),

            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.chevron_left,
                  color: AppColor.kGrayTextColor,
                  size: 20.sp,
                ),
                SizedBox(width: 16.w),
                Text(
                  '3',
                  style: TextStyle(
                    color: AppColor.kGrayTextColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  '2',
                  style: TextStyle(
                    color: AppColor.kGrayTextColor,
                    fontSize: 14.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColor.kPrimaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: AppColor.kPrimaryColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.chevron_right,
                  color: AppColor.kGrayTextColor,
                  size: 20.sp,
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Text(
              'منحنى الإنجاز',
              style: TextStyle(
                color: AppColor.kWhiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              height: 200.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.kSurfaceColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBarGroup(0, 80),
                    _buildBarGroup(1, 60),
                    _buildBarGroup(2, 50),
                    _buildBarGroup(3, 40),
                    _buildBarGroup(4, 20),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: AppColor.kPrimaryColor,
          width: 24.w,
          borderRadius: BorderRadius.zero,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: AppColor.kBorderLight,
          ),
        ),
      ],
    );
  }
}
