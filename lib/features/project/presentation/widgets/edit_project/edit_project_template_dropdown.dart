import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_string.dart';
import '../../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../cubit/edit_project_cubit.dart';
import '../../cubit/edit_project_state.dart';
import 'edit_project_form_utils.dart';

class EditProjectTemplateDropdown extends StatelessWidget {
  const EditProjectTemplateDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.map,
  });

  final String title;
  final SelectionValue value;
  final EditProjectFormData Function(SelectionValue) map;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProjectCubit>();

    return LazyStyledPopupDropdown(
      title: title,
      valueId: value.id,
      valueLabel: value.label,
      hintText: AppString.select.tr(),
      loadItems: () async {
        final templates = await cubit.loadPublishedTemplates();
        return EditProjectFormUtils.templateItems(context, templates);
      },
      onSelected: (id, label) {
        cubit.updateForm(map(SelectionValue(id: id, label: label)));
      },
    );
  }
}
