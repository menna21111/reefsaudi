import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/network/account_user_type.dart';
import '../../../../../core/utils/app_string.dart';
import '../../../../../core/utils/app_theme_context.dart';
import '../../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../../../../core/widgets/styled_popup_dropdown.dart';
import '../../../data/models/project_edit_models.dart';
import '../../cubit/edit_project_cubit.dart';
import '../../cubit/edit_project_state.dart';
import 'edit_project_account_dropdown.dart';
import 'edit_project_date_field.dart';
import 'edit_project_form_utils.dart';
import 'edit_project_section_card.dart';

class EditProjectDataSection extends StatelessWidget {
  const EditProjectDataSection({
    super.key,
    required this.form,
    required this.titleController,
    required this.contractualBudgetController,
    required this.estimatedBudgetController,
    this.descriptionController,
    this.projectCodeController,
    this.requiredFields = false,
    this.showValidationErrors = false,
  });

  final EditProjectFormData form;
  final TextEditingController titleController;
  final TextEditingController contractualBudgetController;
  final TextEditingController estimatedBudgetController;
  final TextEditingController? descriptionController;
  final TextEditingController? projectCodeController;
  final bool requiredFields;
  final bool showValidationErrors;

  String? _requiredValidator(String? value) =>
      requiredFields && (value == null || value.trim().isEmpty) ? ' ' : null;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final cubit = context.read<EditProjectCubit>();
    final fieldStyle = EditProjectFormUtils.fieldTextStyle(context);

    return EditProjectSectionCard(
      icon: Icons.data_usage_outlined,
      title: AppString.projectDataSection.tr(),
      children: [
        TextFormField(
          controller: titleController,
          validator: _requiredValidator,

        
          style: fieldStyle,
          onChanged: (v) => cubit.updateForm(form.copyWith(title: v)),
          decoration: EditProjectFormUtils.inputDecoration(
            context,
            label: AppString.projectTitleLabel.tr(),
            hint: AppString.fullProjectNameHint.tr(),
          ),
        ),
        const EditProjectFieldGap(),
        LazyStyledPopupDropdown(
          title: AppString.projectResponsible.tr(),
          valueId: form.owner.id,
          valueLabel: form.owner.label,
          hintText: AppString.select.tr(),
          required: requiredFields,
          showValidationError: showValidationErrors,
          loadItems: () async => EditProjectFormUtils.accountItems(
            context,
            await cubit.loadAccounts(),
          ),
          onSelected: (id, label) => cubit.updateForm(
            form.copyWith(owner: SelectionValue(id: id, label: label)),
          ),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.generalConsultant.tr(),
          value: form.consultant,
          required: requiredFields,
          showValidationError: showValidationErrors,
          userType: AccountUserType.consultant,
          map: (v) => form.copyWith(consultant: v),
        ),
        const EditProjectFieldGap(),
        EditProjectAccountDropdown(
          title: AppString.contractor.tr(),
          value: form.contractor,
          required: requiredFields,
          showValidationError: showValidationErrors,
          userType: AccountUserType.contractor,
          map: (v) => form.copyWith(contractor: v),
        ),
        if (descriptionController != null) ...[
          const EditProjectFieldGap(),
          TextFormField(
            controller: descriptionController,
            maxLines: 4,
            validator: _requiredValidator,
            // textAlign: FormLayout.alignOf(context),
            // textDirection: FormLayout.directionOf(context),
            style: fieldStyle,
            onChanged: (v) => cubit.updateForm(form.copyWith(description: v)),
            decoration: EditProjectFormUtils.inputDecoration(
              context,
              label: AppString.description.tr(),
              hint: AppString.projectDescriptionHint.tr(),
            ),
          ),
        ],
        const EditProjectFieldGap(),
        Row(
          children: [
            Expanded(
              child: EditProjectDateField(
                label: AppString.projectStartDate.tr(),
                value: form.startDate,
                required: requiredFields,
          showValidationError: showValidationErrors,
                onPicked: (d) =>
                    cubit.updateForm(form.copyWith(startDate: d)),
                onTap: requiredFields
                    ? null
                    : () => EditProjectFormUtils.pickDate(
                          context,
                          initial: form.startDate,
                          onPicked: (d) =>
                              cubit.updateForm(form.copyWith(startDate: d)),
                        ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: EditProjectDateField(
                label: AppString.expectedProjectEndDate.tr(),
                value: form.endDate,
                required: requiredFields,
          showValidationError: showValidationErrors,
                onPicked: (d) => cubit.updateForm(form.copyWith(endDate: d)),
                onTap: requiredFields
                    ? null
                    : () => EditProjectFormUtils.pickDate(
                          context,
                          initial: form.endDate,
                          onPicked: (d) =>
                              cubit.updateForm(form.copyWith(endDate: d)),
                        ),
              ),
            ),
          ],
        ),
        const EditProjectFieldGap(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: contractualBudgetController,
                keyboardType: TextInputType.number,
                validator: _requiredValidator,
                textAlign: FormLayout.alignOf(context),
                textDirection: FormLayout.directionOf(context),
                style: fieldStyle,
                onChanged: (v) =>
                    cubit.updateForm(form.copyWith(contractualBudget: v)),
                decoration: EditProjectFormUtils.inputDecoration(
                  context,
                  label: AppString.contractualBudget.tr(),
                  suffix: Padding(
                    padding: EdgeInsetsDirectional.only(top: 14.h, end: 8.w),
                    child: Text(
                      AppString.sar.tr(),
                      style: TextStyle(
                        color: colors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextFormField(
                controller: estimatedBudgetController,
                keyboardType: TextInputType.number,
                validator: _requiredValidator,
                textAlign: FormLayout.alignOf(context),
                textDirection: FormLayout.directionOf(context),
                style: fieldStyle,
                onChanged: (v) =>
                    cubit.updateForm(form.copyWith(estimatedBudget: v)),
                decoration: EditProjectFormUtils.inputDecoration(
                  context,
                  label: AppString.estimatedBudget.tr(),
                  suffix: Padding(
                    padding: EdgeInsetsDirectional.only(top: 14.h, end: 8.w),
                    child: Text(
                      AppString.sar.tr(),
                      style: TextStyle(
                        color: colors.kPrimaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const EditProjectFieldGap(),
        StyledPopupDropdown<String>(
          title: AppString.projectPhaseLabel.tr(),
          hintText: AppString.select.tr(),
          value: form.phaseKey,
          required: requiredFields,
          showValidationError: showValidationErrors,
          items: EditProjectFormUtils.textItems(context, projectPhaseOptions),
          onChanged: (v) => cubit.updateForm(form.copyWith(phaseKey: v)),
        ),
        const EditProjectFieldGap(),
        EditProjectDateField(
          label: AppString.phaseJoinDate.tr(),
          value: form.phaseJoinDate,
          required: requiredFields,
          showValidationError: showValidationErrors,
          onPicked: (d) => cubit.updateForm(form.copyWith(phaseJoinDate: d)),
          onTap: requiredFields
              ? null
              : () => EditProjectFormUtils.pickDate(
                    context,
                    initial: form.phaseJoinDate,
                    onPicked: (d) =>
                        cubit.updateForm(form.copyWith(phaseJoinDate: d)),
                  ),
        ),
        const EditProjectFieldGap(),
        StyledPopupDropdown<String>(
          title: AppString.projectStatus.tr(),
          hintText: AppString.select.tr(),
          value: form.statusKey,
          required: requiredFields,
          showValidationError: showValidationErrors,
          items: EditProjectFormUtils.textItems(context, projectStatusOptions),
          onChanged: (v) => cubit.updateForm(form.copyWith(statusKey: v)),
        ),
        const EditProjectFieldGap(),
        Row(
          children: [
            Expanded(
              child: LazyStyledPopupDropdown(
                title: AppString.sector.tr(),
                valueId: form.sector.id,
                valueLabel: form.sector.label,
                hintText: AppString.select.tr(),
                required: requiredFields,
          showValidationError: showValidationErrors,
                loadItems: () async => EditProjectFormUtils.dxItems(
                  context,
                  await cubit.loadBrands(),
                ),
                onSelected: (id, label) => cubit.updateForm(
                  form.copyWith(sector: SelectionValue(id: id, label: label)),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: LazyStyledPopupDropdown(
                title: AppString.region.tr(),
                valueId: form.region.id,
                valueLabel: form.region.label,
                hintText: AppString.select.tr(),
                required: requiredFields,
          showValidationError: showValidationErrors,
                loadItems: () async => EditProjectFormUtils.dxItems(
                  context,
                  await cubit.loadProducts(),
                ),
                onSelected: (id, label) => cubit.updateForm(
                  form.copyWith(region: SelectionValue(id: id, label: label)),
                ),
              ),
            ),
          ],
        ),
        const EditProjectFieldGap(),
        LazyStyledPopupDropdown(
          title: AppString.projectTypeLabel.tr(),
          valueId: form.projectType.id,
          valueLabel: form.projectType.label,
          hintText: AppString.select.tr(),
          required: requiredFields,
          showValidationError: showValidationErrors,
          loadItems: () async => EditProjectFormUtils.dxItems(
            context,
            await cubit.loadProjectTypes(),
          ),
          onSelected: (id, label) => cubit.updateForm(
            form.copyWith(projectType: SelectionValue(id: id, label: label)),
          ),
        ),
        const EditProjectFieldGap(),
        LazyStyledPopupDropdown(
          title: AppString.productionLine.tr(),
          valueId: form.productionLine.id,
          valueLabel: form.productionLine.label,
          hintText: AppString.select.tr(),
          required: requiredFields,
          showValidationError: showValidationErrors,
          loadItems: () async => EditProjectFormUtils.dxItems(
            context,
            await cubit.loadProductionLines(),
          ),
          onSelected: (id, label) => cubit.updateForm(
            form.copyWith(productionLine: SelectionValue(id: id, label: label)),
          ),
        ),
        if (projectCodeController != null) ...[
          const EditProjectFieldGap(),
          TextFormField(
            controller: projectCodeController,
            validator: _requiredValidator,
            textAlign: FormLayout.alignOf(context),
            textDirection: FormLayout.directionOf(context),
            style: fieldStyle,
            onChanged: (v) => cubit.updateForm(form.copyWith(projectCode: v)),
            decoration: EditProjectFormUtils.inputDecoration(
              context,
              label: AppString.projectCode.tr(),
            ),
          ),
        ],
      ],
    );
  }
}
