import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../domain/models/project_template.dart';
import '../../domain/repositories/project_templates_repository.dart';
import '../constants/project_template_request_types.dart';
import '../widgets/template_task_form_sheet.dart';

class ProjectTemplatePlanScreen extends StatefulWidget {
  const ProjectTemplatePlanScreen({super.key, required this.template});

  final ProjectTemplate template;

  @override
  State<ProjectTemplatePlanScreen> createState() =>
      _ProjectTemplatePlanScreenState();
}

class _ProjectTemplatePlanScreenState extends State<ProjectTemplatePlanScreen> {
  final _repository = sl<ProjectTemplatesRepository>();
  static const _uuid = Uuid();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  List<TemplateGanttTask> _tasks = [];
  List<TemplateGanttDependency> _dependencies = [];
  List<Map<String, dynamic>> _resources = [];
  List<Map<String, dynamic>> _resourceAssignments = [];

  @override
  void initState() {
    super.initState();
    _loadGantt();
  }

  Future<void> _loadGantt() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _repository.getTemplateGantt(widget.template.id);
    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _isLoading = false;
        _errorMessage = failure.errMessage;
      }),
      (data) => setState(() {
        _isLoading = false;
        _tasks = _orderTasks(data.tasks, data.dependencies);
        _dependencies = data.dependencies;
        _resources = data.resources;
        _resourceAssignments = data.resourceAssignments;
      }),
    );
  }

  /// Orders tasks by their dependency chain (predecessor before successor),
  /// falling back to sortIndex for tasks outside the chain.
  List<TemplateGanttTask> _orderTasks(
    List<TemplateGanttTask> tasks,
    List<TemplateGanttDependency> dependencies,
  ) {
    final byId = {for (final task in tasks) task.id: task};
    final successorsOf = <String, List<String>>{};
    final hasPredecessor = <String>{};

    for (final dependency in dependencies) {
      if (!byId.containsKey(dependency.predecessorId) ||
          !byId.containsKey(dependency.successorId)) {
        continue;
      }
      successorsOf
          .putIfAbsent(dependency.predecessorId, () => [])
          .add(dependency.successorId);
      hasPredecessor.add(dependency.successorId);
    }

    final roots =
        tasks.where((task) => !hasPredecessor.contains(task.id)).toList()
          ..sort((a, b) => a.sortIndex.compareTo(b.sortIndex));

    final ordered = <TemplateGanttTask>[];
    final visited = <String>{};

    void visit(String id) {
      if (!visited.add(id)) return;
      final task = byId[id];
      if (task == null) return;
      ordered.add(task);
      final next = successorsOf[id] ?? const [];
      for (final successorId in next) {
        visit(successorId);
      }
    }

    for (final root in roots) {
      visit(root.id);
    }

    for (final task in tasks) {
      if (!visited.contains(task.id)) ordered.add(task);
    }

    return ordered;
  }

  Future<void> _addTask() async {
    final result = await TemplateTaskFormSheet.show(
      context,
      existingTasks: _tasks,
    );
    if (result == null || !mounted) return;

    final newTask = TemplateGanttTask(
      id: _uuid.v4(),
      title: result.title,
      sortIndex: _tasks.length + 1,
      assignToType: result.assignToType,
      isApprovalAction: false,
      isLocal: true,
      raw: {
        'id': '',
        'title': result.title,
        'assignToType': result.assignToType,
        'isApprovalIdAction': false,
        'isSaved': false,
        'progress': 0,
        'isSummary': false,
      },
    );

    setState(() {
      _dependencies = [
        ..._dependencies,
        for (final dependsOnId in result.dependsOnTaskIds)
          TemplateGanttDependency(
            id: _uuid.v4(),
            predecessorId: dependsOnId,
            successorId: newTask.id,
          ),
      ];
      // Patch raw id after creation.
      final taskWithId = newTask.copyWith(
        raw: {...newTask.raw, 'id': newTask.id},
      );
      _tasks = _orderTasks([..._tasks, taskWithId], _dependencies);
    });
  }

  Future<void> _save(TemplateGanttAction action) async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    final ordered = _tasks;
    final payload = TemplateGanttData(
      tasks: [
        for (var i = 0; i < ordered.length; i++)
          ordered[i].copyWith(sortIndex: i + 1),
      ],
      dependencies: _dependencies,
      resources: _resources,
      resourceAssignments: _resourceAssignments,
    );

    final result = await _repository.saveTemplateGantt(
      templateId: widget.template.id,
      data: payload,
      action: action,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.errMessage.tr())),
        );
      },
      (_) async {
        final message = action == TemplateGanttAction.saveWithPublish
            ? AppString.ganttSavedSuccessfully.tr()
            : AppString.ganttPublishedSuccessfully.tr();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        await _loadGantt();
        if (mounted) setState(() => _isSaving = false);
      },
    );
  }

  String _dependsOnLabel(TemplateGanttTask task) {
    final titles = _dependencies
        .where((dependency) => dependency.successorId == task.id)
        .map(
          (dependency) => _tasks
              .where((item) => item.id == dependency.predecessorId)
              .map((item) => item.title)
              .join(),
        )
        .where((title) => title.isNotEmpty)
        .toList();
    return titles.join('، ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final showActions = !_isLoading && _errorMessage == null && _tasks.isNotEmpty;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.template.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
      floatingActionButton: _isLoading || _errorMessage != null
          ? null
          : FloatingActionButton.extended(
              backgroundColor: colors.kPrimaryColor,
              onPressed: _isSaving ? null : _addTask,
              icon: Icon(Icons.add_rounded, color: colors.kWhiteColor),
              label: Text(
                AppString.addTask.tr(),
                style: TextStyle(
                  color: colors.kWhiteColor,
                  fontFamily: 'Almarai',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      bottomNavigationBar: showActions
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSaving
                            ? null
                            : () => _save(TemplateGanttAction.publish),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.kPrimaryColor,
                          side: BorderSide(color: colors.kPrimaryColor),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          AppString.publishPlan.tr(),
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: _isSaving
                            ? null
                            : () =>
                                _save(TemplateGanttAction.saveWithPublish),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.kPrimaryColor,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          AppString.saveWithPublish.tr(),
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          _buildBody(colors),
          if (_isSaving)
            Positioned.fill(
              child: ColoredBox(
                color: colors.kBgColor.withValues(alpha: 0.45),
                child: Center(
                  child: CircularProgressIndicator(color: colors.kPrimaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBody(AppColorScheme colors) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(color: colors.kPrimaryColor),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessage!.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.kRedColor, fontSize: 14.sp),
              ),
              SizedBox(height: 16.h),
              FilledButton(
                onPressed: _loadGantt,
                child: Text(AppString.retry.tr()),
              ),
            ],
          ),
        ),
      );
    }

    if (_tasks.isEmpty) {
      return Center(
        child: Text(
          AppString.noTasksInPlan.tr(),
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 14.sp,
            fontFamily: 'Almarai',
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: colors.kPrimaryColor,
      onRefresh: _loadGantt,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 96.h),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return _TaskNode(
            order: index + 1,
            task: task,
            dependsOn: _dependsOnLabel(task),
            isLast: index == _tasks.length - 1,
          );
        },
      ),
    );
  }
}

class _TaskNode extends StatelessWidget {
  const _TaskNode({
    required this.order,
    required this.task,
    required this.dependsOn,
    required this.isLast,
  });

  final int order;
  final TemplateGanttTask task;
  final String dependsOn;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: task.isLocal
                      ? colors.kGrayColor.withValues(alpha: 0.2)
                      : colors.kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$order',
                  style: TextStyle(
                    color: task.isLocal
                        ? colors.kFontColor
                        : colors.kWhiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: colors.kPrimaryColor.withValues(alpha: 0.35),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: colors.kInputColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: task.isLocal
                      ? colors.kGrayColor.withValues(alpha: 0.5)
                      : colors.kPrimaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 6.h,
                    children: [
                      _Chip(
                        icon: Icons.person_outline_rounded,
                        label: TemplateTaskAssignTypes.titleKey(
                          task.assignToType,
                        ).tr(),
                        color: colors.kPrimaryColor,
                      ),
                      if (task.isApprovalAction)
                        _Chip(
                          icon: Icons.verified_outlined,
                          label: AppString.approvalTask.tr(),
                          color: const Color(0xFFF5A623),
                        ),
                      if (task.isLocal)
                        _Chip(
                          icon: Icons.cloud_off_rounded,
                          label: AppString.taskNotSavedNote.tr(),
                          color: colors.kGrayColor,
                        ),
                    ],
                  ),
                  if (dependsOn.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.link_rounded,
                          size: 15.sp,
                          color: colors.kGrayColor,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            '${AppString.dependsOnTasks.tr()}: $dependsOn',
                            style: TextStyle(
                              color: colors.kGrayColor,
                              fontSize: 12.sp,
                              fontFamily: 'Almarai',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 5.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
