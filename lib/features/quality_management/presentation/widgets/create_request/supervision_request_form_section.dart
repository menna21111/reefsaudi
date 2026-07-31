import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../constants/quality_form_options.dart';

class SupervisionProcedureFields {
  SupervisionProcedureFields()
      : titleController = TextEditingController(),
        descriptionController = TextEditingController();

  final TextEditingController titleController;
  final TextEditingController descriptionController;

  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
  }
}

class SupervisionRequestFormSection extends StatelessWidget {
  const SupervisionRequestFormSection({
    super.key,
    required this.requestType,
    required this.descriptionController,
    required this.correctiveActionController,
    required this.consultantNotesCorrectiveController,
    required this.consultantNotesReceiptController,
    required this.consultantRequestTypeController,
    required this.procedures,
    required this.onAddProcedure,
    required this.onDeleteProcedure,
    required this.inputDecoration,
  });

  final int requestType;
  final TextEditingController descriptionController;
  final TextEditingController correctiveActionController;
  final TextEditingController consultantNotesCorrectiveController;
  final TextEditingController consultantNotesReceiptController;
  final TextEditingController consultantRequestTypeController;
  final List<SupervisionProcedureFields> procedures;
  final VoidCallback onAddProcedure;
  final ValueChanged<int> onDeleteProcedure;
  final InputDecoration Function(String label) inputDecoration;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          QualityCreatableRequestTypes.detailsSectionKey(requestType).tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: descriptionController,
          minLines: 3,
          maxLines: 5,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.description.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: correctiveActionController,
          minLines: 3,
          maxLines: 5,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.correctiveAction.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: consultantNotesCorrectiveController,
          minLines: 2,
          maxLines: 4,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.consultantNotesCorrective.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: consultantNotesReceiptController,
          minLines: 2,
          maxLines: 4,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.consultantNotesReceipt.tr()),
        ),
        SizedBox(height: 14.h),
        TextFormField(
          controller: consultantRequestTypeController,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          decoration: inputDecoration(AppString.consultantRequestType.tr()),
        ),
        SizedBox(height: 20.h),
        Text(
          AppString.supervisionProcedures.tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 12.h),
        ...procedures.asMap().entries.map((entry) {
          final index = entry.key;
          final procedure = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _SupervisionProcedureCard(
              index: index + 1,
              procedure: procedure,
              canDelete: procedures.length > 1,
              onDelete: () => onDeleteProcedure(index),
              inputDecoration: inputDecoration,
            ),
          );
        }),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: OutlinedButton.icon(
            onPressed: onAddProcedure,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colors.kBorderColor.withValues(alpha: 0.45),
                width: 1,
              ),
              foregroundColor: colors.kPrimaryColor,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            icon: Icon(Icons.add_rounded, color: colors.kPrimaryColor),
            label: Text(
              AppString.addSupervisionProcedure.tr(),
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

class _SupervisionProcedureCard extends StatelessWidget {
  const _SupervisionProcedureCard({
    required this.index,
    required this.procedure,
    required this.canDelete,
    required this.onDelete,
    required this.inputDecoration,
  });

  final int index;
  final SupervisionProcedureFields procedure;
  final bool canDelete;
  final VoidCallback onDelete;
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
                  '${AppString.supervisionProcedureIndex.tr()} #$index',
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
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: colors.kRedColor,
                  ),
                ),
            ],
          ),
          TextFormField(
            controller: procedure.titleController,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            decoration: inputDecoration(
              AppString.supervisionProcedureTitle.tr(),
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: procedure.descriptionController,
            minLines: 2,
            maxLines: 4,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            decoration: inputDecoration(
              AppString.supervisionProcedureDescription.tr(),
            ),
          ),
        ],
      ),
    );
  }
}
