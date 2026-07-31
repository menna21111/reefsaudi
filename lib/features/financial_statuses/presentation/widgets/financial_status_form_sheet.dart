import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';

class FinancialStatusFormResult {
  const FinancialStatusFormResult({
    required this.title,
    required this.description,
    required this.isFinal,
  });

  final String title;
  final String description;
  final bool isFinal;
}

class FinancialStatusFormSheet extends StatefulWidget {
  const FinancialStatusFormSheet({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.initialIsFinal = false,
  });

  final String? initialTitle;
  final String? initialDescription;
  final bool initialIsFinal;

  bool get isEditing => initialTitle != null;

  static Future<FinancialStatusFormResult?> show(
    BuildContext context, {
    String? initialTitle,
    String? initialDescription,
    bool initialIsFinal = false,
  }) {
    return showModalBottomSheet<FinancialStatusFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FinancialStatusFormSheet(
        initialTitle: initialTitle,
        initialDescription: initialDescription,
        initialIsFinal: initialIsFinal,
      ),
    );
  }

  @override
  State<FinancialStatusFormSheet> createState() => _FinancialStatusFormSheetState();
}

class _FinancialStatusFormSheetState extends State<FinancialStatusFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late bool _isFinal;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
    _isFinal = widget.initialIsFinal;
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
      FinancialStatusFormResult(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        isFinal: _isFinal,
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
                    ? AppString.editFinancialStatus.tr()
                    : AppString.addFinancialStatus.tr(),
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
              SizedBox(height: 12.h),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: RobotoText(
                  text: AppString.isFinal.tr(),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.kFontColor,
                  textAlign: TextAlign.start,
                ),
                value: _isFinal,
                activeColor: colors.kPrimaryColor,
                onChanged: (value) => setState(() => _isFinal = value),
              ),
              SizedBox(height: 12.h),
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
