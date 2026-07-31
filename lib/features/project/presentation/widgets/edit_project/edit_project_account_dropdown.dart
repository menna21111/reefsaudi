import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../cubit/edit_project_cubit.dart';
import '../../cubit/edit_project_state.dart';
import 'edit_project_form_utils.dart';

class EditProjectAccountDropdown extends StatelessWidget {
  const EditProjectAccountDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.map,
    this.required = false,
    this.showValidationError = false,
    this.userType,
  });

  final String title;
  final SelectionValue value;
  final EditProjectFormData Function(SelectionValue) map;
  final bool required;
  final bool showValidationError;
  final int? userType;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProjectCubit>();

    return LazyStyledPopupDropdown(
      title: title,
      valueId: value.id,
      valueLabel: value.label,
      hintText: AppString.select.tr(),
      required: required,
      showValidationError: showValidationError,
      loadItems: () async {
        final accounts = userType == null
            ? await cubit.loadAccounts()
            : await cubit.loadAccountsByUserType(userType!);
        return EditProjectFormUtils.accountItems(context, accounts);
      },
      onSelected: (id, label) {
        cubit.updateForm(map(SelectionValue(id: id, label: label)));
      },
    );
  }
}

class EditProjectFieldGap extends StatelessWidget {
  const EditProjectFieldGap({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(height: 14.h);
}
