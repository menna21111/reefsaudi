import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/permissions/permission_gate.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/shimmer_widgets.dart';
import '../../domain/entities/project.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/actions_row.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/filter_chips.dart';
import '../widgets/project_card.dart';
import '../widgets/project_table.dart';
import '../widgets/stats_grid.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isTableView = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<DashboardBloc>();
    bloc.add(const LoadDashboardStats());
    bloc.pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bloc = context.read<DashboardBloc>();

    return PermissionGate(
      permission: AppPermissions.projectView,
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
        drawer: const CustomDrawer(),
        backgroundColor: colors.kBgColor,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(const RefreshDashboard());
            },
            color: colors.kPrimaryColor,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  sliver:
                      const SliverToBoxAdapter(child: DashboardHeader()),
                ),
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardStatsLoaded) {
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverToBoxAdapter(
                          child: StatsGrid(
                            total: state.stats.total,
                            underExecution: state.stats.underExecution,
                            delayed: state.stats.delayed,
                            totalBudget: state.stats.totalBudget,
                          ),
                        ),
                      );
                    }
                    if (state is DashboardStatsError) {
                      return SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        sliver: SliverToBoxAdapter(
                          child: StatsGrid(
                            total: 0,
                            underExecution: 0,
                            delayed: 0,
                            totalBudget: 0,
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: List.generate(
                            2,
                            (_) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ShimmerBox(
                                      width: double.infinity,
                                      height: 72.h,
                                      borderRadius: 12,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: ShimmerBox(
                                      width: double.infinity,
                                      height: 72.h,
                                      borderRadius: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                const SliverToBoxAdapter(child: FilterChipsSection()),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: ActionsRow(
                      isTableView: isTableView,
                      onViewToggle: () {
                        setState(() => isTableView = !isTableView);
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 12.h)),
                if (isTableView)
                  ListenableBuilder(
                    listenable: bloc.pagingController,
                    builder: (context, _) {
                      final controller = bloc.pagingController;
                      final items = controller.itemList ?? [];
                      if (items.isEmpty && controller.error == null) {
                        return SliverToBoxAdapter(
                          child: _buildPageLoader(context),
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
                      return SliverToBoxAdapter(
                        child: ProjectTable(projects: items),
                      );
                    },
                  )
                else
                  PagedSliverList<int, Project>(
                    pagingController: bloc.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Project>(
                      itemBuilder: (context, project, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        child: ProjectCard(project: project),
                      ),
                      firstPageProgressIndicatorBuilder: (_) =>
                          _buildPageLoader(context),
                      newPageProgressIndicatorBuilder: (_) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: colors.kPrimaryColor,
                          ),
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (_) =>
                          _buildEmptyOrError(context),
                      firstPageErrorIndicatorBuilder: (_) =>
                          _buildEmptyOrError(
                        context,
                        error: bloc.pagingController.error?.toString(),
                      ),
                      newPageErrorIndicatorBuilder: (_) => Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text(
                          AppString.unKnownError.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.kRedColor),
                        ),
                      ),
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 80.h)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageLoader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
          error != null
              ? error.toString().tr()
              : AppString.noProjects.tr(),
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
