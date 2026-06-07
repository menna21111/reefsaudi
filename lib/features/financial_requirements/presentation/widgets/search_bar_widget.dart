import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.start,
      style: TextStyle(
        color: AppColor.kWhiteColor,
        fontSize: 13.sp,
        fontFamily: 'Almarai',
      ),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: AppString.searchProjectPlaceholder.tr(),
        hintStyle: TextStyle(
          color: AppColor.kGrayTextColor,
          fontSize: 13.sp,
          fontFamily: 'Almarai',
        ),
        filled: true,
        fillColor: AppColor.kSurfaceColor,
        prefixIcon: Icon(
          Icons.search_rounded,
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
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      ),
    );
  }
}
