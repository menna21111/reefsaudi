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
import '../../../financial_requirements/presentation/widgets/table_pagination_widget.dart';
import '../../domain/models/role.dart';
import '../cubit/roles_cubit.dart';
import '../widgets/role_create_form_sheet.dart';
import '../widgets/role_edit_form_sheet.dart';

class RolesManagementScreen extends StatelessWidget {
  const RolesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RolesCubit>()..load(),
      child: const _RolesManagementView(),
    );
  }
}

class _RolesManagementView extends StatefulWidget {
  const _RolesManagementView();

  @override
  State<_RolesManagementView> createState() => _RolesManagementViewState();
}

class _RolesManagementViewState extends State<_RolesManagementView> {
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
      context.read<RolesCubit>().search(value);
    });
  }

  Future<void> _openCreateSheet() async {
    final name = await RoleCreateFormSheet.show(context);
    if (name == null || !mounted) return;

    final success = await context.read<RolesCubit>().createRole(
          RoleWriteRequest(name: name),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _openEditSheet(RoleItem item) async {
    final cubit = context.read<RolesCubit>();
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final details = await cubit.loadRoleDetails(item.id);
    if (!mounted) return;
    Navigator.of(context).pop();

    if (details == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.retry.tr())),
      );
      return;
    }

    final result = await RoleEditFormSheet.show(context, details: details);
    if (result == null || !mounted) return;

    final success = await cubit.updateRole(
      RoleUpdateRequest(
        id: item.id,
        name: result.name,
        selectedPermissions: result.selectedPermissions,
      ),
    );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
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
          AppString.rolesManagement.tr(),
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
      body: BlocBuilder<RolesCubit, RolesState>(
        builder: (context, state) {
          if (state is RolesLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is RolesError) {
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
                      onPressed: () => context.read<RolesCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! RolesLoaded) {
            return const SizedBox.shrink();
          }

          final tableItems = state.items
              .map(
                (role) => MasterDataItem(
                  id: role.id,
                  title: role.name,
                  description: '—',
                ),
              )
              .toList();

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<RolesCubit>().refresh(),
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
                  showDelete: false,
                  onEdit: (item) => _openEditSheet(
                    state.items.firstWhere((role) => role.id == item.id),
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
                      onPageChanged: context.read<RolesCubit>().changePage,
                      onPageSizeChanged:
                          context.read<RolesCubit>().changePageSize,
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
