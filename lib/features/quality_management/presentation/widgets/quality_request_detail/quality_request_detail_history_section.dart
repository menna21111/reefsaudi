import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../data/models/project_request_history_models.dart';
import '../quality_request_history_timeline.dart';
import 'quality_request_detail_section_shell.dart';

class QualityRequestDetailHistorySection extends StatelessWidget {
  const QualityRequestDetailHistorySection({
    super.key,
    required this.items,
  });

  final List<ProjectRequestHistoryItem> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return QualityRequestDetailSectionShell(
      title: AppString.reviewStatusHistory.tr(),
      icon: Icons.history_rounded,
      expanded: true,
      onToggle: () {},
      collapsible: false,
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: colors.kPrimaryColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          AppString.newTask.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      child: QualityRequestHistoryTimeline(items: items),
    );
  }
}
