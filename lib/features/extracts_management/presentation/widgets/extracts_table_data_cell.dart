import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsTableDataCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;
  final Color? color;
  final FontWeight? fontWeight;

  const ExtractsTableDataCell({
    super.key,
    required this.text,
    required this.flex,
    required this.align,
    this.color,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color ?? Theme.of(context).textTheme.displayLarge?.color,
          fontSize: 10.sp,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
