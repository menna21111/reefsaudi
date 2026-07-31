import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/widgets/button_custom.dart';

class CreateQualityFormActions extends StatelessWidget {
  const CreateQualityFormActions({
    super.key,
    required this.isSubmitting,
    required this.onCancel,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isSubmitting ? null : onCancel,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: colors.kInputColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: colors.kBorderColor, width: 1),
              ),
              child: Text(
                AppString.cancel.tr(),
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.kFontColor,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: isSubmitting
              ? Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    color: colors.kPrimaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: colors.kPrimaryColor, width: 1),
                  ),
                  child: SizedBox(
                    height: 22.h,
                    width: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : ButtonCustom(
                  text: AppString.saveChanges.tr(),
                  onTap: onSubmit,
                ),
        ),
      ],
    );
  }
}
