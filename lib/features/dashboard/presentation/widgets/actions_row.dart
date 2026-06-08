import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class ActionsRow extends StatelessWidget {
  final bool isTableView;
  final VoidCallback onViewToggle;

  const ActionsRow({
    super.key,
    required this.isTableView,
    required this.onViewToggle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onViewToggle,
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: isTableView
                  ? colors.kPrimaryColor.withValues(alpha: 0.15)
                  : colors.kInputColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isTableView
                    ? colors.kPrimaryColor
                    : colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(
              isTableView ? Icons.list_rounded : Icons.grid_view_rounded,
              color: isTableView ? colors.kPrimaryColor : colors.kGrayColor,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
