import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reefsaudia/core/utils/app_font.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/multi_select_popup_dropdown.dart';
import '../../data/models/dashboard_project_filters.dart';
import '../constants/dashboard_filter_options.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class ProjectFiltersSection extends StatelessWidget {
  const ProjectFiltersSection({
    super.key,
    this.onSearch,
  });

  final VoidCallback? onSearch;

  static const double _filterWidth = 148;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final cubit = context.read<DashboardCubit>();
        final categories = ProjectFilterCategory.values;
        final draft = state.draftFilters;
        final showSearchButton =
            draft.hasAny || state.hasPendingFilterChanges;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 10.w,
              runSpacing: 12.h,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                for (final category in categories)
                  SizedBox(
                    width: _filterWidth.w,
                    child: _buildFilterDropdown(
                      context,
                      state: state,
                      cubit: cubit,
                      category: category,
                      draft: draft,
                    ),
                  ),
                if (draft.hasAny)
                  TextButton(
                    onPressed: cubit.clearDraftFilters,
                    child: RobotoText(
                      text: AppString.clearFilters.tr(),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.kPrimaryColor,
                    ),
                  ),
              ],
            ),
            if (showSearchButton) ...[
              SizedBox(height: 12.h),
              ButtonCustom(
                text: AppString.search.tr(),
                buttoncolor: colors.kPrimaryColor,
                onTap: () {
                  FocusScope.of(context).unfocus();
                  if (onSearch != null) {
                    onSearch!();
                  } else {
                    cubit.applyFilters();
                  }
                },
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context, {
    required DashboardState state,
    required DashboardCubit cubit,
    required ProjectFilterCategory category,
    required DashboardProjectFilters draft,
  }) {
    final isActive = draft.hasCategorySelection(category);

    if (category.isIntCategory) {
      final options = category == ProjectFilterCategory.projectStatus
          ? dashboardProjectStatusFilterOptions
          : dashboardProjectTypeFilterOptions;

      final selected = category == ProjectFilterCategory.projectStatus
          ? draft.projectStatus.toSet()
          : draft.projectTypes.toSet();

      return MultiSelectPopupDropdown<int>(
        compact: true,
        isActive: isActive,
        title: category.labelKey.tr(),
        hintText: AppString.all.tr(),
        items: options
            .map(
              (option) => MultiSelectOption<int>(
                value: option.value,
                label: option.labelKey.tr(),
              ),
            )
            .toList(),
        selected: selected,
        onSelectionChanged: (next) {
          cubit.setIntFiltersForCategory(category, next.toList());
        },
      );
    }

    final options = _stringOptionsForCategory(state, category);
    final selected = _selectedStringIds(draft, category).toSet();

    return MultiSelectPopupDropdown<String>(
      compact: true,
      isActive: isActive,
      title: category.labelKey.tr(),
      hintText: AppString.all.tr(),
      isLoading: state.filterOptionsLoading && options.isEmpty,
      emptyText: AppString.noOptions.tr(),
      items: options
          .map(
            (option) => MultiSelectOption<String>(
              value: option.id,
              label: option.title,
            ),
          )
          .toList(),
      selected: selected,
      onSelectionChanged: (next) {
        cubit.setStringFiltersForCategory(category, next.toList());
      },
    );
  }

  List<FilterStringOption> _stringOptionsForCategory(
    DashboardState state,
    ProjectFilterCategory category,
  ) {
    switch (category) {
      case ProjectFilterCategory.brands:
        return state.brandsOptions;
      case ProjectFilterCategory.productionLines:
        return state.productionLinesOptions;
      case ProjectFilterCategory.products:
        return state.productsOptions;
      case ProjectFilterCategory.sizes:
        return state.sizesOptions;
      default:
        return const [];
    }
  }

  List<String> _selectedStringIds(
    DashboardProjectFilters filters,
    ProjectFilterCategory category,
  ) {
    switch (category) {
      case ProjectFilterCategory.brands:
        return filters.brands;
      case ProjectFilterCategory.productionLines:
        return filters.productionLines;
      case ProjectFilterCategory.products:
        return filters.products;
      case ProjectFilterCategory.sizes:
        return filters.sizes;
      default:
        return const [];
    }
  }
}
