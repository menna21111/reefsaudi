import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_color.dart';

class DividerApp extends StatelessWidget {
  const DividerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1.h,
      color: AppColor.kBackgroundColor,
      indent: 16.w,
      endIndent: 16.w,
    );
  }
}
