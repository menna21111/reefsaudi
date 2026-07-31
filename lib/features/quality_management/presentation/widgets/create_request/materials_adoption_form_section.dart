import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import 'quality_file_picker_field.dart';

class MaterialsAdoptionFormSection extends StatelessWidget {
  const MaterialsAdoptionFormSection({
    super.key,
    required this.specificationsController,
    required this.specificEquipmentController,
    required this.suggestedEquipmentController,
    required this.factoryController,
    required this.alternativeController,
    required this.commentsController,
    required this.otherMaterialsController,
    required this.conformityStatementAttachmentPath,
    required this.copyOfSpecificationAttachmentPath,
    required this.sampleAttachmentPath,
    required this.onConformityStatementAttachmentPicked,
    required this.onCopyOfSpecificationAttachmentPicked,
    required this.onSampleAttachmentPicked,
    required this.inputDecoration,
  });

  final TextEditingController specificationsController;
  final TextEditingController specificEquipmentController;
  final TextEditingController suggestedEquipmentController;
  final TextEditingController factoryController;
  final TextEditingController alternativeController;
  final TextEditingController commentsController;
  final TextEditingController otherMaterialsController;
  final String? conformityStatementAttachmentPath;
  final String? copyOfSpecificationAttachmentPath;
  final String? sampleAttachmentPath;
  final ValueChanged<String> onConformityStatementAttachmentPicked;
  final ValueChanged<String> onCopyOfSpecificationAttachmentPicked;
  final ValueChanged<String> onSampleAttachmentPicked;
  final InputDecoration Function(String label) inputDecoration;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppString.materialsAdoptionDetails.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: specificationsController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.specifications.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: specificEquipmentController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.specificEquipment.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: suggestedEquipmentController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.suggestedEquipment.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: factoryController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.factory.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: alternativeController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.alternative.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: commentsController,
          minLines: 2,
          maxLines: 4,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.notes.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: otherMaterialsController,
          minLines: 2,
          maxLines: 4,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.otherMaterials.tr()),
        ),
        SizedBox(height: 20.h),
        QualityFilePickerField(
          label: AppString.conformityStatementAttachment.tr(),
          filePath: conformityStatementAttachmentPath,
          onPicked: onConformityStatementAttachmentPicked,
          onClear: conformityStatementAttachmentPath == null
              ? null
              : () => onConformityStatementAttachmentPicked(''),
        ),
        SizedBox(height: 14.h),
        QualityFilePickerField(
          label: AppString.copyOfSpecificationAttachment.tr(),
          filePath: copyOfSpecificationAttachmentPath,
          onPicked: onCopyOfSpecificationAttachmentPicked,
          onClear: copyOfSpecificationAttachmentPath == null
              ? null
              : () => onCopyOfSpecificationAttachmentPicked(''),
        ),
        SizedBox(height: 14.h),
        QualityFilePickerField(
          label: AppString.sampleAttachment.tr(),
          filePath: sampleAttachmentPath,
          onPicked: onSampleAttachmentPicked,
          onClear: sampleAttachmentPath == null
              ? null
              : () => onSampleAttachmentPicked(''),
        ),
      ],
    );
  }
}
