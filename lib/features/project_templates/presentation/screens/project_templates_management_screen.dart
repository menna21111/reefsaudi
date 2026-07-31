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
import '../../domain/models/project_template.dart';
import '../constants/project_template_request_types.dart';
import '../cubit/project_templates_cubit.dart';
import '../widgets/project_template_form_sheet.dart';
import 'project_template_plan_screen.dart';

class ProjectTemplatesManagementScreen extends StatelessWidget {
  const ProjectTemplatesManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProjectTemplatesCubit>()..load(),
      child: const _ProjectTemplatesManagementView(),
    );
  }
}

class _ProjectTemplatesManagementView extends StatefulWidget {
  const _ProjectTemplatesManagementView();

  @override
  State<_ProjectTemplatesManagementView> createState() =>
      _ProjectTemplatesManagementViewState();
}

class _ProjectTemplatesManagementViewState
    extends State<_ProjectTemplatesManagementView> {
  final _searchController = TextEditingController();
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
      context.read<ProjectTemplatesCubit>().search(value);
    });
  }

  Future<void> _openCreateSheet() async {
    final request = await ProjectTemplateFormSheet.show(context);
    if (request == null || !mounted) return;

    final success = await context
        .read<ProjectTemplatesCubit>()
        .createProjectTemplate(request);
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _openEditSheet(ProjectTemplate template) async {
    final request = await ProjectTemplateFormSheet.show(
      context,
      initial: template,
    );
    if (request == null || !mounted) return;

    final success = await context
        .read<ProjectTemplatesCubit>()
        .updateProjectTemplate(id: template.id, request: request);
    if (success && mounted) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    }
  }

  Future<void> _confirmDelete(ProjectTemplate template) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const DeleteConfirmationDialog(
        messageKey: AppString.confirmDeleteProjectTemplate,
      ),
    );
    if (confirmed != true || !mounted) return;

    final success = await context
        .read<ProjectTemplatesCubit>()
        .deleteProjectTemplate(template.id);
    if (success && mounted) {
      AppFunctions.showSuccessToast(
        context,
        AppString.deletedSuccessfully.tr(),
      );
    }
  }

  void _openPlan(ProjectTemplate template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectTemplatePlanScreen(template: template),
      ),
    );
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
          AppString.projectTemplates.tr(),
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
      body: BlocBuilder<ProjectTemplatesCubit, ProjectTemplatesState>(
        builder: (context, state) {
          if (state is ProjectTemplatesLoading) {
            return Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            );
          }

          if (state is ProjectTemplatesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.kRedColor),
                  ),
                  SizedBox(height: 16.h),
                  FilledButton(
                    onPressed: () =>
                        context.read<ProjectTemplatesCubit>().load(),
                    child: Text(AppString.retry.tr()),
                  ),
                ],
              ),
            );
          }

          if (state is! ProjectTemplatesLoaded) {
            return const SizedBox.shrink();
          }

          final tableItems = state.items
              .map(
                (item) => MasterDataItem(
                  id: item.id,
                  title: item.name,
                  description: ProjectTemplateRequestTypes.titleKey(
                    item.requestType,
                  ).tr(),
                  metaText:
                      (item.published
                              ? AppString.published
                              : AppString.notPublished)
                          .tr(),
                ),
              )
              .toList();

          ProjectTemplate templateFor(MasterDataItem item) =>
              state.items.firstWhere((template) => template.id == item.id);

          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: () => context.read<ProjectTemplatesCubit>().refresh(),
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
                  metaColumnLabelKey: AppString.publishingStatus,
                  descriptionColumnLabelKey: AppString.requestType,
                  onView: (item) => _openPlan(templateFor(item)),
                  onEdit: (item) => _openEditSheet(templateFor(item)),
                  onDelete: (item) => _confirmDelete(templateFor(item)),
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
                      onPageChanged: context
                          .read<ProjectTemplatesCubit>()
                          .changePage,
                      onPageSizeChanged: context
                          .read<ProjectTemplatesCubit>()
                          .changePageSize,
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
