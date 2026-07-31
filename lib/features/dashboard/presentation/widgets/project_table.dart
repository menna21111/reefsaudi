import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../domain/entities/project.dart';
import 'table_row.dart';

class ProjectTable extends StatelessWidget {
  const ProjectTable({
    super.key,
    required this.projects,
    this.showBottomLoader = false,
  });

  final List<Project> projects;
  final bool showBottomLoader;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TableHeader(colors: colors),
            ...projects.asMap().entries.map((entry) {
              final index = entry.key;
              final project = entry.value;
              final isLast = index == projects.length - 1 && !showBottomLoader;
              return TableRowWidget(
                project: project,
                isLast: isLast,
                colors: colors,
              );
            }),
            if (showBottomLoader) _TableBottomLoader(colors: colors),
          ],
        ),
      ),
    );
  }
}

class _TableBottomLoader extends StatelessWidget {
  const _TableBottomLoader({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 880.w,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.35)),
        ),
      ),
      child: Column(
        children: [
          ...List.generate(2, (index) => _TableLoadingRow(colors: colors)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 22.w,
                  height: 22.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.kPrimaryColor,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  AppString.loading.tr(),
                  style: TextStyle(
                    color: colors.kPrimaryColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Almarai',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TableLoadingRow extends StatelessWidget {
  const _TableLoadingRow({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.2)),
        ),
      ),
      child: Row(
        children: [
          ShimmerBox(width: 220.w, height: 14.h, borderRadius: 6),
          SizedBox(width: 30.w),
          ShimmerBox(width: 70.w, height: 14.h, borderRadius: 6),
          SizedBox(width: 30.w),
          ShimmerBox(width: 70.w, height: 14.h, borderRadius: 6),
          SizedBox(width: 30.w),
          ShimmerBox(width: 120.w, height: 14.h, borderRadius: 6),
          SizedBox(width: 30.w),
          ShimmerBox(width: 150.w, height: 14.h, borderRadius: 6),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.colors});

  final AppColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 250.w,
            child: Text(
              'اسم المشروع'.tr(),
              style: _tableHeaderStyle(colors),
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              'القطاع'.tr(),
              style: _tableHeaderStyle(colors),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              'المنطقه'.tr(),
              style: _tableHeaderStyle(colors),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 150.w,
            child: Text(
              'القيمه'.tr(),
              style: _tableHeaderStyle(colors),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 180.w,
            child: Text(
              'نسبة الإنجاز'.tr(),
              style: _tableHeaderStyle(colors),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 100.w,
            child: Text(
              'الإجراءات'.tr(),
              style: _tableHeaderStyle(colors),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _tableHeaderStyle(AppColorScheme colors) {
    return TextStyle(
      color: colors.kGrayColor,
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
    );
  }
}
