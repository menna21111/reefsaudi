import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'project_details_chart_section.dart';
import 'project_details_edit_section.dart';
import 'project_details_header_section.dart';
import 'project_details_summary_section.dart';

class ProjectDetailsBody extends StatelessWidget {
  const ProjectDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProjectDetailsHeaderSection(),
          SizedBox(height: 16.h),
          const ProjectDetailsSummarySection(),
          SizedBox(height: 16.h),
          const ProjectDetailsChartSection(),
          SizedBox(height: 16.h),
          const ProjectDetailsEditSection(),
        ],
      ),
    );
  }
}
