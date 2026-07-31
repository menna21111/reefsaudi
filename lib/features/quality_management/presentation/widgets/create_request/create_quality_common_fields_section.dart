import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../../../../core/widgets/styled_popup_dropdown.dart';
import '../../constants/quality_form_options.dart';
import 'create_quality_read_only_field.dart';

class CreateQualityCommonFieldsSection extends StatelessWidget {
  const CreateQualityCommonFieldsSection({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.specialization,
    required this.requestType,
    required this.allowedRequestTypes,
    required this.showValidationErrors,
    required this.isLoadingNumbers,
    required this.serialNumber,
    required this.reviewNumber,
    required this.loadProjects,
    required this.onProjectSelected,
    required this.onSpecializationChanged,
    required this.onRequestTypeChanged,
  });

  final String? projectId;
  final String? projectName;
  final int specialization;
  final int requestType;
  final List<QualityOption<int>> allowedRequestTypes;
  final bool showValidationErrors;
  final bool isLoadingNumbers;
  final int? serialNumber;
  final int? reviewNumber;
  final Future<List<DropdownMenuItem<String>>> Function() loadProjects;
  final void Function(String id, String label) onProjectSelected;
  final ValueChanged<int> onSpecializationChanged;
  final ValueChanged<int> onRequestTypeChanged;

  List<DropdownMenuItem<int>> _optionItems(List<QualityOption<int>> options) {
    return options
        .map(
          (option) => DropdownMenuItem<int>(
            value: option.value,
            child: Text(
              option.label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final allowedValues = allowedRequestTypes.map((e) => e.value).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CreateQualityReadOnlyField(
          label: AppString.requestDate.tr(),
          value: DateFormat('dd/MM/yyyy').format(DateTime.now()),
        ),
        SizedBox(height: 14.h),
        LazyStyledPopupDropdown(
          title: AppString.projectName.tr(),
          valueId: projectId,
          valueLabel: projectName,
          hintText: AppString.select.tr(),
          required: true,
          showValidationError: showValidationErrors,
          loadItems: loadProjects,
          onSelected: onProjectSelected,
        ),
        SizedBox(height: 14.h),
        StyledPopupDropdown<int>(
          title: AppString.specialization.tr(),
          value: specialization,
          items: _optionItems(QualitySpecializationOptions.items),
          onChanged: (value) {
            if (value == null) return;
            onSpecializationChanged(value);
          },
        ),
        SizedBox(height: 14.h),
        StyledPopupDropdown<int>(
          title: AppString.requestTypeLabel.tr(),
          value: allowedValues.contains(requestType)
              ? requestType
              : allowedValues.firstOrNull,
          items: _optionItems(allowedRequestTypes),
          onChanged: (value) {
            if (value == null) return;
            onRequestTypeChanged(value);
          },
        ),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: CreateQualityReadOnlyField(
                label: AppString.serialNumber.tr(),
                value: isLoadingNumbers
                    ? '...'
                    : (serialNumber?.toString() ?? '-'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CreateQualityReadOnlyField(
                label: AppString.revisionNumber.tr(),
                value: isLoadingNumbers
                    ? '...'
                    : (reviewNumber?.toString() ?? '-'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
