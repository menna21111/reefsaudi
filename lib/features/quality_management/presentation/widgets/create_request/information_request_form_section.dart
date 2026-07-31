import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import 'quality_file_picker_field.dart';

class RequestedInformationFields {
  RequestedInformationFields()
      : descriptionController = TextEditingController();

  final TextEditingController descriptionController;
  String? attachmentPath;

  void dispose() {
    descriptionController.dispose();
  }
}

class InformationRequestFormSection extends StatelessWidget {
  const InformationRequestFormSection({
    super.key,
    required this.subjectController,
    required this.detailsController,
    required this.requestedInformations,
    required this.onAdd,
    required this.onDelete,
    required this.onAttachmentPicked,
    required this.inputDecoration,
  });

  final TextEditingController subjectController;
  final TextEditingController detailsController;
  final List<RequestedInformationFields> requestedInformations;
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
          AppString.informationRequestDetails.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: subjectController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.requestSubject.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: detailsController,
          minLines: 3,
          maxLines: 5,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.details.tr()),
        ),
        SizedBox(height: 20.h),
        ...requestedInformations.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _RequestedInformationCard(
              index: index,
              item: item,
              canDelete: requestedInformations.length > 1,
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
              AppString.addRequestedInformation.tr(),
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

class _RequestedInformationCard extends StatelessWidget {
  const _RequestedInformationCard({
    required this.index,
    required this.item,
    required this.canDelete,
    required this.onDelete,
    required this.onAttachmentPicked,
    required this.inputDecoration,
  });

  final int index;
  final RequestedInformationFields item;
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
                  '${AppString.requestedInformationIndex.tr()} #${index + 1}',
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
          TextFormField(
            controller: item.descriptionController,
            minLines: 2,
            maxLines: 4,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            decoration: inputDecoration(
              AppString.requestedInformationDescription.tr(),
            ),
          ),
          SizedBox(height: 12.h),
          QualityFilePickerField(
            label: AppString.requestedInformationAttachment.tr(),
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
