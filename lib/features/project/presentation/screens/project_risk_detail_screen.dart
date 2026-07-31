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

class ProjectRiskDetailScreen extends StatefulWidget {
  const ProjectRiskDetailScreen({
    super.key,
    required this.projectId,
    required this.riskId,
    required this.initialRisk,
  });

  final String projectId;
  final String riskId;
  final ProjectRiskDto initialRisk;

  @override
  State<ProjectRiskDetailScreen> createState() =>
      _ProjectRiskDetailScreenState();
}

class _ProjectRiskDetailScreenState extends State<ProjectRiskDetailScreen> {
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
    _applyRisk(widget.initialRisk);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _responsePlanController.dispose();
    _contingencyPlanController.dispose();
    super.dispose();
  }

  String? _matchEnum(List<RiskStringOption> options, String? raw) {
    if (raw == null || raw.isEmpty) return null;
    for (final option in options) {
      if (option.value.toLowerCase() == raw.toLowerCase()) {
        return option.value;
      }
    }
    return raw;
  }

  void _applyRisk(ProjectRiskDto risk) {
    _titleController = TextEditingController(text: risk.title);
    _descriptionController =
        TextEditingController(text: risk.description ?? '');
    _responsePlanController =
        TextEditingController(text: risk.responsePlan);
    _contingencyPlanController =
        TextEditingController(text: risk.contingencyPlan);
    _riskDate =
        risk.riskDate != null ? DateTime.tryParse(risk.riskDate!) : null;
    _ownerId = risk.ownerId.isNotEmpty ? risk.ownerId : null;
    _ownerName = risk.ownerName;
    _approvedById = risk.approvedById.isNotEmpty ? risk.approvedById : null;
    _approvedByName = risk.approvedByName;
    _riskImpact = _matchEnum(RiskApiEnums.riskImpact, risk.riskImpact);
    _riskPriority = _matchEnum(RiskApiEnums.riskPriority, risk.riskPriority);
    _riskProbability =
        _matchEnum(RiskApiEnums.riskProbability, risk.riskProbability);
    _riskResponse = _matchEnum(RiskApiEnums.riskResponse, risk.riskResponse);
    _riskStatus = _matchEnum(RiskApiEnums.riskStatus, risk.riskStatus);
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

  Future<void> _save() async {
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
      id: widget.riskId,
      projectId: widget.projectId,
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

    final success = await _cubit.updateRisk(request);
    if (!mounted) return;

    if (success) {
      AppFunctions.showSuccessToast(context, 'saved_successfully'.tr());
    } else {
      AppFunctions.showsToast(
        AppString.unKnownError.tr(),
        AppColor.kRedColor,
        context,
      );
    }
  }

  Future<void> _confirmDelete() async {
    final colors = context.appColorsRead;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.kInputColor,
        title: Text(
          AppString.deleteRisk.tr(),
          style: TextStyle(color: colors.kFontColor, fontFamily: 'Almarai'),
        ),
        content: Text(
          AppString.deleteRiskConfirmation.tr(),
          style: TextStyle(color: colors.kGrayColor, fontFamily: 'Almarai'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppString.cancel.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              AppString.delete.tr(),
              style: TextStyle(color: colors.kRedColor),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await _cubit.deleteRisk(widget.riskId);
    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<ProjectRisksCubit, ProjectRisksState>(
      builder: (context, state) {
        final isBusy = state is ProjectRisksLoaded && state.isSubmitting;

        return Scaffold(
          backgroundColor: colors.kBgColor,
          appBar: AppBar(
            backgroundColor: colors.kBgColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: colors.kFontColor),
            title: Text(
              AppString.riskDetails.tr(),
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Almarai',
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            minimum: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: isBusy ? null : _save,
                    style: FilledButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                      backgroundColor: colors.kPrimaryColor,
                    ),
                    child: isBusy
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
                SizedBox(width: 12.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isBusy ? null : _confirmDelete,
                    icon: Icon(Icons.delete_outline, color: colors.kRedColor),
                    label: Text(
                      AppString.delete.tr(),
                      style: TextStyle(color: colors.kRedColor),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48.h),
                      side: BorderSide(color: colors.kRedColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: _showValidationErrors
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: [
                if (widget.initialRisk.projectTitle?.isNotEmpty == true) ...[
                  Text(
                    widget.initialRisk.projectTitle!,
                    textAlign: FormLayout.alignOf(context),
                    textDirection: FormLayout.directionOf(context),
                    style: TextStyle(
                      color: colors.kGrayColor,
                      fontSize: 13.sp,
                      fontFamily: 'Almarai',
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
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
                  onChanged: (v) => setState(() => _riskProbability = v),
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
