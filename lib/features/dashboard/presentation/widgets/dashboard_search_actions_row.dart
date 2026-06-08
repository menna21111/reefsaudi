import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';

class DashboardSearchActionsRow extends StatefulWidget {
  const DashboardSearchActionsRow({
    super.key,
    required this.isTableView,
    required this.onViewToggle,
  });

  final bool isTableView;
  final VoidCallback onViewToggle;

  @override
  State<DashboardSearchActionsRow> createState() =>
      _DashboardSearchActionsRowState();
}

class _DashboardSearchActionsRowState extends State<DashboardSearchActionsRow> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    context.read<DashboardBloc>().add(SearchProjects(_controller.text.trim()));
  }

  void _clear() {
    _controller.clear();
    FocusScope.of(context).unfocus();
    context.read<DashboardBloc>().add(const SearchProjects(''));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: colors.kFontColor,
                fontSize: 14.sp,
              ),
              textInputAction: TextInputAction.search,
              onChanged: (_) => setState(() {}),
              onSubmitted: (_) => _submitSearch(),
              decoration: InputDecoration(
                hintText: AppString.searchProjects.tr(),
                hintStyle: TextStyle(
                  color: colors.kGrayColor,
                  fontSize: 14.sp,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colors.kGrayColor,
                  size: 22.sp,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: _clear,
                        icon: Icon(
                          Icons.close_rounded,
                          color: colors.kGrayColor,
                          size: 20.sp,
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          onTap: widget.onViewToggle,
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: widget.isTableView
                  ? colors.kPrimaryColor.withValues(alpha: 0.15)
                  : colors.kInputColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: widget.isTableView
                    ? colors.kPrimaryColor
                    : colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            child: Icon(
              widget.isTableView
                  ? Icons.list_rounded
                  : Icons.grid_view_rounded,
              color: widget.isTableView
                  ? colors.kPrimaryColor
                  : colors.kGrayColor,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
