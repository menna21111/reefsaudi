import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';

class ExtractsTableHeaderCell extends StatelessWidget {
  final String text;
  final int flex;
  final TextAlign align;

  const ExtractsTableHeaderCell({
    super.key,
    required this.text,
    required this.flex,
    required this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyMedium?.color,
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
      ),
    );
  }
}
