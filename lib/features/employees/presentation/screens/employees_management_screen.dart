import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/funcation.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/master_data_management_table.dart';
import '../../../financial_requirements/presentation/widgets/delete_confirmation_dialog.dart';
import '../../../financial_requirements/presentation/widgets/table_pagination_widget.dart';
import '../../domain/models/employee.dart';
import '../cubit/employees_cubit.dart';
import '../widgets/employee_card.dart';
import '../widgets/reset_employee_password_dialog.dart';
import 'employees_add_screen.dart';

class EmployeesManagementScreen extends StatelessWidget {
  const EmployeesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmployeesCubit>()..load(),
      child: const _EmployeesManagementView(),
    );
  }
}

class _EmployeesManagementView extends StatefulWidget {
  const _EmployeesManagementView();

  @override
  State<_EmployeesManagementView> createState() =>
      _EmployeesManagementViewState();
}

class _EmployeesManagementViewState extends State<_EmployeesManagementView> {
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
      context.read<EmployeesCubit>().search(value);
    });
  }

  Future<void> _openAddScreen() async {
    await EmployeesAddScreen.open(context);
  }

  Future<void> _openEditScreen(Employee employee) async {
    await EmployeesAddScreen.openEdit(context, employee);
  }

  Future<void> _resetPassword(Employee employee) async {
    final password = await ResetEmployeePasswordDialog.show(context);
    if (!mounted || password == null) return;

    final error = await context.read<EmployeesCubit>().resetPassword(
      userId: employee.id,
      newPassword: password,
    );
    if (!mounted) return;

    if (error == null) {
      AppFunctions.showSuccessToast(
        context,
        AppString.passwordChangedSuccessfully.tr(),
      );
    } else {
      AppFunctions.showsToast(error, context.appColorsRead.kRedColor, context);
    }
  }

  Future<void> _deleteEmployee(Employee employee) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteConfirmationDialog(
        messageKey: AppString.confirmDeleteEmployee,
      ),
    );
    if (!mounted || confirmed != true) return;

    final error = await context.read<EmployeesCubit>().deleteEmployee(
      employee.id,
    );
    if (!mounted) return;

    if (error == null) {
      AppFunctions.showSuccessToast(
        context,
        AppString.deletedSuccessfully.tr(),
      );
    } else {
      AppFunctions.showsToast(error, context.appColorsRead.kRedColor, context);
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
          AppString.employeesManagement.tr(),
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
      body: BlocBuilder<EmployeesCubit, EmployeesState>(
        builder: (context, state) {
          if (state is EmployeesLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is EmployeesError) {
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
                        color: colors.kRedColor,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FilledButton(
                      onPressed: () => context.read<EmployeesCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! EmployeesLoaded) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<EmployeesCubit>().refresh(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: MasterDataManagementToolbar(
                      searchController: _searchController,
                      onSearchChanged: _onSearchChanged,
                      onAddPressed: state.isSubmitting ? () {} : _openAddScreen,
                    ),
                  ),
                ),
                if (state.items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        AppString.noRecordsFound.tr(),
                        style: TextStyle(
                          color: colors.kGrayColor,
                          fontSize: 14.sp,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                    sliver: SliverAlignedGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      itemCount: state.items.length,
                      itemBuilder: (context, index) => EmployeeCard(
                        employee: state.items[index],
                        onEdit: () => _openEditScreen(state.items[index]),
                        onResetPassword: () =>
                            _resetPassword(state.items[index]),
                        onDelete: () => _deleteEmployee(state.items[index]),
                      ),
                    ),
                  ),
                if (state.isPageLoading || state.isRefreshing)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: colors.kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                if (state.totalCount > 0)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                      child: Container(
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
                          onPageChanged: context
                              .read<EmployeesCubit>()
                              .changePage,
                          onPageSizeChanged: context
                              .read<EmployeesCubit>()
                              .changePageSize,
                        ),
                      ),
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
