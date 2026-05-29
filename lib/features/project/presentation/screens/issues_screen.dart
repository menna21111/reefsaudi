import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({super.key});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  bool isTableView = true;

  final List<Map<String, dynamic>> _issues = [
    {
      'id': 'I-001',
      'title': 'خلل في نظام الري',
      'priority': 'عاجل',
      'status': 'مفتوح',
      'owner': 'م. محمد',
      'date': '2024-05-03',
      'category': 'تقني',
    },
    {
      'id': 'I-002',
      'title': 'تأخر تسليم المواد',
      'priority': 'متوسط',
      'status': 'قيد المعالجة',
      'owner': 'م. لينا',
      'date': '2024-05-12',
      'category': 'لوجستي',
    },
    {
      'id': 'I-003',
      'title': 'خلاف مع المقاول',
      'priority': 'منخفض',
      'status': 'مغلق',
      'owner': 'م. عمر',
      'date': '2024-04-28',
      'category': 'إداري',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'مفتوح':
        return AppColor.kGoldColor;
      case 'قيد المعالجة':
        return Colors.cyan;
      case 'مغلق':
        return AppColor.kPrimaryColor;
      default:
        return AppColor.kGrayTextColor;
    }
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'عاجل':
        return AppColor.kRedColor;
      case 'متوسط':
        return AppColor.kGoldColor;
      default:
        return AppColor.kPrimaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColor.kWhiteColor),
        title: Text(
          'المشاكل',
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => setState(() => isTableView = !isTableView),
            child: Container(
              margin: EdgeInsets.only(left: 16.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColor.kSurfaceColor,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColor.kBorderColor.withOpacity(0.5)),
              ),
              child: Icon(
                isTableView ? Icons.grid_view_rounded : Icons.list_rounded,
                color: AppColor.kGoldColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddIssueDialog(context),
        backgroundColor: AppColor.kGoldColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.r)),
        child: Icon(Icons.add, color: AppColor.kWhiteColor, size: 28.sp),
      ),
      body: Column(
        children: [
          // Stats summary
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                _buildSummaryChip('الكل', '${_issues.length}', AppColor.kGrayTextColor),
                SizedBox(width: 8.w),
                _buildSummaryChip('مفتوح', '${_issues.where((i) => i['status'] == 'مفتوح').length}', AppColor.kGoldColor),
                SizedBox(width: 8.w),
                _buildSummaryChip('قيد المعالجة', '${_issues.where((i) => i['status'] == 'قيد المعالجة').length}', Colors.cyan),
                SizedBox(width: 8.w),
                _buildSummaryChip('مغلق', '${_issues.where((i) => i['status'] == 'مغلق').length}', AppColor.kPrimaryColor),
              ],
            ),
          ),
          Expanded(
            child: isTableView ? _buildTableView() : _buildGridView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(color: color, fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 2.h),
            Text(label, style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableView() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColor.kBorderColor.withOpacity(0.4))),
              ),
              child: Row(
                children: [
                  _headerCell('الرقم', 70.w),
                  _headerCell('عنوان المشكلة', 160.w),
                  _headerCell('الفئة', 90.w),
                  _headerCell('الأولوية', 100.w),
                  _headerCell('الحالة', 110.w),
                  _headerCell('المسؤول', 100.w),
                  _headerCell('التاريخ', 110.w),
                  _headerCell('إجراءات', 80.w, center: true),
                ],
              ),
            ),
            // Rows
            ...List.generate(_issues.length, (i) {
              final issue = _issues[i];
              final isLast = i == _issues.length - 1;
              final statusColor = _statusColor(issue['status']);
              final priorityColor = _priorityColor(issue['priority']);
              return Container(
                decoration: BoxDecoration(
                  border: isLast ? null : Border(bottom: BorderSide(color: AppColor.kBorderColor.withOpacity(0.3))),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  child: Row(
                    children: [
                      _dataCell(issue['id'], 70.w, color: AppColor.kGrayTextColor),
                      SizedBox(
                        width: 160.w,
                        child: Row(
                          children: [
                            Container(
                              width: 3.w,
                              height: 30.h,
                              margin: EdgeInsets.only(left: 6.w),
                              decoration: BoxDecoration(
                                color: priorityColor,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                issue['title'],
                                style: TextStyle(color: AppColor.kWhiteColor, fontSize: 13.sp, fontWeight: FontWeight.w600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _dataCell(issue['category'], 90.w, color: AppColor.kGrayTextColor),
                      SizedBox(
                        width: 100.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            issue['priority'],
                            style: TextStyle(color: priorityColor, fontSize: 11.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: statusColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            issue['status'],
                            style: TextStyle(color: statusColor, fontSize: 11.sp, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      _dataCell(issue['owner'], 100.w),
                      _dataCell(issue['date'], 110.w, color: AppColor.kGrayTextColor),
                      SizedBox(
                        width: 80.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.edit_outlined, color: AppColor.kGrayTextColor, size: 18.sp),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(Icons.delete_outline, color: AppColor.kRedColor, size: 18.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text, double width, {bool center = false}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
        textAlign: center ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  Widget _dataCell(String text, double width, {Color? color}) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(color: color ?? AppColor.kWhiteColor, fontSize: 13.sp),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 1.1,
      ),
      itemCount: _issues.length,
      itemBuilder: (context, index) {
        final issue = _issues[index];
        final statusColor = _statusColor(issue['status']);
        final priorityColor = _priorityColor(issue['priority']);
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColor.kSurfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: priorityColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(issue['status'], style: TextStyle(color: statusColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                  ),
                  Icon(Icons.error_outline, color: priorityColor, size: 18.sp),
                ],
              ),
              SizedBox(height: 8.h),
              Text(issue['id'], style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 11.sp)),
              SizedBox(height: 4.h),
              Text(issue['title'], style: TextStyle(color: AppColor.kWhiteColor, fontSize: 13.sp, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5.r)),
                    child: Text(issue['priority'], style: TextStyle(color: priorityColor, fontSize: 10.sp)),
                  ),
                  SizedBox(width: 6.w),
                  Text(issue['category'], style: TextStyle(color: AppColor.kGrayTextColor, fontSize: 10.sp)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddIssueDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.kSurfaceColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24.h, top: 24.h, left: 16.w, right: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: AppColor.kBorderColor, borderRadius: BorderRadius.circular(2.r))),
            SizedBox(height: 16.h),
            Text('إضافة مشكلة جديدة', style: TextStyle(color: AppColor.kWhiteColor, fontSize: 16.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            TextField(
              style: TextStyle(color: AppColor.kWhiteColor, fontSize: 14.sp),
              decoration: InputDecoration(
                labelText: 'عنوان المشكلة',
                labelStyle: TextStyle(color: AppColor.kGrayTextColor),
                filled: true,
                fillColor: AppColor.kBackgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kGoldColor,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: Text('إضافة', style: TextStyle(color: AppColor.kWhiteColor, fontSize: 14.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
