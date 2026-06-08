import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';

class EditTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const EditTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RobotoText(
          text: label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.kWhiteColor,
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          style: TextStyle(
            color: AppColor.kWhiteColor,
            fontSize: 14.sp,
            fontFamily: 'Almarai',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColor.kSurfaceColor,
            suffixIcon: Icon(
              icon,
              color: AppColor.kGrayTextColor,
              size: 20.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: AppColor.kBorderColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColor.kPrimaryColor),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }
}
