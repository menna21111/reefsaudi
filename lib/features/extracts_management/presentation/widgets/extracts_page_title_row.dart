import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_theme_context.dart';
import 'extracts_map_button.dart';

class ExtractsPageTitleRow extends StatelessWidget {
  final VoidCallback? onMapTap;

  const ExtractsPageTitleRow({super.key, this.onMapTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(onTap: () {
          Navigator.pop(context);
        }, child: Icon(Icons.arrow_back_ios,color: colors.kFontColor,)),
        RobotoText(
          text: 'extracts_management'.tr(),
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
          color: colors.kFontColor,
          textAlign: TextAlign.right,
        ),
        ExtractsMapButton(onTap: onMapTap),
      ],
    );
  }
}
