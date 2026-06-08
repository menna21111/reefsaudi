import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_color_scheme.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../data/models/project_risk_models.dart';
import '../constants/risk_enums.dart';
import '../cubit/risk_management_cubit.dart';

import '../widgets/styled_popup_dropdown.dart';

class RiskAddScreen extends StatefulWidget {
  const RiskAddScreen({super.key});

  static Route<bool> route(RiskManagementCubit cubit) {
    return MaterialPageRoute<bool>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const RiskAddScreen(),
      ),
    );
  }

  @override
  State<RiskAddScreen> createState() => _RiskAddScreenState();
}

class _RiskAddScreenState extends State<RiskAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _regionController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _responsePlanController = TextEditingController();
  final _contingencyPlanController = TextEditingController();

  DateTime? _riskDate;
  String? _projectId;
  String? _ownerId;
  String? _approvedById;
  int? _riskImpact;
  int? _riskPriority;
  int? _riskProbability;
  int? _riskResponse;
  int? _riskStatus;

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
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) setState(() => _riskDate = picked);
  }

  Future<void> _submit(RiskManagementLoaded state) async {
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

    final cubit = context.read<RiskManagementCubit>();
    final success = await cubit.createRisk(request);
    if (!mounted) return;
    if (success) Navigator.pop(context, true);
  }

  List<DropdownMenuItem<String>> _projectItems(
    List<ProjectDxItemDto> projects,
  ) =>
      projects
          .map(
            (p) => DropdownMenuItem<String>(
              value: p.id,
              child: Text(p.title, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList();

  List<DropdownMenuItem<String>> _accountItems(
    List<AccountDxItemDto> accounts,
  ) =>
      accounts
          .map(
            (a) => DropdownMenuItem<String>(
              value: a.id,
              child: Text(a.fullName, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<RiskManagementCubit, RiskManagementState>(
      builder: (context, state) {
        if (state is! RiskManagementLoaded) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            appBar: AppBar(
              backgroundColor: colors.kInputColor,
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppString.addRisk.tr(),
                style: TextStyle(
                  color: colors.kPrimaryColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: colors.kBgColor,
          appBar: AppBar(
            backgroundColor: colors.kInputColor,
            elevation: 0,
            centerTitle: true,
            title: Text(
              AppString.addRisk.tr(),
              style: TextStyle(
                color: colors.kPrimaryColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: colors.kPrimaryColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  TextFormField(
                    controller: _titleController,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? ' ' : null,
                    decoration: _inputDecoration(
                      colors: colors,
                      label: '${AppString.riskTitle.tr()} *',
                    ),
                  ),
                  SizedBox(height: 14.h),

                  StyledPopupDropdown<String>(
                    title: AppString.projectName.tr(),
                    hintText: AppString.select.tr(),
                    value: _projectId,
                    required: true,
                    isLoading: state.isFormDataLoading,
                    items: _projectItems(state.projects),
                    onChanged: (v) => setState(() => _projectId = v),
                  ),
                  SizedBox(height: 14.h),

                  TextFormField(
                    controller: _regionController,
                    decoration: _inputDecoration(
                      colors: colors,
                      label: AppString.region.tr(),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: _inputDecoration(
                      colors: colors,
                      label: AppString.description.tr(),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  TextFormField(
                    controller: _responsePlanController,
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? ' ' : null,
                    decoration: _inputDecoration(
                      colors: colors,
                      label: '${AppString.responsePlan.tr()} *',
                    ),
                  ),
                  SizedBox(height: 14.h),

                  TextFormField(
                    controller: _contingencyPlanController,
                    maxLines: 3,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? ' ' : null,
                    decoration: _inputDecoration(
                      colors: colors,
                      label: '${AppString.contingencyPlan.tr()} *',
                    ),
                  ),
                  SizedBox(height: 14.h),

                  InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: _pickDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.kBgColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.kBorderColor),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _riskDate == null
                                  ? '${AppString.date.tr()} *'
                                  : DateFormat.yMMMd().format(_riskDate!),
                              style: TextStyle(
                                color: colors.kFontColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_outlined,
                            color: colors.kGrayColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  StyledPopupDropdown<String>(
                    title: AppString.projectOwner.tr(),
                    hintText: AppString.select.tr(),
                    value: _ownerId,
                    required: true,
                    isLoading: state.isFormDataLoading,
                    items: _accountItems(state.accounts),
                    onChanged: (v) => setState(() => _ownerId = v),
                  ),
                  SizedBox(height: 14.h),

                  StyledPopupDropdown<String>(
                    title: AppString.approvalOfficer.tr(),
                    hintText: AppString.select.tr(),
                    value: _approvedById,
                    required: true,
                    isLoading: state.isFormDataLoading,
                    items: _accountItems(state.accounts),
                    onChanged: (v) => setState(() => _approvedById = v),
                  ),
                  SizedBox(height: 14.h),

                  _intEnumDropdown(
                    label: AppString.riskImpact.tr(),
                    value: _riskImpact,
                    required: true,
                    options: RiskEnums.riskImpact,
                    onChanged: (v) => setState(() => _riskImpact = v),
                  ),

                  _intEnumDropdown(
                    label: AppString.riskPriority.tr(),
                    value: _riskPriority,
                    required: true,
                    options: RiskEnums.riskPriority,
                    onChanged: (v) => setState(() => _riskPriority = v),
                  ),

                  _intEnumDropdown(
                    label: AppString.riskProbability.tr(),
                    value: _riskProbability,
                    required: true,
                    options: RiskEnums.riskProbability,
                    onChanged: (v) => setState(() => _riskProbability = v),
                  ),

                  _intEnumDropdown(
                    label: AppString.riskResponseLabel.tr(),
                    value: _riskResponse,
                    required: true,
                    options: RiskEnums.riskResponse,
                    onChanged: (v) => setState(() => _riskResponse = v),
                  ),

                  _intEnumDropdown(
                    label: AppString.riskStatusLabel.tr(),
                    value: _riskStatus,
                    required: true,
                    options: RiskEnums.riskStatus,
                    onChanged: (v) => setState(() => _riskStatus = v),
                  ),

                  SizedBox(height: 18.h),

                  SizedBox(
                    height: 50.h,
                    child: FilledButton(
                      onPressed: state.isSubmitting ? null : () => _submit(state),
                      child: Text(
                        state.isSubmitting
                            ? AppString.loading.tr()
                            : AppString.save.tr(),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(AppString.cancel.tr()),
                  ),
                  SizedBox(height: 28.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _inputDecoration({
    required AppColorScheme colors,
    required String label,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: colors.kBgColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.kBorderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.kBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: colors.kPrimaryColor),
      ),
      labelStyle: TextStyle(
        color: colors.kGrayColor,
        fontSize: 14.sp,
      ),
    );
  }

  Widget _intEnumDropdown({
    required String label,
    required int? value,
    required bool required,
    required List<RiskEnumOption> options,
    required ValueChanged<int?> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: StyledPopupDropdown<int>(
        title: label,
        hintText: AppString.select.tr(),
        value: value,
        required: required,
        items: options
            .map(
              (o) => DropdownMenuItem<int>(
                value: o.value,
                child: Text(o.labelKey.tr()),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

