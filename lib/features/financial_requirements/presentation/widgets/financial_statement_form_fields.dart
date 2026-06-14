import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class FinancialStatementTextField extends StatelessWidget {
  const FinancialStatementTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.required = false,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool required;
  final int maxLines;

  static double get fieldMinHeight => 52.h;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textAlign: TextAlign.start,
      validator: required
          ? (value) => value == null || value.trim().isEmpty ? ' ' : null
          : null,
      style: TextStyle(
        color: colors.kFontColor,
        fontSize: 15.sp,
        fontFamily: 'Almarai',
      ),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: colors.kInputColor,
        labelStyle: TextStyle(
          color: colors.kGrayColor,
          fontSize: 15.sp,
          fontFamily: 'Almarai',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.45)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: colors.kPrimaryColor, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        constraints: BoxConstraints(minHeight: fieldMinHeight),
      ),
    );
  }
}

class FinancialStatementReadonlyField extends StatelessWidget {
  const FinancialStatementReadonlyField({
    super.key,
    required this.label,
    required this.controller,
    this.visible = true,
  });

  final String label;
  final TextEditingController controller;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: colors.kFontColor,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 10.h),
        TextField(
          controller: controller,
          readOnly: true,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: colors.kGrayColor,
            fontSize: 15.sp,
            fontFamily: 'Almarai',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.kBgColor.withValues(alpha: 0.4),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.35),
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            constraints: BoxConstraints(
              minHeight: FinancialStatementTextField.fieldMinHeight,
            ),
          ),
        ),
      ],
    );
  }
}

class FinancialStatementDateField extends StatelessWidget {
  const FinancialStatementDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.isPlaceholder = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: colors.kFontColor,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              minHeight: FinancialStatementTextField.fieldMinHeight,
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: colors.kBorderColor.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: colors.kGrayColor,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: isPlaceholder ? colors.kGrayColor : colors.kFontColor,
                      fontSize: 15.sp,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
