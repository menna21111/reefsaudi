import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_theme_context.dart';
import '../../../../risk_management/data/models/project_risk_models.dart';
import '../../../data/models/project_edit_models.dart';
import '../../../data/models/project_template_models.dart';
import '../../../data/models/supplier_models.dart';

class EditProjectFormUtils {
  EditProjectFormUtils._();

  static Future<void> pickDate(
    BuildContext context, {
    required DateTime? initial,
    required void Function(DateTime) onPicked,
  }) async {
    final colors = context.appColorsRead;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 15),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: colors.kPrimaryColor,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) onPicked(picked);
  }

  static InputDecoration inputDecoration(
    BuildContext context, {
    required String label,
    String? hint,
    Widget? suffix,
  }) {
    final colors = context.appColors;
    final radius = BorderRadius.circular(14.r);
    final normalBorder = BorderSide(color: colors.kBorderColor.withValues(alpha: 0.45));
    final errorBorderSide = BorderSide(color: colors.kRedColor, width: 1.5);

    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffix: suffix,
      alignLabelWithHint: true,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      labelStyle: TextStyle(
        color: colors.kGrayColor,
        fontSize: 13.sp,
        fontFamily: 'Almarai',
      ),
      hintStyle: TextStyle(
        color: colors.kGrayColor,
        fontSize: 14.sp,
        fontFamily: 'Almarai',
      ),
      filled: true,
      fillColor: colors.kInputColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      errorStyle: TextStyle(height: 0, fontSize: 0, color: colors.kRedColor),
      border: OutlineInputBorder(borderRadius: radius, borderSide: normalBorder),
      enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: normalBorder),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: colors.kPrimaryColor),
      ),
      errorBorder: OutlineInputBorder(borderRadius: radius, borderSide: errorBorderSide),
      focusedErrorBorder: OutlineInputBorder(borderRadius: radius, borderSide: errorBorderSide),
    );
  }

  static TextStyle fieldTextStyle(BuildContext context, {Color? color}) {
    final colors = context.appColors;
    return TextStyle(
      color: color ?? colors.kFontColor,
      fontSize: 15.sp,
      fontFamily: 'Almarai',
    );
  }

  static Text dropdownText(BuildContext context, String value) {
    return Text(
      value,
      textAlign: FormLayout.alignOf(context),
      textDirection: FormLayout.directionOf(context),
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontFamily: 'Almarai'),
    );
  }

  static List<DropdownMenuItem<String>> accountItems(
    BuildContext context,
    List<AccountDxItemDto> items,
  ) {
    return items
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: dropdownText(context, item.fullName),
          ),
        )
        .toList();
  }

  static List<DropdownMenuItem<String>> supplierItems(
    BuildContext context,
    List<SupplierDxItemDto> items,
  ) {
    return items
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: dropdownText(context, item.title),
          ),
        )
        .toList();
  }

  static List<DropdownMenuItem<String>> dxItems(
    BuildContext context,
    List<DxListItemDto> items,
  ) {
    return items
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: dropdownText(context, item.title),
          ),
        )
        .toList();
  }

  static List<DropdownMenuItem<String>> templateItems(
    BuildContext context,
    List<ProjectTemplateDto> items,
  ) {
    return items
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: dropdownText(context, item.name),
          ),
        )
        .toList();
  }

  static List<DropdownMenuItem<String>> textItems(
    BuildContext context,
    List<String> keys,
  ) {
    return keys
        .map(
          (key) => DropdownMenuItem<String>(
            value: key,
            child: dropdownText(context, key.tr()),
          ),
        )
        .toList();
  }
}
