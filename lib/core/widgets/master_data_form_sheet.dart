import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';

class MasterDataFormSheet extends StatefulWidget {
  const MasterDataFormSheet({
    super.key,
    required this.addTitleKey,
    required this.editTitleKey,
    this.initialTitle,
    this.initialDescription,
  });

  final String addTitleKey;
  final String editTitleKey;
  final String? initialTitle;
  final String? initialDescription;

  bool get isEditing => initialTitle != null;

  static Future<MasterDataFormResult?> show(
    BuildContext context, {
    required String addTitleKey,
    required String editTitleKey,
    String? initialTitle,
    String? initialDescription,
  }) {
    return showModalBottomSheet<MasterDataFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MasterDataFormSheet(
        addTitleKey: addTitleKey,
        editTitleKey: editTitleKey,
        initialTitle: initialTitle,
        initialDescription: initialDescription,
      ),
    );
  }

  @override
  State<MasterDataFormSheet> createState() => _MasterDataFormSheetState();
}

class MasterDataFormResult {
  const MasterDataFormResult({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

class _MasterDataFormSheetState extends State<MasterDataFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      MasterDataFormResult(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
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
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RobotoText(
                text: widget.isEditing
                    ? widget.editTitleKey.tr()
                    : widget.addTitleKey.tr(),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colors.kFontColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 18.h),
              _Field(
                controller: _titleController,
                label: AppString.projectTitleLabel.tr(),
              ),
              SizedBox(height: 14.h),
              _Field(
                controller: _descriptionController,
                label: AppString.description.tr(),
                required: false,
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

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    this.required = true,
  });

  final TextEditingController controller;
  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RobotoText(
          text: label,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          color: colors.kGrayColor,
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppString.fillRequiredFields.tr();
                  }
                  return null;
                }
              : null,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 14.sp,
            fontFamily: 'Almarai',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.kBgColor,
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: colors.kPrimaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
        ),
      ],
    );
  }
}
