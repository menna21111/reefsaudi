import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/funcation.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';
import '../../../../core/widgets/lazy_styled_popup_dropdown.dart';
import '../../../../core/widgets/multi_select_popup_dropdown.dart';
import '../../../../core/widgets/styled_popup_dropdown.dart';
import '../../domain/models/employee.dart';
import '../cubit/employees_cubit.dart';

class EmployeesAddScreen extends StatefulWidget {
  const EmployeesAddScreen({super.key, this.employee});

  final Employee? employee;

  static Future<bool?> open(BuildContext context) {
    final cubit = context.read<EmployeesCubit>();
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            BlocProvider.value(value: cubit, child: const EmployeesAddScreen()),
      ),
    );
  }

  static Future<bool?> openEdit(BuildContext context, Employee employee) {
    final cubit = context.read<EmployeesCubit>();
    return Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: EmployeesAddScreen(employee: employee),
        ),
      ),
    );
  }

  @override
  State<EmployeesAddScreen> createState() => _EmployeesAddScreenState();
}

class _EmployeesAddScreenState extends State<EmployeesAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  String? _designationId;
  String? _designationLabel;
  String? _departmentId;
  String? _departmentLabel;
  String? _supervisorId;
  String? _supervisorLabel;
  Set<String> _selectedRoleNames = {};
  int _gender = 0;
  String? _profilePicturePath;
  bool _showValidation = false;
  bool _obscurePassword = true;
  bool _isSubmitting = false;

  bool get _isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;
    if (employee == null) return;

    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
    _emailController.text = employee.email;
    _phoneController.text = employee.phone;
    _gender = employee.gender;
    _designationLabel = employee.designation.isEmpty
        ? null
        : employee.designation;
    _departmentLabel = employee.department.isEmpty ? null : employee.department;
    _supervisorId = employee.supervisorId;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<List<DropdownMenuItem<String>>> _loadDepartments() async {
    final items = await context.read<EmployeesCubit>().loadDepartments();
    var resolvedInitialValue = false;
    if (_departmentId == null && _departmentLabel != null) {
      for (final item in items) {
        if (item.title.trim() == _departmentLabel!.trim()) {
          _departmentId = item.id;
          resolvedInitialValue = true;
          break;
        }
      }
    }
    if (resolvedInitialValue && mounted) setState(() {});
    return _toDropdownItems(items);
  }

  Future<List<DropdownMenuItem<String>>> _loadDesignations() async {
    final items = await context.read<EmployeesCubit>().loadDesignations();
    var resolvedInitialValue = false;
    if (_designationId == null && _designationLabel != null) {
      for (final item in items) {
        if (item.title.trim() == _designationLabel!.trim()) {
          _designationId = item.id;
          resolvedInitialValue = true;
          break;
        }
      }
    }
    if (resolvedInitialValue && mounted) setState(() {});
    return _toDropdownItems(items);
  }

  Future<List<DropdownMenuItem<String>>> _loadSupervisors() async {
    final items = await context.read<EmployeesCubit>().loadSupervisors();
    var resolvedInitialValue = false;
    if (_supervisorId != null && _supervisorLabel == null) {
      for (final item in items) {
        if (item.id == _supervisorId) {
          _supervisorLabel = item.title;
          resolvedInitialValue = true;
          break;
        }
      }
    }
    if (resolvedInitialValue && mounted) setState(() {});
    return _toDropdownItems(items);
  }

  List<DropdownMenuItem<String>> _toDropdownItems(List<EmployeeOption> items) =>
      items
          .map(
            (item) => DropdownMenuItem<String>(
              value: item.id,
              child: Text(item.title),
            ),
          )
          .toList();

  Future<List<MultiSelectOption<String>>> _loadRoleOptions() async {
    final roles = await context.read<EmployeesCubit>().loadRoles();
    return roles
        .map(
          (role) =>
              MultiSelectOption<String>(value: role.title, label: role.title),
        )
        .toList();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;
    setState(() => _profilePicturePath = picked.path);
  }

  Future<void> _submit() async {
    setState(() => _showValidation = true);
    if (!_formKey.currentState!.validate()) return;

    if (_designationId == null ||
        _departmentId == null ||
        _supervisorId == null ||
        _selectedRoleNames.isEmpty) {
      return;
    }

    setState(() => _isSubmitting = true);
    final cubit = context.read<EmployeesCubit>();
    final errorMessage = _isEditing
        ? await cubit.updateEmployee(
            EmployeeUpdateRequest(
              userId: widget.employee!.id,
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              gender: _gender,
              phone: _phoneController.text.trim(),
              designationId: _designationId!,
              departmentId: _departmentId!,
              supervisorId: _supervisorId!,
              roles: _selectedRoleNames.toList(),
              profilePicturePath: _profilePicturePath,
            ),
          )
        : await cubit.createEmployee(
            EmployeeCreateRequest(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              gender: _gender,
              phone: _phoneController.text.trim(),
              designationId: _designationId!,
              departmentId: _departmentId!,
              supervisorId: _supervisorId!,
              roles: _selectedRoleNames.toList(),
              profilePicturePath: _profilePicturePath,
            ),
          );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (errorMessage == null) {
      AppFunctions.showSuccessToast(context, AppString.savedSuccessfully.tr());
      Navigator.pop(context, true);
      return;
    }

    AppFunctions.showsToast(
      errorMessage,
      context.appColorsRead.kRedColor,
      context,
      seconds: 6,
    );
  }

  InputDecoration _decoration(String label, {bool required = false}) {
    final colors = context.appColors;
    return InputDecoration(
      labelText: required ? '$label *' : label,
      labelStyle: TextStyle(color: colors.kGrayColor, fontSize: 13.sp),
      filled: true,
      fillColor: colors.kInputColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: colors.kBorderColor.withValues(alpha: 0.35),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.kBgColor,
      appBar: AppBar(
        backgroundColor: colors.kBgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          (_isEditing ? AppString.editEmployee : AppString.addEmployee).tr(),
          style: TextStyle(
            color: colors.kPrimaryColor,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.kPrimaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
          children: [
            TextFormField(
              controller: _emailController,
              enabled: !_isEditing,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppString.fillRequiredFields.tr();
                }
                return null;
              },
              decoration: _decoration(AppString.email.tr(), required: true),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _firstNameController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppString.fillRequiredFields.tr();
                }
                return null;
              },
              decoration: _decoration(AppString.firstName.tr()),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _lastNameController,
              decoration: _decoration(AppString.lastName.tr()),
            ),
            if (!_isEditing) ...[
              SizedBox(height: 12.h),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppString.fillRequiredFields.tr();
                  }
                  return null;
                },
                decoration: _decoration(AppString.password.tr(), required: true)
                    .copyWith(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: colors.kGrayColor,
                        ),
                      ),
                    ),
              ),
            ],
            SizedBox(height: 12.h),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _decoration(AppString.phoneNumber.tr()),
            ),
            SizedBox(height: 12.h),
            StyledPopupDropdown<int>(
              title: AppString.gender.tr(),
              value: _gender,
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: Text(AppString.genderMale.tr()),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text(AppString.genderFemale.tr()),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _gender = value);
              },
            ),
            SizedBox(height: 12.h),
            LazyStyledPopupDropdown(
              title: AppString.department.tr(),
              valueId: _departmentId,
              valueLabel: _departmentLabel,
              required: true,
              showValidationError: _showValidation && _departmentId == null,
              hintText: AppString.selectPlaceholder.tr(),
              loadItems: _loadDepartments,
              onSelected: (id, label) {
                setState(() {
                  _departmentId = id;
                  _departmentLabel = label;
                });
              },
            ),
            SizedBox(height: 12.h),
            LazyStyledPopupDropdown(
              title: AppString.designation.tr(),
              valueId: _designationId,
              valueLabel: _designationLabel,
              required: true,
              showValidationError: _showValidation && _designationId == null,
              hintText: AppString.selectPlaceholder.tr(),
              loadItems: _loadDesignations,
              onSelected: (id, label) {
                setState(() {
                  _designationId = id;
                  _designationLabel = label;
                });
              },
            ),
            SizedBox(height: 12.h),
            LazyStyledPopupDropdown(
              title: AppString.supervisor.tr(),
              valueId: _supervisorId,
              valueLabel: _supervisorLabel,
              required: true,
              showValidationError: _showValidation && _supervisorId == null,
              hintText: AppString.selectPlaceholder.tr(),
              loadItems: _loadSupervisors,
              onSelected: (id, label) {
                setState(() {
                  _supervisorId = id;
                  _supervisorLabel = label;
                });
              },
            ),
            SizedBox(height: 12.h),
            MultiSelectPopupDropdown<String>(
              title: AppString.responsibilities.tr(),
              hintText: AppString.selectPlaceholder.tr(),
              selected: _selectedRoleNames,
              loadItems: _loadRoleOptions,
              onSelectionChanged: (selected) {
                setState(() => _selectedRoleNames = selected);
              },
            ),
            if (_showValidation && _selectedRoleNames.isEmpty) ...[
              SizedBox(height: 6.h),
              Text(
                AppString.fillRequiredFields.tr(),
                style: TextStyle(color: colors.kRedColor, fontSize: 12.sp),
              ),
            ],
            SizedBox(height: 16.h),
            if (_profilePicturePath != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  File(_profilePicturePath!),
                  height: 140.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 12.h),
            ],
            ButtonCustom(
              text: AppString.pickImage.tr(),
              buttoncolor: colors.kPrimaryColor,
              onTap: _pickImage,
            ),
            SizedBox(height: 16.h),
            if (_isSubmitting)
              Center(
                child: CircularProgressIndicator(color: colors.kPrimaryColor),
              )
            else
              ButtonCustom(
                text: (_isEditing ? AppString.save : AppString.add).tr(),
                buttoncolor: colors.kPrimaryColor,
                onTap: _submit,
              ),
          ],
        ),
      ),
    );
  }
}
