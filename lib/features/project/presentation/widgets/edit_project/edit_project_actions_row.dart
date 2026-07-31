import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/widgets/button_custom.dart';

class EditProjectActionsRow extends StatelessWidget {
  const EditProjectActionsRow({
    super.key,
    required this.isSubmitting,
    required this.onSave,
  });

  final bool isSubmitting;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: colors.kBorderColor, width: 1),
            ),
            child: Text(AppString.cancel.tr()),
           
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: isSubmitting
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: colors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : ButtonCustom(
                  text: AppString.saveChanges.tr(),
                  onTap: onSave,
                ),
        ),
      ],
    );
  }
}
