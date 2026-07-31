import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/funcation.dart';
import '../../../../core/utils/app_color.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../data/models/create_financial_statement_request.dart';
import '../../data/models/dx_title_item_dto.dart';
import '../../domain/entities/financial_requirement.dart';
import '../cubit/financial_statement_form_cubit.dart';
import 'financial_statement_form_fields.dart';

/// Shared form body used by both add and edit screens.
class FinancialRequirementFormView extends StatefulWidget {
  const FinancialRequirementFormView({
    super.key,
    this.item,
    required this.isEditing,
  });

  final FinancialRequirement? item;
  final bool isEditing;

  @override
  State<FinancialRequirementFormView> createState() =>
      _FinancialRequirementFormViewState();
}

class _FinancialRequirementFormViewState
    extends State<FinancialRequirementFormView> {
  final _formKey = GlobalKey<FormState>();

  final _statementNoController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _idController = TextEditingController();

  String? _projectId;
  String? _projectName;
  String? _financialStatusId;
  String? _financialStatusLabel;
  String? _pmStatusId;
  String? _pmStatusLabel;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showValidationErrors = false;

  FinancialStatementFormCubit get _cubit =>
      context.read<FinancialStatementFormCubit>();

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item == null) return;

    _idController.text = item.id;
    _projectName = item.projectName;
    _statementNoController.text = item.extractNumber;
    _amountController.text = item.extractValue;
    _financialStatusLabel = item.extractStatus;
    _pmStatusLabel = item.projectManagementStatus;
    _startDate = _parseDate(item.startDate);
    _endDate = _parseDate(item.endDate);
  }

  @override
  void dispose() {
    _statementNoController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _idController.dispose();
    super.dispose();
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty || value == '-') return null;
    return DateTime.tryParse(value.replaceAll('/', '-'));
  }

  void _resolveStatusId({
    required List<DxTitleItemDto> statuses,
    required String? label,
    required void Function(String id, String title) onMatch,
    required bool Function() hasId,
  }) {
    if (hasId() || label == null || label.trim().isEmpty) return;
    for (final status in statuses) {
      if (status.title.trim() == label.trim()) {
        onMatch(status.id, status.title);
        break;
      }
    }
  }

  Future<List<DropdownMenuItem<String>>> _loadProjects() async {
    final projects = await _cubit.fetchProjects();

    if (widget.isEditing && _projectId == null && widget.item != null) {
      for (final project in projects) {
        if (project.title.trim() == widget.item!.projectName.trim()) {
          if (mounted) {
            setState(() {
              _projectId = project.id;
              _projectName = project.title;
            });
          }
          break;
        }
      }
    }

    return projects
        .map(
          (project) => DropdownMenuItem<String>(
            value: project.id,
            child: Text(
              project.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
        .toList();
  }

  Future<List<DropdownMenuItem<String>>> _loadFinancialStatuses() async {
    final statuses = await _cubit.fetchFinancialStatuses();
    _resolveStatusId(
      statuses: statuses,
      label: _financialStatusLabel,
      hasId: () => _financialStatusId != null,
      onMatch: (id, title) {
        if (!mounted) return;
        setState(() {
          _financialStatusId = id;
          _financialStatusLabel = title;
        });
      },
    );

    return statuses
        .map(
          (status) => DropdownMenuItem<String>(
            value: status.id,
            child: Text(status.title, overflow: TextOverflow.ellipsis),
          ),
        )
        .toList();
  }

  Future<List<DropdownMenuItem<String>>> _loadPmStatuses() async {
    final statuses = await _cubit.fetchPmStatuses();
    _resolveStatusId(
      statuses: statuses,
      label: _pmStatusLabel,
      hasId: () => _pmStatusId != null,
      onMatch: (id, title) {
        if (!mounted) return;
        setState(() {
          _pmStatusId = id;
          _pmStatusLabel = title;
        });
      },
    );

    return statuses
        .map(
          (status) => DropdownMenuItem<String>(
            value: status.id,
            child: Text(status.title, overflow: TextOverflow.ellipsis),
          ),
        )
        .toList();
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

  Future<void> _submit(FinancialStatementFormLoaded loaded) async {
    setState(() => _showValidationErrors = true);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Required by FinancialStatement/create only.
    if (_projectId == null ||
        _financialStatusId == null ||
        _pmStatusId == null) {
      AppFunctions.showsToast(
        'please_complete_required_fields'.tr(),
        AppColor.kRedColor,
        context,
      );
      return;
    }

    final amount = _parseAmount(_amountController.text);
    if (amount <= 0) {
      AppFunctions.showsToast(
        'invalid_amount'.tr(),
        AppColor.kRedColor,
        context,
      );
      return;
    }

    final request = CreateFinancialStatementRequest(
      id: widget.isEditing ? _idController.text.trim() : null,
      projectId: _projectId!,
      statementNo: int.tryParse(_statementNoController.text.trim()),
      amount: amount,
      description: _descriptionController.text.trim(),
      financialStatusId: _financialStatusId!,
      pmStatusId: _pmStatusId!,
      startDate: _startDate,
      endDate: _endDate,
    );

    final error = await _cubit.submitCreate(request);
    if (!mounted) return;

    if (error != null) {
      AppFunctions.showsToast(error.tr(), AppColor.kRedColor, context);
      return;
    }

    AppFunctions.showSuccessToast(
      context,
      widget.isEditing ? 'saved_successfully'.tr() : 'added_successfully'.tr(),
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
    final isEdit = widget.isEditing;

    return BlocBuilder<
      FinancialStatementFormCubit,
      FinancialStatementFormState
    >(
      builder: (context, state) {
        final loaded = state is FinancialStatementFormLoaded
            ? state
            : const FinancialStatementFormLoaded();

        return SafeArea(
          child: Form(
            key: _formKey,
            autovalidateMode: _showValidationErrors
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: ListView(
              padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 28.h),
              children: [
                LazyStyledPopupDropdown(
                  title: '${'projects'.tr()} *',
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
                LazyStyledPopupDropdown(
                  title: '${'financial_management_status'.tr()} *',
                  valueId: _financialStatusId,
                  valueLabel: _financialStatusLabel,
                  hintText: AppString.select.tr(),
                  required: true,
                  showValidationError: _showValidationErrors,
                  loadItems: _loadFinancialStatuses,
                  onSelected: (id, label) {
                    setState(() {
                      _financialStatusId = id;
                      _financialStatusLabel = label;
                    });
                  },
                ),
                _fieldGap(),
                LazyStyledPopupDropdown(
                  title: '${'project_management_status'.tr()} *',
                  valueId: _pmStatusId,
                  valueLabel: _pmStatusLabel,
                  hintText: AppString.select.tr(),
                  required: true,
                  showValidationError: _showValidationErrors,
                  loadItems: _loadPmStatuses,
                  onSelected: (id, label) {
                    setState(() {
                      _pmStatusId = id;
                      _pmStatusLabel = label;
                    });
                  },
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
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: loaded.isSubmitting
                            ? null
                            : () => Navigator.pop(context),
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: colors.kInputColor,
                            borderRadius: BorderRadius.circular(14.r),
                            border: Border.all(
                              color: colors.kBorderColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            AppString.cancel.tr(),
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.kFontColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: FilledButton(
                        onPressed: loaded.isSubmitting
                            ? null
                            : () => _submit(loaded),
                        style: FilledButton.styleFrom(
                          minimumSize: Size(double.infinity, 54.h),
                          backgroundColor: colors.kPrimaryColor,
                          foregroundColor: colors.kWhiteColor,
                          side: BorderSide(
                            color: colors.kPrimaryColor,
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          loaded.isSubmitting
                              ? AppString.loading.tr()
                              : isEdit
                              ? AppString.save.tr()
                              : 'add'.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Almarai',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
