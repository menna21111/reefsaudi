import 'package:dartz/dartz.dart' show Either;
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/funcation.dart';
import '../../../../core/network/api_constant.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../data/models/project_charter_models.dart';
import '../cubit/project_statistics_cubit.dart';
import '../widgets/charter_section_table.dart';

class ProjectCharterScreen extends StatefulWidget {
  const ProjectCharterScreen({super.key, required this.projectId});

  final String projectId;

  @override
  State<ProjectCharterScreen> createState() => _ProjectCharterScreenState();
}

class _ProjectCharterScreenState extends State<ProjectCharterScreen> {
  late final TextEditingController _achievementSearchController;
  late final TextEditingController _stageSearchController;
  late final TextEditingController _constraintSearchController;
  late final TextEditingController _attachmentSearchController;

  @override
  void initState() {
    super.initState();
    _achievementSearchController = TextEditingController();
    _stageSearchController = TextEditingController();
    _constraintSearchController = TextEditingController();
    _attachmentSearchController = TextEditingController();
  }

  @override
  void dispose() {
    _achievementSearchController.dispose();
    _stageSearchController.dispose();
    _constraintSearchController.dispose();
    _attachmentSearchController.dispose();
    super.dispose();
  }

  ProjectCharterCubit get _cubit => context.read<ProjectCharterCubit>();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kInputColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.kWhiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppString.projectCharter.tr(),
          style: TextStyle(
            color: colors.kWhiteColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ProjectCharterCubit, ProjectCharterState>(
        builder: (context, state) {
          return RefreshIndicator(
            color: colors.kPrimaryColor,
            onRefresh: _cubit.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              children: [
                _achievementsSection(state),
                SizedBox(height: 20.h),
                _stagesSection(state),
                SizedBox(height: 20.h),
                _constraintsSection(state),
                SizedBox(height: 20.h),
                _attachmentsSection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _searchToolbar({
    required TextEditingController controller,
    required VoidCallback onSearch,
    required VoidCallback onAdd,
    String? addLabel,
    IconData addIcon = Icons.add_rounded,
  }) {
    final colors = context.appColors;
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => onSearch(),
            decoration: InputDecoration(
              hintText: AppString.search.tr(),
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: colors.kInputColor,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: colors.kBorderColor.withValues(alpha: 0.35),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(
                  color: colors.kBorderColor.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        FilledButton.icon(
          onPressed: onAdd,
          icon: Icon(addIcon, size: 18.sp),
          label: Text(addLabel ?? AppString.add.tr()),
        ),
      ],
    );
  }

  Widget _rowActions({
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    final colors = context.appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onEdit,
          icon: Icon(Icons.edit_outlined, color: colors.kPrimaryColor, size: 18.sp),
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(Icons.delete_outline_rounded, color: colors.kRedColor, size: 18.sp),
        ),
      ],
    );
  }

  Future<void> _showTextEntryDialog({
    required String title,
    String initialValue = '',
    required Future<Either<Failure, void>> Function(String text) onSave,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: AppString.riskTitle.tr()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppString.cancel.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(AppString.save.tr()),
          ),
        ],
      ),
    );
    if (!mounted || result == null || result.isEmpty) return;
    final response = await onSave(result);
    _showResult(response);
  }

  Future<void> _showConstraintDialog({
    CharterConstraintDto? initial,
  }) async {
    final titleController = TextEditingController(text: initial?.title ?? '');
    final descriptionController =
        TextEditingController(text: initial?.description ?? '');
    final result = await showDialog<(String, String)>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          initial == null ? AppString.add.tr() : AppString.editProject.tr(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: AppString.riskTitle.tr()),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: descriptionController,
              minLines: 3,
              maxLines: 4,
              decoration: InputDecoration(labelText: AppString.description.tr()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppString.cancel.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              (titleController.text.trim(), descriptionController.text.trim()),
            ),
            child: Text(AppString.save.tr()),
          ),
        ],
      ),
    );
    if (!mounted || result == null || result.$1.isEmpty) return;
    final response = initial == null
        ? await _cubit.createConstraint(
            CharterConstraintWriteRequest(
              title: result.$1,
              description: result.$2,
            ),
          )
        : await _cubit.updateConstraint(
            CharterConstraintWriteRequest(
              id: initial.id,
              title: result.$1,
              description: result.$2,
            ),
          );
    _showResult(response);
  }

  Future<void> _showStageDialog({CharterStageDto? initial}) async {
    final titleController = TextEditingController(text: initial?.title ?? '');
    final plannedController = TextEditingController(
      text: initial == null ? '' : initial.planned.toString(),
    );
    final actualController = TextEditingController(
      text: initial == null ? '' : initial.actual.toString(),
    );
    final result = await showDialog<(String, String, String)>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(initial == null ? AppString.add.tr() : AppString.editProject.tr()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: AppString.riskTitle.tr()),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: plannedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: AppString.planned.tr()),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: actualController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: AppString.actual.tr()),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppString.cancel.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(
              context,
              (
                titleController.text.trim(),
                plannedController.text.trim(),
                actualController.text.trim(),
              ),
            ),
            child: Text(AppString.save.tr()),
          ),
        ],
      ),
    );
    if (!mounted || result == null || result.$1.isEmpty) return;
    final planned = double.tryParse(result.$2) ?? initial?.planned ?? 0;
    final actual = double.tryParse(result.$3) ?? initial?.actual ?? 0;
    final response = initial == null
        ? await _cubit.createStage(
            CharterStageWriteRequest(
              title: result.$1,
              planned: planned,
              actual: actual,
            ),
          )
        : await _cubit.updateStage(
            CharterStageWriteRequest(
              id: initial.id,
              title: result.$1,
              planned: planned,
              actual: actual,
            ),
          );
    _showResult(response);
  }

  Future<void> _confirmDelete({
    required Future<Either<Failure, void>> Function() onDelete,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppString.confirmDelete.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppString.cancel.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppString.delete.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final response = await onDelete();
    _showResult(response, successMessage: AppString.deletedSuccessfully.tr());
  }

  Future<void> _pickAndUploadAttachment() async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    final path = result?.files.single.path;
    if (!mounted || path == null || path.isEmpty) return;
    final response = await _cubit.uploadAttachment(path);
    _showResult(response);
  }

  Future<void> _openAttachment(CharterAttachmentDto item) async {
    final raw = item.path.trim();
    if (raw.isEmpty) {
      AppFunctions.showsToast(
        AppString.noData.tr(),
        AppColor.kRedColor,
        context,
      );
      return;
    }

    final url = raw.startsWith('http')
        ? raw
        : '${ApiConstants.reefBaseUrl.replaceFirst(RegExp(r'/api/?$'), '')}${raw.startsWith('/') ? raw : '/$raw'}';

    final uri = Uri.tryParse(url);
    if (uri == null) {
      AppFunctions.showsToast(
        AppString.unKnownError.tr(),
        AppColor.kRedColor,
        context,
      );
      return;
    }

    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!mounted || launched) return;

    AppFunctions.showsToast(
      AppString.unKnownError.tr(),
      AppColor.kRedColor,
      context,
    );
  }

  void _showResult(
    Either<Failure, void> result, {
    String? successMessage,
  }) {
    result.fold(
      (failure) => AppFunctions.showsToast(
        failure.errMessage,
        AppColor.kRedColor,
        context,
      ),
      (_) => AppFunctions.showSuccessToast(
        context,
        successMessage ?? AppString.savedSuccessfully.tr(),
      ),
    );
  }

  Widget _achievementsSection(ProjectCharterState state) {
    final section = state.achievements;
    return CharterSectionTable(
      title: AppString.projectAchievements.tr(),
      totalCount: section.isLoading ? null : section.totalCount,
      isLoading: section.isLoading,
      errorMessage: section.errorMessage,
      onRetry: _cubit.loadAchievements,
      headers: [AppString.riskTitle.tr()],
      columnWidths: const [320],
      actionHeader: AppString.details.tr(),
      toolbar: _searchToolbar(
        controller: _achievementSearchController,
        onSearch: () => _cubit.searchAchievements(_achievementSearchController.text),
        onAdd: () => _showTextEntryDialog(
          title: AppString.add.tr(),
          onSave: (text) => _cubit.createAchievement(
            CharterTextWriteRequest(title: text),
          ),
        ),
      ),
      rows: section.items.map((item) => [item.title]).toList(),
      rowActions: section.items
          .map(
            (item) => _rowActions(
              onEdit: () => _showTextEntryDialog(
                title: AppString.editProject.tr(),
                initialValue: item.title,
                onSave: (text) => _cubit.updateAchievement(
                  CharterTextWriteRequest(id: item.id, title: text),
                ),
              ),
              onDelete: () => _confirmDelete(
                onDelete: () => _cubit.deleteAchievement(item.id),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _stagesSection(ProjectCharterState state) {
    final section = state.stages;
    return CharterSectionTable(
      title: AppString.projectStages.tr(),
      totalCount: section.isLoading ? null : section.totalCount,
      isLoading: section.isLoading,
      errorMessage: section.errorMessage,
      onRetry: _cubit.loadStages,
      headers: [
        AppString.riskTitle.tr(),
        AppString.planned.tr(),
        AppString.actual.tr(),
        AppString.date.tr(),
      ],
      columnWidths: const [220, 80, 80, 100],
      actionHeader: AppString.details.tr(),
      toolbar: _searchToolbar(
        controller: _stageSearchController,
        onSearch: () => _cubit.searchStages(_stageSearchController.text),
        onAdd: () => _showStageDialog(),
      ),
      rows: section.items
          .map(
            (item) => [
              item.title,
              formatCharterPercent(item.planned),
              formatCharterPercent(item.actual),
              formatCharterDate(item.date),
            ],
          )
          .toList(),
      rowActions: section.items
          .map(
            (item) => _rowActions(
              onEdit: () => _showStageDialog(initial: item),
              onDelete: () => _confirmDelete(
                onDelete: () => _cubit.deleteStage(item.id),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _constraintsSection(ProjectCharterState state) {
    final section = state.constraints;
    return CharterSectionTable(
      title: AppString.projectConstraints.tr(),
      totalCount: section.isLoading ? null : section.totalCount,
      isLoading: section.isLoading,
      errorMessage: section.errorMessage,
      onRetry: _cubit.loadConstraints,
      headers: [
        AppString.riskTitle.tr(),
        AppString.description.tr(),
      ],
      columnWidths: const [160, 260],
      actionHeader: AppString.details.tr(),
      toolbar: _searchToolbar(
        controller: _constraintSearchController,
        onSearch: () => _cubit.searchConstraints(_constraintSearchController.text),
        onAdd: () => _showConstraintDialog(),
      ),
      rows: section.items.map((item) => [item.title, item.description]).toList(),
      rowActions: section.items
          .map(
            (item) => _rowActions(
              onEdit: () => _showConstraintDialog(initial: item),
              onDelete: () => _confirmDelete(
                onDelete: () => _cubit.deleteConstraint(item.id),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _attachmentsSection(ProjectCharterState state) {
    final section = state.attachments;
    return CharterSectionTable(
      title: AppString.attachments.tr(),
      totalCount: section.isLoading ? null : section.totalCount,
      isLoading: section.isLoading,
      errorMessage: section.errorMessage,
      onRetry: _cubit.loadAttachments,
      headers: [
        AppString.fileName.tr(),
        AppString.fileSize.tr(),
        AppString.date.tr(),
        AppString.creator.tr(),
      ],
      columnWidths: const [180, 80, 100, 100],
      actionHeader: AppString.details.tr(),
      toolbar: _searchToolbar(
        controller: _attachmentSearchController,
        onSearch: () => _cubit.searchAttachments(_attachmentSearchController.text),
        onAdd: _pickAndUploadAttachment,
        addLabel: AppString.attachments.tr(),
        addIcon: Icons.upload_file_rounded,
      ),
      rows: section.items
          .map(
            (item) => [
              item.name,
              formatFileSize(item.size),
              formatCharterDate(item.date),
              (item.creator?.trim().isNotEmpty == true)
                  ? item.creator!.trim()
                  : '-',
            ],
          )
          .toList(),
      rowActions: section.items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => _openAttachment(item),
                  icon: Icon(
                    Icons.open_in_new_rounded,
                    color: context.appColors.kPrimaryColor,
                    size: 18.sp,
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(
                    onDelete: () => _cubit.deleteAttachment(item.id),
                  ),
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: context.appColors.kRedColor,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
