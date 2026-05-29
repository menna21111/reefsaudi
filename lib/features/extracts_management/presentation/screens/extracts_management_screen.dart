import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../widgets/extracts_summary_card.dart';
import '../widgets/extracts_table.dart';

class ExtractsManagementScreen extends StatelessWidget {
  const ExtractsManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Saudi Reef', style: TextStyle(color: AppColor.kPrimaryColor, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(width: 8.w),
            Icon(Icons.dashboard_customize, color: AppColor.kPrimaryColor, size: 20.sp),
          ],
        ),
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: CircleAvatar(
            backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
            radius: 16.r,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColor.kSurfaceColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.filter_list, color: AppColor.kPrimaryColor, size: 24.sp),
                ),
                Text(
                  'إدارة المستخلصات',
                  style: TextStyle(
                    color: AppColor.kWhiteColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ExtractsSummaryCard(
                    title: 'قيمة المستخلصات',
                    mainValue: '12.4M',
                    approvedLabel: 'معتمد',
                    approvedValue: '285.6M',
                    rejectedLabel: 'مرفوض',
                    rejectedValue: '48.8M',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ExtractsSummaryCard(
                    title: 'عدد المستخلصات',
                    mainValue: '292',
                    approvedLabel: 'معتمد',
                    approvedValue: '235',
                    rejectedLabel: 'مرفوض',
                    rejectedValue: '57',
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: AppColor.kPrimaryColor,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.add, color: AppColor.kBackgroundColor, size: 24.sp),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: AppColor.kWhiteColor),
                    decoration: InputDecoration(
                      hintText: 'يبحث...',
                      hintStyle: TextStyle(color: AppColor.kGrayTextColor, fontSize: 14.sp),
                      filled: true,
                      fillColor: AppColor.kSurfaceColor,
                      suffixIcon: Icon(Icons.search, color: AppColor.kGrayTextColor, size: 20.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            const ExtractsTable(),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
