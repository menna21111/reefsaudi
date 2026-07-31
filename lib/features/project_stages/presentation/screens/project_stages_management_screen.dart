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
import '../../domain/models/project_stage_assignment.dart';
import '../cubit/project_stages_cubit.dart';
import '../widgets/project_stage_form_sheet.dart';
import '../widgets/project_stages_table.dart';

class ProjectStagesManagementScreen extends StatelessWidget {
  const ProjectStagesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectStagesCubit>()..load(),
      child: const _ProjectStagesManagementView(),
    );
  }
}

class _ProjectStagesManagementView extends StatefulWidget {
  const _ProjectStagesManagementView();

  @override
  State<_ProjectStagesManagementView> createState() =>
      _ProjectStagesManagementViewState();
}

class _ProjectStagesManagementViewState
    extends State<_ProjectStagesManagementView> {
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
      context.read<ProjectStagesCubit>().search(value);
    });
  }

  String _toAssignedDateIso(DateTime date) {
    return DateTime.utc(date.year, date.month, date.day, 21).toIso8601String();
  }

  Future<void> _openCreateSheet() async {
    final cubit = context.read<ProjectStagesCubit>();
    final result = await ProjectStageFormSheet.show(
      context,
      loadProjects: cubit.loadProjects,
      loadSteps: cubit.loadStepOptions,
    );
    if (result == null || !mounted) return;

    final success = await cubit.createProjectStage(
      ProjectStageWriteRequest(
        projectId: result.projectId,
        pStepId: result.pStepId,
        assignedDate: _toAssignedDateIso(result.assignedDate),
      ),
    );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _openEditSheet(ProjectStageAssignment item) async {
    final cubit = context.read<ProjectStagesCubit>();
    final result = await ProjectStageFormSheet.show(
      context,
      loadProjects: cubit.loadProjects,
      loadSteps: cubit.loadStepOptions,
      initial: item,
    );
    if (result == null || !mounted) return;

    final success = await cubit.updateProjectStage(
      id: item.id,
      request: ProjectStageWriteRequest(
        projectId: result.projectId,
        pStepId: result.pStepId,
        assignedDate: _toAssignedDateIso(result.assignedDate),
      ),
    );
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _confirmDelete(ProjectStageAssignment item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteConfirmationDialog(
        titleKey: AppString.confirmDelete,
        messageKey: AppString.confirmDeleteProjectStage,
      ),
    );

    if (confirmed != true || !mounted) return;

    final success =
        await context.read<ProjectStagesCubit>().deleteProjectStage(item.id);
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
          AppString.projectStagesManagement.tr(),
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
      body: BlocBuilder<ProjectStagesCubit, ProjectStagesState>(
        builder: (context, state) {
          if (state is ProjectStagesLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is ProjectStagesError) {
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
                      onPressed: () => context.read<ProjectStagesCubit>().load(),
                      child: Text(AppString.retry.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! ProjectStagesLoaded) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<ProjectStagesCubit>().refresh(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: [
                MasterDataManagementToolbar(
                  searchController: _searchController,
                  onSearchChanged: _onSearchChanged,
                  onAddPressed: state.isSubmitting ? () {} : _openCreateSheet,
                ),
                ProjectStagesTable(
                  items: state.items,
                  isLoading: state.isPageLoading || state.isRefreshing,
                  onEdit: _openEditSheet,
                  onDelete: _confirmDelete,
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
                          context.read<ProjectStagesCubit>().changePage,
                      onPageSizeChanged:
                          context.read<ProjectStagesCubit>().changePageSize,
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
