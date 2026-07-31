import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class DashboardSearchActionsRow extends StatefulWidget {
  const DashboardSearchActionsRow({
    super.key,
    required this.isTableView,
    required this.onViewToggle,
    required this.isFiltersExpanded,
    required this.onFilterToggle,
  });

  final bool isTableView;
  final VoidCallback onViewToggle;
  final bool isFiltersExpanded;
  final VoidCallback onFilterToggle;

  @override
  State<DashboardSearchActionsRow> createState() =>
      DashboardSearchActionsRowState();
}

class DashboardSearchActionsRowState extends State<DashboardSearchActionsRow> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    context.read<DashboardCubit>().submitSearch(_controller.text.trim());
  }

  void submitFromParent() => _submitSearch();

  void _clear() {
    _controller.clear();
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final hasFilterActivity =
            state.draftFilters.hasAny || state.filters.hasAny;
        final isFilterActive =
            widget.isFiltersExpanded || hasFilterActivity;

        return Row(
          children: [
            GestureDetector(
              onTap: widget.onFilterToggle,
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: isFilterActive
                      ? colors.kPrimaryColor.withValues(alpha: 0.15)
                      : colors.kInputColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isFilterActive
                        ? colors.kPrimaryColor
                        : colors.kBorderColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Icon(
                  Icons.filter_list_rounded,
                  color: isFilterActive
                      ? colors.kPrimaryColor
                      : colors.kGrayColor,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 8.w),
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
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
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
      },
    );
  }
}
