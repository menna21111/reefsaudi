import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_bloc.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_event.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_state.dart';
import '../../../financial_requirements/presentation/widgets/table_pagination_widget.dart';
import '../../domain/models/extract_item.dart';
import '../../domain/models/financial_requirement_mapper.dart';
import '../widgets/extracts_management_header.dart';
import '../widgets/extracts_page_title_row.dart';
import '../widgets/extracts_search_action_row.dart';
import '../widgets/extracts_summary_cards.dart';
import '../widgets/extracts_table.dart';

class ExtractsManagementScreen extends StatelessWidget {
  const ExtractsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<FinancialRequirementsBloc>()
            ..add(const LoadFinancialRequirements()),
      child: const _ExtractsManagementView(),
    );
  }
}

class _ExtractsManagementView extends StatefulWidget {
  const _ExtractsManagementView();

  @override
  State<_ExtractsManagementView> createState() => _ExtractsManagementViewState();
}

class _ExtractsManagementViewState extends State<_ExtractsManagementView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    FocusScope.of(context).unfocus();
    context.read<FinancialRequirementsBloc>().add(
          SearchFinancialRequirements(_searchController.text.trim()),
        );
  }

  List<ExtractItem> _mapItems(FinancialRequirementsLoaded state) {
    return state.filteredItems
        .map(FinancialRequirementMapper.toExtractItem)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      body: SafeArea(
        child: BlocBuilder<FinancialRequirementsBloc, FinancialRequirementsState>(
          builder: (context, state) {
            if (state is FinancialRequirementsLoading) {
              return Center(
                child: CircularProgressIndicator(color: colors.kPrimaryColor),
              );
            }

            if (state is FinancialRequirementsError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.kFontColor,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FilledButton(
                        onPressed: () => context
                            .read<FinancialRequirementsBloc>()
                            .add(const LoadFinancialRequirements()),
                        child: Text(AppString.retry.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            final loaded = state is FinancialRequirementsLoaded ? state : null;
            final items = loaded == null ? const <ExtractItem>[] : _mapItems(loaded);
            final pageAmount = loaded == null
                ? 0.0
                : loaded.filteredItems.fold<double>(
                    0,
                    (sum, item) => sum + item.amount,
                  );
            final completedCount = items
                .where((item) => item.status == ExtractStatus.completed)
                .length;
            final inProcessCount = items.length - completedCount;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                  sliver: const SliverToBoxAdapter(
                    child: ExtractsManagementHeader(),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 16.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: const SliverToBoxAdapter(
                    child: ExtractsPageTitleRow(),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: ExtractsSummaryCards(
                      totalCount: loaded?.totalCount ?? 0,
                      pageValueLabel:
                          FinancialRequirementMapper.formatCompactAmount(
                        pageAmount,
                      ),
                      completedCount: completedCount,
                      inProcessCount: inProcessCount,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: ExtractsSearchActionRow(
                      searchController: _searchController,
                      onSearchSubmitted: _submitSearch,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: loaded == null
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              ExtractsTable(items: items),
                              if (loaded.totalPages > 1)
                                TablePaginationWidget(
                                  currentPage: loaded.pageNumber,
                                  totalPages: loaded.totalPages,
                                  pageSize: loaded.pageSize,
                                  hasPreviousPage: loaded.hasPreviousPage,
                                  hasNextPage: loaded.hasNextPage,
                                  isLoading: loaded.isPageLoading,
                                  onPageChanged: (page) => context
                                      .read<FinancialRequirementsBloc>()
                                      .add(
                                        ChangeFinancialRequirementsPage(page),
                                      ),
                                  onPageSizeChanged: (size) => context
                                      .read<FinancialRequirementsBloc>()
                                      .add(
                                        ChangeFinancialRequirementsPageSize(
                                          size,
                                        ),
                                      ),
                                ),
                            ],
                          ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 32.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}
