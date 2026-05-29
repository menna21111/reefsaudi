import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';
import '../../../../core/utils/app_color.dart';

class RisksScreen extends StatefulWidget {
  const RisksScreen({super.key});

  @override
  State<RisksScreen> createState() => _RisksScreenState();
}

class _RisksScreenState extends State<RisksScreen> {
  bool isTableView = true;

  final List<Map<String, dynamic>> _risks = [
    {
      'id': 'R-001',
      'title': 'تأخر التوريدات',
      'probability': 'عالية',
      'impact': 'عالي',
      'status': 'مفتوح',
      'owner': 'م. أحمد',
      'date': '2024-05-01',
    },
    {
      'id': 'R-002',
      'title': 'نقص العمالة',
      'probability': 'متوسطة',
      'impact': 'متوسط',
      'status': 'قيد المعالجة',
      'owner': 'م. سارة',
      'date': '2024-05-10',
    },
    {
      'id': 'R-003',
      'title': 'تجاوز الميزانية',
      'probability': 'منخفضة',
      'impact': 'عالي',
      'status': 'مغلق',
      'owner': 'م. خالد',
      'date': '2024-04-20',
    },
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'مفتوح':
        return AppColor.kRedColor;
      case 'قيد المعالجة':
        return AppColor.kGoldColor;
      case 'مغلق':
        return AppColor.kPrimaryColor;
      default:
        return AppColor.kGrayTextColor;
    }
  }

  Color _probabilityColor(String p) {
    switch (p) {
      case 'عالية':
        return AppColor.kRedColor;
      case 'متوسطة':
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
        title: RobotoText(
          text: 'إدارة المخاطر',

          color: AppColor.kWhiteColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
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
                border: Border.all(
                  color: AppColor.kBorderColor.withOpacity(0.5),
                ),
              ),
              child: Icon(
                isTableView ? Icons.grid_view_rounded : Icons.list_rounded,
                color: AppColor.kPrimaryColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRiskDialog(context),
        backgroundColor: AppColor.kRedColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Icon(Icons.add, color: AppColor.kWhiteColor, size: 28.sp),
      ),
      body: Column(
        children: [
          // Stats summary
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                _buildSummaryChip(
                  'الكل',
                  '${_risks.length}',
                  AppColor.kGrayTextColor,
                ),
                SizedBox(width: 8.w),
                _buildSummaryChip(
                  'مفتوح',
                  '${_risks.where((r) => r['status'] == 'مفتوح').length}',
                  AppColor.kRedColor,
                ),
                SizedBox(width: 8.w),
                _buildSummaryChip(
                  'قيد المعالجة',
                  '${_risks.where((r) => r['status'] == 'قيد المعالجة').length}',
                  AppColor.kGoldColor,
                ),
                SizedBox(width: 8.w),
                _buildSummaryChip(
                  'مغلق',
                  '${_risks.where((r) => r['status'] == 'مغلق').length}',
                  AppColor.kPrimaryColor,
                ),
              ],
            ),
          ),

          Expanded(child: isTableView ? _buildTableView() : _buildGridView()),
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
            RobotoText(
              text: count,

              color: color,
              fontSize: 1.sp,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 2.h),
            RobotoText(
              text: label,
              color: AppColor.kGrayTextColor,
              fontSize: 10.sp,
            ),
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
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.kBorderColor.withOpacity(0.4),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _headerCell('الرقم', 70.w),
                  _headerCell('عنوان الخطر', 160.w),
                  _headerCell('الاحتمالية', 100.w),
                  _headerCell('التأثير', 90.w),
                  _headerCell('الحالة', 110.w),
                  _headerCell('المسؤول', 100.w),
                  _headerCell('التاريخ', 110.w),
                  _headerCell('إجراءات', 80.w, center: true),
                ],
              ),
            ),
            // Rows
            ...List.generate(_risks.length, (i) {
              final risk = _risks[i];
              final isLast = i == _risks.length - 1;
              final statusColor = _statusColor(risk['status']);
              final probColor = _probabilityColor(risk['probability']);
              return Container(
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: AppColor.kBorderColor.withOpacity(0.3),
                          ),
                        ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      _dataCell(
                        risk['id'],
                        70.w,
                        color: AppColor.kGrayTextColor,
                      ),
                      SizedBox(
                        width: 160.w,
                        child: Row(
                          children: [
                            Container(
                              width: 3.w,
                              height: 30.h,
                              margin: EdgeInsets.only(left: 6.w),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(2.r),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                risk['title'],
                                style: TextStyle(
                                  color: AppColor.kWhiteColor,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: probColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            risk['probability'],
                            style: TextStyle(
                              color: probColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      _dataCell(risk['impact'], 90.w),
                      SizedBox(
                        width: 110.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            risk['status'],
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      _dataCell(risk['owner'], 100.w),
                      _dataCell(
                        risk['date'],
                        110.w,
                        color: AppColor.kGrayTextColor,
                      ),
                      SizedBox(
                        width: 80.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.edit_outlined,
                                color: AppColor.kGrayTextColor,
                                size: 18.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                Icons.delete_outline,
                                color: AppColor.kRedColor,
                                size: 18.sp,
                              ),
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
      child: RobotoText(
        text: text,

        color: AppColor.kGrayTextColor,
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,

        textAlign: center ? TextAlign.center : TextAlign.start,
      ),
    );
  }

  Widget _dataCell(String text, double width, {Color? color}) {
    return SizedBox(
      width: width,
      child: RobotoText(
        text: text,
        color: color ?? AppColor.kWhiteColor,
        fontSize: 11.sp,
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
      itemCount: _risks.length,
      itemBuilder: (context, index) {
        final risk = _risks[index];
        final statusColor = _statusColor(risk['status']);
        final probColor = _probabilityColor(risk['probability']);
        return Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColor.kSurfaceColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: RobotoText(
                      text: risk['status'],
                      color: statusColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.warning_amber_rounded,
                    color: statusColor,
                    size: 18.sp,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              RobotoText(
                text: risk['id'],
                color: AppColor.kGrayTextColor,
                fontSize: 11.sp,
              ),
              SizedBox(height: 4.h),
              RobotoText(
                text: risk['title'],
                color: AppColor.kWhiteColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,

                maxLines: 2,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: probColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: RobotoText(
                      text: risk['probability'],
                      color: probColor,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  RobotoText(
                    text: risk['owner'],
                    color: AppColor.kGrayTextColor,
                    fontSize: 10.sp,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddRiskDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.kSurfaceColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          top: 24.h,
          left: 16.w,
          right: 16.w,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.kBorderColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            RobotoText(
              text: 'إضافة خطر جديد',
              color: AppColor.kWhiteColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),

            SizedBox(height: 16.h),
            TextField(
              style: TextStyle(color: AppColor.kWhiteColor, fontSize: 14.sp),
              decoration: InputDecoration(
                labelText: 'عنوان الخطر',
                labelStyle: TextStyle(color: AppColor.kGrayTextColor),
                filled: true,
                fillColor: AppColor.kBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.kRedColor,
                minimumSize: Size(double.infinity, 48.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: RobotoText(
                text: 'إضافة',
                color: AppColor.kWhiteColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
