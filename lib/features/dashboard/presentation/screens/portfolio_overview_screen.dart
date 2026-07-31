import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_image.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/utils/responsive.dart';
import '../../../user_chat/user_chat.dart';
import '../../data/models/portfolio_overview_models.dart';
import '../cubit/portfolio_overview_cubit.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/portfolio_overview/portfolio_financial_card.dart';
import '../widgets/portfolio_overview/portfolio_overview_error.dart' show PortfolioOverviewErrorView;
import '../widgets/portfolio_overview/portfolio_overview_loading.dart' show PortfolioOverviewShimmer;
import '../widgets/portfolio_overview/portfolio_overview_title.dart';
import '../widgets/portfolio_overview/portfolio_project_status_grid.dart';
import '../widgets/portfolio_overview/portfolio_section_header.dart';
import '../widgets/portfolio_overview/portfolio_sector_dropdown.dart';
import '../widgets/portfolio_overview/portfolio_top_stats_grid.dart';

class PortfolioOverviewScreen extends StatefulWidget {
  const PortfolioOverviewScreen({super.key});

  @override
  State<PortfolioOverviewScreen> createState() =>
      _PortfolioOverviewScreenState();
}

class _PortfolioOverviewScreenState extends State<PortfolioOverviewScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PortfolioOverviewCubit>();
    if (cubit.state is PortfolioOverviewInitial) {
      cubit.load();
    }
  }

  void _onSectorChanged(
    PortfolioOverviewCubit cubit,
    BrandDto? brand,
  ) {
    if (brand == null) {
      cubit.clearBrandFilter();
      return;
    }
    cubit.selectBrand(brand);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      drawer: const CustomDrawer(),
      backgroundColor: colors.kBgColor,
      body: SafeArea(
        child: BlocBuilder<PortfolioOverviewCubit, PortfolioOverviewState>(
          builder: (context, state) {
            if (state is PortfolioOverviewLoading ||
                state is PortfolioOverviewInitial) {
              return Scaffold(
                backgroundColor: colors.kBgColor,
                body: SafeArea(child: const PortfolioOverviewShimmer()),
              );
            }

            if (state is PortfolioOverviewError) {
              return Scaffold(
                backgroundColor: colors.kBgColor,
                body: SafeArea(
                  child: PortfolioOverviewErrorView(message: state.message),
                ),
              );
            }

            if (state is! PortfolioOverviewLoaded) {
              return const SizedBox.shrink();
            }

            final bundle = state.bundle;
            final cubit = context.read<PortfolioOverviewCubit>();

            final hPad = context.pagePadding;
            final content = RefreshIndicator(
              onRefresh: cubit.refresh,
              color: colors.kPrimaryColor,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: hPad, vertical: 12.h),
                    sliver: SliverToBoxAdapter(
                      child: AdaptiveContent(
                        padding: EdgeInsets.zero,
                        child: DashboardHeader(
                          trailing: IconButton(
                            tooltip: 'user_chat_title'.tr(),
                            onPressed: () => openUserChatScreen(context),
                            icon: SvgPicture.asset(
                              AppImage.messages,
                              width: 24.sp,
                              height: 24.sp,
                              colorFilter: ColorFilter.mode(
                                colors.kPrimaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: hPad),
                    sliver: SliverToBoxAdapter(
                      child: AdaptiveContent(
                        padding: EdgeInsets.zero,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PortfolioOverviewTitle(),
                            SizedBox(height: 16.h),
                            if (bundle.brands.isNotEmpty)
                              PortfolioSectorDropdown(
                                brands: bundle.brands,
                                selectedBrandId: bundle.selectedBrandId,
                                onChanged: (brand) =>
                                    _onSectorChanged(cubit, brand),
                              ),
                            SizedBox(height: 12.h),
                            PortfolioSectionHeader(
                              title: AppString.financialStatements.tr(),
                            ),
                            SizedBox(height: 12.h),
                            PortfolioFinancialCard(financial: bundle.financial),
                            SizedBox(height: 16.h),
                            PortfolioTopStatsGrid(sectors: bundle.sectors),
                            SizedBox(height: 24.h),
                            PortfolioSectionHeader(
                              title: AppString.projectStatuses.tr(),
                            ),
                            SizedBox(height: 12.h),
                            PortfolioProjectStatusGrid(
                              status: bundle.statusCounts,
                            ),
                            SizedBox(height: 80.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );

            if (!state.isRefreshing) return content;

            return Stack(
              children: [
                content,
                Positioned.fill(
                  child: Container(
                    color: colors.kBgColor.withValues(alpha: 0.55),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colors.kPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
