import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../data/models/project_risk_models.dart';
import '../constants/risk_enums.dart';
import '../cubit/risk_management_cubit.dart';

class AddRiskSheet extends StatefulWidget {
  const AddRiskSheet({
    super.key,
    required this.projects,
    required this.accounts,
    required this.isLoading,
    required this.isSubmitting,
  });

  final List<ProjectDxItemDto> projects;
  final List<AccountDxItemDto> accounts;
  final bool isLoading;
  final bool isSubmitting;

  @override
  State<AddRiskSheet> createState() => _AddRiskSheetState();
}

class _AddRiskSheetState extends State<AddRiskSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _regionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _responsePlanController = TextEditingController();
  final _contingencyPlanController = TextEditingController();

  String? _projectId;
  String? _ownerId;
  String? _approvedById;
  DateTime? _riskDate;
  String? _riskImpact;
  String? _riskPriority;
  String? _riskProbability;
  String? _riskResponse;
  String? _riskStatus;

  @override
  void dispose() {
    _titleController.dispose();
    _regionController.dispose();
    _descriptionController.dispose();
    _responsePlanController.dispose();
    _contingencyPlanController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _riskDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _riskDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_projectId == null ||
        _ownerId == null ||
        _approvedById == null ||
        _riskDate == null ||
        _riskImpact == null ||
        _riskPriority == null ||
        _riskProbability == null ||
        _riskResponse == null ||
        _riskStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.fillRequiredFields.tr())),
      );
      return;
    }

    final request = CreateProjectRiskRequest(
      title: _titleController.text.trim(),
      projectId: _projectId!,
      description: _descriptionController.text.trim(),
      responsePlan: _responsePlanController.text.trim(),
      contingencyPlan: _contingencyPlanController.text.trim(),
      riskDate: _riskDate!,
      ownerId: _ownerId!,
      approvedById: _approvedById!,
      riskPriority: _riskPriority!,
      riskResponse: _riskResponse!,
      riskImpact: _riskImpact!,
      riskProbability: _riskProbability!,
      riskStatus: _riskStatus!,
    );

    final success =
        await context.read<RiskManagementCubit>().createRisk(request);
    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.riskCreatedSuccess.tr())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.riskCreateFailed.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: 0.92.sh),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 8.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      AppString.projectRisks.tr(),
                      style: TextStyle(
                        color: colors.kPrimaryColor,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: colors.kGrayColor),
                  ),
                ],
              ),
            ),
            if (widget.isLoading)
              LinearProgressIndicator(
                color: colors.kPrimaryColor,
                backgroundColor: colors.kBorderColor.withOpacity(0.2),
              ),
            Flexible(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  children: [
                    _textField(
                      controller: _titleController,
                      label: AppString.riskTitle.tr(),
                      required: true,
                    ),
                    _dropdown<String>(
                      label: AppString.projectName.tr(),
                      value: _projectId,
                      items: widget.projects
                          .map(
                            (project) => DropdownMenuItem(
                              value: project.id,
                              child: Text(
                                project.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _projectId = value),
                      required: true,
                    ),
                    _textField(
                      controller: _regionController,
                      label: AppString.region.tr(),
                    ),
                    _textField(
                      controller: _descriptionController,
                      label: AppString.description.tr(),
                      maxLines: 2,
                    ),
                    _textField(
                      controller: _responsePlanController,
                      label: AppString.responsePlan.tr(),
                      required: true,
                      maxLines: 2,
                    ),
                    _textField(
                      controller: _contingencyPlanController,
                      label: AppString.contingencyPlan.tr(),
                      required: true,
                      maxLines: 2,
                    ),
                    _dateField(),
                    _dropdown<String>(
                      label: AppString.projectOwner.tr(),
                      value: _ownerId,
                      items: widget.accounts
                          .map(
                            (account) => DropdownMenuItem(
                              value: account.id,
                              child: Text(
                                account.fullName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() => _ownerId = value),
                      required: true,
                    ),
                    _dropdown<String>(
                      label: AppString.approvalOfficer.tr(),
                      value: _approvedById,
                      items: widget.accounts
                          .map(
                            (account) => DropdownMenuItem(
                              value: account.id,
                              child: Text(
                                account.fullName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _approvedById = value),
                      required: true,
                    ),
                    _enumDropdown(
                      label: AppString.riskImpact.tr(),
                      value: _riskImpact,
                      options: RiskEnums.riskImpact,
                      onChanged: (value) => setState(() => _riskImpact = value),
                    ),
                    _enumDropdown(
                      label: AppString.riskPriority.tr(),
                      value: _riskPriority,
                      options: RiskEnums.riskPriority,
                      onChanged: (value) =>
                          setState(() => _riskPriority = value),
                    ),
                    _enumDropdown(
                      label: AppString.riskProbability.tr(),
                      value: _riskProbability,
                      options: RiskEnums.riskProbability,
                      onChanged: (value) =>
                          setState(() => _riskProbability = value),
                    ),
                    _enumDropdown(
                      label: AppString.riskResponseLabel.tr(),
                      value: _riskResponse,
                      options: RiskEnums.riskResponse,
                      onChanged: (value) =>
                          setState(() => _riskResponse = value),
                    ),
                    _enumDropdown(
                      label: AppString.riskStatusLabel.tr(),
                      value: _riskStatus,
                      options: RiskEnums.riskStatus,
                      onChanged: (value) => setState(() => _riskStatus = value),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: widget.isSubmitting
                                ? null
                                : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: colors.kBorderColor),
                              minimumSize: Size(double.infinity, 48.h),
                            ),
                            child: Text(AppString.cancel.tr()),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: FilledButton(
                            onPressed: widget.isSubmitting ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: colors.kPrimaryColor,
                              minimumSize: Size(double.infinity, 48.h),
                            ),
                            child: widget.isSubmitting
                                ? SizedBox(
                                    width: 20.w,
                                    height: 20.w,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: colors.kWhiteColor,
                                    ),
                                  )
                                : Text(AppString.save.tr()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    int maxLines = 1,
  }) {
    final colors = context.appColors;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(color: colors.kFontColor, fontSize: 14.sp),
        decoration: _inputDecoration(label, required: required),
        validator: required
            ? (value) =>
                (value == null || value.trim().isEmpty) ? ' ' : null
            : null,
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    bool required = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        decoration: _inputDecoration(label, required: required),
        validator: required ? (value) => value == null ? ' ' : null : null,
      ),
    );
  }

  Widget _enumDropdown({
    required String label,
    required String? value,
    required List<RiskEnumOption> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownButtonFormField<String>(
        value: value,
        items: options
            .map(
              (option) => DropdownMenuItem(
                value: option.value,
                child: Text(option.labelKey.tr()),
              ),
            )
            .toList(),
        onChanged: onChanged,
        decoration: _inputDecoration(label, required: true),
        validator: (value) => value == null ? ' ' : null,
      ),
    );
  }

  Widget _dateField() {
    final colors = context.appColors;
    final label = AppString.date.tr();
    final display = _riskDate == null
        ? AppString.select.tr()
        : DateFormat.yMMMd().format(_riskDate!);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: _pickDate,
        borderRadius: BorderRadius.circular(12.r),
        child: InputDecorator(
          decoration: _inputDecoration(label, required: true),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  display,
                  style: TextStyle(color: colors.kFontColor, fontSize: 14.sp),
                ),
              ),
              Icon(Icons.calendar_today_outlined,
                  color: colors.kGrayColor, size: 18.sp),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {bool required = false}) {
    final colors = context.appColors;

    return InputDecoration(
      labelText: required ? '$label *' : label,
      labelStyle: TextStyle(color: colors.kGrayColor),
      filled: true,
      fillColor: colors.kBgColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.kBorderColor.withOpacity(0.4)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.kBorderColor.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.kPrimaryColor),
      ),
    );
  }
}
