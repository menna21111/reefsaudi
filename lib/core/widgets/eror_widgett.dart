import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import '../blocs/theme_bloc.dart';
import '../utils/app_color.dart';
import '../utils/app_font.dart';
import '../utils/app_icon.dart';

class ErorWidgett extends StatelessWidget {
  const ErorWidgett({
    super.key,
    required this.message,
    required this.onTryAgain,
    required this.height,
    this.heightimage,
  });
  final String message;
  final double height;
  final double? heightimage;

  final Function() onTryAgain;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            state.isDark
                ? Image.asset(
                    'assets/images/Error 2.png',
                    height: heightimage ?? 150.h,
                    color: AppColor.kGoldColor,
                  )
                : Image.asset(
                    "AppIcon.erorlightheme",
                    height: heightimage ?? 150,
                    width: 150,
                  ),
            const SizedBox(height: 16),
            LamaSansText(
              text: message,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: state.appColor.kBlackColor,
            ),
            GestureDetector(
              onTap: onTryAgain,
              child: Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: state.isDark
                      ? AppColor.kGoldColor
                      : AppColor.kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: LamaSansText(
                  text: 'حاول مجددا',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: state.isDark ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
