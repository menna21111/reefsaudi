import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color.dart';

class TablePaginationWidget extends StatelessWidget {
  static const List<int> pageSizeOptions = [10, 20, 40, 50, 100];

  final int currentPage;
  final int totalPages;
  final int pageSize;
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
    required this.hasPreviousPage,
    required this.hasNextPage,
    required this.isLoading,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 16.h),
      child: Column(
        children: [
          _buildPageSizeRow(),
          SizedBox(height: 12.h),
          _buildPageNumbersRow(),
        ],
      ),
    );
  }

  Widget _buildPageSizeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: pageSizeOptions.map((size) {
        final isSelected = pageSize == size;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: _PaginationBox(
            label: '$size',
            isSelected: isSelected,
            isLoading: isLoading,
            onTap: () {
              if (!isSelected) onPageSizeChanged(size);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPageNumbersRow() {
    final pages = _visiblePages();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(
          icon: Icons.chevron_left_rounded,
          enabled: hasPreviousPage && !isLoading,
          onTap: () => onPageChanged(currentPage - 1),
        ),
        ...pages.map((page) {
          if (page == -1) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                '...',
                style: TextStyle(
                  color: AppColor.kGrayTextColor,
                  fontSize: 12.sp,
                  fontFamily: 'Almarai',
                ),
              ),
            );
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: _PaginationBox(
              label: '$page',
              isSelected: page == currentPage,
              isLoading: isLoading,
              onTap: () {
                if (page != currentPage) onPageChanged(page);
              },
            ),
          );
        }),
        _NavButton(
          icon: Icons.chevron_right_rounded,
          enabled: hasNextPage && !isLoading,
          onTap: () => onPageChanged(currentPage + 1),
        ),
      ],
    );
  }

  List<int> _visiblePages() {
    if (totalPages <= 7) {
      return List.generate(totalPages, (index) => index + 1);
    }

    final pages = <int>[1];

    if (currentPage > 3) pages.add(-1);

    final start = (currentPage - 1).clamp(2, totalPages - 1);
    final end = (currentPage + 1).clamp(2, totalPages - 1);
    for (var page = start; page <= end; page++) {
      if (!pages.contains(page)) pages.add(page);
    }

    if (currentPage < totalPages - 2) pages.add(-1);
    if (!pages.contains(totalPages)) pages.add(totalPages);

    return pages;
  }
}

class _PaginationBox extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isLoading;
  final VoidCallback onTap;

  const _PaginationBox({
    required this.label,
    required this.isSelected,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.kPrimaryColor
              : AppColor.kBackgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected
                ? AppColor.kPrimaryColor
                : AppColor.kBorderColor.withOpacity(0.5),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColor.kWhiteColor : AppColor.kGrayTextColor,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontFamily: 'Almarai',
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36.w,
        height: 36.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: AppColor.kBackgroundColor.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColor.kBorderColor.withOpacity(0.5)),
        ),
        child: Icon(
          icon,
          size: 20.sp,
          color: enabled ? AppColor.kWhiteColor : AppColor.kDarkGrayColor,
        ),
      ),
    );
  }
}
