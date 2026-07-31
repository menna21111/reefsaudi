import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/utils/app_string.dart';
import '../../cubit/edit_project_state.dart';

abstract final class ProjectDetailsFieldHelpers {
  static String text(String value) => value.trim().isEmpty ? '-' : value.trim();

  static String selection(SelectionValue value) {
    final label = value.label?.trim();
    if (label != null && label.isNotEmpty) return label;
    return '-';
  }

  static String date(DateTime? value) {
    if (value == null) return '-';
    return DateFormat('dd/MM/yyyy').format(value);
  }

  static String option(String? key) {
    if (key == null || key.isEmpty) return '-';
    return key.tr();
  }

  static String budget(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '-';
    return '$trimmed ${AppString.sar.tr()}';
  }
}
