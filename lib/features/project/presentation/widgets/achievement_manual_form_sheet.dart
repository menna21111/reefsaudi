import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../data/models/project_api_models.dart';
import '../cubit/project_statistics_cubit.dart';

class AchievementManualFormSheet extends StatefulWidget {
  const AchievementManualFormSheet._({
    required this.projectId,
    this.record,
  });

  final String projectId;
  final AchievementManualItemDto? record;

  static Future<bool?> show(
    BuildContext context, {
    required String projectId,
    AchievementManualItemDto? record,
  }) {
    final cubit = context.read<ProjectBlueprintCubit>();

    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) => BlocProvider.value(
        value: cubit,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: AchievementManualFormSheet._(
            projectId: projectId,
            record: record,
          ),
        ),
      ),
    );
  }

  bool get isEdit => record != null;

  @override
  State<AchievementManualFormSheet> createState() =>
      _AchievementManualFormSheetState();
}

class _AchievementManualFormSheetState extends State<AchievementManualFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _plannedController;
  late final TextEditingController _actualController;
  late DateTime _monthYear;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final record = widget.record;
    _plannedController = TextEditingController(
      text: record != null ? _formatNumber(record.planned) : '',
    );
    _actualController = TextEditingController(
      text: record != null ? _formatNumber(record.actual) : '',
    );
    _monthYear = record != null
        ? (DateTime.tryParse(record.monthYear) ?? DateTime.now())
        : DateTime.now();
  }

  @override
  void dispose() {
    _plannedController.dispose();
    _actualController.dispose();
    super.dispose();
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toString();
  }

  double? _parsePercent(String value) {
    final parsed = double.tryParse(value.replaceAll(',', '').trim());
    if (parsed == null) return null;
    return parsed;
  }

  Future<void> _pickMonth() async {
    final colors = context.appColorsRead;
    final picked = await showDatePicker(
      context: context,
      initialDate: _monthYear,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: colors.kPrimaryColor,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _monthYear = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final planned = _parsePercent(_plannedController.text);
    final actual = _parsePercent(_actualController.text);
    if (planned == null || actual == null) return;

    final cubit = context.read<ProjectBlueprintCubit>();
    setState(() => _isSubmitting = true);

    final String? error;
    if (widget.isEdit) {
      error = await cubit.updateAchievement(
        record: widget.record!,
        monthYear: _monthYear,
        planned: planned,
        actual: actual,
      );
    } else {
      error = await cubit.createAchievement(
        monthYear: _monthYear,
        planned: planned,
        actual: actual,
      );
    }

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (error != null) {
      AppFunctions.showsToast(error, AppColor.kRedColor, context);
      return;
    }

    AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.kBorderColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              widget.isEdit
                  ? AppString.editAchievementRecord.tr()
                  : AppString.add.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Almarai',
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              AppString.monthYear.tr(),
              style: TextStyle(
                color: colors.kGrayColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                fontFamily: 'Almarai',
              ),
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: _isSubmitting ? null : _pickMonth,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: colors.kInputColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.kBorderColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat.yMMMM(context.locale.toString())
                            .format(_monthYear),
                        style: TextStyle(
                          color: colors.kFontColor,
                          fontSize: 13.sp,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    ),
                    Icon(
                      Icons.calendar_month_outlined,
                      color: colors.kPrimaryColor,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 14.h),
            _PercentField(
              label: AppString.planned.tr(),
              controller: _plannedController,
              enabled: !_isSubmitting,
            ),
            SizedBox(height: 14.h),
            _PercentField(
              label: AppString.actual.tr(),
              controller: _actualController,
              enabled: !_isSubmitting,
            ),
            SizedBox(height: 24.h),
            _isSubmitting
                ? Center(
                    child: CircularProgressIndicator(color: colors.kPrimaryColor),
                  )
                : ButtonCustom(
                    text: AppString.saveChanges.tr(),
                    onTap: _submit,
                  ),
          ],
        ),
      ),
    );
  }
}

class _PercentField extends StatelessWidget {
  const _PercentField({
    required this.label,
    required this.controller,
    required this.enabled,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return ' ';
        if (double.tryParse(value.replaceAll(',', '').trim()) == null) {
          return ' ';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: colors.kInputColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: colors.kBorderColor.withValues(alpha: 0.35),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: colors.kPrimaryColor),
        ),
      ),
    );
  }
}
