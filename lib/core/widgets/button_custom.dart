
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_color.dart';
import '../utils/app_font.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({
    super.key,
    required this.text,
    required this.onTap,
    this.buttoncolor,
    this.iconaimge,
  });
  final String text;
  final String? iconaimge;
  final VoidCallback onTap;
  final Color? buttoncolor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,

        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: buttoncolor ?? AppColor.kPrimaryColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color:
                  (buttoncolor == null || buttoncolor == AppColor.kPrimaryColor)
                  ? AppColor.kPrimaryColor.withOpacity(0.3)
                  : AppColor.kWhiteColor.withOpacity(0.5),
              blurRadius: 16,
              offset: const Offset(4, 8),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RobotoText(
                text: text,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.kWhiteColor,
              ),
              iconaimge == null
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: SvgPicture.asset(
                        iconaimge!,
                        color: AppColor.kWhiteColor,
                        height: 12.sp,
                        width: 16.w,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
