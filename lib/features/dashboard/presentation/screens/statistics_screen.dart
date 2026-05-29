import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../widgets/custom_progress_bar.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الإحصائيات',
          style: TextStyle(
            color: AppColor.kPrimaryColor,
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
            icon: const Icon(Icons.grid_view, color: AppColor.kPrimaryColor),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColor.kSurfaceColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'الميزانية الإجمالية',
                          style: TextStyle(
                            color: AppColor.kGrayTextColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '1.5 مليار ر.س',
                          style: TextStyle(
                            color: AppColor.kPrimaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColor.kSurfaceColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'إجمالي المشاريع',
                          style: TextStyle(
                            color: AppColor.kGrayTextColor,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '100 مشروع',
                          style: TextStyle(
                            color: AppColor.kPrimaryColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'حالة المشاريع',
              style: TextStyle(
                color: AppColor.kWhiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.kSurfaceColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 14,
                          child: Container(
                            height: 16.h,
                            color: AppColor.kPrimaryColor,
                          ),
                        ), // In progress 14
                        Expanded(
                          flex: 25,
                          child: Container(
                            height: 16.h,
                            color: AppColor.kRedColor,
                          ),
                        ), // Delayed 25
                        Expanded(
                          flex: 60,
                          child: Container(
                            height: 16.h,
                            color: const Color(0xFF6A8EAE),
                          ),
                        ), // Finished 60
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatusLegend(
                        'منتهي',
                        '60 مشروع',
                        const Color(0xFF6A8EAE),
                      ),
                      _buildStatusLegend(
                        'متأخر',
                        '25 مشروع',
                        AppColor.kRedColor,
                      ),
                      _buildStatusLegend(
                        'جاري التنفيذ',
                        '14 مشروع',
                        AppColor.kPrimaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'نظرة عامة على الأداء',
              style: TextStyle(
                color: AppColor.kWhiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
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
                    percentageText: '39.8%',
                    percentage: 0.398,
                    color: AppColor.kPrimaryColor,
                  ),
                  SizedBox(height: 16.h),
                  CustomProgressBar(
                    label: 'نسبة الإنجاز الفعلية',
                    percentageText: '18.5%',
                    percentage: 0.185,
                    color: const Color(0xFF6A8EAE),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'التوزيع الإقليمي للمشاريع',
              style: TextStyle(
                color: AppColor.kWhiteColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColor.kSurfaceColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.network(
                      'https://via.placeholder.com/400x200',
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  _buildRegionItem('الرياض', '42', AppColor.kPrimaryColor),
                  SizedBox(height: 16.h),
                  _buildRegionItem('مكة المكرمة', '28', AppColor.kPrimaryColor),
                  SizedBox(height: 16.h),
                  _buildRegionItem(
                    'المنطقة الشرقية',
                    '15',
                    AppColor.kPrimaryColor,
                  ),
                  SizedBox(height: 16.h),
                  _buildRegionItem('مناطق أخرى', '23', AppColor.kPrimaryColor),
                ],
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLegend(String title, String subtitle, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 4.h, left: 8.w),
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColor.kWhiteColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRegionItem(String name, String count, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: AppColor.kWhiteColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 6.w,
              height: 6.w,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ],
        ),
      ],
    );
  }
}
