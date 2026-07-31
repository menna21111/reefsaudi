import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../constants/request_type_config.dart';
import '../../data/models/project_request_item_models.dart';

class QualityRequestCard extends StatelessWidget {
  const QualityRequestCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final ProjectRequestItem item;
  final VoidCallback? onTap;

  String _display(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? AppString.notAvailable.tr() : trimmed;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return AppString.notAvailable.tr();
    return DateFormat.yMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final config = RequestTypeRegistry.configFor(item.requestTypeName);
    final statusLabel = RequestStatusLabels.forStatusId(item.statusId);

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Ink(
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colors.kBorderColor.withValues(alpha: 0.35),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.kBlackColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: config.color,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(15.r),
                    ),
                  ),
                  child: Text(
                    config.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.kWhiteColor,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.projectName,
                              style: TextStyle(
                                color: colors.kFontColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.45,
                                fontFamily: 'Almarai',
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.kPrimaryColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                color: colors.kPrimaryColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Almarai',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      Divider(
                        height: 1,
                        color: colors.kBorderColor.withValues(alpha: 0.35),
                      ),
                      SizedBox(height: 14.h),
                      _InfoRow(
                        colors: colors,
                        leftLabel: AppString.requestDate.tr(),
                        leftValue: _formatDate(item.requestDate),
                        rightLabel: AppString.contractor.tr(),
                        rightValue: _display(item.contractor),
                      ),
                      SizedBox(height: 12.h),
                      _InfoRow(
                        colors: colors,
                        leftLabel: AppString.serialNumber.tr(),
                        leftValue: _display(item.serialNumber),
                        rightLabel: AppString.revisionNumber.tr(),
                        rightValue: _display(item.reviewNumber),
                      ),
                      SizedBox(height: 12.h),
                      _InfoRow(
                        colors: colors,
                        leftLabel: AppString.currentTasks.tr(),
                        leftValue: _display(item.currentTask),
                        rightLabel: AppString.assignedTo.tr(),
                        rightValue: _display(item.responsible),
                      ),
                      if ((item.requestNote ?? '').trim().isNotEmpty) ...[
                        SizedBox(height: 12.h),
                        _InfoCell(
                          colors: colors,
                          label: AppString.requestNote.tr(),
                          value: _display(item.requestNote),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.colors,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final AppColorScheme colors;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _InfoCell(
            colors: colors,
            label: leftLabel,
            value: leftValue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _InfoCell(
            colors: colors,
            label: rightLabel,
            value: rightValue,
          ),
        ),
      ],
    );
  }
}

class _InfoCell extends StatelessWidget {
  const _InfoCell({
    required this.colors,
    required this.label,
    required this.value,
  });

  final AppColorScheme colors;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            height: 1.35,
            fontFamily: 'Almarai',
          ),
        ),
      ],
    );
  }
}
