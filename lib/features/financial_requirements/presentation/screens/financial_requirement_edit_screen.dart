import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/service_locator.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../../project/data/models/project_api_models.dart';
import '../../data/models/dx_title_item_dto.dart';
import '../../data/models/create_financial_statement_request.dart';
import '../../domain/entities/financial_requirement.dart';
import '../../domain/repositories/financial_requirements_repository.dart';
import '../cubit/financial_statement_form_cubit.dart';
import '../widgets/financial_statement_form_fields.dart';

class FinancialRequirementEditScreen extends StatelessWidget {
  final FinancialRequirement? item;

  const FinancialRequirementEditScreen({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FinancialStatementFormCubit>()..loadLookups(),
      child: _FinancialRequirementEditView(item: item),
    );
  }
}

class _FinancialRequirementEditView extends StatefulWidget {
  final FinancialRequirement? item;

  const _FinancialRequirementEditView({this.item});

  @override
  State<_FinancialRequirementEditView> createState() =>
      _FinancialRequirementEditViewState();
}

class _FinancialRequirementEditViewState
    extends State<_FinancialRequirementEditView> {
  final _formKey = GlobalKey<FormState>();

  final _brandController = TextEditingController();
  final _statementNoController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _idController = TextEditingController();

  String? _projectId;
  String? _financialStatusId;
  String? _pmStatusId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _didPrefill = false;

  bool get _isEdit => widget.item != null;

  @override
  void dispose() {
    _brandController.dispose();
    _statementNoController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _prefillFromItem(FinancialStatementFormLookups lookups) {
    if (_didPrefill || widget.item == null) return;

    final item = widget.item!;
    _didPrefill = true;
    _idController.text = item.id;
    _statementNoController.text = item.extractNumber;
    _amountController.text = item.extractValue;
    _brandController.text = item.sector;

    _projectId = _findProjectId(lookups.projects, item.projectName);
    if (_projectId != null) {
      _brandController.text =
          lookups.projects.firstWhere((p) => p.id == _projectId).brand;
    }

    _financialStatusId =
        _findStatusId(lookups.financialStatuses, item.extractStatus);
    _pmStatusId =
        _findStatusId(lookups.pmStatuses, item.projectManagementStatus);
    _startDate = _parseDate(item.startDate);
    _endDate = _parseDate(item.endDate);
  }

  String? _findProjectId(List<ProjectDxItemDto> projects, String title) {
    for (final project in projects) {
      if (project.title.trim() == title.trim()) return project.id;
    }
    return null;
  }

  String? _findStatusId(List<DxTitleItemDto> statuses, String title) {
    for (final status in statuses) {
      if (status.title.trim() == title.trim()) return status.id;
    }
    return null;
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty || value == '-') return null;
    final normalized = value.replaceAll('/', '-');
    return DateTime.tryParse(normalized);
  }

  void _onProjectChanged(
    String? projectId,
    FinancialStatementFormLookups lookups,
  ) {
    setState(() {
      _projectId = projectId;
      if (projectId == null) {
        _brandController.clear();
        return;
      }
      final project = lookups.projects.firstWhere((p) => p.id == projectId);
      _brandController.text = project.brand;
    });
  }

  Future<void> _pickDate({required bool isStart}) async {
    final colors = context.appColorsRead;
    final initial = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: colors.kPrimaryColor,
              onPrimary: colors.kWhiteColor,
              surface: colors.kInputColor,
              onSurface: colors.kFontColor,
            ),
          ),
          child: child!,
        );
      },
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

  String _formatDate(DateTime? date) {
    if (date == null) return AppString.select.tr();
    return '${date.year}/${date.month}/${date.day}';
  }

  Future<void> _submit(FinancialStatementFormLookups lookups) async {
    if (!_formKey.currentState!.validate()) return;

    if (_projectId == null ||
        _financialStatusId == null ||
        _pmStatusId == null) {
      _showMessage('please_complete_required_fields'.tr(), isError: true);
      return;
    }

    final amount = _parseAmount(_amountController.text);
    if (amount <= 0) {
      _showMessage('invalid_amount'.tr(), isError: true);
      return;
    }

    final project =
        lookups.projects.firstWhere((item) => item.id == _projectId);
    final sector = project.product.trim().isNotEmpty
        ? project.product.trim()
        : project.brand.trim();

    final request = CreateFinancialStatementRequest(
      id: _isEdit ? _idController.text.trim() : null,
      projectId: _projectId!,
      statementNo: int.tryParse(_statementNoController.text.trim()),
      amount: amount,
      description: _descriptionController.text.trim(),
      sector: sector.isEmpty ? null : sector,
      financialStatusId: _financialStatusId!,
      pmStatusId: _pmStatusId!,
      startDate: _startDate,
      endDate: _endDate,
    );

    final error = await context
        .read<FinancialStatementFormCubit>()
        .submitCreate(request);

    if (!mounted) return;

    if (error != null) {
      _showMessage(error.tr(), isError: true);
      return;
    }

    _showMessage(
      _isEdit ? 'saved_successfully'.tr() : 'added_successfully'.tr(),
    );
    Navigator.pop(context, true);
  }

  double _parseAmount(String raw) {
    final cleaned = raw.trim().replaceAll(',', '').replaceAll(' ', '');
    if (cleaned.isEmpty) return 0;

    final lastDot = cleaned.lastIndexOf('.');
    if (lastDot > 0 && cleaned.length - lastDot - 1 <= 2) {
      final integerPart = cleaned.substring(0, lastDot).replaceAll('.', '');
      final decimalPart = cleaned.substring(lastDot + 1);
      return double.tryParse('$integerPart.$decimalPart') ?? 0;
    }

    return double.tryParse(cleaned.replaceAll('.', '')) ?? 0;
  }

  void _showMessage(String message, {bool isError = false}) {
    final colors = context.appColorsRead;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: colors.kWhiteColor,
            fontFamily: 'Almarai',
          ),
        ),
        backgroundColor: isError ? colors.kRedColor : colors.kPrimaryColor,
      ),
    );
  }

  List<DropdownMenuItem<String>> _projectItems(List<ProjectDxItemDto> projects) {
    return projects
        .map(
          (project) => DropdownMenuItem<String>(
            value: project.id,
            child: Text(
              project.title,
              textAlign: TextAlign.start,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }

  List<DropdownMenuItem<String>> _statusItems(List<DxTitleItemDto> statuses) {
    return statuses
        .map(
          (status) => DropdownMenuItem<String>(
            value: status.id,
            child: Text(
              status.title,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }

  Widget _fieldGap() => SizedBox(height: 18.h);

  Widget _pairRow({required Widget first, required Widget second}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        SizedBox(width: 14.w),
        Expanded(child: second),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isEdit = _isEdit;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kInputColor,
        foregroundColor: colors.kFontColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: colors.kPrimaryColor, size: 22.sp),
        title: Text(
          isEdit ? 'edit_financial_statement'.tr() : 'add_financial_statement'.tr(),
          style: TextStyle(
            color: colors.kFontColor,
            fontSize: 19.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
      ),
      body: BlocConsumer<FinancialStatementFormCubit, FinancialStatementFormState>(
          listener: (context, state) {
            if (state is FinancialStatementFormLoaded &&
                widget.item != null &&
                !_didPrefill) {
              setState(() => _prefillFromItem(state.lookups));
            }
          },
          builder: (context, state) {
            if (state is FinancialStatementFormLoading ||
                state is FinancialStatementFormInitial) {
              return Center(
                child: CircularProgressIndicator(color: colors.kPrimaryColor),
              );
            }

            if (state is FinancialStatementFormError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.kFontColor,
                          fontSize: 14.sp,
                          fontFamily: 'Almarai',
                        ),
                      ),
                      SizedBox(height: 16.h),
                      FilledButton(
                        onPressed: () => context
                            .read<FinancialStatementFormCubit>()
                            .loadLookups(),
                        child: Text(AppString.retry.tr()),
                      ),
                    ],
                  ),
                ),
              );
            }

            final loaded = state as FinancialStatementFormLoaded;
            final lookups = loaded.lookups;

            return SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 28.h),
                  children: [
                    StyledPopupDropdown<String>(
                      title: '${'projects'.tr()} *',
                      hintText: AppString.select.tr(),
                      value: _projectId,
                      required: true,
                      items: _projectItems(lookups.projects),
                      onChanged: (value) => _onProjectChanged(value, lookups),
                    ),
                    _fieldGap(),
                    FinancialStatementReadonlyField(
                      label: 'brand'.tr(),
                      controller: _brandController,
                    ),
                    _fieldGap(),
                    _pairRow(
                      first: FinancialStatementTextField(
                        controller: _statementNoController,
                        label: 'extract_number'.tr(),
                        keyboardType: TextInputType.number,
                      ),
                      second: FinancialStatementTextField(
                        controller: _amountController,
                        label: '${'amount'.tr()} *',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        required: true,
                      ),
                    ),
                    _fieldGap(),
                    StyledPopupDropdown<String>(
                      title: '${'financial_management_status'.tr()} *',
                      hintText: AppString.select.tr(),
                      value: _financialStatusId,
                      required: true,
                      items: _statusItems(lookups.financialStatuses),
                      onChanged: (value) =>
                          setState(() => _financialStatusId = value),
                    ),
                    _fieldGap(),
                    StyledPopupDropdown<String>(
                      title: '${'project_management_status'.tr()} *',
                      hintText: AppString.select.tr(),
                      value: _pmStatusId,
                      required: true,
                      items: _statusItems(lookups.pmStatuses),
                      onChanged: (value) =>
                          setState(() => _pmStatusId = value),
                    ),
                    _fieldGap(),
                    _pairRow(
                      first: FinancialStatementDateField(
                        label: 'start_date'.tr(),
                        value: _formatDate(_startDate),
                        isPlaceholder: _startDate == null,
                        onTap: () => _pickDate(isStart: true),
                      ),
                      second: FinancialStatementDateField(
                        label: 'end_date'.tr(),
                        value: _formatDate(_endDate),
                        isPlaceholder: _endDate == null,
                        onTap: () => _pickDate(isStart: false),
                      ),
                    ),
                    _fieldGap(),
                    if (isEdit)
                      _pairRow(
                        first: FinancialStatementTextField(
                          controller: _descriptionController,
                          label: 'description'.tr(),
                          maxLines: 3,
                        ),
                        second: FinancialStatementReadonlyField(
                          label: 'id'.tr(),
                          controller: _idController,
                        ),
                      )
                    else
                      FinancialStatementTextField(
                        controller: _descriptionController,
                        label: 'description'.tr(),
                        maxLines: 3,
                      ),
                    SizedBox(height: 32.h),
                    SizedBox(
                      height: 54.h,
                      child: FilledButton(
                        onPressed: loaded.isSubmitting
                            ? null
                            : () => _submit(lookups),
                        style: FilledButton.styleFrom(
                          backgroundColor: colors.kPrimaryColor,
                          foregroundColor: colors.kWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                        ),
                        child: Text(
                          loaded.isSubmitting
                              ? AppString.loading.tr()
                              : isEdit
                                  ? AppString.save.tr()
                                  : 'add'.tr(),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    SizedBox(
                      height: 54.h,
                      child: OutlinedButton(
                        onPressed:
                            loaded.isSubmitting ? null : () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.kPrimaryColor,
                          side: BorderSide(color: colors.kPrimaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Almarai',
                          ),
                        ),
                        child: Text(AppString.cancel.tr()),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }
}
