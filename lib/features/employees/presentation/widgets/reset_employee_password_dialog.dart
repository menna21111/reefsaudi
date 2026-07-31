import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';

class ResetEmployeePasswordDialog extends StatefulWidget {
  const ResetEmployeePasswordDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) => const ResetEmployeePasswordDialog(),
    );
  }

  @override
  State<ResetEmployeePasswordDialog> createState() =>
      _ResetEmployeePasswordDialogState();
}

class _ResetEmployeePasswordDialogState
    extends State<ResetEmployeePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AlertDialog(
      backgroundColor: colors.kInputColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        AppString.changePassword.tr(),
        style: TextStyle(
          color: colors.kFontColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Almarai',
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppString.fillRequiredFields.tr();
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: AppString.newPassword.tr(),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _confirmationController,
              obscureText: _obscureConfirmation,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppString.fillRequiredFields.tr();
                }
                if (value != _passwordController.text) {
                  return AppString.passwordsDoNotMatch.tr();
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: AppString.confirmNewPassword.tr(),
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _obscureConfirmation = !_obscureConfirmation,
                  ),
                  icon: Icon(
                    _obscureConfirmation
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppString.cancel.tr()),
        ),
        SizedBox(
          width: 120.w,
          child: ButtonCustom(
            text: AppString.confirm.tr(),
            buttoncolor: colors.kPrimaryColor,
            onTap: _submit,
          ),
        ),
      ],
    );
  }
}
