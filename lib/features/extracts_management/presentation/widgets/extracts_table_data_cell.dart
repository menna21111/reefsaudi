import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_theme_context.dart';

class ExtractsTableDataCell extends StatelessWidget {
  final String text;
  final double width;
  final TextAlign align;
  final Color? color;
  final FontWeight? fontWeight;
  final int maxLines;

  const ExtractsTableDataCell({
    super.key,
    required this.text,
    required this.width,
    required this.align,
    this.color,
    this.fontWeight,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: align,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color ?? colors.kFontColor,
          fontSize: 10.sp,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
