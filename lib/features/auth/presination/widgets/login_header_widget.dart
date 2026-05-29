import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_image.dart';
import '../../../../core/utils/app_string.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Green glow background effect
          Positioned(
            top: 0,
            child: Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                // gradient: RadialGradient(
                //   colors: [
                //     AppColor.kPrimaryColor.withOpacity(0.15),
                //     AppColor.kPrimaryColor.withOpacity(0.05),
                //     Colors.transparent,
                //   ],
                //   stops: const [0.0, 0.5, 1.0],
                // ),
              ),
            ),
          ),
          // Content
          Column(
            children: [
              SizedBox(height: 20.h),
              // App Logo
              Center(
                child: SvgPicture.asset(
                  AppImage.applogo,
                  width: 44.w,
                  height: 44.w,
                ),
              ),
              SizedBox(height: 16.h),
              // App name
              RobotoText(
                text: AppString.saudiReef.tr(),

                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.kSecondaryColor,
              ),
              SizedBox(height: 6.h),
              // Subtitle
              RobotoText(
                text: AppString.excellenceInManagingProjects.tr(),
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.kGrayTextColor,
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ],
      ),
    );
  }
}
