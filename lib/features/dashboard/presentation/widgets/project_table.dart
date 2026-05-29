import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/utils/app_color.dart';
import '../../domain/entities/project.dart';
import 'table_row.dart';

class ProjectTable extends StatelessWidget {
  final List<Project> projects;

  const ProjectTable({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
            _buildHeader(),
            ...projects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              final isLast = index == projects.length - 1;
              return TableRowWidget(project: project, isLast: isLast);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColor.kBorderColor.withOpacity(0.3)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 250.w,
            child: Text('اسم المشروع'.tr(), style: _tableHeaderStyle()),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              'القطاع'.tr(),
              style: _tableHeaderStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              'المنطقه'.tr(),
              style: _tableHeaderStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 150.w,
            child: Text(
              'القيمه'.tr(),
              style: _tableHeaderStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 180.w,
            child: Text(
              'نسبة الإنجاز'.tr(),
              style: _tableHeaderStyle(),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              'الإجراءات'.tr(),
              style: _tableHeaderStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle() {
    return TextStyle(
      color: AppColor.kGrayTextColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
    );
  }
}
