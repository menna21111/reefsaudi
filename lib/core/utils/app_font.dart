import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RobotoText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double fontSize;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextDecoration? textDecoration;

  const RobotoText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.textOverflow,
    this.maxLines,
    this.textDecoration,
    required this.fontSize,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: textOverflow,
      maxLines: maxLines,
      softWrap: true,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        fontFamily: 'Almarai',
        decorationColor: color,
        color: color ?? Colors.black,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize.sp,
        decoration: textDecoration ?? TextDecoration.none,
      ),
    );
  }
}

class LamaSansText extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final int fontSize;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final TextDecoration? textDecoration;

  const LamaSansText({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.textOverflow,
    this.maxLines,
    this.textDecoration,
    required this.fontSize,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(),
      overflow: textOverflow,
      maxLines: maxLines,
      softWrap: true,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        fontFamily: 'LamaSans',
        color: color ?? Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontSize: fontSize.sp,
        decoration: textDecoration ?? TextDecoration.none,
        decorationColor: color ?? Theme.of(context).textTheme.bodyLarge?.color,
      ),
    );
  }
}
