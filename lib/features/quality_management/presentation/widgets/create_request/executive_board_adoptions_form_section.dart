import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import 'quality_file_picker_field.dart';

class ExecutiveBoardAdoptionFields {
  ExecutiveBoardAdoptionFields()
      : plateNumberController = TextEditingController(),
        reviewNumberController = TextEditingController(),
        descriptionController = TextEditingController();

  final TextEditingController plateNumberController;
  final TextEditingController reviewNumberController;
  final TextEditingController descriptionController;
  String? attachmentPath;

  void dispose() {
    plateNumberController.dispose();
    reviewNumberController.dispose();
    descriptionController.dispose();
  }
}

class ExecutiveBoardAdoptionsFormSection extends StatelessWidget {
  const ExecutiveBoardAdoptionsFormSection({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onDelete,
    required this.onAttachmentPicked,
    required this.inputDecoration,
  });

  final List<ExecutiveBoardAdoptionFields> items;
  final VoidCallback onAdd;
  final ValueChanged<int> onDelete;
  final void Function(int index, String path) onAttachmentPicked;
  final InputDecoration Function(String label) inputDecoration;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppString.executiveBoardAdoptionDetails.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 14.h),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _ExecutiveBoardCard(
              index: index,
              item: item,
              canDelete: items.length > 1,
              onDelete: () => onDelete(index),
              onAttachmentPicked: (path) => onAttachmentPicked(index, path),
              inputDecoration: inputDecoration,
            ),
          );
        }),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OutlinedButton.icon(
            onPressed: onAdd,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.45),
              ),
              foregroundColor: colors.kPrimaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: Icon(Icons.add_rounded, color: colors.kPrimaryColor),
            label: Text(
              AppString.addExecutiveBoard.tr(),
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ExecutiveBoardCard extends StatelessWidget {
  const _ExecutiveBoardCard({
    required this.index,
    required this.item,
    required this.canDelete,
    required this.onDelete,
    required this.onAttachmentPicked,
    required this.inputDecoration,
  });

  final int index;
  final ExecutiveBoardAdoptionFields item;
  final bool canDelete;
  final VoidCallback onDelete;
  final ValueChanged<String> onAttachmentPicked;
  final InputDecoration Function(String label) inputDecoration;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${AppString.executiveBoardIndex.tr()} #${index + 1}',
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Almarai',
                  ),
                ),
              ),
              if (canDelete)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete_outline_rounded, color: colors.kRedColor),
                ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: item.plateNumberController,
                  textAlign: FormLayout.alignOf(context),
                  textDirection: FormLayout.directionOf(context),
                  decoration: inputDecoration(AppString.plateNumber.tr()),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextFormField(
                  controller: item.reviewNumberController,
                  textAlign: FormLayout.alignOf(context),
                  textDirection: FormLayout.directionOf(context),
                  decoration: inputDecoration(AppString.documentReviewNumber.tr()),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: item.descriptionController,
            minLines: 3,
            maxLines: 5,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            decoration: inputDecoration(AppString.details.tr()),
          ),
          SizedBox(height: 12.h),
          QualityFilePickerField(
            label: AppString.executiveBoardAttachments.tr(),
            filePath: item.attachmentPath,
            onPicked: onAttachmentPicked,
            onClear: item.attachmentPath == null
                ? null
                : () => onAttachmentPicked(''),
          ),
        ],
      ),
    );
  }
}
