import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/project_stage_assignment.dart';

class ProjectStagesTable extends StatelessWidget {
  const ProjectStagesTable({
    super.key,
    required this.items,
    required this.isLoading,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ProjectStageAssignment> items;
  final bool isLoading;
  final ValueChanged<ProjectStageAssignment> onEdit;
  final ValueChanged<ProjectStageAssignment> onDelete;

  static const double projectWidth = 200;
  static const double stageWidth = 140;
  static const double dateWidth = 150;
  static const double actionsWidth = 100;

  static double get minTableWidth =>
      projectWidth.w + stageWidth.w + dateWidth.w + actionsWidth.w;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (items.isEmpty && !isLoading) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(vertical: 48.h),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
        ),
        alignment: Alignment.center,
        child: Text(
          AppString.noRecordsFound.tr(),
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 14.sp,
            fontFamily: 'Almarai',
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useExpanded = constraints.maxWidth >= minTableWidth;

        final table = Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Header(colors: colors, useExpanded: useExpanded),
                ...items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isLast = index == items.length - 1 && !isLoading;
                  return _Row(
                    item: item,
                    colors: colors,
                    isLast: isLast,
                    useExpanded: useExpanded,
                    onEdit: () => onEdit(item),
                    onDelete: () => onDelete(item),
                  );
                }),
              ],
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: colors.kInputColor.withValues(alpha: 0.65),
                  child: Center(
                    child: CircularProgressIndicator(color: colors.kPrimaryColor),
                  ),
                ),
              ),
          ],
        );

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: colors.kInputColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
          ),
          clipBehavior: Clip.antiAlias,
          child: useExpanded
              ? table
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: SizedBox(width: minTableWidth, child: table),
                ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.colors, required this.useExpanded});

  final AppColorScheme colors;
  final bool useExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.35)),
        ),
      ),
      child: Row(
        children: [
          _cell(
            flex: 4,
            width: ProjectStagesTable.projectWidth,
            label: AppString.projectName.tr(),
            align: TextAlign.start,
          ),
          _cell(
            flex: 3,
            width: ProjectStagesTable.stageWidth,
            label: AppString.projectPhaseLabel.tr(),
            align: TextAlign.center,
          ),
          _cell(
            flex: 3,
            width: ProjectStagesTable.dateWidth,
            label: AppString.phaseJoinDate.tr(),
            align: TextAlign.center,
          ),
          _cell(
            flex: 2,
            width: ProjectStagesTable.actionsWidth,
            label: AppString.actions.tr(),
            align: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _cell({
    required int flex,
    required double width,
    required String label,
    required TextAlign align,
  }) {
    final child = Text(
      label,
      textAlign: align,
      style: TextStyle(
        color: colors.kGrayColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        fontFamily: 'Almarai',
      ),
    );

    if (useExpanded) return Expanded(flex: flex, child: child);
    return SizedBox(width: width.w, child: child);
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.item,
    required this.colors,
    required this.isLast,
    required this.useExpanded,
    required this.onEdit,
    required this.onDelete,
  });

  final ProjectStageAssignment item;
  final AppColorScheme colors;
  final bool isLast;
  final bool useExpanded;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String get _formattedDate {
    final parsed = DateTime.tryParse(item.assignedDate);
    if (parsed == null) return item.assignedDate.isEmpty ? '—' : item.assignedDate;
    return DateFormat('yyyy/M/d').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colors.kBorderColor.withValues(alpha: 0.35),
                ),
              ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _projectCell(),
            _textCell(
              text: item.pStepTitle,
              flex: 3,
              width: ProjectStagesTable.stageWidth,
            ),
            _textCell(
              text: _formattedDate,
              flex: 3,
              width: ProjectStagesTable.dateWidth,
            ),
            _actionsCell(),
          ],
        ),
      ),
    );
  }

  Widget _projectCell() {
    final content = Row(
      children: [
        Container(
          width: 4.w,
          margin: EdgeInsetsDirectional.only(
            start: 8.w,
            end: 4.w,
            top: 12.h,
            bottom: 12.h,
          ),
          decoration: BoxDecoration(
            color: colors.kPrimaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Text(
              item.projectTitle,
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );

    if (useExpanded) return Expanded(flex: 4, child: content);
    return SizedBox(width: ProjectStagesTable.projectWidth.w, child: content);
  }

  Widget _textCell({
    required String text,
    required int flex,
    required double width,
  }) {
    final child = Center(
      child: Text(
        text.isEmpty ? '—' : text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.kGrayColor,
          fontSize: 12.sp,
          fontFamily: 'Almarai',
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );

    if (useExpanded) return Expanded(flex: flex, child: child);
    return SizedBox(width: width.w, child: child);
  }

  Widget _actionsCell() {
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: AppString.editAction.tr(),
          onPressed: onEdit,
          icon: Icon(Icons.edit_outlined, color: colors.kGrayColor, size: 18.sp),
        ),
        SizedBox(width: 8.w),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          tooltip: AppString.delete.tr(),
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline, color: colors.kRedColor, size: 18.sp),
        ),
      ],
    );

    if (useExpanded) return Expanded(flex: 2, child: child);
    return SizedBox(width: ProjectStagesTable.actionsWidth.w, child: child);
  }
}
