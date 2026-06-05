import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class LoginTextFieldWidget extends StatelessWidget {
  const LoginTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputTheme = theme.inputDecorationTheme;
    final secondaryText =
        theme.textTheme.bodyMedium?.color ?? AppColor.kGrayTextColor;
    final fillColor = inputTheme.fillColor ?? colorScheme.surface;
    final borderColor = inputTheme.enabledBorder is OutlineInputBorder
        ? (inputTheme.enabledBorder! as OutlineInputBorder).borderSide.color
        : theme.dividerColor;

    return Column(
      children: [
        Row(
          children: [
            RobotoText(
              text: label,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: secondaryText,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: colorScheme.onSurface,
          ),
          cursorColor: colorScheme.primary,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: 'Almarai',
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: secondaryText.withValues(alpha: 0.5),
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(left: 12.w, right: 8.w),
                    child: Icon(
                      prefixIcon,
                      color: secondaryText.withValues(alpha: 0.6),
                      size: 20.sp,
                    ),
                  )
                : null,
            prefixIconConstraints: BoxConstraints(
              minWidth: 40.w,
              minHeight: 20.h,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: fillColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(color: AppColor.kRedColor, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: const BorderSide(
                color: AppColor.kRedColor,
                width: 1.5,
              ),
            ),
            errorStyle: TextStyle(
              fontFamily: 'Almarai',
              fontSize: 11.sp,
              color: AppColor.kRedColor,
            ),
          ),
        ),
      ],
    );
  }
}
