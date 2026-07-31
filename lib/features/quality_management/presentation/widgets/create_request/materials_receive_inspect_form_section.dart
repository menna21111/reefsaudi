import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../project/presentation/widgets/edit_project/edit_project_date_field.dart';
import 'quality_file_picker_field.dart';

class MaterialsReceiveInspectFormSection extends StatelessWidget {
  const MaterialsReceiveInspectFormSection({
    super.key,
    required this.approvalApplicationNumberController,
    required this.factoryNameController,
    required this.materialDescriptionController,
    required this.attachmentsStatementController,
    required this.responsibleEngineerNameController,
    required this.responsibleDirectorNameController,
    required this.accreditationDate,
    required this.requiredExaminationDate,
    required this.onAccreditationDateChanged,
    required this.onRequiredExaminationDateChanged,
    required this.approvalApplicationNumberAttachmentPath,
    required this.factoryNameAttachmentPath,
    required this.attachmentsStatementAttachmentPath,
    required this.onApprovalApplicationNumberAttachmentPicked,
    required this.onFactoryNameAttachmentPicked,
    required this.onAttachmentsStatementAttachmentPicked,
    required this.inputDecoration,
  });

  final TextEditingController approvalApplicationNumberController;
  final TextEditingController factoryNameController;
  final TextEditingController materialDescriptionController;
  final TextEditingController attachmentsStatementController;
  final TextEditingController responsibleEngineerNameController;
  final TextEditingController responsibleDirectorNameController;
  final DateTime? accreditationDate;
  final DateTime? requiredExaminationDate;
  final ValueChanged<DateTime> onAccreditationDateChanged;
  final ValueChanged<DateTime> onRequiredExaminationDateChanged;
  final String? approvalApplicationNumberAttachmentPath;
  final String? factoryNameAttachmentPath;
  final String? attachmentsStatementAttachmentPath;
  final ValueChanged<String> onApprovalApplicationNumberAttachmentPicked;
  final ValueChanged<String> onFactoryNameAttachmentPicked;
  final ValueChanged<String> onAttachmentsStatementAttachmentPicked;
  final InputDecoration Function(String label) inputDecoration;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppString.materialsReceiveDetails.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: approvalApplicationNumberController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.approvalApplicationNumber.tr()),
        ),
        SizedBox(height: 14.h),
        EditProjectDateField(
          label: AppString.accreditationDate.tr(),
          value: accreditationDate,
          onPicked: onAccreditationDateChanged,
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: factoryNameController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.factoryName.tr()),
        ),
        SizedBox(height: 14.h),
        EditProjectDateField(
          label: AppString.requiredExaminationDate.tr(),
          value: requiredExaminationDate,
          onPicked: onRequiredExaminationDateChanged,
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: materialDescriptionController,
          minLines: 3,
          maxLines: 5,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.materialDescription.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: attachmentsStatementController,
          minLines: 3,
          maxLines: 5,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.attachmentsStatement.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: responsibleEngineerNameController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.responsibleEngineerName.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: responsibleDirectorNameController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.responsibleDirectorName.tr()),
        ),
        SizedBox(height: 20.h),
        QualityFilePickerField(
          label: AppString.approvalApplicationNumberFile.tr(),
          filePath: approvalApplicationNumberAttachmentPath,
          onPicked: onApprovalApplicationNumberAttachmentPicked,
          onClear: approvalApplicationNumberAttachmentPath == null
              ? null
              : () => onApprovalApplicationNumberAttachmentPicked(''),
        ),
        SizedBox(height: 14.h),
        QualityFilePickerField(
          label: AppString.factoryNameFile.tr(),
          filePath: factoryNameAttachmentPath,
          onPicked: onFactoryNameAttachmentPicked,
          onClear: factoryNameAttachmentPath == null
              ? null
              : () => onFactoryNameAttachmentPicked(''),
        ),
        SizedBox(height: 14.h),
        QualityFilePickerField(
          label: AppString.attachmentsStatementFile.tr(),
          filePath: attachmentsStatementAttachmentPath,
          onPicked: onAttachmentsStatementAttachmentPicked,
          onClear: attachmentsStatementAttachmentPath == null
              ? null
              : () => onAttachmentsStatementAttachmentPicked(''),
        ),
      ],
    );
  }
}
