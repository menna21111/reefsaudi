import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../financial_requirements/domain/entities/financial_requirement.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_bloc.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_event.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_state.dart';
import '../../../financial_requirements/presentation/screens/financial_requirement_edit_screen.dart';
import '../../../financial_requirements/presentation/widgets/delete_confirmation_dialog.dart';
import '../../domain/models/extract_item.dart';
import '../../domain/models/financial_requirement_mapper.dart';
import '../../../dashboard/presentation/screens/statistics_screen.dart';
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
            ..add(const LoadFinancialRequirements(pageSize: 100)),
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

  void _onMapTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StatisticsScreen()),
    );
  }

  Future<void> _onAdd() async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const FinancialRequirementEditScreen(item: null),
      ),
    );

    if (created == true && mounted) {
      context.read<FinancialRequirementsBloc>().add(
            const LoadFinancialRequirements(pageSize: 100),
          );
    }
  }

  Future<void> _onEdit(FinancialRequirement item) async {
    final updated = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => FinancialRequirementEditScreen(item: item),
      ),
    );

    if (updated == true && mounted) {
      context.read<FinancialRequirementsBloc>().add(
            const LoadFinancialRequirements(pageSize: 100),
          );
    }
  }

  void _onDelete(FinancialRequirement item) {
    final colors = context.appColorsRead;

    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        onConfirm: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: RobotoText(
                text: AppString.deletedSuccessfully.tr(),
                fontSize: 14.sp,
                color: colors.kWhiteColor,
              ),
              backgroundColor: colors.kPrimaryColor,
            ),
          );
        },
      ),
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
                  sliver: SliverToBoxAdapter(
                    child: ExtractsPageTitleRow(onMapTap: _onMapTap),
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
                      onAddTap: _onAdd,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  sliver: SliverToBoxAdapter(
                    child: loaded == null
                        ? const SizedBox.shrink()
                        : ExtractsTable(
                            items: loaded.filteredItems,
                            onEdit: _onEdit,
                            onDelete: _onDelete,
                            currentPage: loaded.pageNumber,
                            totalPages: loaded.totalPages,
                            pageSize: loaded.pageSize,
                            totalCount: loaded.totalCount,
                            hasPreviousPage: loaded.hasPreviousPage,
                            hasNextPage: loaded.hasNextPage,
                            isPageLoading: loaded.isPageLoading,
                            onPageChanged: (page) => context
                                .read<FinancialRequirementsBloc>()
                                .add(ChangeFinancialRequirementsPage(page)),
                            onPageSizeChanged: (size) => context
                                .read<FinancialRequirementsBloc>()
                                .add(
                                  ChangeFinancialRequirementsPageSize(size),
                                ),
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
