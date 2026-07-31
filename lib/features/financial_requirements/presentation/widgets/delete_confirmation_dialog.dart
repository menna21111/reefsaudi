import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({
    super.key,
    this.titleKey = AppString.confirmDelete,
    this.messageKey = AppString.confirmDeleteFinancialRequirement,
  });

  final String titleKey;
  final String messageKey;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.kSurfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: RobotoText(
        text: titleKey.tr(),
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: AppColor.kWhiteColor,
        textAlign: TextAlign.start,
      ),
      content: RobotoText(
        text: messageKey.tr(),
        fontSize: 14.sp,
        color: AppColor.kGrayTextColor,
        textAlign: TextAlign.start,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: RobotoText(
            text: AppString.cancel.tr(),
            fontSize: 14.sp,
            color: AppColor.kGrayTextColor,
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: RobotoText(
            text: AppString.delete.tr(),
            fontSize: 14.sp,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
