import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'achievement_pagination_nav_icon.dart';
import 'achievement_pagination_page_number.dart';

class AchievementPagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  const AchievementPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AchievementPaginationNavIcon(
          icon: Icons.chevron_left_rounded,
          onTap: currentPage < totalPages
              ? () => onPageChanged(currentPage + 1)
              : null,
        ),
        SizedBox(width: 8.w),
        ...List.generate(totalPages, (index) {
          final page = totalPages - index;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: AchievementPaginationPageNumber(
              page: page,
              isSelected: page == currentPage,
              onTap: () => onPageChanged(page),
            ),
          );
        }),
        SizedBox(width: 8.w),
        AchievementPaginationNavIcon(
          icon: Icons.chevron_right_rounded,
          onTap: currentPage > 1
              ? () => onPageChanged(currentPage - 1)
              : null,
        ),
      ],
    );
  }
}
