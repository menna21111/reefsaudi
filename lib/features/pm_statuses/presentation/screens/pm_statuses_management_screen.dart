import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/master_data_form_sheet.dart';
import '../../../../core/widgets/master_data_management_table.dart';
import '../../../financial_requirements/presentation/widgets/delete_confirmation_dialog.dart';
import '../../../financial_requirements/presentation/widgets/table_pagination_widget.dart';
import '../../domain/models/pm_status.dart';
import '../cubit/pm_statuses_cubit.dart';

class PmStatusesManagementScreen extends StatelessWidget {
  const PmStatusesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PmStatusesCubit>()..load(),
      child: const _PmStatusesManagementView(),
    );
  }
}

class _PmStatusesManagementView extends StatefulWidget {
  const _PmStatusesManagementView();

  @override
  State<_PmStatusesManagementView> createState() =>
      _PmStatusesManagementViewState();
}

class _PmStatusesManagementViewState extends State<_PmStatusesManagementView> {
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
      context.read<PmStatusesCubit>().search(value);
    });
  }

  Future<void> _openCreateSheet() async {
    final result = await MasterDataFormSheet.show(
      context,
      addTitleKey: AppString.addPmStatus,
      editTitleKey: AppString.editPmStatus,
    );
    if (result == null || !mounted) return;

    final success = await context.read<PmStatusesCubit>().createPmStatus(
          PmStatusWriteRequest(
            title: result.title,
            description: result.description,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _openEditSheet(PmStatus item) async {
    final result = await MasterDataFormSheet.show(
      context,
      addTitleKey: AppString.addPmStatus,
      editTitleKey: AppString.editPmStatus,
      initialTitle: item.title,
      initialDescription: item.description,
    );
    if (result == null || !mounted) return;

    final success = await context.read<PmStatusesCubit>().updatePmStatus(
          id: item.id,
          request: PmStatusWriteRequest(
            title: result.title,
            description: result.description,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _confirmDelete(PmStatus item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        titleKey: AppString.confirmDelete,
        messageKey: AppString.confirmDeletePmStatus,
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await context.read<PmStatusesCubit>().deletePmStatus(item.id);
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
          AppString.pmStatusesManagement.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.kPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<PmStatusesCubit, PmStatusesState>(
        builder: (context, state) {
          if (state is PmStatusesLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is PmStatusesError) {
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
                      onPressed: () => context.read<PmStatusesCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! PmStatusesLoaded) {
            return const SizedBox.shrink();
          }

          final tableItems = state.items
              .map(
                (item) => MasterDataItem(
                  id: item.id,
                  title: item.title,
                  description: item.description,
                ),
              )
              .toList();

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<PmStatusesCubit>().refresh(),
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
                  onEdit: (row) => _openEditSheet(
                    state.items.firstWhere((item) => item.id == row.id),
                  ),
                  onDelete: (row) => _confirmDelete(
                    state.items.firstWhere((item) => item.id == row.id),
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
                      onPageChanged: context.read<PmStatusesCubit>().changePage,
                      onPageSizeChanged:
                          context.read<PmStatusesCubit>().changePageSize,
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
