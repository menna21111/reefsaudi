
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
      child: Container(     width: double.infinity,
        alignment: Alignment.center,
    
            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
            decoration: BoxDecoration(

              borderRadius: BorderRadius.circular(8.r),
            
   
      
          color: buttoncolor ?? AppColor.kPrimaryColor,
  
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
                fontSize: 14,
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
