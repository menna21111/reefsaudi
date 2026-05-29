import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../project/presentation/screens/project_details_screen.dart';
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
    context.read<DashboardBloc>().add(LoadDashboardProjects());
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';

    return Scaffold(
      drawer: CustomDrawer(),
      backgroundColor: AppColor.kBackgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardBloc>().add(LoadDashboardProjects());
          },
          color: AppColor.kPrimaryColor,
          backgroundColor: AppColor.kSurfaceColor,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                sliver: SliverToBoxAdapter(child: const DashboardHeader()),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverToBoxAdapter(child: const StatsGrid()),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 16.h)),
              SliverToBoxAdapter(child: const FilterChipsSection()),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverToBoxAdapter(
                  child: ActionsRow(
                    isTableView: isTableView,
                    onViewToggle: () {
                      setState(() {
                        isTableView = !isTableView;
                      });
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 12.h)),
              BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColor.kPrimaryColor,
                        ),
                      ),
                    );
                  } else if (state is DashboardError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(
                          state.message.tr(),
                          style: TextStyle(
                            color: AppColor.kRedColor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else if (state is DashboardLoaded) {
                    if (state.filteredProjects.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                            'لا توجد مشاريع'.tr(),
                            style: TextStyle(
                              color: AppColor.kGrayTextColor,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      );
                    }

                    if (isTableView) {
                      return SliverToBoxAdapter(
                        child: ProjectTable(projects: state.filteredProjects),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final project = state.filteredProjects[index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: ProjectCard(project: project),
                          );
                        }, childCount: state.filteredProjects.length),
                      );
                    }
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
              SliverToBoxAdapter(child: SizedBox(height: 80.h)),
            ],
          ),
        ),
      ),
    );
  }
}
