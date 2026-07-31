import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/master_data_management_table.dart';
import '../../../financial_requirements/presentation/widgets/delete_confirmation_dialog.dart';
import '../../../financial_requirements/presentation/widgets/table_pagination_widget.dart';
import '../../domain/models/contractor.dart';
import '../cubit/contractors_cubit.dart';
import '../widgets/contractor_form_sheet.dart';

class ContractorsManagementScreen extends StatelessWidget {
  const ContractorsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ContractorsCubit>()..load(),
      child: const _ContractorsManagementView(),
    );
  }
}

class _ContractorsManagementView extends StatefulWidget {
  const _ContractorsManagementView();

  @override
  State<_ContractorsManagementView> createState() =>
      _ContractorsManagementViewState();
}

class _ContractorsManagementViewState extends State<_ContractorsManagementView> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ContractorsCubit>().search(value);
    });
  }

  String _typeLabel(int type) {
    return type == 0
        ? AppString.supplierTypeConsultant.tr()
        : AppString.supplierTypeContractor.tr();
  }

  Future<void> _openCreateSheet() async {
    final result = await ContractorFormSheet.show(context);
    if (result == null || !mounted) return;

    final success = await context.read<ContractorsCubit>().createContractor(
          ContractorWriteRequest(
            title: result.title,
            description: result.description,
            type: result.type,
            currency: result.currency,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _openEditSheet(Contractor item) async {
    final result = await ContractorFormSheet.show(
      context,
      initialTitle: item.title,
      initialDescription: item.description,
      initialType: item.type,
      initialCurrency: item.currency.isEmpty ? 'SAR' : item.currency,
    );
    if (result == null || !mounted) return;

    final success = await context.read<ContractorsCubit>().updateContractor(
          id: item.id,
          request: ContractorWriteRequest(
            title: result.title,
            description: result.description,
            type: result.type,
            currency: result.currency,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _confirmDelete(Contractor item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteConfirmationDialog(
        titleKey: AppString.confirmDelete,
        messageKey: AppString.confirmDeleteContractor,
      ),
    );

    if (confirmed != true || !mounted) return;

    final success =
        await context.read<ContractorsCubit>().deleteContractor(item.id);
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.deletedSuccessfully.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppString.contractorsManagement.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.kPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ContractorsCubit, ContractorsState>(
        builder: (context, state) {
          if (state is ContractorsLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is ContractorsError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.kRedColor, fontSize: 14.sp),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () =>
                          context.read<ContractorsCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! ContractorsLoaded) {
            return const SizedBox.shrink();
          }

          final tableItems = state.items
              .map(
                (item) => MasterDataItem(
                  id: item.id,
                  title: item.title,
                  description: item.description,
                  metaText: '${_typeLabel(item.type)} · ${item.currency}',
                ),
              )
              .toList();

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<ContractorsCubit>().refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: [
                MasterDataManagementToolbar(
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                  onAddPressed: state.isSubmitting ? () {} : _openCreateSheet,
                ),
                MasterDataManagementTable(
                  items: tableItems,
                  isLoading: state.isPageLoading || state.isRefreshing,
                  showMetaColumn: true,
                  metaColumnLabelKey: AppString.supplierTypeLabel,
                  onEdit: (item) => _openEditSheet(
                    state.items.firstWhere((c) => c.id == item.id),
                  ),
                  onDelete: (item) => _confirmDelete(
                    state.items.firstWhere((c) => c.id == item.id),
                  ),
                ),
                if (state.totalCount > 0)
                  Container(
                    decoration: BoxDecoration(
                      color: colors.kInputColor,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: colors.kBorderColor.withValues(alpha: 0.35),
                      ),
                    ),
                    child: TablePaginationWidget(
                      currentPage: state.currentPage,
                      totalPages: state.totalPages,
                      pageSize: state.pageSize,
                      totalCount: state.totalCount,
                      hasPreviousPage: state.hasPreviousPage,
                      hasNextPage: state.hasNextPage,
                      isLoading: state.isPageLoading,
                      onPageChanged:
                          context.read<ContractorsCubit>().changePage,
                      onPageSizeChanged:
                          context.read<ContractorsCubit>().changePageSize,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
