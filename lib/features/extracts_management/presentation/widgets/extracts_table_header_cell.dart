import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class ExtractsTableHeaderCell extends StatelessWidget {
  final String text;
  final double width;
  final TextAlign align;

  const ExtractsTableHeaderCell({
    super.key,
    required this.text,
    required this.width,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: colors.kGrayColor,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
