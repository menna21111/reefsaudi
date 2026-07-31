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
import '../../domain/models/department.dart';
import '../cubit/departments_cubit.dart';

class DepartmentsManagementScreen extends StatelessWidget {
  const DepartmentsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DepartmentsCubit>()..load(),
      child: const _DepartmentsManagementView(),
    );
  }
}

class _DepartmentsManagementView extends StatefulWidget {
  const _DepartmentsManagementView();

  @override
  State<_DepartmentsManagementView> createState() =>
      _DepartmentsManagementViewState();
}

class _DepartmentsManagementViewState extends State<_DepartmentsManagementView> {
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
      context.read<DepartmentsCubit>().search(value);
    });
  }

  Future<void> _openCreateSheet() async {
    final result = await MasterDataFormSheet.show(
      context,
      addTitleKey: AppString.addDepartment,
      editTitleKey: AppString.editDepartment,
    );
    if (result == null || !mounted) return;

    final success = await context.read<DepartmentsCubit>().createDepartment(
          DepartmentWriteRequest(
            title: result.title,
            description: result.description,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _openEditSheet(Department department) async {
    final result = await MasterDataFormSheet.show(
      context,
      addTitleKey: AppString.addDepartment,
      editTitleKey: AppString.editDepartment,
      initialTitle: department.title,
      initialDescription: department.description,
    );
    if (result == null || !mounted) return;

    final success = await context.read<DepartmentsCubit>().updateDepartment(
          id: department.id,
          request: DepartmentWriteRequest(
            title: result.title,
            description: result.description,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _confirmDelete(Department department) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteConfirmationDialog(
        titleKey: AppString.confirmDelete,
        messageKey: AppString.confirmDeleteDepartment,
      ),
    );

    if (confirmed != true || !mounted) return;

    final success =
        await context.read<DepartmentsCubit>().deleteDepartment(department.id);
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
          AppString.departmentsManagement.tr(),
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
      body: BlocBuilder<DepartmentsCubit, DepartmentsState>(
        builder: (context, state) {
          if (state is DepartmentsLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is DepartmentsError) {
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
                          context.read<DepartmentsCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! DepartmentsLoaded) {
            return const SizedBox.shrink();
          }

          final tableItems = state.items
              .map(
                (department) => MasterDataItem(
                  id: department.id,
                  title: department.title,
                  description: department.description,
                ),
              )
              .toList();

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<DepartmentsCubit>().refresh(),
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
                  onEdit: (item) => _openEditSheet(
                    state.items.firstWhere((d) => d.id == item.id),
                  ),
                  onDelete: (item) => _confirmDelete(
                    state.items.firstWhere((d) => d.id == item.id),
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
                          context.read<DepartmentsCubit>().changePage,
                      onPageSizeChanged:
                          context.read<DepartmentsCubit>().changePageSize,
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
