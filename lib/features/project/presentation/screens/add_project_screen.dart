import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../../risk_management/data/models/project_risk_models.dart';
import '../../data/models/supplier_models.dart';
import '../cubit/add_project_cubit.dart';
import '../cubit/add_project_state.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (_) => sl<AddProjectCubit>()..loadLookups(),
        child: const AddProjectScreen(),
      ),
    );
  }

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _approvedBudgetController = TextEditingController();
  final _estimatedBudgetController = TextEditingController();
  final _projectCodeController = TextEditingController(text: 'EXP-2024-001');

  String? _consultantId;
  String? _projectResponsibleId;
  String? _contractorId;
  String? _modelType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _region;
  String? _sector;
  String? _projectType;
  String? _fieldResponsibleId;
  String? _financialResponsibleId;
  String? _pmConsultantId;
  String? _morningResponsibleId;

  final Set<String> _selectedForms = {};

  static const _modelTypes = ['empty', 'standard', 'advanced'];
  static const _regions = [
    'region_sa01',
    'region_sa02',
    'region_sa03',
    'region_sa04',
    'region_sa05',
    'region_sa06',
    'region_sa07',
    'region_sa08',
    'region_sa09',
    'region_sa10',
    'region_sa11',
    'region_sa12',
    'region_sa14',
  ];
  static const _sectors = ['agriculture', 'industrial', 'services'];
  static const _projectTypes = [
    'project_type_started',
    'project_type_awarded',
    'project_type_signed',
    'project_type_review_committee',
    'project_type_accreditation',
    'project_type_tender',
  ];

  static const _projectForms = [
    'form_subcontractor_approval',
    'form_work_handover',
    'form_shop_drawings_approval',
    'form_material_receiving',
    'form_payment_certificate',
    'form_site_observations',
    'form_document_approval',
    'form_material_approval',
    'form_request_for_information',
    'form_site_work_instructions',
    'form_non_conformance',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _approvedBudgetController.dispose();
    _estimatedBudgetController.dispose();
    _projectCodeController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? (_startDate ?? now) : (_endDate ?? now),
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 15),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  Future<void> _submit(AddProjectLoaded state) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_consultantId == null ||
        _projectResponsibleId == null ||
        _contractorId == null ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppString.fillRequiredFields.tr())),
      );
      return;
    }

    final success = await context.read<AddProjectCubit>().submit();
    if (!mounted || !success) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppString.changesSavedSuccessfully.tr())),
    );
    Navigator.pop(context);
  }

  List<DropdownMenuItem<String>> _supplierItems(List<SupplierDxItemDto> items) {
    return items
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: Text(item.title, overflow: TextOverflow.ellipsis),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<String>> _accountItems(List<AccountDxItemDto> accounts) {
    return accounts
        .map(
          (item) => DropdownMenuItem<String>(
            value: item.id,
            child: Text(item.fullName, overflow: TextOverflow.ellipsis),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<String>> _textItems(List<String> keys) {
    return keys
        .map(
          (key) => DropdownMenuItem<String>(
            value: key,
            child: Text(key.tr(), overflow: TextOverflow.ellipsis),
          ),
        )
        .toList();
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    Widget? suffix,
  }) {
    final colors = context.appColors;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      suffix: suffix,
      labelStyle: TextStyle(color: colors.kGrayColor, fontSize: 13.sp),
      hintStyle: TextStyle(color: colors.kGrayColor, fontSize: 14.sp),
      filled: true,
      fillColor: colors.kInputColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.45)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: colors.kBorderColor.withValues(alpha: 0.45)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: BorderSide(color: colors.kPrimaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return BlocBuilder<AddProjectCubit, AddProjectState>(
      builder: (context, state) {
        if (state is AddProjectLoading || state is AddProjectInitial) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            appBar: _buildAppBar(context),
            body: Center(
              child: CircularProgressIndicator(color: colors.kPrimaryColor),
            ),
          );
        }

        if (state is AddProjectError) {
          return Scaffold(
            backgroundColor: colors.kBgColor,
            appBar: _buildAppBar(context),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: TextStyle(color: colors.kRedColor)),
                  SizedBox(height: 12.h),
                  FilledButton(
                    onPressed: () => context.read<AddProjectCubit>().loadLookups(),
                    child: Text(AppString.retry.tr()),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! AddProjectLoaded) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: colors.kBgColor,
          appBar: _buildAppBar(context),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
              children: [
                _SectionCard(
                  icon: Icons.info_outline_rounded,
                  title: AppString.basicProjectDataSection.tr(),
                  children: [
                    TextFormField(
                      controller: _titleController,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? ' ' : null,
                      decoration: _inputDecoration(
                        label: AppString.projectTitleLabel.tr(),
                        hint: AppString.fullProjectNameHint.tr(),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.generalConsultant.tr(),
                      hintText: AppString.select.tr(),
                      value: _consultantId,
                      required: true,
                      items: _supplierItems(state.consultants),
                      onChanged: (v) => setState(() => _consultantId = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.projectResponsible.tr(),
                      hintText: AppString.select.tr(),
                      value: _projectResponsibleId,
                      required: true,
                      items: _accountItems(state.accounts),
                      onChanged: (v) =>
                          setState(() => _projectResponsibleId = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.contractor.tr(),
                      hintText: AppString.select.tr(),
                      value: _contractorId,
                      required: true,
                      items: _supplierItems(state.contractors),
                      onChanged: (v) => setState(() => _contractorId = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.modelType.tr(),
                      hintText: AppString.select.tr(),
                      value: _modelType,
                      items: _textItems(_modelTypes),
                      onChanged: (v) => setState(() => _modelType = v),
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: _inputDecoration(
                        label: AppString.description.tr(),
                        hint: AppString.projectDescriptionHint.tr(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _SectionCard(
                  icon: Icons.calendar_month_outlined,
                  title: AppString.timelineBudgetSection.tr(),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _DateField(
                            label: AppString.projectStartDate.tr(),
                            value: _startDate,
                            onTap: () => _pickDate(isStart: true),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _DateField(
                            label: AppString.expectedProjectEndDate.tr(),
                            value: _endDate,
                            onTap: () => _pickDate(isStart: false),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: _approvedBudgetController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        label: AppString.approvedBudget.tr(),
                        suffix: Padding(
                          padding: EdgeInsets.only(top: 14.h, right: 8.w),
                          child: Text(
                            AppString.sar.tr(),
                            style: TextStyle(
                              color: colors.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: _estimatedBudgetController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        label: AppString.estimatedBudget.tr(),
                        suffix: Padding(
                          padding: EdgeInsets.only(top: 14.h, right: 8.w),
                          child: Text(
                            AppString.sar.tr(),
                            style: TextStyle(
                              color: colors.kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _SectionCard(
                  icon: Icons.location_on_outlined,
                  title: AppString.locationClassificationSection.tr(),
                  children: [
                    StyledPopupDropdown<String>(
                      title: AppString.region.tr(),
                      hintText: AppString.select.tr(),
                      value: _region,
                      items: _textItems(_regions),
                      onChanged: (v) => setState(() => _region = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.sector.tr(),
                      hintText: AppString.select.tr(),
                      value: _sector,
                      items: _textItems(_sectors),
                      onChanged: (v) => setState(() => _sector = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.projectTypeLabel.tr(),
                      hintText: AppString.select.tr(),
                      value: _projectType,
                      items: _textItems(_projectTypes),
                      onChanged: (v) => setState(() => _projectType = v),
                    ),
                    SizedBox(height: 14.h),
                    TextFormField(
                      controller: _projectCodeController,
                      decoration: _inputDecoration(
                        label: AppString.projectCode.tr(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _SectionCard(
                  icon: Icons.groups_outlined,
                  title: AppString.projectManagementSection.tr(),
                  children: [
                    StyledPopupDropdown<String>(
                      title: AppString.fieldResponsible.tr(),
                      hintText: AppString.select.tr(),
                      value: _fieldResponsibleId,
                      items: _accountItems(state.accounts),
                      onChanged: (v) => setState(() => _fieldResponsibleId = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.financialResponsible.tr(),
                      hintText: AppString.select.tr(),
                      value: _financialResponsibleId,
                      items: _accountItems(state.accounts),
                      onChanged: (v) =>
                          setState(() => _financialResponsibleId = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.pmConsultant.tr(),
                      hintText: AppString.select.tr(),
                      value: _pmConsultantId,
                      items: _accountItems(state.accounts),
                      onChanged: (v) => setState(() => _pmConsultantId = v),
                    ),
                    SizedBox(height: 14.h),
                    StyledPopupDropdown<String>(
                      title: AppString.morningResponsible.tr(),
                      hintText: AppString.select.tr(),
                      value: _morningResponsibleId,
                      items: _accountItems(state.accounts),
                      onChanged: (v) =>
                          setState(() => _morningResponsibleId = v),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _SectionCard(
                  icon: Icons.checklist_rtl_rounded,
                  title: AppString.formsManagementSection.tr(),
                  children: [
                    for (final formKey in _projectForms) ...[
                      CheckboxListTile(
                        value: _selectedForms.contains(formKey),
                        onChanged: (checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedForms.add(formKey);
                            } else {
                              _selectedForms.remove(formKey);
                            }
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: colors.kPrimaryColor,
                        title: Text(
                          formKey.tr(),
                          style: TextStyle(
                            color: colors.kFontColor,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 24.h),
                FilledButton(
                  onPressed: state.isSubmitting ? null : () => _submit(state),
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.kPrimaryColor,
                    minimumSize: Size(double.infinity, 52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: state.isSubmitting
                      ? SizedBox(
                          height: 22.h,
                          width: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          AppString.saveChanges.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final colors = context.appColors;
    return AppBar(
      backgroundColor: colors.kInputColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.kFontColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        AppString.addNewProject.tr(),
        style: TextStyle(
          color: colors.kFontColor,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_none_rounded, color: colors.kFontColor),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.kInputColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.kBorderColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: colors.kPrimaryColor, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...children,
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final formatted = value == null
        ? 'dd/mm/yyyy'
        : DateFormat('dd/MM/yyyy').format(value!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
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
                color: colors.kBorderColor.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    formatted,
                    style: TextStyle(
                      color: value == null
                          ? colors.kGrayColor
                          : colors.kFontColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_outlined, color: colors.kPrimaryColor),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
