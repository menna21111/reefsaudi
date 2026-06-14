import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_theme_context.dart';

class TablePaginationWidget extends StatelessWidget {
  static const List<int> pageSizeOptions = [10, 20, 50, 100];

  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalCount;
  final bool hasPreviousPage;
  final bool hasNextPage;
  final bool isLoading;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  const TablePaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.isLoading,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  int get _fromItem =>
      totalCount == 0 ? 0 : ((currentPage - 1) * pageSize) + 1;

  int get _toItem {
    if (totalCount == 0) return 0;
    final end = currentPage * pageSize;
    return end > totalCount ? totalCount : end;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final showNav = totalPages > 1;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      child: Column(
        children: [
          Text(
            'pagination_showing'.tr(
              namedArgs: {
                'from': '$_fromItem',
                'to': '$_toItem',
                'total': '$totalCount',
              },
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.kGrayColor,
              fontSize: 13.sp,
              fontFamily: 'Almarai',
            ),
          ),
          if (showNav) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: _NavActionButton(
                    label: 'previous'.tr(),
                    icon: Icons.chevron_right_rounded,
                    enabled: hasPreviousPage && !isLoading,
                    colors: colors,
                    onTap: () => onPageChanged(currentPage - 1),
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: colors.kBgColor.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.kBorderColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 48.w,
                          height: 18.h,
                          child: Center(
                            child: SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.kPrimaryColor,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          'pagination_page_indicator'.tr(
                            namedArgs: {
                              'current': '$currentPage',
                              'total': '$totalPages',
                            },
                          ),
                          style: TextStyle(
                            color: colors.kFontColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                        ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _NavActionButton(
                    label: 'next'.tr(),
                    icon: Icons.chevron_left_rounded,
                    enabled: hasNextPage && !isLoading,
                    colors: colors,
                    iconAfterLabel: true,
                    onTap: () => onPageChanged(currentPage + 1),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 14.h),
          _PageSizeSelector(
            pageSize: pageSize,
            isLoading: isLoading,
            colors: colors,
            onChanged: onPageSizeChanged,
          ),
        ],
      ),
    );
  }
}

class _NavActionButton extends StatelessWidget {
  const _NavActionButton({
    required this.label,
    required this.icon,
    required this.enabled,
    required this.colors,
    required this.onTap,
    this.iconAfterLabel = false,
  });

  final String label;
  final IconData icon;
  final bool enabled;
  final AppColorScheme colors;
  final VoidCallback onTap;
  final bool iconAfterLabel;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(
      icon,
      size: 20.sp,
      color: enabled ? colors.kPrimaryColor : colors.kDarkGrayColor,
    );
    final labelWidget = Text(
      label,
      style: TextStyle(
        color: enabled ? colors.kFontColor : colors.kDarkGrayColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'Almarai',
      ),
    );

    return Material(
      color: colors.kBgColor.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: enabled
                  ? colors.kBorderColor.withValues(alpha: 0.4)
                  : colors.kBorderColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: iconAfterLabel
                ? [labelWidget, SizedBox(width: 4.w), iconWidget]
                : [iconWidget, SizedBox(width: 4.w), labelWidget],
          ),
        ),
      ),
    );
  }
}

class _PageSizeSelector extends StatelessWidget {
  const _PageSizeSelector({
    required this.pageSize,
    required this.isLoading,
    required this.colors,
    required this.onChanged,
  });

  final int pageSize;
  final bool isLoading;
  final AppColorScheme colors;
  final ValueChanged<int> onChanged;

  Future<void> _openSheet(BuildContext context) async {
    if (isLoading) return;

    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: colors.kInputColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Text(
                'rows_per_page'.tr(),
                style: TextStyle(
                  color: colors.kFontColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai',
                ),
              ),
            ),
            ...TablePaginationWidget.pageSizeOptions.map((size) {
              final isSelected = size == pageSize;
              return ListTile(
                title: Text(
                  '$size',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? colors.kPrimaryColor : colors.kFontColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontFamily: 'Almarai',
                    fontSize: 15.sp,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_rounded, color: colors.kPrimaryColor)
                    : null,
                onTap: () => Navigator.pop(context, size),
              );
            }),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );

    if (selected != null && selected != pageSize) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : () => _openSheet(context),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.kBgColor.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'rows_per_page'.tr(),
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 13.sp,
                fontFamily: 'Almarai',
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '$pageSize',
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Almarai',
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colors.kPrimaryColor,
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }
}
