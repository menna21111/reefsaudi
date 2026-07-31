import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../project/presentation/widgets/edit_project/edit_project_date_field.dart';

class ReceiveBusinessFormSection extends StatelessWidget {
  const ReceiveBusinessFormSection({
    super.key,
    required this.buildingStatementController,
    required this.buildingCommentsController,
    required this.floorStatementController,
    required this.floorCommentsController,
    required this.approvedPlatesStatementController,
    required this.approvedPlatesCommentsController,
    required this.requiredExaminationDateCommentsController,
    required this.workToBeExaminedStatementController,
    required this.workToBeExaminedCommentsController,
    required this.responsibleEngineerController,
    required this.responsibleDirectorController,
    required this.requiredExaminationDate,
    required this.onRequiredExaminationDateChanged,
    required this.inputDecoration,
  });

  final TextEditingController buildingStatementController;
  final TextEditingController buildingCommentsController;
  final TextEditingController floorStatementController;
  final TextEditingController floorCommentsController;
  final TextEditingController approvedPlatesStatementController;
  final TextEditingController approvedPlatesCommentsController;
  final TextEditingController requiredExaminationDateCommentsController;
  final TextEditingController workToBeExaminedStatementController;
  final TextEditingController workToBeExaminedCommentsController;
  final TextEditingController responsibleEngineerController;
  final TextEditingController responsibleDirectorController;
  final DateTime? requiredExaminationDate;
  final ValueChanged<DateTime> onRequiredExaminationDateChanged;
  final InputDecoration Function(String label) inputDecoration;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppString.receiveBusinessDetails.tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 14.h),
        _StatementWithComments(
          statementController: buildingStatementController,
          commentsController: buildingCommentsController,
          statementLabel: AppString.building.tr(),
          commentsLabel: AppString.buildingComments.tr(),
          inputDecoration: inputDecoration,
        ),
        SizedBox(height: 14.h),
        _StatementWithComments(
          statementController: floorStatementController,
          commentsController: floorCommentsController,
          statementLabel: AppString.floor.tr(),
          commentsLabel: AppString.floorComments.tr(),
          inputDecoration: inputDecoration,
        ),
        SizedBox(height: 14.h),
        _StatementWithComments(
          statementController: approvedPlatesStatementController,
          commentsController: approvedPlatesCommentsController,
          statementLabel: AppString.approvedPlates.tr(),
          commentsLabel: AppString.approvedPlatesComments.tr(),
          inputDecoration: inputDecoration,
        ),
        SizedBox(height: 14.h),
        EditProjectDateField(
          label: AppString.requiredExaminationDate.tr(),
          value: requiredExaminationDate,
          onPicked: onRequiredExaminationDateChanged,
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: requiredExaminationDateCommentsController,
          minLines: 2,
          maxLines: 4,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(
            AppString.requiredExaminationDateComments.tr(),
          ),
        ),
        SizedBox(height: 14.h),
        _StatementWithComments(
          statementController: workToBeExaminedStatementController,
          commentsController: workToBeExaminedCommentsController,
          statementLabel: AppString.workToBeExamined.tr(),
          commentsLabel: AppString.workToBeExaminedComments.tr(),
          inputDecoration: inputDecoration,
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: responsibleEngineerController,
                textAlign: FormLayout.alignOf(context),
                textDirection: FormLayout.directionOf(context),
                decoration: inputDecoration(AppString.responsibleEngineer.tr()),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextFormField(
                controller: responsibleDirectorController,
                textAlign: FormLayout.alignOf(context),
                textDirection: FormLayout.directionOf(context),
                decoration: inputDecoration(AppString.responsibleDirector.tr()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatementWithComments extends StatelessWidget {
  const _StatementWithComments({
    required this.statementController,
    required this.commentsController,
    required this.statementLabel,
    required this.commentsLabel,
    required this.inputDecoration,
  });

  final TextEditingController statementController;
  final TextEditingController commentsController;
  final String statementLabel;
  final String commentsLabel;
  final InputDecoration Function(String label) inputDecoration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: statementController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(statementLabel),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: commentsController,
          minLines: 2,
          maxLines: 4,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(commentsLabel),
        ),
      ],
    );
  }
}
