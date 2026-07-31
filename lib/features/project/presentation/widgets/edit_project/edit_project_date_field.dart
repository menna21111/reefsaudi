import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';

class EditProjectDateField extends StatelessWidget {
  const EditProjectDateField({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
    this.onPicked,
    this.required = false,
    this.showValidationError = false,
  });

  final String label;
  final DateTime? value;
  final VoidCallback? onTap;
  final ValueChanged<DateTime>? onPicked;
  final bool required;
  final bool showValidationError;

  Future<void> _pickDate(BuildContext context, {ValueChanged<DateTime>? onChanged}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 15),
    );
    if (picked == null) return;
    onChanged?.call(picked);
    onPicked?.call(picked);
  }

  @override
  Widget build(BuildContext context) {
    final externalError = showValidationError && value == null;

    if (!required) {
      return _DateFieldBody(
        label: label,
        value: value,
        onTap: onTap ?? () => _pickDate(context),
        hasError: externalError,
      );
    }

    return FormField<DateTime>(
      initialValue: value,
      autovalidateMode: showValidationError
          ? AutovalidateMode.always
          : AutovalidateMode.disabled,
      validator: (v) => v == null ? ' ' : null,
      builder: (field) {
        final hasError = externalError ||
            (field.hasError && (field.errorText?.isNotEmpty ?? false));
        return _DateFieldBody(
          label: label,
          value: field.value ?? value,
          hasError: hasError,
          onTap: () => _pickDate(context, onChanged: field.didChange),
        );
      },
    );
  }
}

class _DateFieldBody extends StatelessWidget {
  const _DateFieldBody({
    required this.label,
    required this.value,
    required this.onTap,
    this.hasError = false,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final formatted =
        value == null ? 'dd/mm/yyyy' : DateFormat('dd/MM/yyyy').format(value!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          // textAlign: FormLayout.alignOf(context),
          // textDirection: FormLayout.directionOf(context),
          style: TextStyle(
            color: hasError ? colors.kRedColor : colors.kFontColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: hasError
                    ? colors.kRedColor
                    : colors.kBorderColor.withValues(alpha: 0.45),
                width: hasError ? 1.5 : 1,
              ),
            ),
            child: Row(
              textDirection: FormLayout.directionOf(context),
              children: [
                Expanded(
                  child: Text(
                    formatted,
                    textAlign: FormLayout.alignOf(context),
                    textDirection: FormLayout.directionOf(context),
                    style: TextStyle(
                      color: value == null
                          ? colors.kGrayColor
                          : colors.kFontColor,
                      fontSize: 14.sp,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_outlined, color: colors.kPrimaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
