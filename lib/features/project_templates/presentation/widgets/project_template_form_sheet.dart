import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../domain/models/project_template.dart';
import '../constants/project_template_request_types.dart';

class ProjectTemplateFormSheet extends StatefulWidget {
  const ProjectTemplateFormSheet({super.key, this.initial});

  final ProjectTemplate? initial;

  static Future<ProjectTemplateWriteRequest?> show(
    BuildContext context, {
    ProjectTemplate? initial,
  }) {
    return showModalBottomSheet<ProjectTemplateWriteRequest>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ProjectTemplateFormSheet(initial: initial),
    );
  }

  @override
  State<ProjectTemplateFormSheet> createState() =>
      _ProjectTemplateFormSheetState();
}

class _ProjectTemplateFormSheetState extends State<ProjectTemplateFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late int _requestType;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial?.name ?? '');
    _requestType = widget.initial?.requestType ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      ProjectTemplateWriteRequest(
        name: _nameController.text.trim(),
        requestType: _requestType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isEditing = widget.initial != null;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  (isEditing
                          ? AppString.editProjectTemplate
                          : AppString.addProjectTemplate)
                      .tr(),
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
                  controller: _nameController,
                  validator: (value) => value == null || value.trim().isEmpty
                      ? AppString.fillRequiredFields.tr()
                      : null,
                  decoration: InputDecoration(
                    labelText: '${AppString.templateName.tr()} *',
                    filled: true,
                    fillColor: colors.kInputColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                StyledPopupDropdown<int>(
                  title: AppString.requestType.tr(),
                  required: true,
                  value: _requestType,
                  items: ProjectTemplateRequestTypes.titleKeys.entries
                      .map(
                        (entry) => DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(entry.value.tr()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _requestType = value);
                    }
                  },
                ),
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
    );
  }
}
