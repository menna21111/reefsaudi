import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';
import '../constants/request_type_config.dart';

class QualityFilterHeader extends StatelessWidget {
  const QualityFilterHeader({
    super.key,
    required this.options,
    required this.selectedStatus,
    required this.onChanged,
    this.statusCounts,
  });

  final List<QualityStatusFilterOption> options;
  final String? selectedStatus;
  final ValueChanged<String> onChanged;
  final Map<String, int>? statusCounts;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selected = selectedStatus ?? options.first.value;

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((option) {
        final isSelected = selected == option.value;
        final count = statusCounts?[option.value];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onChanged(option.value),
            borderRadius: BorderRadius.circular(24.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.kPrimaryColor
                    : colors.kInputColor,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: isSelected
                      ? colors.kPrimaryColor
                      : colors.kBorderColor.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isSelected) ...[
                    Icon(
                      Icons.check_rounded,
                      size: 16.sp,
                      color: colors.kWhiteColor,
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Text(
                    option.labelKey.tr(),
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12.sp,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? colors.kWhiteColor
                          : colors.kFontColor,
                    ),
                  ),
                  if (count != null) ...[
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.kWhiteColor.withValues(alpha: 0.2)
                            : colors.kPrimaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? colors.kWhiteColor
                              : colors.kPrimaryColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
