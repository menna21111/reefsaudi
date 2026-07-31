import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_font.dart';
import '../../../../core/utils/app_string.dart';
import '../../../../core/utils/app_theme_context.dart';
import '../../../../core/widgets/button_custom.dart';

class RoleCreateFormSheet extends StatefulWidget {
  const RoleCreateFormSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RoleCreateFormSheet(),
    );
  }

  @override
  State<RoleCreateFormSheet> createState() => _RoleCreateFormSheetState();
}

class _RoleCreateFormSheetState extends State<RoleCreateFormSheet> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _controller.text.trim());
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RobotoText(
                text: AppString.addRole.tr(),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: colors.kFontColor,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 18.h),
              TextFormField(
                controller: _controller,
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
                  labelText: AppString.roleName.tr(),
                  labelStyle: TextStyle(color: colors.kGrayColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ButtonCustom(
                text: AppString.add.tr(),
                buttoncolor: colors.kPrimaryColor,
                onTap: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
