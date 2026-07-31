import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';

class ContractorFormResult {
  const ContractorFormResult({
    required this.title,
    required this.description,
    required this.type,
    required this.currency,
  });

  final String title;
  final String description;
  final int type;
  final String currency;
}

class ContractorFormSheet extends StatefulWidget {
  const ContractorFormSheet({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.initialType = 1,
    this.initialCurrency = 'SAR',
  });

  final String? initialTitle;
  final String? initialDescription;
  final int initialType;
  final String initialCurrency;

  bool get isEditing => initialTitle != null;

  static const currencies = ['SAR', 'USD', 'EUR'];

  static Future<ContractorFormResult?> show(
    BuildContext context, {
    String? initialTitle,
    String? initialDescription,
    int initialType = 1,
    String initialCurrency = 'SAR',
  }) {
    return showModalBottomSheet<ContractorFormResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ContractorFormSheet(
        initialTitle: initialTitle,
        initialDescription: initialDescription,
        initialType: initialType,
        initialCurrency: initialCurrency,
      ),
    );
  }

  @override
  State<ContractorFormSheet> createState() => _ContractorFormSheetState();
}

class _ContractorFormSheetState extends State<ContractorFormSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late int _type;
  late String _currency;
  final _formKey = GlobalKey<FormState>();
  bool _showValidation = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialDescription ?? '');
    _type = widget.initialType;
    _currency = widget.initialCurrency;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _showValidation = true);
    if (!_formKey.currentState!.validate()) return;

    Navigator.pop(
      context,
      ContractorFormResult(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _type,
        currency: _currency,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: colors.kInputColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RobotoText(
                  text: widget.isEditing
                      ? AppString.editContractor.tr()
                      : AppString.addContractor.tr(),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: colors.kFontColor,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  controller: _titleController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppString.fillRequiredFields.tr();
                    }
                    return null;
                  },
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 14.sp,
                    fontFamily: 'Almarai',
                  ),
                  decoration: InputDecoration(
                    labelText: AppString.projectTitleLabel.tr(),
                    labelStyle: TextStyle(color: colors.kGrayColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  style: TextStyle(
                    color: colors.kFontColor,
                    fontSize: 14.sp,
                    fontFamily: 'Almarai',
                  ),
                  decoration: InputDecoration(
                    labelText: AppString.description.tr(),
                    labelStyle: TextStyle(color: colors.kGrayColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                StyledPopupDropdown<int>(
                  title: AppString.supplierTypeLabel.tr(),
                  required: true,
                  showValidationError: _showValidation,
                  value: _type,
                  items: [
                    DropdownMenuItem(
                      value: 0,
                      child: Text(AppString.supplierTypeConsultant.tr()),
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(AppString.supplierTypeContractor.tr()),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _type = value);
                  },
                ),
                SizedBox(height: 12.h),
                StyledPopupDropdown<String>(
                  title: AppString.currencyLabel.tr(),
                  required: true,
                  showValidationError: _showValidation,
                  value: _currency,
                  items: ContractorFormSheet.currencies
                      .map(
                        (currency) => DropdownMenuItem(
                          value: currency,
                          child: Text(currency),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _currency = value);
                  },
                ),
                SizedBox(height: 24.h),
                ButtonCustom(
                  text: AppString.save.tr(),
                  onTap: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
