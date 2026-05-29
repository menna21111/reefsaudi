
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/app_image.dart';

class Applogo extends StatelessWidget {
  const Applogo({super.key, this.height, this.width});
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      AppImage.applogo,
      height: height ?? 96.h,
      width: width ?? 80.w,
    );
  }
}
