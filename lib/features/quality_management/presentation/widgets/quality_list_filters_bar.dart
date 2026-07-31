import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../data/models/project_request_list_filter.dart';
import '../constants/quality_form_options.dart';

class QualityListFiltersBar extends StatelessWidget {
  const QualityListFiltersBar({
    super.key,
    required this.filter,
    required this.onRequestTypeChanged,
    required this.onDateRangeChanged,
    required this.onClear,
    this.enabled = true,
  });

  final ProjectRequestListFilter filter;
  final ValueChanged<int?> onRequestTypeChanged;
  final void Function(DateTime? from, DateTime? to) onDateRangeChanged;
  final VoidCallback onClear;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hasActive = filter.hasListFilter;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StyledPopupDropdown<int?>(
          title: AppString.requestTypeLabel.tr(),
          value: filter.requestType,
          hintText: AppString.filterAll.tr(),
          onChanged: enabled
              ? (value) => onRequestTypeChanged(value)
              : (_) {},
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(AppString.filterAll.tr()),
            ),
            ...QualityCreatableRequestTypes.items.map(
              (option) => DropdownMenuItem<int?>(
                value: option.value,
                child: Text(option.label),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: enabled ? () => _pickDateRange(context) : null,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: StyledPopupDropdown.fieldMinHeight,
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                  decoration: BoxDecoration(
                    color: colors.kInputColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: colors.kBorderColor.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range_outlined,
                        color: colors.kPrimaryColor,
                        size: 20.sp,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          _dateLabel(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: filter.hasDateRange
                                ? colors.kFontColor
                                : colors.kGrayColor,
                            fontSize: 13.sp,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (filter.hasDateRange)
                        GestureDetector(
                          onTap: enabled
                              ? () => onDateRangeChanged(null, null)
                              : null,
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.sp,
                            color: colors.kGrayColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (hasActive) ...[
              SizedBox(width: 8.w),
              TextButton(
                onPressed: enabled ? onClear : null,
                child: Text(
                  AppString.clearFilters.tr(),
                  style: TextStyle(
                    color: colors.kPrimaryColor,
                    fontFamily: 'Almarai',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  String _dateLabel() {
    if (!filter.hasDateRange) {
      return AppString.filterCustomRange.tr();
    }
    final formatter = DateFormat('yyyy/MM/dd');
    return '${formatter.format(filter.fromDate!)} - ${formatter.format(filter.toDate!)}';
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final colors = context.appColorsRead;
    final now = DateTime.now();
    final initial = DateTimeRange(
      start: filter.fromDate ?? now.subtract(const Duration(days: 7)),
      end: filter.toDate ?? now,
    );

    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colors.kPrimaryColor,
              onPrimary: colors.kWhiteColor,
              surface: colors.kBgColor,
              onSurface: colors.kFontColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;
    onDateRangeChanged(picked.start, picked.end);
  }
}
