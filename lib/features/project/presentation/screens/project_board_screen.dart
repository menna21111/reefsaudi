import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class TaskItem {
  final String id;
  final String title;
  final String owner;
  final String duration;
  final String statusLabel;
  String status; // 'new', 'in_progress', 'pending', 'ended'
  final Color indicatorColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final bool hasImage;

  TaskItem({
    required this.id,
    required this.title,
    required this.owner,
    required this.duration,
    required this.statusLabel,
    required this.status,
    required this.indicatorColor,
    required this.badgeColor,
    required this.badgeTextColor,
    this.hasImage = false,
  });
}

class ProjectBoardScreen extends StatefulWidget {
  const ProjectBoardScreen({super.key});

  @override
  State<ProjectBoardScreen> createState() => _ProjectBoardScreenState();
}

class _ProjectBoardScreenState extends State<ProjectBoardScreen> {
  final List<TaskItem> _tasks = [
    TaskItem(
      id: 'TSK-001',
      title: 'Structural Site Analysis Phase 1',
      owner: 'Omar A.',
      duration: '2 days',
      statusLabel: '2 days',
      status: 'new',
      indicatorColor: AppColor.kRedColor,
      badgeColor: AppColor.kRedColor.withOpacity(0.1),
      badgeTextColor: AppColor.kRedColor,
    ),
    TaskItem(
      id: 'TSK-002',
      title: 'Environmental Impact Survey',
      owner: 'Sarah K.',
      duration: '5 days',
      statusLabel: '5 days',
      status: 'new',
      indicatorColor: AppColor.kGoldColor,
      badgeColor: AppColor.kBorderColor,
      badgeTextColor: AppColor.kGrayTextColor,
    ),
    TaskItem(
      id: 'TSK-003',
      title: 'Marine Life Observation',
      owner: 'Dr. Ahmed',
      duration: 'Active',
      statusLabel: 'Active',
      status: 'in_progress',
      indicatorColor: AppColor.kPrimaryColor,
      badgeColor: AppColor.kPrimaryColor.withOpacity(0.1),
      badgeTextColor: AppColor.kPrimaryColor,
      hasImage: true,
    ),
    TaskItem(
      id: 'TSK-004',
      title: 'Resource Allocation Map',
      owner: 'Layla M.',
      duration: 'Waiting',
      statusLabel: 'Waiting',
      status: 'pending',
      indicatorColor: AppColor.kGoldColor,
      badgeColor: AppColor.kGoldColor.withOpacity(0.1),
      badgeTextColor: AppColor.kGoldColor,
    ),
    TaskItem(
      id: 'TSK-005',
      title: 'Initial Site Inspection',
      owner: 'Ali Al-Harbi',
      duration: 'Completed',
      statusLabel: 'Completed',
      status: 'ended',
      indicatorColor: AppColor.kGrayTextColor,
      badgeColor: AppColor.kPrimaryColor.withOpacity(0.1),
      badgeTextColor: AppColor.kPrimaryColor,
    ),
  ];

  void _showChangeStatusBottomSheet(TaskItem task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: AppColor.kSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Bottom sheet handler line
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColor.kBorderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 16.h),

              // Title & Subtitle
              RobotoText(
                text: 'اسم المهمة',
                color: AppColor.kPrimaryColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 4.h),
              Text(
                task.title,
                style: TextStyle(
                  color: AppColor.kGrayTextColor,
                  fontSize: 12.sp,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Options
              _buildStatusOption(
                title: 'جديد',
                subtitle: 'المهام المضافة حديثاً',
                isSelected: task.status == 'new',
                icon: Icons.bookmark_added_rounded,
                onTap: () {
                  setState(() => task.status = 'new');
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 12.h),
              _buildStatusOption(
                title: 'قيد التنفيذ',
                subtitle: 'يتم العمل عليها حالياً',
                isSelected: task.status == 'in_progress',
                icon: Icons.timelapse_rounded,
                onTap: () {
                  setState(() => task.status = 'in_progress');
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 12.h),
              _buildStatusOption(
                title: 'قيد المراجعة',
                subtitle: 'بانتظار موافقة المشرف',
                isSelected: task.status == 'pending',
                icon: Icons.rate_review_rounded,
                onTap: () {
                  setState(() => task.status = 'pending');
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 12.h),
              _buildStatusOption(
                title: 'مكتمل',
                subtitle: 'تم إنجاز المهمة بالكامل',
                isSelected: task.status == 'ended',
                icon: Icons.check_circle_rounded,
                onTap: () {
                  setState(() => task.status = 'ended');
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 24.h),

              // Cancel button
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColor.kInputBorderColor),
                  minimumSize: Size(double.infinity, 48.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: RobotoText(
                  text: 'إلغاء',
                  color: AppColor.kRedColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusOption({
    required String title,
    required String subtitle,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.kPrimaryColor.withOpacity(0.1)
              : AppColor.kBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? AppColor.kPrimaryColor
                : AppColor.kBorderColor.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle_rounded : icon,
              color: isSelected
                  ? AppColor.kPrimaryColor
                  : AppColor.kGrayTextColor,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected
                          ? AppColor.kPrimaryColor
                          : AppColor.kWhiteColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColor.kGrayTextColor,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_left_rounded,
              color: AppColor.kGrayTextColor,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RobotoText(
              text: 'لوحة المهام (Project Board)',
              color: AppColor.kWhiteColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 2.h),
            Text(
              'Sustainable Coastal Dev.',
              style: TextStyle(
                color: AppColor.kPrimaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppColor.kWhiteColor, size: 22.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search/Filter Bar
          Padding(
            padding: EdgeInsets.all(16.w),
            child: TextField(
              style: TextStyle(color: AppColor.kWhiteColor, fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: 'Search tasks, assignees...',
                hintStyle: TextStyle(
                  color: AppColor.kGrayTextColor,
                  fontSize: 13.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColor.kGrayTextColor,
                  size: 18.sp,
                ),
                filled: true,
                fillColor: AppColor.kSurfaceColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
            ),
          ),

          // Kanban Columns
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKanbanColumn(
                    title: 'جديد',
                    count: _tasks.where((t) => t.status == 'new').length,
                    statusKey: 'new',
                  ),
                  _buildKanbanColumn(
                    title: 'قيد التنفيذ',
                    count: _tasks
                        .where((t) => t.status == 'in_progress')
                        .length,
                    statusKey: 'in_progress',
                  ),
                  _buildKanbanColumn(
                    title: 'قيد المراجعة',
                    count: _tasks.where((t) => t.status == 'pending').length,
                    statusKey: 'pending',
                  ),
                  _buildKanbanColumn(
                    title: 'مكتمل',
                    count: _tasks.where((t) => t.status == 'ended').length,
                    statusKey: 'ended',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn({
    required String title,
    required int count,
    required String statusKey,
  }) {
    final columnTasks = _tasks.where((t) => t.status == statusKey).toList();

    return Container(
      width: 260.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColor.kWhiteColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.kSurfaceColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: AppColor.kPrimaryColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.more_horiz,
                  color: AppColor.kGrayTextColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Cards List
          Expanded(
            child: ListView.builder(
              itemCount: columnTasks.length,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final task = columnTasks[index];
                return _buildTaskCard(task);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task) {
    return GestureDetector(
      onTap: () => _showChangeStatusBottomSheet(task),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColor.kSurfaceColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColor.kBorderColor.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Colored left bar
                Container(
                  width: 3.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: task.indicatorColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      color: AppColor.kWhiteColor,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // If task has mock image/chart (like in In-Progress column of screenshot)
            if (task.hasImage) ...[
              Container(
                height: 70.h,
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColor.kBackgroundColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColor.kBorderColor.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 6.h,
                            width: 80.w,
                            decoration: BoxDecoration(
                              color: AppColor.kPrimaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            height: 6.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: AppColor.kGoldColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.insert_chart_outlined_rounded,
                      color: AppColor.kPrimaryColor,
                      size: 36.sp,
                    ),
                  ],
                ),
              ),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10.r,
                      backgroundColor: AppColor.kPrimaryColor.withOpacity(0.2),
                      child: Text(
                        task.owner[0],
                        style: TextStyle(
                          color: AppColor.kPrimaryColor,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      task.owner,
                      style: TextStyle(
                        color: AppColor.kGrayTextColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: task.badgeColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    task.statusLabel,
                    style: TextStyle(
                      color: task.badgeTextColor,
                      fontSize: 8.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
