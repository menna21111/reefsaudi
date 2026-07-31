import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/permissions/app_permissions.dart';
import '../../../../core/permissions/permission_gate.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../financial_requirements/domain/entities/financial_requirement.dart';
import '../../../financial_requirements/domain/entities/financial_statement_summary.dart';
import '../../../financial_requirements/domain/repositories/financial_requirements_repository.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_bloc.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_event.dart';
import '../../../financial_requirements/presentation/bloc/financial_requirements_state.dart';
import '../../../financial_requirements/presentation/screens/financial_requirement_add_screen.dart';
import '../../../financial_requirements/presentation/screens/financial_requirement_edit_screen.dart';
import '../../../financial_requirements/presentation/widgets/delete_confirmation_dialog.dart';
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
    final colors = context.appColors;
    return PermissionGate(
      permission: AppPermissions.financialStatementView,
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
      child: BlocProvider(
        create: (_) =>
            sl<FinancialRequirementsBloc>()
              ..add(const LoadFinancialRequirements()),
        child: const _ExtractsManagementView(),
      ),
    );
  }
}

class _ExtractsManagementView extends StatefulWidget {
  const _ExtractsManagementView();

  @override
  State<_ExtractsManagementView> createState() =>
      _ExtractsManagementViewState();
}

class _ExtractsManagementViewState extends State<_ExtractsManagementView> {
  final TextEditingController _searchController = TextEditingController();

  FinancialStatementSummary _countSummary = FinancialStatementSummary.empty;
  FinancialStatementSummary _sumSummary = FinancialStatementSummary.empty;
  bool _isSummaryLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSummaries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSummaries() async {
    setState(() => _isSummaryLoading = true);

    final repository = sl<FinancialRequirementsRepository>();
    final results = await Future.wait([
      repository.getStatementCount(),
      repository.getStatementSum(),
    ]);

    if (!mounted) return;

    setState(() {
      _countSummary = results[0].fold(
        (_) => FinancialStatementSummary.empty,
        (summary) => summary,
      );
      _sumSummary = results[1].fold(
        (_) => FinancialStatementSummary.empty,
        (summary) => summary,
      );
      _isSummaryLoading = false;
    });
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

  void _reloadKeepingPageSize() {
    final state = context.read<FinancialRequirementsBloc>().state;
    final pageSize = state is FinancialRequirementsLoaded
        ? state.pageSize
        : FinancialRequirementsBloc.defaultPageSize;
    context.read<FinancialRequirementsBloc>().add(
      LoadFinancialRequirements(pageSize: pageSize),
    );
    _loadSummaries();
  }

  Future<void> _onAdd() async {
    final created = await FinancialRequirementAddScreen.open(context);

    if (created == true && mounted) {
      _reloadKeepingPageSize();
    }
  }

  Future<void> _onEdit(FinancialRequirement item) async {
    final updated = await FinancialRequirementEditScreen.open(
      context,
      item: item,
    );

    if (updated == true && mounted) {
      _reloadKeepingPageSize();
    }
  }

  Future<void> _onDelete(FinancialRequirement item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const DeleteConfirmationDialog(),
    );

    if (confirmed != true || !mounted) return;

    context.read<FinancialRequirementsBloc>().add(
      DeleteFinancialRequirement(item.id),
    );
    _loadSummaries();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      body: SafeArea(
        child:
            BlocConsumer<FinancialRequirementsBloc, FinancialRequirementsState>(
              listenWhen: (previous, current) =>
                  current is FinancialRequirementsLoaded &&
                  current.feedbackMessage != null &&
                  (previous is! FinancialRequirementsLoaded ||
                      previous.feedbackMessage != current.feedbackMessage),
              listener: (context, state) {
                if (state is! FinancialRequirementsLoaded ||
                    state.feedbackMessage == null) {
                  return;
                }

                final message = state.feedbackMessage!.tr();
                if (state.feedbackIsError) {
                  AppFunctions.showsToast(message, AppColor.kRedColor, context);
                } else {
                  AppFunctions.showSuccessToast(context, message);
                }

                context.read<FinancialRequirementsBloc>().add(
                  const ClearFinancialFeedback(),
                );
              },
              builder: (context, state) {
                if (state is FinancialRequirementsLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: colors.kPrimaryColor,
                    ),
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

                final loaded = state is FinancialRequirementsLoaded
                    ? state
                    : null;

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // SliverPadding(
                    //   padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
                    //   sliver: const SliverToBoxAdapter(
                    //     child: ExtractsManagementHeader(),
                    //   ),
                    // ),
                    // SliverToBoxAdapter(child: SizedBox(height: 16.h)),
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
                          countSummary: _countSummary,
                          sumSummary: _sumSummary,
                          isLoading: _isSummaryLoading,
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
