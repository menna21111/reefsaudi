import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../../project/presentation/widgets/edit_project/edit_project_date_field.dart';
import '../../domain/models/project_stage_assignment.dart';

class ProjectStageFormResult {
  const ProjectStageFormResult({
    required this.projectId,
    required this.projectTitle,
    required this.pStepId,
    required this.pStepTitle,
    required this.assignedDate,
  });

  final String projectId;
  final String projectTitle;
  final String pStepId;
  final String pStepTitle;
  final DateTime assignedDate;
}

class ProjectStageFormSheet extends StatefulWidget {
  const ProjectStageFormSheet({
    super.key,
    required this.loadProjects,
    required this.loadSteps,
    this.initial,
  });

  final Future<List<ProjectStageOption>> Function() loadProjects;
  final Future<List<ProjectStageOption>> Function() loadSteps;
  final ProjectStageAssignment? initial;

  bool get isEditing => initial != null;

  static Future<ProjectStageFormResult?> show(
    BuildContext context, {
    required Future<List<ProjectStageOption>> Function() loadProjects,
    required Future<List<ProjectStageOption>> Function() loadSteps,
    ProjectStageAssignment? initial,
  }) {
    return showModalBottomSheet<ProjectStageFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProjectStageFormSheet(
        loadProjects: loadProjects,
        loadSteps: loadSteps,
        initial: initial,
      ),
    );
  }

  @override
  State<ProjectStageFormSheet> createState() => _ProjectStageFormSheetState();
}

class _ProjectStageFormSheetState extends State<ProjectStageFormSheet> {
  String? _projectId;
  String? _projectTitle;
  String? _pStepId;
  String? _pStepTitle;
  DateTime? _assignedDate;
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _projectId = initial.projectId;
      _projectTitle = initial.projectTitle;
      _pStepId = initial.pStepId;
      _pStepTitle = initial.pStepTitle;
      _assignedDate = DateTime.tryParse(initial.assignedDate);
    }
  }

  Future<List<DropdownMenuItem<String>>> _mapOptions(
    Future<List<ProjectStageOption>> Function() loader,
  ) async {
    final items = await loader();
    return items
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: Text(item.title),
          ),
        )
        .toList();
  }

  void _submit() {
    final isValid = _projectId != null &&
        _pStepId != null &&
        _assignedDate != null &&
        (_projectTitle?.isNotEmpty ?? false) &&
        (_pStepTitle?.isNotEmpty ?? false);

    if (!isValid) {
      setState(() => _showValidation = true);
      return;
    }

    Navigator.pop(
      context,
      ProjectStageFormResult(
        projectId: _projectId!,
        projectTitle: _projectTitle!,
        pStepId: _pStepId!,
        pStepTitle: _pStepTitle!,
        assignedDate: _assignedDate!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RobotoText(
                text: widget.isEditing
                    ? AppString.editProjectStage.tr()
                    : AppString.addProjectStage.tr(),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colors.kFontColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 18.h),
              LazyStyledPopupDropdown(
                title: AppString.projectName.tr(),
                valueId: _projectId,
                valueLabel: _projectTitle,
                required: true,
                showValidationError: _showValidation && _projectId == null,
                loadItems: () => _mapOptions(widget.loadProjects),
                onSelected: (id, label) {
                  setState(() {
                    _projectId = id;
                    _projectTitle = label;
                  });
                },
              ),
              SizedBox(height: 14.h),
              LazyStyledPopupDropdown(
                title: AppString.projectPhaseLabel.tr(),
                valueId: _pStepId,
                valueLabel: _pStepTitle,
                required: true,
                showValidationError: _showValidation && _pStepId == null,
                loadItems: () => _mapOptions(widget.loadSteps),
                onSelected: (id, label) {
                  setState(() {
                    _pStepId = id;
                    _pStepTitle = label;
                  });
                },
              ),
              SizedBox(height: 14.h),
              EditProjectDateField(
                label: AppString.phaseJoinDate.tr(),
                value: _assignedDate,
                required: true,
                showValidationError: _showValidation && _assignedDate == null,
                onPicked: (date) => setState(() => _assignedDate = date),
              ),
              SizedBox(height: 20.h),
              ButtonCustom(
                text: widget.isEditing ? AppString.save.tr() : AppString.add.tr(),
                buttoncolor: colors.kPrimaryColor,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
