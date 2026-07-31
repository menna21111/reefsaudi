import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/permissions/permission_gate.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../domain/entities/project.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../../../project/presentation/screens/add_project_screen.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_search_actions_row.dart';
import '../widgets/project_filters_section.dart';
import '../widgets/project_card.dart';
import '../widgets/project_table.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isTableView = false;
  bool _showFilters = false;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<DashboardSearchActionsRowState> _searchRowKey =
      GlobalKey<DashboardSearchActionsRowState>();

  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().ensureInitialLoad();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final cubit = context.read<DashboardCubit>();
    if (cubit.state.isLoadingMore || !cubit.canLoadMore) return;

    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 280) return;

    // Table view + tablet multi-column both need manual load-more.
    if (isTableView || context.projectGridCrossAxisCount > 1) {
      cubit.loadMoreIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cubit = context.read<DashboardCubit>();
    final hPad = context.pagePadding;

    return PermissionGate(
      permission: AppPermissions.projectView,
      allowAdmin: true,
      fallback: Scaffold(
        backgroundColor: colors.kBgColor,
        body: Center(
          child: Text(
            AppString.noPermission.tr(),
            style: TextStyle(color: colors.kFontColor, fontSize: 16.sp),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: colors.kBgColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().refresh(),
            color: colors.kPrimaryColor,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 12.h),
                  sliver: SliverToBoxAdapter(
                    child: AdaptiveContent(
                      padding: EdgeInsets.zero,
                      child: DashboardHeader(
                        leading: DashboardHeaderLeading.back,
                        titleKey: AppString.projects,
                        trailing: IconButton(
                          tooltip: AppString.addNewProject.tr(),
                          onPressed: () {
                            Navigator.of(context).push(AddProjectScreen.route());
                          },
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                            color: colors.kPrimaryColor,
                            size: context.isTablet ? 28.sp : 26.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: AdaptiveContent(
                      padding: EdgeInsets.zero,
                      child: DashboardSearchActionsRow(
                        key: _searchRowKey,
                        isTableView: isTableView,
                        isFiltersExpanded: _showFilters,
                        onFilterToggle: () {
                          setState(() => _showFilters = !_showFilters);
                          if (_showFilters) {
                            context.read<DashboardCubit>().loadFilterOptions();
                          }
                        },
                        onViewToggle: () {
                          setState(() => isTableView = !isTableView);
                        },
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  sliver: SliverToBoxAdapter(
                    child: AdaptiveContent(
                      padding: EdgeInsets.zero,
                      child: AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: EdgeInsets.only(top: 12.h),
                          child: ProjectFiltersSection(
                            onSearch: () =>
                                _searchRowKey.currentState?.submitFromParent(),
                          ),
                        ),
                        crossFadeState: _showFilters
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                        sizeCurve: Curves.easeInOut,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                if (isTableView)
                  BlocBuilder<DashboardCubit, DashboardState>(
                    builder: (context, state) {
                      return ListenableBuilder(
                        listenable: cubit.pagingController,
                        builder: (context, _) {
                          final controller = cubit.pagingController;
                          final items = controller.itemList ?? [];
                          if (items.isEmpty &&
                              controller.error == null &&
                              !cubit.hasCachedProjects) {
                            return SliverToBoxAdapter(
                              child: AdaptiveContent(
                                padding: EdgeInsets.symmetric(horizontal: hPad),
                                child: _buildPageLoader(context),
                              ),
                            );
                          }
                          if (items.isEmpty) {
                            return SliverFillRemaining(
                              hasScrollBody: false,
                              child: _buildEmptyOrError(
                                context,
                                error: controller.error?.toString(),
                              ),
                            );
                          }
                          return SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: hPad),
                            sliver: SliverToBoxAdapter(
                              child: AdaptiveContent(
                                padding: EdgeInsets.zero,
                                child: ProjectTable(
                                  projects: items,
                                  showBottomLoader: state.isLoadingMore,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                else
                  _buildProjectsList(cubit, hPad),
                SliverToBoxAdapter(child: SizedBox(height: 80.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsList(DashboardCubit cubit, double hPad) {
    final crossAxisCount = context.projectGridCrossAxisCount;

    if (crossAxisCount <= 1) {
      return PagedSliverList<int, Project>(
        pagingController: cubit.pagingController,
        builderDelegate: PagedChildBuilderDelegate<Project>(
          itemBuilder: (context, project, index) => Padding(
            padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 8.h),
            child: AdaptiveContent(
              padding: EdgeInsets.zero,
              child: ProjectCard(project: project),
            ),
          ),
          firstPageProgressIndicatorBuilder: (_) => AdaptiveContent(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: _buildPageLoader(context),
          ),
          newPageProgressIndicatorBuilder: (_) => Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Center(
              child: CircularProgressIndicator(
                color: context.appColors.kPrimaryColor,
              ),
            ),
          ),
          noItemsFoundIndicatorBuilder: (_) => _buildEmptyOrError(context),
          firstPageErrorIndicatorBuilder: (_) => _buildEmptyOrError(
            context,
            error: cubit.pagingController.error?.toString(),
          ),
          newPageErrorIndicatorBuilder: (_) => Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              AppString.unKnownError.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appColors.kRedColor),
            ),
          ),
        ),
      );
    }

    // Tablet: pair cards in rows so height stays intrinsic (no overflow).
    return ListenableBuilder(
      listenable: cubit.pagingController,
      builder: (context, _) {
        final controller = cubit.pagingController;
        final items = controller.itemList ?? [];
        final colors = context.appColors;

        if (items.isEmpty &&
            controller.error == null &&
            !cubit.hasCachedProjects) {
          return SliverToBoxAdapter(
            child: AdaptiveContent(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              child: _buildPageLoader(context),
            ),
          );
        }

        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: _buildEmptyOrError(
              context,
              error: controller.error?.toString(),
            ),
          );
        }

        final rowCount = (items.length / crossAxisCount).ceil();

        return BlocBuilder<DashboardCubit, DashboardState>(
          buildWhen: (prev, next) => prev.isLoadingMore != next.isLoadingMore,
          builder: (context, state) {
            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: hPad),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, rowIndex) {
                    if (rowIndex == rowCount) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: state.isLoadingMore
                              ? CircularProgressIndicator(
                                  color: colors.kPrimaryColor,
                                )
                              : const SizedBox.shrink(),
                        ),
                      );
                    }

                    final start = rowIndex * crossAxisCount;
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: AdaptiveContent(
                        padding: EdgeInsets.zero,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var col = 0; col < crossAxisCount; col++) ...[
                              if (col > 0) SizedBox(width: 12.w),
                              Expanded(
                                child: start + col < items.length
                                    ? ProjectCard(project: items[start + col])
                                    : const SizedBox.shrink(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: rowCount + 1,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPageLoader(BuildContext context) {
    final crossAxisCount = context.projectGridCrossAxisCount;
    if (crossAxisCount > 1) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          children: List.generate(
            2,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                children: List.generate(
                  crossAxisCount,
                  (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: i == 0 ? 0 : 6.w,
                        right: i == crossAxisCount - 1 ? 0 : 6.w,
                      ),
                      child: ShimmerBox(
                        width: double.infinity,
                        height: 200.h,
                        borderRadius: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: List.generate(
          3,
          (_) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ShimmerBox(
              width: double.infinity,
              height: 180.h,
              borderRadius: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyOrError(BuildContext context, {String? error}) {
    final colors = context.appColors;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Text(
          error != null ? error.toString().tr() : AppString.noProjects.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: error != null ? colors.kRedColor : colors.kGrayColor,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
