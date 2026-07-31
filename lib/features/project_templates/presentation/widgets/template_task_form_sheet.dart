import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/multi_select_popup_dropdown.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../domain/models/project_template.dart';
import '../constants/project_template_request_types.dart';

class TemplateTaskFormResult {
  const TemplateTaskFormResult({
    required this.title,
    required this.assignToType,
    required this.dependsOnTaskIds,
  });

  final String title;
  final int assignToType;
  final Set<String> dependsOnTaskIds;
}

class TemplateTaskFormSheet extends StatefulWidget {
  const TemplateTaskFormSheet({super.key, required this.existingTasks});

  /// Tasks already in the plan, selectable as dependencies.
  final List<TemplateGanttTask> existingTasks;

  static Future<TemplateTaskFormResult?> show(
    BuildContext context, {
    required List<TemplateGanttTask> existingTasks,
  }) {
    return showModalBottomSheet<TemplateTaskFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TemplateTaskFormSheet(existingTasks: existingTasks),
    );
  }

  @override
  State<TemplateTaskFormSheet> createState() => _TemplateTaskFormSheetState();
}

class _TemplateTaskFormSheetState extends State<TemplateTaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  int _assignToType = 0;
  Set<String> _dependsOn = {};

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      TemplateTaskFormResult(
        title: _titleController.text.trim(),
        assignToType: _assignToType,
        dependsOnTaskIds: _dependsOn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: colors.kBgColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: SafeArea(
          top: false,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppString.addTask.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colors.kFontColor,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _titleController,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? AppString.fillRequiredFields.tr()
                        : null,
                    decoration: InputDecoration(
                      labelText: '${AppString.taskTitleLabel.tr()} *',
                      filled: true,
                      fillColor: colors.kInputColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  StyledPopupDropdown<int>(
                    title: AppString.assignTypeLabel.tr(),
                    value: _assignToType,
                    items: TemplateTaskAssignTypes.titleKeys.entries
                        .map(
                          (entry) => DropdownMenuItem<int>(
                            value: entry.key,
                            child: Text(entry.value.tr()),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _assignToType = value);
                      }
                    },
                  ),
                  if (widget.existingTasks.isNotEmpty) ...[
                    SizedBox(height: 14.h),
                    MultiSelectPopupDropdown<String>(
                      title: AppString.dependsOnTasks.tr(),
                      hintText: AppString.selectPlaceholder.tr(),
                      selected: _dependsOn,
                      items: widget.existingTasks
                          .map(
                            (task) => MultiSelectOption<String>(
                              value: task.id,
                              label: task.title,
                            ),
                          )
                          .toList(),
                      onSelectionChanged: (selected) {
                        setState(() => _dependsOn = selected);
                      },
                    ),
                  ],
                  SizedBox(height: 20.h),
                  ButtonCustom(
                    text: AppString.save.tr(),
                    buttoncolor: colors.kPrimaryColor,
                    onTap: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
