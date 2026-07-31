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
import '../../domain/models/project_type.dart';
import '../cubit/project_types_cubit.dart';

class ProjectTypesManagementScreen extends StatelessWidget {
  const ProjectTypesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectTypesCubit>()..load(),
      child: const _ProjectTypesManagementView(),
    );
  }
}

class _ProjectTypesManagementView extends StatefulWidget {
  const _ProjectTypesManagementView();

  @override
  State<_ProjectTypesManagementView> createState() =>
      _ProjectTypesManagementViewState();
}

class _ProjectTypesManagementViewState extends State<_ProjectTypesManagementView> {
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
      context.read<ProjectTypesCubit>().search(value);
    });
  }

  Future<void> _openCreateSheet() async {
    final result = await MasterDataFormSheet.show(
      context,
      addTitleKey: AppString.addProjectType,
      editTitleKey: AppString.editProjectType,
    );
    if (result == null || !mounted) return;

    final success = await context.read<ProjectTypesCubit>().createProjectType(
          ProjectTypeWriteRequest(
            title: result.title,
            description: result.description,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _openEditSheet(ProjectType projectType) async {
    final result = await MasterDataFormSheet.show(
      context,
      addTitleKey: AppString.addProjectType,
      editTitleKey: AppString.editProjectType,
      initialTitle: projectType.title,
      initialDescription: projectType.description,
    );
    if (result == null || !mounted) return;

    final success = await context.read<ProjectTypesCubit>().updateProjectType(
          id: projectType.id,
          request: ProjectTypeWriteRequest(
            title: result.title,
            description: result.description,
          ),
        );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _confirmDelete(ProjectType projectType) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
        titleKey: AppString.confirmDelete,
        messageKey: AppString.confirmDeleteProjectType,
      ),
    );

    if (confirmed != true || !mounted) return;

    final success =
        await context.read<ProjectTypesCubit>().deleteProjectType(projectType.id);
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
          AppString.projectTypesManagement.tr(),
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
      body: BlocBuilder<ProjectTypesCubit, ProjectTypesState>(
        builder: (context, state) {
          if (state is ProjectTypesLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is ProjectTypesError) {
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
                      onPressed: () => context.read<ProjectTypesCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! ProjectTypesLoaded) {
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
            onRefresh: () => context.read<ProjectTypesCubit>().refresh(),
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
                    state.items.firstWhere((type) => type.id == item.id),
                  ),
                  onDelete: (item) => _confirmDelete(
                    state.items.firstWhere((type) => type.id == item.id),
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
                      onPageChanged: context.read<ProjectTypesCubit>().changePage,
                      onPageSizeChanged:
                          context.read<ProjectTypesCubit>().changePageSize,
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
