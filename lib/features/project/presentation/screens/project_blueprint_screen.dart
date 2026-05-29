import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class ProjectBlueprintScreen extends StatelessWidget {
  const ProjectBlueprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.kSurfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColor.kWhiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: RobotoText(
          text: 'المخطط ونسبة الإنجاز',
          color: AppColor.kWhiteColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    title: 'نسبة الإنجاز',
                    value: '64%',
                    icon: Icons.trending_up_rounded,
                    iconColor: AppColor.kPrimaryColor,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildSummaryCard(
                    title: 'المهام النشطة',
                    value: '12',
                    icon: Icons.bolt_rounded,
                    iconColor: AppColor.kGoldColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Timeline Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.kSurfaceColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: RobotoText(
                    text: 'DECEMBER 2025',
                    color: AppColor.kWhiteColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.kPrimaryColor.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: RobotoText(
                    text: 'MONTHLY VIEW',
                    color: AppColor.kPrimaryColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Gantt Chart View
            _buildGanttChart(context),
            SizedBox(height: 24.h),

            // In-Focus Tasks Section
            Row(
              children: [
                Container(
                  width: 4.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: AppColor.kPrimaryColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 8.w),
                RobotoText(
                  text: 'المهام المركزة (In-Focus Tasks)',
                  color: AppColor.kWhiteColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Task List
            _buildFocusTaskCard(
              dateDay: '14',
              dateMonth: 'DEC',
              title: 'Architectural Design Review',
              subtitle:
                  'Finalizing the structural blueprint for Villa Group A.',
              isCompleted: true,
              priority: 'PRIORITY-HIGH',
              dateBgColor: AppColor.kPrimaryColor.withOpacity(0.15),
              dateColor: AppColor.kPrimaryColor,
            ),
            SizedBox(height: 12.h),
            _buildFocusTaskCard(
              dateDay: '19',
              dateMonth: 'DEC',
              title: 'Environmental Clearance',
              subtitle:
                  'Awaiting government approvals for phase 2 water lines.',
              isCompleted: false,
              priority: 'MEDIUM',
              dateBgColor: AppColor.kGoldColor.withOpacity(0.15),
              dateColor: AppColor.kGoldColor,
              extraInfo: '2 days remaining',
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RobotoText(
                text: title,
                color: AppColor.kGrayTextColor,
                fontSize: 9.sp,
              ),
              SizedBox(height: 8.h),
              RobotoText(
                text: value,
                color: AppColor.kWhiteColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildGanttChart(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gantt Header
            Row(
              children: [
                _buildGanttHeaderCell('TASK CATEGORY', 130.w),
                _buildGanttHeaderCell('DEC 01', 80.w),
                _buildGanttHeaderCell('DEC 08', 80.w),
                _buildGanttHeaderCell('DEC 15', 80.w),
                _buildGanttHeaderCell('DEC 22', 80.w),
                _buildGanttHeaderCell('DEC 29', 80.w),
              ],
            ),
            SizedBox(height: 12.h),
            const Divider(color: AppColor.kBorderColor),
            SizedBox(height: 8.h),

            // PROJECT PLAN Category
            _buildCategoryRow('PROJECT PLAN', AppColor.kPrimaryColor),
            _buildTimelineRow(
              taskName: 'Site Analysis',
              offset: 20.w,
              width: 140.w,
              barColor: AppColor.kPrimaryColor.withOpacity(0.3),
              labelColor: AppColor.kPrimaryColor,
              ownerInitials: 'MA',
            ),
            SizedBox(height: 12.h),

            // INFRASTRUCTURE Category
            _buildCategoryRow('INFRASTRUCTURE', AppColor.kGoldColor),
            _buildTimelineRow(
              taskName: 'Excavation',
              offset: 60.w,
              width: 160.w,
              barColor: Colors.amber.withOpacity(0.3),
              labelColor: Colors.amber,
              ownerInitials: 'KS',
            ),
            SizedBox(height: 8.h),
            _buildTimelineRow(
              taskName: 'Piping & Drainage',
              offset: 120.w,
              width: 150.w,
              barColor: Colors.teal.withOpacity(0.3),
              labelColor: Colors.tealAccent,
              ownerInitials: 'OM',
            ),
            SizedBox(height: 12.h),

            // BUILDING CONST. Category
            _buildCategoryRow('BUILDING CONST.', Colors.purpleAccent),
            _buildTimelineRow(
              taskName: 'Foundation Works',
              offset: 190.w,
              width: 100.w,
              barColor: Colors.deepPurple.withOpacity(0.3),
              labelColor: Colors.purple[200]!,
              ownerInitials: 'HZ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGanttHeaderCell(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          color: AppColor.kGrayTextColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String title, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTimelineRow({
    required String taskName,
    required double offset,
    required double width,
    required Color barColor,
    required Color labelColor,
    required String ownerInitials,
  }) {
    return Row(
      children: [
        // Name Column
        SizedBox(
          width: 130.w,
          child: Text(
            taskName,
            style: TextStyle(
              color: AppColor.kWhiteColor.withOpacity(0.8),
              fontSize: 11.sp,
            ),
          ),
        ),
        // Timeline Column with custom bar positioning
        Stack(
          children: [
            // Grid background placeholders
            Row(
              children: List.generate(
                5,
                (index) => Container(
                  width: 80.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: AppColor.kBorderColor.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // The capsule timeline bar
            Positioned(
              left: offset,
              top: 4.h,
              child: Container(
                width: width,
                height: 20.h,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        ownerInitials,
                        style: TextStyle(
                          color: AppColor.kWhiteColor,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: 12.w,
                      height: 12.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: const BoxDecoration(
                        color: AppColor.kWhiteColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFocusTaskCard({
    required String dateDay,
    required String dateMonth,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required String priority,
    required Color dateBgColor,
    required Color dateColor,
    String? extraInfo,
  }) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.kSurfaceColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isCompleted
              ? AppColor.kPrimaryColor.withOpacity(0.2)
              : AppColor.kGoldColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Date Chip
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: dateBgColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dateDay,
                  style: TextStyle(
                    color: dateColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateMonth,
                  style: TextStyle(
                    color: dateColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColor.kWhiteColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColor.kGrayTextColor,
                    fontSize: 11.sp,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (extraInfo != null) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: AppColor.kGrayTextColor,
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        extraInfo,
                        style: TextStyle(
                          color: AppColor.kGrayTextColor,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Action/Priority
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(
                isCompleted
                    ? Icons.check_circle_outline_rounded
                    : Icons.pending_actions_rounded,
                color: isCompleted
                    ? AppColor.kPrimaryColor
                    : AppColor.kGoldColor,
                size: 20.sp,
              ),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColor.kBackgroundColor,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: isCompleted
                        ? AppColor.kPrimaryColor
                        : AppColor.kGoldColor,
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
