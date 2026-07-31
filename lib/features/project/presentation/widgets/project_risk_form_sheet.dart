import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import '../../../risk_management/presentation/constants/risk_enums.dart';
import '../cubit/project_statistics_cubit.dart';
import '../widgets/edit_project/edit_project_form_utils.dart';

Future<bool?> showProjectRiskFormSheet(
  BuildContext context, {
  ProjectRiskDto? initial,
}) {
  final cubit = context.read<ProjectRisksCubit>();
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _ProjectRiskFormDialog(initial: initial),
    ),
  );
}

class _ProjectRiskFormDialog extends StatefulWidget {
  const _ProjectRiskFormDialog({this.initial});

  final ProjectRiskDto? initial;

  bool get isEdit => initial != null;

  @override
  State<_ProjectRiskFormDialog> createState() => _ProjectRiskFormDialogState();
}

class _ProjectRiskFormDialogState extends State<_ProjectRiskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _showValidationErrors = false;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _responsePlanController;
  late final TextEditingController _contingencyPlanController;

  DateTime? _riskDate;
  String? _ownerId;
  String? _ownerName;
  String? _approvedById;
  String? _approvedByName;
  String? _riskImpact;
  String? _riskPriority;
  String? _riskProbability;
  String? _riskResponse;
  String? _riskStatus;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _responsePlanController =
        TextEditingController(text: initial?.responsePlan ?? '');
    _contingencyPlanController =
        TextEditingController(text: initial?.contingencyPlan ?? '');
    _riskDate = initial?.riskDate != null
        ? DateTime.tryParse(initial!.riskDate!)
        : null;
    _ownerId = initial?.ownerId;
    _ownerName = initial?.ownerName;
    _approvedById = initial?.approvedById;
    _approvedByName = initial?.approvedByName;
    _riskImpact = _nonEmpty(initial?.riskImpact);
    _riskPriority = _nonEmpty(initial?.riskPriority);
    _riskProbability = _nonEmpty(initial?.riskProbability);
    _riskResponse = _nonEmpty(initial?.riskResponse);
    _riskStatus = _nonEmpty(initial?.riskStatus);
  }

  String? _nonEmpty(String? value) =>
      value == null || value.isEmpty ? null : value;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _responsePlanController.dispose();
    _contingencyPlanController.dispose();
    super.dispose();
  }

  ProjectRisksCubit get _cubit => context.read<ProjectRisksCubit>();

  Future<void> _pickDate() async {
    await EditProjectFormUtils.pickDate(
      context,
      initial: _riskDate,
      onPicked: (picked) => setState(() => _riskDate = picked),
    );
  }

  Future<List<DropdownMenuItem<String>>> _loadAccounts() async {
    final accounts = await _cubit.fetchAccounts();
    return EditProjectFormUtils.accountItems(context, accounts);
  }

  Future<void> _submit(ProjectRisksLoaded state) async {
    setState(() => _showValidationErrors = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_ownerId == null ||
        _approvedById == null ||
        _riskDate == null ||
        _riskImpact == null ||
        _riskPriority == null ||
        _riskProbability == null ||
        _riskResponse == null ||
        _riskStatus == null) {
      return;
    }

    final request = ProjectRiskWriteRequest(
      id: widget.initial?.id,
      projectId: widget.initial?.projectId,
      title: _titleController.text.trim(),
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

    final success = widget.isEdit
        ? await _cubit.updateRisk(request)
        : await _cubit.createRisk(request);

    if (!mounted) return;
    if (success) {
      AppFunctions.showSuccessToast(
        context,
        widget.isEdit
            ? 'saved_successfully'.tr()
            : AppString.riskCreatedSuccess.tr(),
      );
      Navigator.pop(context, true);
    } else {
      AppFunctions.showsToast(
        AppString.riskCreateFailed.tr(),
        AppColor.kRedColor,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<ProjectRisksCubit, ProjectRisksState>(
      builder: (context, state) {
        final loaded = state is ProjectRisksLoaded ? state : null;
        final isSubmitting = loaded?.isSubmitting ?? false;

        return Dialog(
          backgroundColor: colors.kInputColor,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 8.w, 0),
                  child: Row(
                    textDirection: FormLayout.directionOf(context),
                    children: [
                      Expanded(
                        child: Text(
                          widget.isEdit
                              ? AppString.editRisk.tr()
                              : AppString.addRisk.tr(),
                          textAlign: FormLayout.alignOf(context),
                          textDirection: FormLayout.directionOf(context),
                          style: TextStyle(
                            color: colors.kFontColor,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            isSubmitting ? null : () => Navigator.pop(context),
                        icon: Icon(Icons.close, color: colors.kGrayColor),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _showValidationErrors
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                      children: [
                        _textField(
                          controller: _titleController,
                          label: '${AppString.riskTitle.tr()} *',
                          required: true,
                        ),
                        SizedBox(height: 14.h),
                        _textField(
                          controller: _descriptionController,
                          label: AppString.description.tr(),
                          minLines: 2,
                          maxLines: 4,
                        ),
                        SizedBox(height: 14.h),
                        _textField(
                          controller: _responsePlanController,
                          label: '${AppString.responsePlan.tr()} *',
                          required: true,
                          minLines: 2,
                          maxLines: 4,
                        ),
                        SizedBox(height: 14.h),
                        _textField(
                          controller: _contingencyPlanController,
                          label: '${AppString.contingencyPlan.tr()} *',
                          required: true,
                          minLines: 2,
                          maxLines: 4,
                        ),
                        SizedBox(height: 14.h),
                        _DateField(
                          colors: colors,
                          label: '${AppString.date.tr()} *',
                          value: _riskDate,
                          onTap: _pickDate,
                          showValidationError: _showValidationErrors,
                        ),
                        SizedBox(height: 14.h),
                        LazyStyledPopupDropdown(
                          title: '${AppString.projectOwner.tr()} *',
                          valueId: _ownerId,
                          valueLabel: _ownerName,
                          hintText: AppString.select.tr(),
                          required: true,
                          showValidationError: _showValidationErrors,
                          loadItems: _loadAccounts,
                          onSelected: (id, label) {
                            setState(() {
                              _ownerId = id;
                              _ownerName = label;
                            });
                          },
                        ),
                        SizedBox(height: 14.h),
                        LazyStyledPopupDropdown(
                          title: '${AppString.approvalOfficer.tr()} *',
                          valueId: _approvedById,
                          valueLabel: _approvedByName,
                          hintText: AppString.select.tr(),
                          required: true,
                          showValidationError: _showValidationErrors,
                          loadItems: _loadAccounts,
                          onSelected: (id, label) {
                            setState(() {
                              _approvedById = id;
                              _approvedByName = label;
                            });
                          },
                        ),
                        SizedBox(height: 14.h),
                        _enumDropdown(
                          label: AppString.riskImpact.tr(),
                          value: _riskImpact,
                          options: RiskApiEnums.riskImpact,
                          onChanged: (v) => setState(() => _riskImpact = v),
                        ),
                        _enumDropdown(
                          label: AppString.riskPriority.tr(),
                          value: _riskPriority,
                          options: RiskApiEnums.riskPriority,
                          onChanged: (v) => setState(() => _riskPriority = v),
                        ),
                        _enumDropdown(
                          label: AppString.riskProbability.tr(),
                          value: _riskProbability,
                          options: RiskApiEnums.riskProbability,
                          onChanged: (v) =>
                              setState(() => _riskProbability = v),
                        ),
                        _enumDropdown(
                          label: AppString.riskResponseLabel.tr(),
                          value: _riskResponse,
                          options: RiskApiEnums.riskResponse,
                          onChanged: (v) => setState(() => _riskResponse = v),
                        ),
                        _enumDropdown(
                          label: AppString.riskStatusLabel.tr(),
                          value: _riskStatus,
                          options: RiskApiEnums.riskStatus,
                          onChanged: (v) => setState(() => _riskStatus = v),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48.h),
                            side: BorderSide(
                              color: colors.kBorderColor.withValues(alpha: 0.45),
                              width: 1,
                            ),
                          ),
                          child: Text(AppString.cancel.tr()),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton(
                          onPressed: isSubmitting || loaded == null
                              ? null
                              : () => _submit(loaded),
                          style: FilledButton.styleFrom(
                            minimumSize: Size(double.infinity, 48.h),
                            backgroundColor: colors.kPrimaryColor,
                            side: BorderSide(
                              color: colors.kPrimaryColor,
                              width: 1,
                            ),
                          ),
                          child: isSubmitting
                              ? SizedBox(
                                  height: 22.h,
                                  width: 22.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  AppString.save.tr(),
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      textAlign: FormLayout.alignOf(context),
      textDirection: FormLayout.directionOf(context),
      validator: required
          ? (v) => v == null || v.trim().isEmpty ? ' ' : null
          : null,
      decoration: EditProjectFormUtils.inputDecoration(
        context,
        label: label,
      ),
    );
  }

  Widget _enumDropdown({
    required String label,
    required String? value,
    required List<RiskStringOption> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: StyledPopupDropdown<String>(
        title: '$label *',
        hintText: AppString.select.tr(),
        value: value,
        required: true,
        showValidationError: _showValidationErrors,
        items: options
            .map(
              (o) => DropdownMenuItem<String>(
                value: o.value,
                child: Text(
                  o.labelKey.tr(),
                  textAlign: FormLayout.alignOf(context),
                  textDirection: FormLayout.directionOf(context),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.colors,
    required this.label,
    required this.value,
    required this.onTap,
    required this.showValidationError,
  });

  final AppColorScheme colors;
  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final bool showValidationError;

  @override
  Widget build(BuildContext context) {
    final hasError = showValidationError && value == null;
    final display = value == null
        ? AppString.select.tr()
        : DateFormat('dd/MM/yyyy').format(value!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          textAlign: FormLayout.alignOf(context),
          textDirection: FormLayout.directionOf(context),
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: hasError ? colors.kRedColor : colors.kFontColor,
            fontFamily: 'Almarai',
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: colors.kInputColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: hasError
                    ? colors.kRedColor
                    : colors.kBorderColor.withValues(alpha: 0.45),
                width: hasError ? 1.5 : 1,
              ),
            ),
            child: Row(
              textDirection: FormLayout.directionOf(context),
              children: [
                Expanded(
                  child: Text(
                    display,
                    textAlign: FormLayout.alignOf(context),
                    textDirection: FormLayout.directionOf(context),
                    style: TextStyle(
                      color:
                          value == null ? colors.kGrayColor : colors.kFontColor,
                      fontSize: 15.sp,
                      fontFamily: 'Almarai',
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: colors.kGrayColor,
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
