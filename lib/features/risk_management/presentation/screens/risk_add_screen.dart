import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../../project/presentation/widgets/edit_project/edit_project_form_utils.dart';
import '../../data/models/project_risk_models.dart';
import '../constants/risk_enums.dart';
import '../cubit/risk_management_cubit.dart';

class RiskAddScreen extends StatefulWidget {
  const RiskAddScreen({super.key, this.initial});

  final ProjectRiskDto? initial;

  bool get isEdit => initial != null;

  static Route<bool> route(
    RiskManagementCubit cubit, {
    ProjectRiskDto? initial,
  }) {
    return MaterialPageRoute<bool>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: RiskAddScreen(initial: initial),
      ),
    );
  }

  @override
  State<RiskAddScreen> createState() => _RiskAddScreenState();
}

class _RiskAddScreenState extends State<RiskAddScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _showValidationErrors = false;

  late final TextEditingController _titleController;
  late final TextEditingController _regionController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _responsePlanController;
  late final TextEditingController _contingencyPlanController;

  DateTime? _riskDate;
  String? _projectId;
  String? _projectName;
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
    _regionController = TextEditingController(text: initial?.region ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _responsePlanController =
        TextEditingController(text: initial?.responsePlan ?? '');
    _contingencyPlanController =
        TextEditingController(text: initial?.contingencyPlan ?? '');
    _riskDate = initial?.riskDate != null
        ? DateTime.tryParse(initial!.riskDate!)
        : null;
    _projectId = _nonEmpty(initial?.projectId);
    _projectName = initial?.projectTitle;
    _ownerId = _nonEmpty(initial?.ownerId);
    _ownerName = initial?.ownerName;
    _approvedById = _nonEmpty(initial?.approvedById);
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
    _regionController.dispose();
    _descriptionController.dispose();
    _responsePlanController.dispose();
    _contingencyPlanController.dispose();
    super.dispose();
  }

  RiskManagementCubit get _cubit => context.read<RiskManagementCubit>();

  Future<void> _pickDate() async {
    await EditProjectFormUtils.pickDate(
      context,
      initial: _riskDate,
      onPicked: (picked) => setState(() => _riskDate = picked),
    );
  }

  Future<void> _submit(RiskManagementLoaded state) async {
    setState(() => _showValidationErrors = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_projectId == null ||
        _ownerId == null ||
        _approvedById == null ||
        _riskDate == null ||
        _riskImpact == null ||
        _riskPriority == null ||
        _riskProbability == null ||
        _riskResponse == null ||
        _riskStatus == null) {
      return;
    }

    final success = widget.isEdit
        ? await _cubit.updateRisk(
            ProjectRiskWriteRequest(
              id: widget.initial!.id,
              projectId: _projectId!,
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
            ),
          )
        : await _cubit.createRisk(
            CreateProjectRiskRequest(
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
            ),
          );
    if (!mounted) return;
    if (success) {
      AppFunctions.showSuccessToast(
        context,
        widget.isEdit
            ? AppString.savedSuccessfully.tr()
            : AppString.riskCreatedSuccess.tr(),
      );
      Navigator.pop(context, true);
    } else {
      AppFunctions.showsToast(
        widget.isEdit
            ? AppString.unKnownError.tr()
            : AppString.riskCreateFailed.tr(),
        AppColor.kRedColor,
        context,
      );
    }
  }

  Future<List<DropdownMenuItem<String>>> _loadProjects() async {
    final projects = await _cubit.fetchProjects();
    return projects
        .map(
          (ProjectDxItemDto project) => DropdownMenuItem<String>(
            value: project.id,
            child: Text(
              project.title,
              textAlign: FormLayout.alignOf(context),
              textDirection: FormLayout.directionOf(context),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }

  Future<List<DropdownMenuItem<String>>> _loadAccounts() async {
    final accounts = await _cubit.fetchAccounts();
    return EditProjectFormUtils.accountItems(context, accounts);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<RiskManagementCubit, RiskManagementState>(
      builder: (context, state) {
        final loaded = state is RiskManagementLoaded ? state : null;

        return Scaffold(
          backgroundColor: colors.kBgColor,
          appBar: AppBar(
            backgroundColor: colors.kBgColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              (widget.isEdit ? AppString.editRisk : AppString.addRisk).tr(),
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Almarai',
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colors.kFontColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              autovalidateMode: _showValidationErrors
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                children: [
                  TextFormField(
                    controller: _titleController,
                    textAlign: FormLayout.alignOf(context),
                    textDirection: FormLayout.directionOf(context),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? ' ' : null,
                    decoration: EditProjectFormUtils.inputDecoration(
                      context,
                      label: '${AppString.riskTitle.tr()} *',
                    ),
                  ),
                  SizedBox(height: 14.h),
                  LazyStyledPopupDropdown(
                    title: AppString.projectName.tr(),
                    valueId: _projectId,
                    valueLabel: _projectName,
                    hintText: AppString.select.tr(),
                    required: true,
                    showValidationError: _showValidationErrors,
                    loadItems: _loadProjects,
                    onSelected: (id, label) {
                      setState(() {
                        _projectId = id;
                        _projectName = label;
                      });
                    },
                  ),
                  // SizedBox(height: 14.h),
                  // TextFormField(
                  //   controller: _regionController,
                  //   textAlign: FormLayout.alignOf(context),
                  //   textDirection: FormLayout.directionOf(context),
                  //   decoration: EditProjectFormUtils.inputDecoration(
                  //     context,
                  //     label: AppString.region.tr(),
                  //   ),
                  // ),
                  SizedBox(height: 14.h),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    textAlign: FormLayout.alignOf(context),
                    textDirection: FormLayout.directionOf(context),
                    decoration: EditProjectFormUtils.inputDecoration(
                      context,
                      label: AppString.description.tr(),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  TextFormField(
                    controller: _responsePlanController,
                    minLines: 3,
                    maxLines: 5,
                    textAlign: FormLayout.alignOf(context),
                    textDirection: FormLayout.directionOf(context),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? ' ' : null,
                    decoration: EditProjectFormUtils.inputDecoration(
                      context,
                      label: '${AppString.responsePlan.tr()} *',
                    ),
                  ),
                  SizedBox(height: 14.h),
                  TextFormField(
                    controller: _contingencyPlanController,
                    minLines: 3,
                    maxLines: 5,
                    textAlign: FormLayout.alignOf(context),
                    textDirection: FormLayout.directionOf(context),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? ' ' : null,
                    decoration: EditProjectFormUtils.inputDecoration(
                      context,
                      label: '${AppString.contingencyPlan.tr()} *',
                    ),
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
                    title: AppString.projectOwner.tr(),
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
                    title: AppString.approvalOfficer.tr(),
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
                  _stringEnumDropdown(
                    label: AppString.riskImpact.tr(),
                    value: _riskImpact,
                    required: true,
                    options: RiskEnums.riskImpact,
                    onChanged: (v) => setState(() => _riskImpact = v),
                  ),
                  _stringEnumDropdown(
                    label: AppString.riskPriority.tr(),
                    value: _riskPriority,
                    required: true,
                    options: RiskEnums.riskPriority,
                    onChanged: (v) => setState(() => _riskPriority = v),
                  ),
                  _stringEnumDropdown(
                    label: AppString.riskProbability.tr(),
                    value: _riskProbability,
                    required: true,
                    options: RiskEnums.riskProbability,
                    onChanged: (v) => setState(() => _riskProbability = v),
                  ),
                  _stringEnumDropdown(
                    label: AppString.riskResponseLabel.tr(),
                    value: _riskResponse,
                    required: true,
                    options: RiskEnums.riskResponse,
                    onChanged: (v) => setState(() => _riskResponse = v),
                  ),
                  _stringEnumDropdown(
                    label: AppString.riskStatusLabel.tr(),
                    value: _riskStatus,
                    required: true,
                    options: RiskEnums.riskStatus,
                    onChanged: (v) => setState(() => _riskStatus = v),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: loaded?.isSubmitting == true
                              ? null
                              : () => Navigator.pop(context),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            decoration: BoxDecoration(
                              color: colors.kInputColor,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: colors.kBorderColor,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              AppString.cancel.tr(),
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.kFontColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: loaded?.isSubmitting == true
                            ? Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                decoration: BoxDecoration(
                                  color: colors.kPrimaryColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(
                                    color: colors.kPrimaryColor,
                                    width: 1,
                                  ),
                                ),
                                child: SizedBox(
                                  height: 22.h,
                                  width: 22.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : ButtonCustom(
                                text: AppString.save.tr(),
                                onTap: () {
                                  if (loaded != null) _submit(loaded);
                                },
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _stringEnumDropdown({
    required String label,
    required String? value,
    required bool required,
    required List<RiskEnumOption> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: StyledPopupDropdown<String>(
        title: label,
        hintText: AppString.select.tr(),
        value: value,
        required: required,
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
                      color: value == null
                          ? colors.kGrayColor
                          : colors.kFontColor,
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
